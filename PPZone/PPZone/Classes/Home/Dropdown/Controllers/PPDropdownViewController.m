//
//  PPDropdownViewController.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/11.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPDropdownViewController.h"

@interface PPDropdownViewController ()

@end

@implementation PPDropdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"dropdown";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 显示消息
    cell.textLabel.text = [NSString stringWithFormat:@"index = %ld", indexPath.row];
    
    return cell;
}


@end
