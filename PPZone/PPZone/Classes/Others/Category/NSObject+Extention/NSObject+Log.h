//
//  NSObject+Log.h
//  HighCourt
//
//  Created by ludawei on 13-9-24.
//  Copyright (c) 2013年 ludawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Log)

-(NSString *)logClassData;
-(NSArray *)allKeys;
- (NSArray *)getPropertyNameArray;
- (id)isNull:(id)obj;

@end

#define ENABLE_LOG 1

#if ENABLE_LOG

#define LOG(fmt, ...) NSLog((@"[LOG " fmt), ##__VA_ARGS__);
//NSLog((@"[LOG %@-%@-%d] " fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], NSStringFromSelector(_cmd), __LINE__, ##__VA_ARGS__);

#else
#define LOG(fmt, ...)
#define NSLog(...) {};
#endif
