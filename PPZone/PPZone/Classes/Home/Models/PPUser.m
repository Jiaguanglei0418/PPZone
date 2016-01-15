//
//  PPUser.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPUser.h"
#import "MJExtension.h"
@implementation PPUser
MJCodingImplementation
- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

/**
 *  替换key
 */
//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{@"ID": @"id"};
//}

/**
 *  数组套数组
 */
//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{@"user" : [PPUser class]};
//}
@end
