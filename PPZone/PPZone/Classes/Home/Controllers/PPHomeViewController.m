
//
//  PPHomeViewController.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/9.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPHomeViewController.h"
#import "UIBarButtonItem+Extension.h"

#import "MyButton.h"
#import "PPDropdownMenu.h" // 下拉菜单
#import "PPDropdownViewController.h"

@interface PPHomeViewController ()<PPDropdownMenuDelegate>
//@property (nonatomic, weak) MyButton *btn;
@end

@implementation PPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置navItem
    [self setupNavigationItem];
    
    
}

/**
 *  设置导航Item
 */
- (void)setupNavigationItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchFriend) image:@"navigationbar_friendsearch_os7" highImage:@"navigationbar_friendsearch_highlighted_os7"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop_os7" highImage:@"navigationbar_pop_highlighted_os7"];
    
    // 设置下拉菜单
    MyButton *btn = [MyButton buttonWithFrame:CGRectMake(0, 0, 100, 30) type:UIButtonTypeCustom title:@"home" titleColor:PPCOLOR_TABBAR_TITLE image:[UIImage imageNamed:@"navigationbar_arrow_down_os7"] selectedImage:[UIImage imageNamed:@"navigationbar_arrow_up_os7"] backgroundImage:nil andBlock:^(MyButton *button) {
        
        // 1. 创建
        PPDropdownMenu *menu = [PPDropdownMenu dropdownMenu];
        menu.delegate = self;
        
        // 2. 设置内容
        PPDropdownViewController *Vc = [[PPDropdownViewController alloc] initWithStyle:UITableViewStylePlain];
        Vc.view.height = 200;
        Vc.view.width = 300;
        menu.contentViewController = Vc;
        
        // 3. 显示
        [menu showFrom:button];
    }];
    
    /**  取消自适应高亮显示 ***/
    btn.adjustsImageWhenHighlighted = NO;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.width - 12, 0, 0);
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.navigationItem.titleView = btn;
}

#pragma mark - PPDropdownMenuDelegate
- (void)dropdownMenuDidShow:(PPDropdownMenu *)dropdownMenu
{
    /**  设置选中 ***/
    MyButton *btn = (MyButton *)self.navigationItem.titleView;
    [btn setSelected:YES];
}

- (void)dropdownMenuDidDismiss:(PPDropdownMenu *)dropdownMenu
{
    /**  设置未选中 ***/
    MyButton *btn = (MyButton *)self.navigationItem.titleView;
    [btn setSelected:NO];
}


/**
 *  监听navItem点击
 */
- (void)searchFriend
{
    LogRed(@"查找好友");
}

- (void)pop
{
    LogRed(@"扫描二维码");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
