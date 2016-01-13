//
//  PPUserInfoHttpUtils.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/12.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPUserInfoHttpUtils.h"
#import "MJExtension.h"

@implementation PPUserInfoHttpUtils
// unread
+ (void)userUnreadStatusesWithParams:(PPUserInfoParam *)params success:(void (^)(PPUserUnreadCount *))success failure:(void (^)(NSError * error))failure
{
    [PPHttpUtils GETWithURL:@"https://rm.api.weibo.com/2/remind/unread_count.json" prarams:params.mj_keyValues success:^(id json) {
        if (success) {
            
            // 将 "微博字典"数组 转为 "微博模型"数组
            PPUserUnreadCount *result = [PPUserUnreadCount mj_objectWithKeyValues:json];

            success(result);
        }
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
}

// userInfo
+ (void)userInfoStatusesWithParams:(PPUserInfoParam *)params success:(void (^)(PPUserInfoResult *))success failure:(void (^)(NSError * error))failure
{
    [PPHttpUtils GETWithURL:@"https://api.weibo.com/2/users/show.json" prarams:params.mj_keyValues success:^(id json) {
        if (success) {
            // 将 "微博字典"数组 转为 "微博模型"数组
            PPUserInfoResult *result = [PPUserInfoResult mj_objectWithKeyValues:json];
            success(result);
        }
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
}


@end
@implementation PPUserInfoParam
@end
@implementation PPUserInfoResult
@end
@implementation PPUserUnreadCount
- (int)messageCount
{
    return self.cmt + self.mention_cmt + self.mention_status + self.dm;
}

- (int)count
{
    return self.messageCount + self.status + self.follower;
}
@end

