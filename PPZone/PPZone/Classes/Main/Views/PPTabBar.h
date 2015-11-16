//
//  PPTabBar.h
//  PPZone
//
//  Created by jiaguanglei on 15/11/13.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPTabBar;

#warning PPTabBarDelegate 继承自 UITabBarDelegate, 所以成为 PPTabBarDelegate的代理, 也必须实现UITabBar 的代理协议.
@protocol PPTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickedPlusButton:(PPTabBar *)tabBar;
@end

@interface PPTabBar : UITabBar
@property (nonatomic, weak) id<PPTabBarDelegate> delegate;
@end
