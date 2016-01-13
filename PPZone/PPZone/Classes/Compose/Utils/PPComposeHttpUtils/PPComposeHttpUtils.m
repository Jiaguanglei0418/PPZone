//
//  PPComposeHttpUtils.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/13.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPComposeHttpUtils.h"
#import "MJExtension.h"


@implementation PPComposeHttpUtils
// 无图片微博
+ (void)composeParams:(PPComposeHttpUtilsParams *)params success:(void(^)())success failure:(void(^)(NSError *error)) failure
{
    [PPHttpUtils POSTWithURL:@"https://api.weibo.com/2/statuses/update.json" prarams:params.mj_keyValues success:^(id json) {
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

// 有图片微博
+ (void)composeWithPhotoesParams:(PPComposeHttpUtilsParams *)params success:(void (^)())success failure:(void (^)(NSError *))failure
{
    [PPHttpUtils POSTWithURL:@"https://upload.api.weibo.com/2/statuses/upload.json" prarams:@{@"access_token" : params.access_token, @"status" : params.status} formDataArray:params.formdata success:^(id json) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (error) {
            failure(error);
        }
    }];
}

@end

@implementation PPComposeHttpUtilsParams
@end