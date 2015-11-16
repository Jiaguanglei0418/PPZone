//
//  PPDropdownMenu.h
//  PPZone
//
//  Created by jiaguanglei on 15/11/11.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPDropdownMenu;
@protocol PPDropdownMenuDelegate <NSObject>

@optional
 /**  通知主界面控制器, 已经显示下拉菜单 ***/
- (void)dropdownMenuDidShow:(PPDropdownMenu *)dropdownMenu;
 /**  通知主界面控制器, 下拉菜单已经移除 ***/
- (void)dropdownMenuDidDismiss:(PPDropdownMenu *)dropdownMenu;
@end



@interface PPDropdownMenu : UIView
@property (nonatomic, weak) id<PPDropdownMenuDelegate> delegate;
 /**  内容 ***/
@property (nonatomic, strong) UIView *contentView;
 /**  内容控制器 ***/
@property (nonatomic, strong) UIViewController *contentViewController;

 /**  创建对象 ***/
+ (instancetype)dropdownMenu;
 /** 显示  ***/
- (void)showFrom:(UIView *)from;
 /**  销毁 ***/
- (void)dismiss;
@end
