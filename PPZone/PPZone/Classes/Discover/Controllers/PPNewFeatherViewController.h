//
//  PPNewFeatherViewController.h
//  PPZone
//
//  Created by jiaguanglei on 15/11/16.
//  Copyright © 2015年 roseonly. All rights reserved.
//
/**
 *  版本新特性 判断
 
 1. 版本升级;
 2. 第一次打开App;  --  显示新特性
 
 沙盒中存放当前版本
 读取沙盒中版本号 --> (不存在)存储当前软件版本号 --> 显示新特性
               --> (存在)对比版本号 --> (相等) --> tabBarCon
                                  --> (小于) --> 显示新特性
 */
#import <UIKit/UIKit.h>

@interface PPNewFeatherViewController : UIViewController

@end
