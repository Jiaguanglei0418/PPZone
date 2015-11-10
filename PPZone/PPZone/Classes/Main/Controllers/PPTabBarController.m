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

#import "PPNavigationController.h"
@interface PPTabBarController ()

@end

@implementation PPTabBarController

+ (instancetype)tabBarController
{
    return [[self alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 3. 设置子控制器
    PPHomeViewController *homeVc = [[PPHomeViewController alloc] init];
    PPMessageViewController *messageVc = [[PPMessageViewController alloc] init];
    PPDiscoverViewController *discoverVc = [[PPDiscoverViewController alloc] init];
    PPProfileViewController *profileVc = [[PPProfileViewController alloc] init];
    
    [self addChildVc:homeVc Title:@"首页" image:[UIImage imageNamed:@"tabbar_home_os7"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected_os7"]];
    [self addChildVc:messageVc Title:@"消息" image:[UIImage imageNamed:@"tabbar_message_center_os7"] selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected_os7"]];
    
    [self addChildVc:discoverVc Title:@"发现" image:[UIImage imageNamed:@"tabbar_discover_os7"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected_os7"]];
    [self addChildVc:profileVc Title:@"我的" image:[UIImage imageNamed:@"tabbar_profile_os7"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected_os7"]];
    
    
    
    
    //    tabBarCon.viewControllers = @[viewCon1, viewCon2, viewCon3, viewCon4, viewCon5];
//    [tabBarCon addChildViewController:homeVc];
//    [tabBarCon addChildViewController:messageVc];
//    [tabBarCon addChildViewController:discoverVc];
//    [tabBarCon addChildViewController:profileVc];
    
    
}

/**
 *  添加一个子控制器
 */
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
