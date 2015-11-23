//
//  PPSearchBar.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/10.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPSearchBar.h"
#import "UIImage+Extention.h"
#define PP_FONT_SEARCHBAR [UIFont systemFontOfSize:15]

@implementation PPSearchBar

+ (instancetype)searchBarWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 1. 创建搜索框对象
        self.frame = frame;
        self.font = PP_FONT_SEARCHBAR;
        self.placeholder = @"请输入搜索内容";
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.background = [UIImage resizedImageWithName:@"searchbar_textfield_background"];
        
        // 2. 设置 左边放大镜
        UIImageView *searchBarIcon = [[UIImageView alloc] init];
        searchBarIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchBarIcon.frame = CGRectMake(0, 0, 30, 30);
        /**  设置图标居中 ***/
        searchBarIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchBarIcon;
        self.leftViewMode = UITextFieldViewModeUnlessEditing;
    }
    
    return self;
}

@end
