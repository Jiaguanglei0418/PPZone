//
//  AppDelegate.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/9.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "AppDelegate.h"
#import "PPTabBarController.h"
#import "PPNewFeatherViewController.h"
#import "SDWebImageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1. 创建window
    self.window = [[UIWindow alloc] initWithFrame:PP_SCREEN_RECT];
    
    // 2. 设置根控制器
    UITabBarController *tabBarCon = [PPTabBarController tabBarController];
    // 新特性
    PPNewFeatherViewController *newFeather = [[PPNewFeatherViewController alloc] init];
    
    /**  版本判断 ***/
    NSString *versionKey = @"CFBundleVersion";
    // 上一次使用版本号(存储在沙盒中的版本号)
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    // 获取当前App版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    if (![currentVersion isEqualToString:lastVersion]) { // 显示新特性
        // 将版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        // 同步到沙盒
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 设置根控制器
        self.window.rootViewController = newFeather;
        
    }else self.window.rootViewController = tabBarCon;
 
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];

    // 1. 取消下载
    [mgr cancelAll];
    // 2. 清除内存中的所有图片
    [mgr.imageCache clearMemory];
    [mgr.imageCache clearDisk];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
