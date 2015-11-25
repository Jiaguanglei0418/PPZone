//
//  PPTitleButton.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/24.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPTitleButton.h"

@implementation PPTitleButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置图片
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        
        /**  取消自适应高亮显示 ***/
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [self setTitleColor:PPCOLOR_TABBAR_TITLE forState:UIControlStateNormal];
        self.contentMode = UIViewContentModeCenter;
//        self.titleLabel.backgroundColor = [UIColor yellowColor];
//        self.imageView.backgroundColor = [UIColor redColor];
//        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

/**
 *  设置按钮内部titleLabel的frame
 *
 *  @param contentRect 按钮的bounds
 */
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleX = 0;
//    CGFloat titleY = 0;
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = self.titleLabel.font;
//    CGFloat width = [self.currentTitle sizeWithAttributes:attrs].width;
//    CGFloat titleW = 80;
//    CGFloat titleH = contentRect.size.height;
//    return CGRectMake(titleX, titleY, titleW, titleH);
//}
//
///**
// *  设置按钮内部imageView的frame
// *
// *  @param contentRect 按钮的bounds
// */
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat imageX = 80;
//    CGFloat imageY = 0;
//    CGFloat imageW = 13;
//    CGFloat imageH = contentRect.size.height;
//    return CGRectMake(imageX, imageY, imageW, imageH);
//}


/**
 *  访问内部控件的位置时, 在这个方法内部调用
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
     /**  如果仅仅是调整按钮内部 imageView和titleLabel的位置, 那么在Layout
      SubViews中单独设置位置即可 ***/
    
    // 1. 计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    
    // 2. 计算imageView的fame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 2;
    
//    [self sizeToFit];
}


/**
 *  设置title时, 调用sizeTofit
 */
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 每次设置title 都自适应
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}
@end
