//
//  PPAuthViewController.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/23.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPAuthViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "PPAccountManager.h"
#import "PPAccount.h"
#import "UIWindow+Extension.h"
#import "MBProgressHUD+MJ.h"
@interface PPAuthViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation PPAuthViewController
/**
 *    // 1. 创建一个webView
 */
- (UIWebView *)webView{
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = PP_SCREEN_RECT;
        webView.delegate = self;
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 拼接URL
    /**
     *  
     client_id      true	string	申请应用时分配的AppKey。
     redirect_uri   true	string	授权回调地址，
     */
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", APPKEY_Sina, APPREDIRECT_Sina];
    
    // 2. 请求授权
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

#pragma mark -
#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1. 获得URL
    NSString *url = request.URL.absoluteString;
//    LogRed(@"%s -- %@",__func__, request.URL.absoluteString);
    
    // 2. 判断是是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        // 截取code 后面的内容
        NSInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
//        LogGreen(@"%@",code);
        
        // 3.利用code 换取一个accessToken
        [self accessTokenWithCode:code];

        /**  不跳转到回调页面 ***/
        return NO;
    }
    return YES;
}

/**
 *  利用code 换取一个accessToken
 *
 */
- (void)accessTokenWithCode:(NSString *)code
{
    /**
     *  https://api.weibo.com/oauth2/access_token
     *
     client_id      true	string	申请应用时分配的AppKey。
     client_secret	 true	string	申请应用时分配的AppSecret。
     grant_type	 true	string	请求的类型，填写authorization_code
     code           true   string	调用authorize获得的code值。
     redirect_uri	 true	string	回调地址，需需与注册应用里的回调地址一致。
     */
    // 1. 请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 2. 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"code"] = code;
    params[@"client_id"] = APPKEY_Sina;
    params[@"client_secret"] = APPSECRET_Sina;
    params[@"redirect_uri"] = APPREDIRECT_Sina;
    params[@"grant_type"] = @"authorization_code";
    
    // 3. POST 请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        // 答应返回值 类型
//        LogYellow(@"respose - %@",[NSString stringWithUTF8String:object_getClassName(responseObject)]);
        // 请求成功
        /**
         uid = 5655531910,
         expires_in = 157679999,
         access_token = 2.00cMCkKG_v29NBd13f6ad65dtbAZOE,
         remind_in = 157679999
         */
//        LogRed(@"登录成功 - %@", [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
        
        
        // 将账号信息, 转换成模型
        PPAccount *account = [PPAccount mj_objectWithKeyValues:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]];
        // 将账号数据 存储到沙盒路径
        [PPAccountManager saveAccout:account];

        // 归档 模型 -- 自定义模型必须用归档
//        [NSKeyedArchiver archiveRootObject:account toFile:path];
        // Dictionary NSArray -- 字典数组
//        [responseObject writeToFile:path atomically:YES];
        
        // 切换窗口根控制器
        [[UIApplication sharedApplication].keyWindow switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        LogGreen(@"%@", error);
    }];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中....." toView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
