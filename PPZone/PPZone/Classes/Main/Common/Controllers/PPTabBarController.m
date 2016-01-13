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

#import "PPUserInfoHttpUtils.h" // 请求用户信息 - 业务工具类
#import "PPAccountManager.h"

@interface PPTabBarController ()<PPTabBarDelegate>
PROPERTYSTRONG(PPHomeViewController, homeVc)
PROPERTYSTRONG(PPMessageViewController, messageVc)
PROPERTYSTRONG(PPDiscoverViewController, discoverVc)
PROPERTYSTRONG(PPProfileViewController, profileVc)
@end

@implementation PPTabBarController

+ (instancetype)tabBarController
{
    return [[self alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 1. 设置子控制器
    _homeVc = [[PPHomeViewController alloc] init];
    _messageVc = [[PPMessageViewController alloc] init];
    _discoverVc = [[PPDiscoverViewController alloc] init];
    _profileVc = [[PPProfileViewController alloc] init];
    
    [self addChildVc:_homeVc Title:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [self addChildVc:_messageVc Title:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"]];
    
     /**  设置发微博 ***/
//    [self addChildVc:[[UIViewController alloc] init] Title:@"发微博" image:nil selectedImage:nil];
    
    [self addChildVc:_discoverVc Title:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
    
    [self addChildVc:_profileVc Title:@"我的" image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
    
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
    
    // 3. 设置badgeValue
    // 5. 设置未读消息
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(setupUnreadStatusCount) userInfo:nil repeats:YES];
    // 添加到子线程 (NSRunLoopCommonModes)
    // 添加到主线程 (NSDefaultRunLoopMode)
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

#pragma mark -
#pragma mark - PPTabBarDelegate
- (void)tabBarDidClickedPlusButton:(PPTabBar *)tabBar
{
    PPComposeViewController *composeVC = [[PPComposeViewController alloc] init];
    [self presentViewController:[[PPNavigationController alloc] initWithRootViewController:composeVC] animated:YES completion:nil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item isEqual:_homeVc.tabBarItem]) {
        [_homeVc refresh];
    }
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

#pragma mark -
#pragma mark - 获得未读数
- (void)setupUnreadStatusCount
{
    // 2.拼接请求参数
    PPUserInfoParam *param = [PPUserInfoParam param];
    //    param.access_token = account.access_token; // 写在父类中
    param.uid = [PPAccountManager account].uid;
    
    [PPUserInfoHttpUtils userUnreadStatusesWithParams:param success:^(PPUserUnreadCount *result) {
        // @20 --> @"20"
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        
        
        // 1. homeVC
        NSString *status = [NSString stringWithFormat:@"%d", result.status];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            _homeVc.tabBarItem.badgeValue = nil;
        } else { // 非0情况
            _homeVc.tabBarItem.badgeValue = status;
        }
        
        // 2. messageVC
        NSString *messageCount = [NSString stringWithFormat:@"%d", result.messageCount];
        if ([messageCount isEqualToString:@"0"]) { // 如果是0，得清空数字
            _messageVc.tabBarItem.badgeValue = nil;
        } else { // 非0情况
            _messageVc.tabBarItem.badgeValue = messageCount;
        }
        
        //  3. proVC
        NSString *follower = [NSString stringWithFormat:@"%d", result.follower];
        if ([follower isEqualToString:@"0"]) { // 如果是0，得清空数字
            _profileVc.tabBarItem.badgeValue = nil;
        } else { // 非0情况
            _profileVc.tabBarItem.badgeValue = follower;

        }
        
        // 4. applicationIconBadgeNumber
        NSString *count = [NSString stringWithFormat:@"%d", result.count];
        if ([count isEqualToString:@"0"]) { // 如果是0，得清空数字
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            [UIApplication sharedApplication].applicationIconBadgeNumber = count.intValue;
        }
        
    } failure:^(NSError *error) {
        LogGreen(@"未读消息请求失败-%@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
