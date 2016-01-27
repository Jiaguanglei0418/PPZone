//
//  PPEmotionListPageView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/19.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionListPageView.h"
#import "PPEmotionModel.h"
//#import "NSString+Extention.h"
#import "PPEmotionButton.h" // 表情按钮

#import "PPEmotionListDetailView.h" // 放大镜
#import "PPComposeDBUtils.h" // 存储表情

@interface PPEmotionListPageView ()

//PROPERTYSTRONG(PPEmotionModel, emotion)

PROPERTYSTRONG(PPEmotionListDetailView, detailView) // 放大镜

PROPERTYWEAK(UIButton, cancelBtn)
@end
@implementation PPEmotionListPageView

- (PPEmotionListDetailView *)detailView
{
    if(!_detailView){
        _detailView = [PPEmotionListDetailView detailView];
        
    }
    return _detailView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1. 添加 删除按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [cancelBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        
        // 2. 添加 longPressGesture
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressPageView:)]];
    }
    return self;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    
    // 设置数据
    NSUInteger count = datas.count;
    for (int i = 0; i<count; i++) {
        PPEmotionButton *btn = [[PPEmotionButton alloc] init];
        [self addSubview:btn];
        btn.emotion = datas[i];
        
        [btn addTarget:self action:@selector(btnDidClickedMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setNeedsLayout];
}

/**
 *  监听长按手势
 *
 */
- (void)longpressPageView:(UILongPressGestureRecognizer *)longpress
{
    CGPoint location = [longpress locationInView:self];
    PPEmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (longpress.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: { // 手势位置改变
            
            // 显示表情
            [self showFrom:btn];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {

            // 删除 放大镜
            [self.detailView removeFromSuperview];
            // 如果长按手势结束, 手指还在按钮上, 发送通知
            if (btn) {
                // 发通知
                [self selectEmotion:btn.emotion];
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  根据位置 取出对应的表情按钮
 */
- (PPEmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.datas.count;
    
    for (int i = 0; i<count; i++) {
        PPEmotionButton *btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, location)) {
            // 找到当前手势点击的表情按钮
            return btn;
        }
    }
    return nil;
}


/**
 *  监听删除按钮点击
 */
- (void)cancelBtnDidClicked:(UIButton *)button
{
    // 发通知
    [PPNOTICEFICATION postNotificationName:PPEmotionCancelBtnDidSelectedNoticefication object:nil userInfo:nil];
}

/**
 *  监听表情按钮点击
 */
- (void)btnDidClickedMethod:(PPEmotionButton *)button
{
    // 显示放大镜
    [self showFrom:button];
    
    // 移除放大镜
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.detailView removeFromSuperview];
    });
    
    // 发通知
    [self selectEmotion:button.emotion];
}

/**
 *  发通知
 **/
- (void)selectEmotion:(PPEmotionModel *)emotion
{
    // 2. 保存到沙盒 - 最近使用
    [PPComposeDBUtils addEmotion:emotion];

    // 1. 发通知
    [PPNOTICEFICATION postNotificationName:PPEmotionBtnDidSelectedNoticefication object:nil userInfo:@{PPEmotionBtnDidSelectedKey : emotion}];
    
}

// 显示放大镜
- (void)showFrom:(PPEmotionButton *)from
{
    if(!from) return;
    
    // 添加放大镜视图 -- 最上面的窗口 (不是keywindow)
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.detailView];
    
    // 计算出button在 window中的frame
    CGRect rect = [from convertRect:from.bounds toView:nil];
    self.detailView.centerX = CGRectGetMidX(rect);
    self.detailView.y = CGRectGetMidY(rect) - self.detailView.height;
    
    //    LogYellow(@"%@", NSStringFromCGRect(self.detailView.frame));
    self.detailView.emotion = from.emotion;

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // 内边距(四周)
    CGFloat inset = 10;
    NSUInteger count = self.datas.count;
    CGFloat btnW = (self.width - 2 * inset) / PPEmotionListPageViewMaxCols;
    CGFloat btnH = (self.height - inset) / PPEmotionListPageViewMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%PPEmotionListPageViewMaxCols) * btnW;
        btn.y = inset + (i/PPEmotionListPageViewMaxCols) * btnH;
    }
    
    // 删除按钮
    self.cancelBtn.width = btnW;
    self.cancelBtn.height = btnH;
    self.cancelBtn.x = self.width - btnW - inset;
    self.cancelBtn.y = self.height - btnH;
}
@end
