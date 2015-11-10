//
//  PPNavigationController.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/9.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPNavigationController.h"
#import "UIBarButtonItem+Extension.h"

#define PP_FONT_NAVIGATIONITEM [UIFont systemFontOfSize:18]
@interface PPNavigationController ()

@end

@implementation PPNavigationController
/**
 *  第一次使用本类, 调用一次
 */
+ (void)initialize
{
    // 设置整个项目所有Item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = PPCOLOR_TABBAR_TITLE;
    textAttrs[NSFontAttributeName] = PP_FONT_NAVIGATIONITEM;
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置disable状态
    NSMutableDictionary *disableAttrs = [NSMutableDictionary dictionary];
    disableAttrs[NSForegroundColorAttributeName] = PPCOLOR_TABBAR_NORMAL;
    disableAttrs[NSFontAttributeName] = PP_FONT_NAVIGATIONITEM;
    [item setTitleTextAttributes:disableAttrs forState:UIControlStateDisabled];
}


/**
 *  拦截 push方法
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    // 设置push 才有返回按钮
    if (self.viewControllers.count > 1) { //  ViewControllers > 0 : 需要显示left
    
         /**  设置隐藏 tabBar ***/
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back_os7" highImage:@"navigationbar_back_highlighted_os7"];
        
        if (self.viewControllers.count > 2) { // 大于 1 , 需要同时显示left right
            viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToRoot) image:@"navigationbar_more_os7" highImage:@"navigationbar_more_highlighted_os7"];
        }
    }
}


/**
 *  pop 到上一个ViewCon
 */
- (void)back
{
    [self popViewControllerAnimated:YES];
}


/**
 *  pop 到根控制器
 */
- (void)backToRoot
{
    [self popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
