//
//  PPEmotionButton.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/25.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionButton.h"
#import "PPEmotionModel.h"
#import "NSString+Extention.h"

@implementation PPEmotionButton
/**
 *  当控件不是从xib/storyboard中创建时, 就会调用这个方法
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


/**
 *  当控件从xib/storyboard中创建时, 就会调用这个方法
 *
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]){
    
        [self setup];
    }
    return self;
}

/**
 *  调用完initWithCoder方法后, 调用此方法
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
}

/**
 *  初始化
 */
- (void)setup
{
    // 取消高亮显示
//    self.adjustsImageWhenHighlighted = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:38];
}

- (void)setHighlighted:(BOOL)highlighted
{}

- (void)setEmotion:(PPEmotionModel *)emotion
{
    _emotion = emotion;
    
    // 显示内容
    if (emotion.png) { // 有图片
        [self setImage:[[UIImage imageNamed:emotion.png] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else if (emotion.code) { // 是emoji表情
        // 设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}

@end
