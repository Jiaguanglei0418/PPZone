//
//  PPEmotionButton.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/25.
//  Copyright © 2016年 roseonly. All rights reserved.
//

/**
 *  自定义表情按钮  --- 一个表情按钮附带一个model
 */

#import <UIKit/UIKit.h>
@class PPEmotionModel;

@protocol PPEmotionButtonDelegate <NSObject>

@optional
- (void)emotionBtnDidClicked:(PPEmotionModel *)model;

@end
@interface PPEmotionButton : UIButton

PROPERTYSTRONG(PPEmotionModel, emotion);


PROPERTYDELEGATE(PPEmotionButtonDelegate, delegate)


@end
