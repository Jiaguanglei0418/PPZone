//
//  PPComposeViewController.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/8.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPComposeViewController.h"
#import "PPAccountManager.h"
#import "UIBarButtonItem+Extension.h"
#import "PPTextView.h" // 输入框



@interface PPComposeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

PROPERTYWEAK(PPTextView, textView)



@end

@implementation PPComposeViewController

- (PPTextView *)textView
{
    if (!_textView) {
       
    }
    return _textView;
}

// 弹出键盘, (减缓卡顿)
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏内容
    [self setupNav];
    LogRed(@"%d", self.navigationItem.rightBarButtonItem.isEnabled);
    // 添加输入控件
    [self setupTextView];
//
//    // 添加工具条
//    [self setupToolbar];
//    
//    // 添加相册
//    [self setupPhotosView];

}

#pragma mark - 设置导航栏内容
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    
    NSString *name = [PPAccountManager account].name;
    NSString *prefix = @"发微博";
    if (name) {
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        // 自动换行
        titleView.numberOfLines = 0;
        titleView.y = 50;
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        
        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    } else {
        self.title = prefix;
    }
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send {
    if (self.textView.photos.count) {
        [self sendWithImage];
    } else {
        [self sendWithoutImage];
    }
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 发送
- (void)sendWithImage
{
    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /**	pic true binary 微博的配图。*/
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [PPAccountManager account].access_token;
    params[@"status"] = self.textView.text;
    
    // 3.发送请求
    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage *image = [self.textView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];

    
    
}

- (void)sendWithoutImage
{
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [PPAccountManager account].access_token;
    params[@"status"] = self.textView.text;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];

}

#pragma mark - 设置导航栏内容
- (void)setupTextView
{
    // 1. 创建textView
    PPTextView *textView = [[PPTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:18];
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    _textView = textView;
    
    // 2. 注册通知, 监听文本改变
    [PPNOTICEFICATION addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
}
// 监听文字改变
- (void)textViewTextDidChange
{
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}



// 移除通知
- (void)dealloc{
    [PPNOTICEFICATION removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
}
@end
