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
    }
    return self;
}

- (void)setupPlaceholder
{
    UILabel *placeholder = [[UILabel alloc] init];
    [self addSubview:placeholder];
    placeholder.backgroundColor = [UIColor clearColor];
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = [UIFont systemFontOfSize:19];
    _placeholder = placeholder;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _placeholder.frame = CGRectMake(3, 0, self.width - 6, 44);
    
    
}
@end
