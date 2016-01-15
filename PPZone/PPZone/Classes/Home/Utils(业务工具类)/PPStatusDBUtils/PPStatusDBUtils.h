//
//  PPStatusDBUtils.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/15.
//  Copyright © 2016年 roseonly. All rights reserved.
//
/**
 *  微博数据处理 - 业务工具类
 */
#import <Foundation/Foundation.h>
@class PPStatus;
@class PPHomeStatusesParam;

@interface PPStatusDBUtils : NSObject
/**
 *  缓存一条微博 -  模型
 *
 *  @param dict 需要缓存的微博数据
 */
+ (void)addStatus:(NSDictionary *)status;


/**
 *  缓存多条微博
 *
 *  @param  需要缓存的 -  模型数组
 */
+ (void)addStatuses:(NSArray *)statusArray;


/**
 *  加载缓存中的微博数据
 *
 *  @param param 请求参数
 *
 *  @return 微博数组
 */
+ (NSArray *)statusesWithParam:(PPHomeStatusesParam *)param;
@end
