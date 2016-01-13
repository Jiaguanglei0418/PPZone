//
//  PPAuthorHttpUtils.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/13.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPAuthorHttpParams;
@class PPAccount;
@interface PPAuthorHttpUtils : NSObject

+ (void)authorParams:(PPAuthorHttpParams *)params success:(void(^)(PPAccount *account))success failure:(void(^)(NSError *error)) failure;

@end


@interface PPAuthorHttpParams : NSObject
PROPERTYCOPY(NSString, code)
PROPERTYCOPY(NSString, client_id)
PROPERTYCOPY(NSString, client_secret)
PROPERTYCOPY(NSString, redirect_uri)
PROPERTYCOPY(NSString, grant_type)

+ (instancetype)param;
/**
 *  NSMutableDictionary *params = [NSMutableDictionary dictionary];
 params[@"code"] = code;
 params[@"client_id"] = APPKEY_Sina;
 params[@"client_secret"] = APPSECRET_Sina;
 params[@"redirect_uri"] = APPREDIRECT_Sina;
 params[@"grant_type"] = @"authorization_code";
 */
@end