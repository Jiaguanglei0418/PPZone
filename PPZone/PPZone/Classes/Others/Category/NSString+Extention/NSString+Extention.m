//
//  NSString+Extention.m
//  loveonly
//
//  Created by jiaguanglei on 15/10/29.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "NSString+Extention.h"


#define MINUTES		60
#define HOURS		3600
#define DAYS		86400
#define MONTHS		(86400 * 30)
#define YEARS		(86400 * 30 * 12)

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)


@implementation NSString (Extention)

#pragma mark - 字符串转换成日期
/*!
 @function   string2Date:
 @abstract   Change given string to NSDate
 @discussion If the given str is wrong, should return the current system date
 @param      dateStr A string include the date like "2009-11-09 11:14:41"
 @result     The NSDate object with given format
 */
+ (NSDate *)string2Date:(NSString *)dateStr {
    
    if (10 > [dateStr length]) {
        
        return [NSDate date];
    }
    NSRange range;
    NSString *year, *month, *day, *hr, *mn, *sec;
    range.location = 0;
    range.length = 4;
    year = [dateStr substringWithRange:range];
    
    range.location = 5;
    range.length = 2;
    month = [dateStr substringWithRange:range];
    
    range.location = 8;
    range.length = 2;
    day = [dateStr substringWithRange:range];
    
    if (11 < [dateStr length]) {
        
        range.location = 11;
        range.length = 2;
        hr = [dateStr substringWithRange:range];
    } else {
        hr = @"0";
    }
    
    if (14 < [dateStr length]) {
        
        range.location = 14;
        range.length = 2;
        mn = [dateStr substringWithRange:range];
    } else {
        mn = @"0";
    }
    
    if (17 < [dateStr length]) {
        
        range.location = 17;
        range.length = 2;
        sec = [dateStr substringWithRange:range];
    } else {
        sec = @"0";
    }
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:		[year integerValue]];
    [comps setMonth:	[month integerValue]];
    [comps setDay:		[day integerValue]];
    [comps setHour:		[hr integerValue]];
    [comps setMinute:	[mn integerValue]];
    [comps setSecond:	[sec integerValue]];
    
    NSCalendar *gregorian = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *returnDate = [gregorian dateFromComponents:comps];
    //[comps release];
    return returnDate;
}

/*!
 @function   stringFromCurrent:
 @abstract   Change given date string to "xxx ago" format
 @discussion If the given str is wrong, should return the current date
 @param      dateStr A string include the date like "2009-11-09 11:14:41" at least 10 characters
 @result     The string with "xxx ago", xxx: years, months, days, hours, minutes, seconds
 */
+ (NSString *)stringFromCurrent:(NSString *)dateStr {
    
    NSDate *earlierDate = [NSString string2Date:dateStr];
    
    NSDate *sysDate = [NSDate date];
    //	 //NSLog(@"now from System [%@]", [sysDate description]);
    double timeInterval = [sysDate timeIntervalSinceDate:earlierDate];
    //	 //NSLog(@"[%f]", timeInterval);
    
    NSInteger yearsAgo = timeInterval / YEARS;
    if (1 < yearsAgo) {
        
        return [NSString stringWithFormat:@"%ld 年以前", yearsAgo];
    } else if (1 == yearsAgo) {
        
        return @"1 年以前";
    }
    
    NSInteger monthsAgo = timeInterval / MONTHS;
    if (1 < monthsAgo) {
        
        return [NSString stringWithFormat:@"%ld 月以前", monthsAgo];;
    } else if (1 == monthsAgo) {
        
        return [NSString stringWithFormat:@"1 月以前"];
    }
    
    NSInteger daysAgo = timeInterval / DAYS;
    if (1 < daysAgo) {
        
        return [NSString stringWithFormat:@"%ld 天以前", daysAgo];
    } else if (1 == daysAgo) {
        
        return @"1 天以前";
    }
    
    NSInteger hoursAgo = timeInterval / HOURS;
    if (1 < hoursAgo) {
        
        return [NSString stringWithFormat:@"%ld 小时以前", hoursAgo];
    } else if (1 == hoursAgo) {
        
        return @"1小时以前";
    }
    
    NSInteger minutesAgo = timeInterval / MINUTES;
    if (1 < minutesAgo) {
        
        return [NSString stringWithFormat:@"%ld 分钟以前", minutesAgo];
    } else if (1 == minutesAgo) {
        
        return @"1 分钟以前";
    }
    // 1 sceond ago? we ignore this time
    return [NSString stringWithFormat:@"%ld 秒以前", (NSInteger)timeInterval];
}

//时间戳转化为时间字符串
+(NSString*)timeStamp:(NSString *)stamp{
    NSTimeInterval time = [stamp doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:detaildate];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


#pragma mark - 判断是否是汉字
-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

#pragma mark - 计算字符串尺寸
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    // 获得系统版本
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:maxSize];
    }
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

- (NSInteger)fileSize
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断是否为文件
    BOOL dir = NO;
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&dir];
    // 文件\文件夹不存在
    if (exists == NO) return 0;
    
    if (dir) { // self是一个文件夹
        // 遍历caches里面的所有内容 --- 直接和间接内容
        NSArray *subpaths = [mgr subpathsAtPath:self];
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths) {
            // 获得全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 判断是否为文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubpath isDirectory:&dir];
            if (dir == NO) { // 文件
                totalByteSize += [[mgr attributesOfItemAtPath:fullSubpath error:nil][NSFileSize] integerValue];
            }
        }
        return totalByteSize;
    } else { // self是一个文件
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
}



#pragma mark - 转换成Emoji字符
+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

- (NSString *)emoji
{
    return [NSString emojiWithStringCode:self];
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode
{
    char *charCode = (char *)stringCode.UTF8String;
    int intCode = (int)strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:intCode];
}

// 判断是否是 emoji表情
- (BOOL)isEmoji
{
    BOOL returnValue = NO;
    
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }
    
    return returnValue;
}



@end
