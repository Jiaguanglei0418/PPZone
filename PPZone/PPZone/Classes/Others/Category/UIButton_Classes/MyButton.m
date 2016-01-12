//
//  MyButton.m
//  bolock
//
//  Created by zhaokai on 15/5/28.
//  Copyright (c) 2015年 zhaokai. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

+ (MyButton *)addToolbarButtonWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlightedIcon tag:(NSInteger)tag target:(id)target andAction:(SEL)sel
{
    MyButton *btn = [self buttonWithFrame:CGRectZero type:UIButtonTypeCustom title:nil target:self andAction:sel];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedIcon] forState:UIControlStateHighlighted];
    btn.tag = tag;
    
    if ([target isKindOfClass:[UIView class]]) {
        [target addSubview:btn];
    }
    
    return btn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (MyButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type title:(NSString *)title titleColor:(UIColor *)color image:(UIImage *)image selectedImage:(UIImage *)seleImage backgroundImage:(UIImage *)backImage andBlock:(myBlock)block{
    MyButton *button = [MyButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:seleImage forState:UIControlStateSelected];
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    
    [button addTarget:button action:@selector(blockButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //将参数接收过来,保存到成员变量中
    button.tempBlock = block;
    
    return button;


}


+(MyButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type title:(NSString *)title target:(id)target andAction:(SEL)sel{
    MyButton *button = [MyButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(MyButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type title:(NSString *)title andBlock:(myBlock)block{
    MyButton *button = [MyButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];

    [button addTarget:button action:@selector(blockButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //将参数接收过来,保存到成员变量中
    button.tempBlock = block;
    
    return button;
}

-(void)blockButtonclicked:(MyButton *)button{
    //执行block变量
    button.tempBlock(button);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
