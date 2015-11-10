//
//  NSObject+Log.m
//  HighCourt
//
//  Created by ludawei on 13-9-24.
//  Copyright (c) 2013年 ludawei. All rights reserved.
//

#import "NSObject+Log.h"
#import <objc/runtime.h>

@implementation NSObject (Log)

- (NSString *)logClassData
{
    NSArray *keys = [self getPropertyNameArray];

    NSMutableString *logString = [NSMutableString string];
    for (NSString *propertyName in keys)
    {
        [logString appendFormat:@"\n%@ : %@", propertyName, [self valueForKey:propertyName]];
    }

    return logString;
}

// 得到所有的keys
- (NSArray *)allKeys
{
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];

    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
                
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [keys addObject:propertyName];
        
    }
    
    // 递归
    if (self.superclass != [NSObject class])
    {
        [keys addObjectsFromArray:[objc_getClass([NSStringFromClass(self.superclass) UTF8String]) allKeys]];
    }
    
    free(properties);
    
    return keys;
}

- (NSArray *)getPropertyNameArray
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count;
    objc_property_t *props = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = props[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        [array addObject:propertyName];
    }
    free(props);
    return array;
}

- (id)isNull:(id)obj
{
    if([obj isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    return obj;
}


@end
