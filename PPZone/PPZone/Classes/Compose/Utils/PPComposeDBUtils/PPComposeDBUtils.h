//
//  PPComposeDBUtils.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/26.
//  Copyright © 2016年 roseonly. All rights reserved.
//

/**
 *  工具类 --  保存表情到沙盒中(最近)
 */

#import <Foundation/Foundation.h>
@class PPEmotionModel;


@interface PPComposeDBUtils : NSObject

// 存储
+ (void)addEmotion:(PPEmotionModel *)emotion;


// 取
+ (NSArray *)recentEmotions;

@end
