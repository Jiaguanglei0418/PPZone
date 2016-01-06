//
//  PPAccount.h
//  PPZone
//
//  Created by jiaguanglei on 15/11/23.
//  Copyright © 2015年 roseonly. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface PPAccount : NSObject<NSCoding>

/**  access_token	string	用于调用access_token，接口获取授权后的access token。 ***/
@property (nonatomic, copy) NSString *access_token;

/**  expires_in	string	access_token的生命周期，单位是秒数。 ***/
@property (nonatomic, copy) NSString *expires_in;

/** remind_in	string  access_token的生命周期（该参数即将废弃，开发者请使用expires_in） ***/

//@property (nonatomic, copy) NSString *remind_in;

/**  uid	string	当前授权用户的UID。 ***/
@property (nonatomic, copy) NSString *uid;

 /**  判断存储账号的时间 (accessToken获得时间)***/
@property (nonatomic, strong) NSDate *created_time;

 /**  用户的昵称 ***/
@property (nonatomic, copy) NSString *name;


@end
