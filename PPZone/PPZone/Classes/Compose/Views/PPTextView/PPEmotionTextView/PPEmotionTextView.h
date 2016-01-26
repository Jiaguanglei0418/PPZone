//
//  PPEmotionTextView.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/25.
//  Copyright © 2016年 roseonly. All rights reserved.
//

 /// 封装textView 具有placeholder 和 emotion功能

#import "PPTextView.h"
@class PPEmotionModel;
@interface PPEmotionTextView : PPTextView

/**
 *  插入表情
 *
 */
- (void)insertEmotion:(PPEmotionModel *)emotion;


/**
 *  返回带表情的 text
 *
 */
- (NSString *)fullText;

@end
