//
//  PPAuthorHttpUtils.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/13.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPAuthorHttpUtils.h"
#import "MJExtension.h"
#import "PPAccount.h"

@implementation PPAuthorHttpUtils
+ (void)authorParams:(PPAuthorHttpParams *)params success:(void (^)(PPAccount *))success failure:(void (^)(NSError *))failure
{
    
    [PPHttpUtils POSTWithURL:@"https://api.weibo.com/oauth2/access_token" prarams:params.mj_keyValues success:^(id json) {
        
        if (success) {
            PPAccount *account = [PPAccount mj_objectWithKeyValues:[NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil]];
            success(account);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end



@implementation PPAuthorHttpParams

+ (instancetype)param
{
    return [[self alloc] init];
}
@end