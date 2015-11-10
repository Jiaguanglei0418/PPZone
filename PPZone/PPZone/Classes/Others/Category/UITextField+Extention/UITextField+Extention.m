//
//  UITextField+Extention.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/10.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "UITextField+Extention.h"

#import "UIImage+Extention.h"
#define PP_FONT_SEARCHBAR [UIFont systemFontOfSize:15]

@implementation UITextField (Extention)
+ (instancetype)searchBar
{
    // 1. 创建搜索框对象
    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, PP_SCREEN_WIDTH - 60, 30)];
    searchBar.font = PP_FONT_SEARCHBAR;
    searchBar.placeholder = @"请输入搜索内容";
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchBar.background = [UIImage resizedImageWithName:@"searchbar_textfield_background_os7"];
    
    // 2. 设置 左边放大镜
    UIImageView *searchBarIcon = [[UIImageView alloc] init];
    searchBarIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
    searchBarIcon.frame = CGRectMake(0, 0, 30, 30);
    /**  设置图标居中 ***/
    searchBarIcon.contentMode = UIViewContentModeCenter;
    searchBar.leftView = searchBarIcon;
    searchBar.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    return searchBar;
}
@end
