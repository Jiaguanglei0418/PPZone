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
