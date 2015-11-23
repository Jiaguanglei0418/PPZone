//
//  PPTabBar.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/13.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPTabBar.h"
#import "MyButton.h"

@interface PPTabBar ()
@property (nonatomic, weak) MyButton *plusBtn;
@end

@implementation PPTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         /**  添加加号按钮 ***/
        MyButton *plusBtn = [MyButton buttonWithFrame:CGRectZero type:UIButtonTypeCustom title:nil titleColor:nil image:[UIImage imageNamed:@"tabbar_compose_icon_add"] selectedImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] backgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] andBlock:^(MyButton *button) {
        }];
        
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

/**
 *  监听加号按钮点击
 */
- (void)plusBtnDidClicked
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
        [self.delegate tabBarDidClickedPlusButton:self];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. 设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    
    // 2. 设置其他tabBarBtn的位置尺寸
    CGFloat tabBarButtonW = self.width / 5;
    CGFloat tabBarButtonIndex = 0;
    
    for (UIView *child in self.subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 设置宽度
            child.width = tabBarButtonW;
            // 设置x
            child.x = tabBarButtonW * tabBarButtonIndex;
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
}

@end
