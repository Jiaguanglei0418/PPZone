//
//  PPEmotionListDetailView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/20.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionListDetailView.h"

#import "PPEmotionButton.h"

@interface PPEmotionListDetailView ()
@property (weak, nonatomic) IBOutlet PPEmotionButton *emotionBtn;

@end

@implementation PPEmotionListDetailView
+ (instancetype)detailView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PPEmotionListDetailView" owner:nil options:nil] lastObject];
}


- (void)setEmotion:(PPEmotionModel *)emotion
{
    _emotion = emotion;

    // 设置内容
    self.emotionBtn.emotion = emotion;
    self.emotionBtn.titleLabel.font = [UIFont systemFontOfSize:40];
}

@end
