
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
#import "PPLoadMoreFooter.h"
#import "PPStatusFrame.h"
#import "PPStatusCell.h"
@interface PPHomeViewController ()<PPDropdownMenuDelegate>
 /**  微博数组 ***/
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation PPHomeViewController
- (NSArray *)statusFrames{
    if (!_statusFrames) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    // 注册 - 显示badgeValue
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil]];
    
    // 1. 设置navItem
    [self setupNavigationItem];
    
    // 2. 设置用户信息
    [self setupUserInfo];
    
    // 3. 加载数据
//    [self loadNewStatus];
 
    // 4. 集成刷新控件
    [self setupRefresh];
    
    // 5. 设置未读消息
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(setupUnreadStatusCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

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


#pragma mark - 1.
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



#pragma mark - 4
#pragma mark - 集成刷新
- (void)setupRefresh
{
//    UIRefreshControl *control = [[UIRefreshControl alloc] init];
//    [control addTarget:self action:@selector(refreshStateChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:control];
//    
//    // 1. 设置进入 自动刷新(仅仅显示刷新状态), 只有用户通过手动下拉刷新才会触发刷新事件
//    [control beginRefreshing];
//    
//    // 2. 手动刷新
//    [self refreshStateChanged:control];
    
    // 4. 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshStateChanged:nil];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 3. 添加上拉刷新
//    PPLoadMoreFooter *footer = [PPLoadMoreFooter footer];
//    [footer.activityIndicator startAnimating];
//    self.tableView.tableFooterView = footer;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreStatus];
    }];
}


/**
 *  监听下拉刷新
 */
- (void)refreshStateChanged:(UIRefreshControl *)control
{
    // 未读消息数
    self.tabBarItem.badgeValue = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1. 请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2. 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PPAccount *account = [PPAccountManager account];
    params[@"access_token"] = account.access_token;
    params[@"count"] = @5;
    // 取出最前面的微博(最新的微博, ID最大)
    PPStatusFrame *firstStatus = [self.statusFrames firstObject];
    // 指定 since_id 则返回ID比since_id大的微博数据, 默认为0
    if(firstStatus){
        params[@"since_id"] = firstStatus.status.idstr;
    }
    //    params[@"count"] = @10;
    // 3. GET 请求 -- 获取用户昵称
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) { // 成功
        // 获取返回数据
        NSArray *newStatus = [PPStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
         /**  将Status数组 转换成StatusFrame 数组 ***/
        NSArray *newFrames = [self stausFramesWithStatuses:newStatus];
        
        
        NSRange range = NSMakeRange(0, newFrames.count);
        [self.statusFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
        // 刷表
        [self.tableView reloadData];
//        [control endRefreshing];
        
        // 显示最新微博的数量
        [self showNewStausCount:newFrames.count];
        // 隐藏 下拉刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        [control endRefreshing];
        // 隐藏 下拉刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
}

/**
 *  将HWStatus模型转为HWStatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (PPStatus *status in statuses) {
        PPStatusFrame *f = [[PPStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}

/**
 *  显示最新微博的数量
 */
- (void)showNewStausCount:(NSInteger)count
{
    // 1. 创建Label
    CGFloat NStatusLabelH = 30;
    UILabel *NStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 - NStatusLabelH, self.tableView.width, NStatusLabelH)];
    NStatusLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    // 2. 设置其他属性
    if(count == 0){
        NStatusLabel.text = @"没有新的微博数据, 请稍后再试";
    }else{
        NStatusLabel.text = [NSString stringWithFormat:@"共有%ld条新的微博数据", count];
    }
    NStatusLabel.textColor = [UIColor whiteColor];
    NStatusLabel.font = [UIFont systemFontOfSize:16];
    NStatusLabel.alpha = 0.9;
    NStatusLabel.textAlignment = NSTextAlignmentCenter;
    // 3. 添加
    [self.navigationController.view insertSubview:NStatusLabel belowSubview:self.navigationController.navigationBar];
    // 4. 动画
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        NStatusLabel.transform = CGAffineTransformMakeTranslation(0, NStatusLabelH);
//        NStatusLabel.y += NStatusLabelH;
    } completion:^(BOOL finished) { // 延迟1秒 弹回
        [UIView animateWithDuration:duration delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            // 返回 动画执行前的状态
            NStatusLabel.transform = CGAffineTransformIdentity;
//            NStatusLabel.y -= NStatusLabelH;
        } completion:^(BOOL finished) { // 销毁
            [NStatusLabel removeFromSuperview];
        }];
    }];
}


/**
 *  获得未读数
 */
- (void)setupUnreadStatusCount
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    PPAccount *account = [PPAccountManager account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // @20 --> @"20"
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogGreen(@"请求失败-%@", error);
    }];
}

/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    PPAccount *account = [PPAccountManager account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"count"] = @5;
    // 取出最后面的微博（最新的微博，ID最大的微博）
    PPStatusFrame *lastStatus = [self.statusFrames lastObject];
    if (lastStatus) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatus.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [PPStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//        LogRed(@"%@", responseObject[@"statuses"]);
        
        
        
//        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"model.plist"];
//        
//        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        
//        [responseObject[@"statuses"] writeToFile:path atomically:YES];

//        BOOL boo=[NSKeyedArchiver archiveRootObject:responseObject[@"statuses"] toFile:path];
//        if(boo){
//                LogRed(@"%@", path);
//        }

        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:[self stausFramesWithStatuses:newStatuses]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        //
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogGreen(@"请求失败-%@", error);
        
    }];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 5
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.statusFrames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPStatusCell *cell = [PPStatusCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.statusFrame = self.statusFrames[indexPath.row];;
    
    return cell;
}


@end
