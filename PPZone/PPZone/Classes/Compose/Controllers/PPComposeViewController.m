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
#import "PPComposeToolbar.h" // 工具条
#import "PPComposePhotosView.h" // 发微博 imageView

#import "PPComposeHttpUtils.h" // 网络请求工具类

@interface PPComposeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, PPComposeToolbarDelegate>

// textView
PROPERTYWEAK(PPTextView, textView)
// 工具条
PROPERTYWEAK(PPComposeToolbar, toolbar)
// 图片View
PROPERTYWEAK(PPComposePhotosView, photosView)

@end

@implementation PPComposeViewController
/**
 *  lazy
 */
- (PPTextView *)textView
{
    if (!_textView) {
        PPTextView *textView = [[PPTextView alloc] init];
        textView.frame = self.view.bounds;
        textView.placeholder.text = @" 请输入微博内容 ...";
        [self.view addSubview:textView];
        _textView = textView;
    }
    return _textView;
}

/**
 *  工具条
 */
- (PPComposeToolbar *)toolbar
{
    if (!_toolbar) {
        PPComposeToolbar *toolbar = [PPComposeToolbar composeToolbar];
        toolbar.frame = CGRectMake(0, PP_SCREEN_HIGHT - 44, self.view.width, 44);
        [self.view addSubview:toolbar];
        _toolbar = toolbar;
    }
    return _toolbar;
}

// 弹出键盘, (减缓卡顿)
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    // 1. 注册通知, 监听键盘状态
    [PPNOTICEFICATION addObserver:self selector:@selector(keyboardDidShowMethod:) name:UIKeyboardDidShowNotification object:nil];
    [PPNOTICEFICATION addObserver:self selector:@selector(keyboardDidHideMethod:) name:UIKeyboardDidHideNotification object:nil];
    
    // 2. 注册通知, 监听文本改变
    [PPNOTICEFICATION addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
    
    [self.textView becomeFirstResponder];
}

// 拖动textView, 键盘消失
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textView endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1. 设置导航栏内容
    [self setupNav];
    
    // 2. 添加输入控件
    [self setupTextView];

    // 3. 添加工具条
    [self setupToolbar];

    // 添加相册
    [self setupPhotosView];

}
#pragma mark - 设置照片内容
- (void)setupPhotosView
{
    CGFloat photosW = self.textView.width;
    CGFloat photosY = 80;
    CGFloat photosH = self.textView.height - photosY;
    PPComposePhotosView *photosView = [[PPComposePhotosView alloc] initWithFrame:CGRectMake(0, photosY, photosW, photosH)];
    
    [self.textView  addSubview:photosView];
    _photosView = photosView;
}

#pragma mark - 设置工具栏内容
- (void)setupToolbar
{
    self.toolbar.delegate = self;
}
#pragma mark -- toolbarDeleagete
- (void)composeToolbar:(PPComposeToolbar *)toolbar didClickedToolbarButton:(PPComposeToolbarButtonType)composeToolbarButtonType
{
    switch (composeToolbarButtonType) {
        case PPComposeToolbarButtonTypeCamera: { // 照相
            [self presentPhotoCameraViewController];
            break;
        }
        case PPComposeToolbarButtonTypePicture: { // 相册
            [self presentPhotoAlbumViewController];
            break;
        }
        case PPComposeToolbarButtonTypeMention: { // 提到我的
            LogRed(@"__PPComposeToolbarButtonTypeMention _");
            break;
        }
        case PPComposeToolbarButtonTypeTrend: { // 关注
            LogRed(@"PPComposeToolbarButtonTypeTrend _");

            break;
        }
        case PPComposeToolbarButtonTypeEmotion: { // 表情
             LogRed(@"PPComposeToolbarButtonTypeEmotion _");
            break;
        }
    }
}

// 打开相册
- (void)presentPhotoAlbumViewController
{
    /**
     UIImagePickerControllerSourceTypePhotoLibrary,
     UIImagePickerControllerSourceTypeCamera,
     UIImagePickerControllerSourceTypeSavedPhotosAlbum
     */
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


// 打开相机
- (void)presentPhotoCameraViewController
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
#pragma mark - imagePikerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
//        LogRed(@"%@", info);
    }];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.photosView addPhoto:image];
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
    if ([self.photosView totalPhotos].count) {
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
    // 2.拼接请求参数
    PPComposeHttpUtilsParams *param = [[PPComposeHttpUtilsParams alloc] init];
    param.access_token = [PPAccountManager account].access_token;
    param.status = self.textView.text;
    param.formdata = [NSMutableArray array];
    // 拼接照片数据
    NSArray *totalPhotos = [self.photosView totalPhotos];
    
    [totalPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 拼接文件数据
        PPFormData *formData = [[PPFormData alloc] init];
        formData.data = UIImageJPEGRepresentation(obj, 1.0);
        formData.name = @"pic";
        formData.filename = [NSString stringWithFormat:@"count%lu", idx];
        formData.mimeType = @"image/jpeg";
        
        [param.formdata addObject:formData];
    }];
    
    [PPComposeHttpUtils composeWithPhotoesParams:param success:^{
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:@"发送失败"];
    }];
}

- (void)sendWithoutImage
{
    // 2.拼接请求参数
    PPComposeHttpUtilsParams *param = [[PPComposeHttpUtilsParams alloc] init];
    param.access_token = [PPAccountManager account].access_token;
    param.status = self.textView.text;
    
    [PPComposeHttpUtils composeParams:param success:^{
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:@"发送失败"];
    }];
}

#pragma mark - 监听TextView内容改变
- (void)setupTextView
{
    // 1. 创建textView
    self.textView.delegate = self;
    
}

// 监听文字改变
- (void)textViewTextDidChange
{
    if (![self.textView.text isEqualToString:@""]) {
        self.textView.placeholder.hidden = YES;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else{
        self.textView.placeholder.hidden = NO;
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

#pragma mark - 监听键盘show hide
- (void)keyboardDidShowMethod:(NSNotification *)notice
{
    // 1. 取出键盘的frame
    CGRect keyboardFrame = [notice.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2. 取出键盘动画时间
    CGFloat keyboardTime = [notice.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:keyboardTime animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, -keyboardFrame.size.height);
    }];
}

- (void)keyboardDidHideMethod:(NSNotification *)notice
{
    CGFloat keyboardTime = [notice.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:keyboardTime animations:^{
        self.toolbar.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI), CGAffineTransformMakeScale(1.5, 1.5));
    } completion:^(BOOL finished) {
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}



// 移除通知
- (void)dealloc{
    [PPNOTICEFICATION removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
    [PPNOTICEFICATION removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [PPNOTICEFICATION removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
@end
