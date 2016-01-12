//
//  PPTextView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/8.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPTextView.h"

@interface PPTextView ()

@end

@implementation PPTextView

+ (instancetype)textView
{
    return [[PPTextView alloc] init];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1. 创建placeholder
        [self setupPlaceholder];
        
        // 2. 初始化
        self.font = [UIFont systemFontOfSize:18];
        self.alwaysBounceVertical = YES;
    }
    return self;
}


- (void)setupPlaceholder
{
    UILabel *placeholder = [[UILabel alloc] init];
    [self insertSubview:placeholder belowSubview:self];
    placeholder.backgroundColor = [UIColor clearColor];
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = [UIFont systemFontOfSize:19];
    // 换行
    placeholder.numberOfLines = 0;
    [placeholder sizeToFit];
    _placeholder = placeholder;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _placeholder.frame = CGRectInset(self.frame, 2, 5);
    [_placeholder sizeToFit];
    
}
@end
