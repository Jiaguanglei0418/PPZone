//
//  PPStatusHttpUtils.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/12.
//  Copyright © 2016年 roseonly. All rights reserved.
//

/**
 *  业务工具类  ---   用来完成功能, 业务的工具类(屏蔽业务的实现细节) - 网络 沙盒 -- 控制器瘦身
 *  功能工具类  ---   用来完成某种通用的技术方案
 */
//  ---- 业务工具类 -  微博工具类
#import <Foundation/Foundation.h>
#import "PPBaseParams.h"
@class PPHomeStatusesParam;
@class PPHomeStatusesResult;

@interface PPStatusHttpUtils : NSObject
/**
 *  加载更多 -  微博数据
 *
 *  @param params  请求参数
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)homeMoreStatusesWithParams:(PPHomeStatusesParam *)params success:(void(^)(PPHomeStatusesResult *result))result failure:(void(^)(NSError *error)) failure;

/**
 *  下拉刷新 -  微博数据
 *
 *  @param params  请求参数
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)homeNewStatusesWithParams:(PPHomeStatusesParam *)params success:(void(^)(PPHomeStatusesResult *result))result failure:(void(^)(NSError *error)) failure;




@end


#pragma mark - 首页微博的 - 网络请求模型
@interface PPHomeStatusesParam : PPBaseParams
/**
 *  采用 NSNumber 不用int 在给模型的属性赋值的时候, 可以避免未赋值的属性 为0
 **/
PROPERTYSTRONG(NSNumber, count) // 加载数量
PROPERTYSTRONG(NSNumber, max_id) // 加载更多
PROPERTYSTRONG(NSNumber, since_id) // 刷新微博


@end

#pragma mark - 首页微博的 - 返回数据模型
@interface PPHomeStatusesResult : NSObject
/**
 *  采用 NSNumber 不用int 在给模型的属性赋值的时候, 可以避免未赋值的属性 为0
 **/
PROPERTYSTRONG(NSNumber, previous_cursor) //
PROPERTYSTRONG(NSNumber, next_cursor) //

PROPERTYSTRONG(NSNumber, total_number) // 总数

PROPERTYSTRONG(NSArray, statuses) // 微博模型 数组
@end