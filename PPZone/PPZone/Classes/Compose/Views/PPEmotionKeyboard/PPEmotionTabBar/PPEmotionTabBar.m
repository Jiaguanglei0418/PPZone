//
//  PPEmotionTabBar.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/18.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionTabBar.h"

@interface PPEmotionTabBar ()

// 当前选中按钮
PROPERTYSTRONG(MyButton, selectedBtn)

@end

@implementation PPEmotionTabBar

+ (instancetype)emotionTabbar
{
    return [[self alloc] init];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加按钮
        [self addTabbarButtonWithTitle:@"最近" type:PPEmotionTabBarBtnTypeRecent];
        
        // 设置默认选中按钮
        [self addTabbarButtonWithTitle:@"默认" type:PPEmotionTabBarBtnTypeDefault];
        [self addTabbarButtonWithTitle:@"Emoj" type:PPEmotionTabBarBtnTypeEmoj];
        [self addTabbarButtonWithTitle:@"花小花" type:PPEmotionTabBarBtnTypeFlower];
    }
    return self;
}


- (MyButton *)addTabbarButtonWithTitle:(NSString *)title type:(PPEmotionTabBarBtnType)type
{
    MyButton *button = [MyButton buttonWithTitle:title type:UIButtonTypeCustom target:self andAction:@selector(tabbarButtonMethod:)];
    button.tag = type;
    
    // 设置文字颜色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    // 设置背景
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    }else if (self.subviews.count == 4){
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    [button setBackgroundImage:[[UIImage imageNamed:image] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:selectImage] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateSelected];
    
    [self addSubview:button];
    
    // 设置默认选中btn
//    if (type == PPEmotionTabBarBtnTypeDefault){
//        [self tabbarButtonMethod:button];
//    }
    
    return button;
}

// 第一次进入的时候keyboard的时候, delegate = nil
// 重写 set方法
- (void)setDelegate:(id<PPEmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    
    // 拿到默认按钮 -- 设置默认选中 (初始状态, delegate=nil)
    [self tabbarButtonMethod:(MyButton *)[self viewWithTag:PPEmotionTabBarBtnTypeDefault]];
}

/**
 *  监听按钮点击
 */
- (void)tabbarButtonMethod:(MyButton *)button
{
    if([self.selectedBtn isEqual:button]) return;
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didClickedToolbarButton:)]) {
        [self.delegate emotionToolbar:self didClickedToolbarButton:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置frame
    CGFloat btnW = self.width / 4;
    CGFloat btnH = self.height;
    CGFloat btnY = 0;
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
    }
    
}
@end
