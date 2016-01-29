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

#import "PPComposeToolbar.h" // 工具条
#import "PPComposePhotosView.h" // 发微博 imageView

#import "PPComposeHttpUtils.h" // 网络请求工具类
#import "PPEmotionKeyboard.h" // 表情键盘

#import "PPEmotionTextView.h" // 显示emotion


@interface PPComposeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, PPComposeToolbarDelegate>

// textView
PROPERTYWEAK(PPEmotionTextView, textView)
// 工具条
PROPERTYWEAK(PPComposeToolbar, toolbar)
// 图片View
PROPERTYWEAK(PPComposePhotosView, photosView)
// 表情键盘
PROPERTYSTRONG(PPEmotionKeyboard, emotionKeyboard)
// 键盘切换状态
PROPERTYASSIGN(BOOL, switchingKeybaord)

// 键盘高度
PROPERTYASSIGN(CGFloat, keyboardH)
@end

@implementation PPComposeViewController
#pragma mark - 懒加载
// textView
- (PPEmotionTextView *)textView
{
    if (!_textView) {
        PPEmotionTextView *textView = [[PPEmotionTextView alloc] init];
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

- (PPEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[PPEmotionKeyboard alloc] init];
        _emotionKeyboard.width = self.view.width;
        _emotionKeyboard.height = _keyboardH;
        // 由于是弱指针, 需要添加到self.view上, 强引用
//        [self.view addSubview:_emotionKeyboard];
//        _emotionKeyboard = emotionKeyboard;
    }
    return _emotionKeyboard;
}


// 弹出键盘, (减缓卡顿)
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    // 1. 注册通知, 监听键盘状态
    [PPNOTICEFICATION addObserver:self selector:@selector(keyboardDidChangeFrameMethod:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    // 2. 注册通知, 监听文本改变
    [PPNOTICEFICATION addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
    
    // 3. 注册通知, 监听表情键盘中表情的点击
    [PPNOTICEFICATION addObserver:self selector:@selector(listPageViewEmotionButtonDidClickedNoticefication:) name:PPEmotionBtnDidSelectedNoticefication object:nil];
    
    // 4. 注册通知监听删除按钮的点击
    [PPNOTICEFICATION addObserver:self selector:@selector(listPageViewCancelButtonDidClickedNoticefication:) name:PPEmotionCancelBtnDidSelectedNoticefication object:nil];
    
    [self.textView becomeFirstResponder];
}

#pragma mark - 监听表情键盘, 表情按钮点击
- (void)listPageViewEmotionButtonDidClickedNoticefication:(NSNotification *)noticefication
{
    // 隐藏placeholder
    self.textView.placeholder.hidden = YES;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    PPEmotionModel *emotion = noticefication.userInfo[PPEmotionBtnDidSelectedKey];
    // 插入表情
    [self.textView insertEmotion:emotion];
    
    // 保存到最近使用表情中
    
}


// 监听表情键盘, 删除按钮的点击
- (void)listPageViewCancelButtonDidClickedNoticefication:(NSNotification *)noticefication
{
    [self.textView deleteBackward];
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
            // emoj 切换键盘
            [self switchKeyboard];
//            LogRed(@"PPComposeToolbarButtonTypeEmotion _");
            break;
        }
    }
}

/**
 *  切换键盘
 */
- (void)switchKeyboard
{
    if (self.textView.inputView == nil) { // 当前键盘是系统自带键盘
        // 设置 inputView
        self.textView.inputView = self.emotionKeyboard;
        
        // 显示键盘图标
        self.toolbar.showEmotion = NO;
    } else {
        self.textView.inputView = nil;
        
        // 显示表情图标
        self.toolbar.showEmotion = YES;
    }
    
    // 设置键盘切换状态
    self.switchingKeybaord = YES;
    
    // 退出键盘
    [self.textView endEditing:YES];
    // 结束切换键盘
//    self.switchingKeybaord = NO;
    
//    [self.textView resignFirstResponder];
    // 再次弹出键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
        // 结束切换键盘
        self.switchingKeybaord = NO;
    });
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
    param.status = self.textView.fullText;
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
    param.status = self.textView.fullText;
    
    // 发送表情😊
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
    
    // 2. 插入表情
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
- (void)keyboardDidChangeFrameMethod:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeybaord) return;
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyboardH = keyboardF.size.height;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}


// 移除通知
- (void)dealloc{
    [PPNOTICEFICATION removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
    [PPNOTICEFICATION removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [PPNOTICEFICATION removeObserver:self name:PPEmotionBtnDidSelectedKey object:nil];
    [PPNOTICEFICATION removeObserver:self name:PPEmotionCancelBtnDidSelectedNoticefication object:nil];
}
@end
