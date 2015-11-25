
//
//  PPHomeViewController.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/9.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPHomeViewController.h"
#import "UIBarButtonItem+Extension.h"

#import "PPTitleButton.h"
#import "PPDropdownMenu.h" // 下拉菜单
#import "PPDropdownViewController.h"

#import "AFNetworking.h"
#import "PPAccountManager.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "PPStatus.h"
@interface PPHomeViewController ()<PPDropdownMenuDelegate>
 /**  微博数组 ***/
@property (nonatomic, strong) NSMutableArray *statuses;
@end

@implementation PPHomeViewController
- (NSArray *)statuses{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置navItem
    [self setupNavigationItem];
    
    // 2. 设置用户信息
    [self setupUserInfo];
    
    // 3. 加载数据
    [self loadNewStatus];
 
    // 4. 集成刷新控件
    [self setupRefresh];
}

#pragma mark -1.
#pragma mark - 设置导航Item
- (void)setupNavigationItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchFriend) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    // 设置下拉菜单
    PPTitleButton *btn = [PPTitleButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150, 30);
    
    // 设置标题
    NSString *name = [PPAccountManager account].name;
    [btn setTitle:name ? name : @"首页" forState:UIControlStateNormal];
 
    // 监听标题
    [btn addTarget:self action:@selector(btnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = btn;
}

#pragma mark - 监听navItem点击
- (void)searchFriend
{
    LogRed(@"查找好友");
}

- (void)pop
{
    LogRed(@"扫描二维码");
}


#pragma mark -
#pragma mark - 监听titleBtn的点击
- (void)btnDidSelected:(UIButton *)button
{
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
}


#pragma mark - 2
#pragma mark - 获取用户信息
- (void)setupUserInfo
{
    /**
     *  https://api.weibo.com/2/users/show.json
    
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     uid	false	int64	需要查询的用户ID。
     */
    // 1. 请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 2. 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PPAccount *account = [PPAccountManager account];
    
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3. GET 请求 -- 获取用户昵称
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) { // 成功
        // 获取返回数据类型
//        LogYellow(@"%@", [NSString stringWithUTF8String:object_getClassName(responseObject)]);
        
        // 获取标题按钮
        PPUser *user = [PPUser mj_objectWithKeyValues:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]];
//        NSString *name = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil][@"name"];
        
        PPTitleButton *titleBtn = (PPTitleButton *)self.navigationItem.titleView;
        // 设置名称
        [titleBtn setTitle:user.name forState:UIControlStateNormal];
        // 内容改了以后, 需要重新设置  ---  在setTitle中设置
//        [titleBtn sizeToFit];
        // 存储昵称到沙盒中
        account.name = user.name;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}


#pragma mark -
#pragma mark - PPDropdownMenuDelegate
- (void)dropdownMenuDidShow:(PPDropdownMenu *)dropdownMenu
{
    /**  设置选中 ***/
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    [btn setSelected:YES];
}

- (void)dropdownMenuDidDismiss:(PPDropdownMenu *)dropdownMenu
{
    /**  设置未选中 ***/
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    [btn setSelected:NO];
}


#pragma mark - 3
#pragma mark - 加载关注好友信息
- (void)loadNewStatus
{
    [self refreshStateChanged:nil];
//    // 1. 请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2. 拼接请求参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    PPAccount *account = [PPAccountManager account];
//    
//    params[@"access_token"] = account.access_token;
////    params[@"count"] = @10;
//    // 3. GET 请求 -- 获取用户昵称
//    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) { // 成功
//        // 获取返回数据
//        NSArray *newStatus = [PPStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//        [self.statuses addObjectsFromArray:newStatus];
//        
//        // 刷表
//        [self.tableView reloadData];
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        
//    }];

}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statuses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"status";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    // 取出数据
    PPStatus *status = self.statuses[indexPath.row];
    PPUser *user = status.user;
    
    // 显示消息
    cell.textLabel.text = user.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    cell.detailTextLabel.text = status.text;
    
    return cell;
}

#pragma mark -
#pragma mark - 集成刷新
- (void)setupRefresh
{
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control addTarget:self action:@selector(refreshStateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
}

/**
 *  监听下拉刷新
 */
- (void)refreshStateChanged:(UIRefreshControl *)control
{
    [control endRefreshing];
    LogYellow(@"加载最新数据");
    
    // 1. 请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2. 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PPAccount *account = [PPAccountManager account];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博(最新的微博, ID最大)
    PPStatus *firstStatus = [self.statuses firstObject];
    // 指定 since_id 则返回ID比since_id大的微博数据, 默认为0
    params[@"since_id"] = firstStatus.idstr;
    //    params[@"count"] = @10;
    // 3. GET 请求 -- 获取用户昵称
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) { // 成功
        // 获取返回数据
        NSArray *newStatus = [PPStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        NSRange range = NSMakeRange(0, newStatus.count);
        [self.statuses insertObjects:newStatus atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
        // 刷表
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
@end
