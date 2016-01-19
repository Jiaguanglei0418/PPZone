//
//  PPEmotionListPageView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/19.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionListPageView.h"
#import "PPEmotionModel.h"
#import "NSString+Emoji.h"

@interface PPEmotionListPageView ()

PROPERTYSTRONG(PPEmotionModel, emotion)

@end
@implementation PPEmotionListPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    
    // 设置数据
    NSUInteger count = datas.count;
    for (int i = 0; i<count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        _emotion = datas[i];
        
        if (_emotion.png) { // 有图片
            [btn setImage:[UIImage imageNamed:_emotion.png] forState:UIControlStateNormal];
        } else if (_emotion.code) { // 是emoji表情
            // 设置emoji
            [btn setTitle:_emotion.code.emoji forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:32];
        }
        
        [btn addTarget:self action:@selector(btnDidClickedMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
    
    // 添加 删除按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:cancelBtn];
}

- (void)btnDidClickedMethod:(UIButton *)button
{
    LogGreen(@"%@", _emotion.png);
    
    if ([self.delegate respondsToSelector:@selector(emotionListPageViewBtnDidClicked:)]) {
        [self.delegate emotionListPageViewBtnDidClicked:_emotion];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // 内边距(四周)
    CGFloat inset = 10;
    NSUInteger count = self.datas.count;
    CGFloat btnW = (self.width - 2 * inset) / PPEmotionListPageViewMaxCols;
    CGFloat btnH = (self.height - inset) / PPEmotionListPageViewMaxRows;
    for (int i = 0; i<count + 1; i++) {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%PPEmotionListPageViewMaxCols) * btnW;
        btn.y = inset + (i/PPEmotionListPageViewMaxCols) * btnH;
    }
    
    
    
}
@end
