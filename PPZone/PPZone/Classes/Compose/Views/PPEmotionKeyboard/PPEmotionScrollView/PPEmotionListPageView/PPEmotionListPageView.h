//
//  PPEmotionListPageView.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/19.
//  Copyright © 2016年 roseonly. All rights reserved.
//
/**
 *  显示表情页面 -- 20
 */
#import <UIKit/UIKit.h>

// 一页中最多3行
#define PPEmotionListPageViewMaxRows 3
// 一行中最多7列
#define PPEmotionListPageViewMaxCols 7
// 每一页的表情个数
#define PPEmotionListPageViewMaxNum ((PPEmotionListPageViewMaxRows * PPEmotionListPageViewMaxCols) - 1)

@class PPEmotionModel;
@protocol PPEmotionListPageViewDelegate <NSObject>

@optional
- (void)emotionListPageViewBtnDidClicked:(PPEmotionModel *)model;

@end

@interface PPEmotionListPageView : UIView

/**
 *  表情模型
 */
PROPERTYSTRONG(NSArray, datas)

PROPERTYDELEGATE(PPEmotionListPageViewDelegate, delegate)


@end
