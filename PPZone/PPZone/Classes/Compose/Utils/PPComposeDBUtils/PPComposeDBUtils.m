//
//  PPComposeDBUtils.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/26.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#define PPEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

#import "PPComposeDBUtils.h"
#import "PPEmotionModel.h"


@implementation PPComposeDBUtils
// 全局变量
static NSMutableArray *_recentEmotions;

/**
 *  类初始化的时候, 会调用一次
 * 只从沙盒中加载一次数据
 */
+ (void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:PPEmotionPath];
    if(_recentEmotions == nil){
        _recentEmotions = [NSMutableArray array];
    }
}

+ (void)addEmotion:(PPEmotionModel *)emotion
{
    // 1. 排除重复的
//    [_recentEmotions enumerateObjectsUsingBlock:^(PPEmotionModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        if ([obj.chs isEqualToString:emotion.chs]) {
////            [emotions removeObject:obj];
////        }
//        if ([obj isEqual:emotion]) {
//            [_recentEmotions removeObject:obj];
//        }
//    }];
    
    [_recentEmotions removeObject:emotion];
    
//    for (PPEmotionModel *obj in emotions){
//        if ([obj.chs isEqualToString:emotion.chs] || [obj.code isEqualToString:emotion.code]) {
//            [emotions removeObject:obj];
//            break;
//        }
//    }
    
    
    // 2. 将表情放到数组最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 3. 写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:PPEmotionPath];
}



+ (NSArray *)recentEmotions
{
    // 装着emotion模型的数组
    return _recentEmotions;
}

@end
