//
//  PPEmotionListDetailView.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/20.
//  Copyright © 2016年 roseonly. All rights reserved.
//

/**
 *  长按表情的时候, 放大镜视图
 */

#import <UIKit/UIKit.h>
@class PPEmotionModel;
@interface PPEmotionListDetailView : UIView

PROPERTYSTRONG(PPEmotionModel, emotion)

+ (instancetype)detailView;

@end
