//
//  PPComposeToolbar.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/11.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPComposeToolbar.h"

@implementation PPComposeToolbar

+ (instancetype)composeToolbar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1. 通过一条线, 设置平铺背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 2. 添加5个按钮
        [self addButtonWithIcon:@"compose_camerabutton_background" highIcon:@"compose_camerabutton_background_highlighted" tag:PPComposeToolbarButtonTypeCamera];
        [self addButtonWithIcon:@"compose_toolbar_picture" highIcon:@"compose_toolbar_picture_highlighted" tag:PPComposeToolbarButtonTypePicture];
        [self addButtonWithIcon:@"compose_mentionbutton_background" highIcon:@"compose_mentionbutton_background_highlighted" tag:PPComposeToolbarButtonTypeMention];
        [self addButtonWithIcon:@"compose_trendbutton_background" highIcon:@"compose_trendbutton_background_highlighted" tag:PPComposeToolbarButtonTypeTrend];
        [self addButtonWithIcon:@"compose_emoticonbutton_background" highIcon:@"compose_emoticonbutton_background_highlighted" tag:PPComposeToolbarButtonTypeEmotion];
        
    }
    return self;
}


- (void)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(int)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [self addSubview:button];
}


// 监听点击
- (void)buttonClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickedToolbarButton:)]) {
        [self.delegate composeToolbar:self didClickedToolbarButton:btn.tag];
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //
    self.size = CGSizeMake(PP_SCREEN_WIDTH, 44);
    
    // 设置toolbarBtnframe
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonH = self.frame.size.height;
    for (int i = 0; i<self.subviews.count; i++) {
        UIButton *button = self.subviews[i];
        CGFloat buttonX = buttonW * i;
        button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
    }

}


@end
