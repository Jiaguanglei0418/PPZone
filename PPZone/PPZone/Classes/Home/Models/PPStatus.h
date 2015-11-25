//
//  PPStatus.h
//  PPZone
//
//  Created by jiaguanglei on 15/11/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//
//  --- 微博模型
#import <Foundation/Foundation.h>
#import "PPUser.h"

@interface PPStatus : NSObject

/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) PPUser *user;


@end
