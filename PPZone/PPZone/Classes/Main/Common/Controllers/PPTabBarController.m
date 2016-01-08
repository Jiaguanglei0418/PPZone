//
//  PPTabBarController.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/9.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPTabBarController.h"
#import "PPHomeViewController.h"
#import "PPMessageViewController.h"
#import "PPDiscoverViewController.h"
#import "PPProfileViewController.h"
#import "PPComposeViewController.h" // 发微博

#import "PPNavigationController.h"
#import "MyButton.h"
#import "PPTabBar.h"
@interface PPTabBarController ()<PPTabBarDelegate>

@end

@implementation PPTabBarController

+ (instancetype)tabBarController
{
    return [[self alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 1. 设置子控制器
    PPHomeViewController *homeVc = [[PPHomeViewController alloc] init];
    PPMessageViewController *messageVc = [[PPMessageViewController alloc] init];
    PPDiscoverViewController *discoverVc = [[PPDiscoverViewController alloc] init];
    PPProfileViewController *profileVc = [[PPProfileViewController alloc] init];
    
    [self addChildVc:homeVc Title:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [self addChildVc:messageVc Title:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"]];
    
     /**  设置发微博 ***/
//    [self addChildVc:[[UIViewController alloc] init] Title:@"发微博" image:nil selectedImage:nil];
    
    [self addChildVc:discoverVc Title:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
    
    [self addChildVc:profileVc Title:@"我的" image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
    
    // 2. 更换自定义tabBar  ---  KVC 可以修改只读属性
    /**  可以修改只读 属性 ***/
    //    self.tabBar = [[PPTabBar alloc] init];
    PPTabBar *tabBar = [[PPTabBar alloc] init];
    //    tabBar.delegate = self;
    /**  修改tabBar 系统属性, 默认已经设置代理 ***/
    [self setValue:tabBar forKeyPath:@"tabBar"];
    //   如果修改完属性以后, 再次修改属性(设置代理), 就会报错.
    // error: 'Changing the delegate of a tab bar managed by a tab bar controller is not allowed.'
    //   不允许修改tabBar的delegate属性, 应该写到设置之前;
    //    tabBar.delegate = self;
    
}

#pragma mark -
#pragma mark - PPTabBarDelegate
- (void)tabBarDidClickedPlusButton:(PPTabBar *)tabBar
{
    PPComposeViewController *composeVC = [[PPComposeViewController alloc] init];
    [self presentViewController:[[PPNavigationController alloc] initWithRootViewController:composeVC] animated:YES completion:nil];
}


#pragma mark -
#pragma mark - 添加一个子控制器
- (void)addChildVc:(UIViewController *)Vc Title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    // 不调用此方法, 不会创建View
//    Vc.view.backgroundColor = PPCOLOR_RANDOM;
    
    // 设置子控制器的图片
    Vc.tabBarItem.image = image;
    /**  取消自动渲染 ***/
    Vc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置标题
//    Vc.tabBarItem.title = title;
//    Vc.navigationItem.title = title;
    Vc.title = title;
    [Vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : PPCOLOR_TABBAR_TITLE} forState:UIControlStateSelected];
    [Vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : PPCOLOR_TABBAR_NORMAL} forState:UIControlStateNormal];
    // 包装一个导航控制器
    PPNavigationController *nav = [[PPNavigationController alloc] initWithRootViewController:Vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
