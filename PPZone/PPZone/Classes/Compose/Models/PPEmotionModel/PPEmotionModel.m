//
//  PPEmotionModel.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/19.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionModel.h"
#import "MJExtension.h"

@interface PPEmotionModel () <NSCoding>

@end
@implementation PPEmotionModel

MJExtensionCodingImplementation

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super init];
//    if (self) {
//        self.chs = [coder decodeObjectForKey:@"chs"];
//        self.code = [coder decodeObjectForKey:@"code"];
//        self.png = [coder decodeObjectForKey:@"png"];
//        
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)coder
//{
//      [coder encodeObject:self.chs forKey:@"chs"];
//      [coder encodeObject:self.png forKey:@"png"];
//      [coder encodeObject:self.code forKey:@"code"];
//}


/**
 *  常用来比较两个对象是否是否一样
 *
 *  @另外一个对象 (内存地址一样才相等)
 */
- (BOOL)isEqual:(PPEmotionModel *)object
{
//    if ([self.chs isEqualToString:object.chs] || [self.code isEqualToString:object.code])
//    {
//        return YES;
//    }else{
//        return NO;
//    }
    return [self.chs isEqualToString:object.chs] || [self.code isEqualToString:object.code];
}

@end
