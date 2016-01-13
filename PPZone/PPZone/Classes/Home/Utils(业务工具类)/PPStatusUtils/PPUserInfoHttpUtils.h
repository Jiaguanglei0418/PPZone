//
//  PPUserInfoHttpUtils.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/12.
//  Copyright © 2016年 roseonly. All rights reserved.
//
/**
 *  -----    用户信息业务工具类
 */
#import <Foundation/Foundation.h>
@class PPUserInfoResult;
@class PPUserInfoParam;
#import "PPUser.h"
#import "PPBaseParams.h"
@class PPUserUnreadCount;

@interface PPUserInfoHttpUtils : NSObject

/**
 *  监听未读消息数 -  未读微博数据
 *
 *  @param params  请求参数
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)userUnreadStatusesWithParams:(PPUserInfoParam *)params success:(void (^)(PPUserUnreadCount *))success failure:(void (^)(NSError * error))failure;

+ (void)userInfoStatusesWithParams:(PPUserInfoParam *)params success:(void(^)(PPUserInfoResult *))success failure:(void (^)(NSError * error))failure;

@end


#pragma mark - 用户信息 - 请求参数
@interface PPUserInfoParam : PPBaseParams
PROPERTYSTRONG(NSNumber, uid) // 用户id 未读消息


@end

#pragma mark - 用户信息 - 返回数据模型
@interface PPUserInfoResult : PPUser
/**
 *  采用 NSNumber 不用int 在给模型的属性赋值的时候, 可以避免未赋值的属性 为0
 **/
//PROPERTYSTRONG(PPUser, user) // 总数
//PROPERTYSTRONG(NSNumber, status) // wei
@end

#pragma mark - 未读信息 - 返回数据模型
@interface PPUserUnreadCount : NSObject
/**
 *  新微博未读数
 */
@property (nonatomic, assign) int status;

/**
 *  新粉丝数
 */
@property (nonatomic, assign) int follower;

/**
 *  新评论数
 */
@property (nonatomic, assign) int cmt;

/**
 *  新私信数
 */
@property (nonatomic, assign) int dm;

/**
 *  新提及我的微博数
 */
@property (nonatomic, assign) int mention_cmt;

/**
 *  新提及我的评论数
 */
@property (nonatomic, assign) int mention_status;

/**
 *  消息的总数
 */
- (int)messageCount;
/**
 *  总数
 */
- (int)count;

@end
