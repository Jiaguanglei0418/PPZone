//
//  PPDiscoverViewController.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/9.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPDiscoverViewController.h"
#import "PPSearchBar.h"

@interface PPDiscoverViewController ()

@end

@implementation PPDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建自定义 searchBar
    PPSearchBar *searchBar = [PPSearchBar searchBarWithFrame:CGRectMake(0, 0, PP_SCREEN_WIDTH - 40, 30)];
    
    self.navigationItem.titleView = searchBar;
    
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    back.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:back];
    LogGreen(@"back -- %@", NSStringFromCGRect(back.frame));
    
    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    red.backgroundColor = [UIColor redColor];
    [back addSubview:red];
     LogYellow(@"red -- %@", NSStringFromCGRect(red.frame));
    
    
    
    CGRect newFrame = [red.superview convertRect:red.frame toView:self.view];
    LogRed(@"%@", NSStringFromCGRect(newFrame));
    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.centerX = self.view.centerX;
    btn.centerY = self.view.height * 0.7;
    btn.width = 50;
    btn.height = 50;
    btn.hidden = NO;
    [btn setImage:[[UIImage imageNamed:@"lxh_zana.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //    btn.imageView.image = [UIImage imageNamed:@"lxh_zana.png"];
    //    btn.imageView.frame = btn.bounds;
    btn.backgroundColor = [UIColor greenColor];
    btn.titleLabel.text = @"123";
    LogGreen(@"%@", NSStringFromCGRect(btn.frame));
    LogRed(@"%@", btn.currentImage);
    [self.view addSubview:btn];

    
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
