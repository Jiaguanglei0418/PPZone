//
//  NSDateFormatter+Extention.m
//  loveonly
//
//  Created by jiaguanglei on 15/10/29.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "NSDateFormatter+Extention.h"

@implementation NSDateFormatter (Extention)

+ (id)dateFormatter
{
    return [[self alloc] init];
}

+ (id)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (id)defaultDateFormatter
{
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
@end
