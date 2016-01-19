//
//  PPEmotionTabBar.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/18.
//  Copyright © 2016年 roseonly. All rights reserved.
//
/**
 *  ------ 表情键盘的 tabbar - 工具条
 */
#import <UIKit/UIKit.h>
@class PPEmotionTabBar;

typedef NS_ENUM(NSInteger, PPEmotionTabBarBtnType) {
    PPEmotionTabBarBtnTypeRecent, // 最近
    PPEmotionTabBarBtnTypeDefault, // 默认
    PPEmotionTabBarBtnTypeEmoj, // emoj
    PPEmotionTabBarBtnTypeFlower // 花小花
};

@protocol PPEmotionTabBarDelegate <NSObject>
@optional
- (void)emotionToolbar:(PPEmotionTabBar *)toolbar didClickedToolbarButton:(PPEmotionTabBarBtnType)emotionToolbarButtonType;


@end


@interface PPEmotionTabBar : UIView
// 代理
PROPERTYDELEGATE(PPEmotionTabBarDelegate, delegate)

+ (instancetype)emotionTabbar;
@end
