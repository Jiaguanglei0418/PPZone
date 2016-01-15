//
//  PPStatusDBUtils.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/15.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPStatusDBUtils.h"
#import "PPAccountManager.h"
#import "FMDB.h"
#import "PPStatusHttpUtils.h"
#import "PPStatus.h"
/**
 *  采用多线程
 */
static FMDatabaseQueue *_dbQueue;
@implementation PPStatusDBUtils
+ (void)initialize
{
    // 0. 获得沙盒路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"statuses.sqlite"];

    // 1. 创建队列
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2. 创建表
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL suc = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_statuses (id integer primary key autoincrement, access_token text, idstr text, status blob);"];
        if (suc) {
            LogRed(@"创建表成功!!!");
        }else{
            LogYellow(@"建表失败!!!");
        }
    }];
}

/**
 *  缓存字典数组
 */
+ (void)addStatuses:(NSArray *)statusArray
{
    [statusArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addStatus:obj];
    }];
}

/**
 *  缓存 模型 数组
 */
+ (void)addStatus:(NSDictionary *)status
{
    // 3. 写入数据
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *token = [PPAccountManager account].access_token;
        NSString *idstr = status[@"idstr"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:status];
//        NSData *statusData = [];
        [db executeUpdate:@"INSERT INTO t_statuses (access_token, idstr, status) values(?, ?, ?)", token, idstr, data];
//        [db executeUpdate:@"INSERT INTO t_statuses (access_token, idstr, dict) values(?, ? , ?)", token, idstr, data];
    }];
    [_dbQueue close];
}

/**
 *  从缓存中读取数据
 *
 *  @param param 请求参数 (加载更多, 刷新)
 *
 *  @return 字典数组
 */
+ (NSArray *)statusesWithParam:(PPHomeStatusesParam *)param
{
    __block NSMutableArray *statuses = [NSMutableArray array];
    
    // 4. 查数据
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *accessToken = [PPAccountManager account].access_token;

        FMResultSet *set = nil;
        if (param.since_id) {
            set = [db executeQuery:@"SELECT * FROM t_statuses where access_token = ? and idstr > ? order by idstr desc limit 0, ?;", accessToken, param.since_id, param.count];
        }else if (param.max_id){
            set = [db executeQuery:@"SELECT * FROM t_statuses where access_token = ? and idstr <= ? order by idstr desc limit 0, ?;", accessToken, param.max_id, param.count];
        }else{
            set = [db executeQuery:@"SELECT * FROM t_statuses where access_token = ? order by idstr desc limit 0, ?;", accessToken, param.count];
        }
        
        while([set next]) {
            NSData *data = [set dataForColumn:@"status"];
            NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [statuses addObject:status];
        }
    }];
    [_dbQueue close];
    
    return statuses;
}


@end
