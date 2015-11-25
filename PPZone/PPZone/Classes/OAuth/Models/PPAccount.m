//
//  PPAccount.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/23.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPAccount.h"
#import "MJExtension.h"

@implementation PPAccount
 /**  归档的实现 ***/
MJExtensionCodingImplementation

- (void)setName:(NSString *)name
{
    // 获取账号存储时间(accessToken)
    NSDate *creatDate = [NSDate date];
    self.created_time = creatDate;
}
/**
 *  当一个对象要归档进沙盒时, 就会调用这个方法
 *
 *  @ 在这个方法中说明这个对象的那些属性要存进沙盒
 */
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.access_token forKey:@"access_token"];
//    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
//    [aCoder encodeObject:self.uid forKey:@"uid"];
//}
//
///**
// *  当从沙盒中解档一个对象时, 调用此方法
// *
// *  @ 在这个方法中说明沙盒中的属性该怎么解析(取出那些属性)
// */
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if(self = [super init]){
//        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
//        self.expires_in =  [aDecoder decodeObjectForKey:@"expires_in"];
//        self.uid = [aDecoder decodeObjectForKey:@"uid"];
//    }
//    return self;
//}
@end
