//
//  PPStatusHttpUtils.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/12.
//  Copyright © 2016年 roseonly. All rights reserved.
//


#import "PPStatusHttpUtils.h"
#import "PPHttpUtils.h"
#import "MJExtension.h"
#import "PPStatus.h" // 字典数组 转 模型数组

@implementation PPStatusHttpUtils

// MoreData
+ (void)homeMoreStatusesWithParams:(PPHomeStatusesParam *)params success:(void(^)(PPHomeStatusesResult *result))success failure:(void(^)(NSError *error)) failure
{
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"access_token"] = params.access_token;
//    dic[@"count"] = @(params.count);
//    dic[@"since_id"] = @(params.since_id);
//    dic[@"max_id"] = @(params.max_id);
    
    [PPHttpUtils GETWithURL:@"https://api.weibo.com/2/statuses/friends_timeline.json" prarams:params.mj_keyValues success:^(id json) {
        
        if (success) {
            // 将 "微博字典"数组 转为 "微博模型"数组
            PPHomeStatusesResult *result = [PPHomeStatusesResult mj_objectWithKeyValues:json];
            success(result);
        }
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}


// newData
+ (void)homeNewStatusesWithParams:(PPHomeStatusesParam *)params success:(void(^)(PPHomeStatusesResult *result))success failure:(void(^)(NSError *error)) failure
{
    [PPHttpUtils GETWithURL:@"https://api.weibo.com/2/statuses/friends_timeline.json" prarams:params.mj_keyValues success:^(id json) {
        
        if (success) {
            // 将 "微博字典"数组 转为 "微博模型"数组
            PPHomeStatusesResult *result = [PPHomeStatusesResult mj_objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        
        failure(error);
    }];

}






@end

@implementation PPHomeStatusesParam
@end
@implementation PPHomeStatusesResult
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"statuses" : [PPStatus class]};
}

@end