//
//  PPDropdownMenu.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/11.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPDropdownMenu.h"

@interface PPDropdownMenu ()
 /**  用来显示内容的容器 ***/
@property (nonatomic, weak) UIImageView *dropdownMenu;

@end

@implementation PPDropdownMenu
/**
 *  懒加载
 */
- (UIImageView *)dropdownMenu{
    if (!_dropdownMenu) {
        UIImageView *dropdownMenu = [[UIImageView alloc] initWithFrame:CGRectMake(PP_SCREEN_WIDTH * 0.5, 64, 200, 200)];
        dropdownMenu.centerX = PP_SCREEN_WIDTH * 0.5;
        dropdownMenu.userInteractionEnabled = YES;
        dropdownMenu.image = [UIImage imageNamed:@"popover_background"];
        [self addSubview:dropdownMenu];
        
        _dropdownMenu = dropdownMenu;
    }
    return _dropdownMenu;
}


/**
 *  重写set方法
 */
- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    contentView.x = 10;
    contentView.y = 15;
//    contentView.width = self.dropdownMenu.width - 2 * contentView.x;
    
    // 设置尺寸
    self.dropdownMenu.height = 10 + CGRectGetMaxY(contentView.frame);
    self.dropdownMenu.width = contentView.width + 2 * contentView.x;
    
    // 向容器中添加内容
    [self.dropdownMenu addSubview:contentView];
}


/**
 *  添加引用, 防止View销毁
 */
- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    
    self.contentView = contentViewController.view;
}


+ (instancetype)dropdownMenu
{
    return [[self alloc] init];
}


/**
 *  初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 添加遮板
        self.backgroundColor = [UIColor clearColor];
        
        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    
    }
    return self;
}


/**
 *  显示
 */
- (void)showFrom:(UIView *)from
{
    // 1. 获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2. 添加到自己的窗口上
    [window addSubview:self];
    
    // 3. 设置尺寸
    self.frame = window.bounds;
    
    // 4. 调整灰色图片的位置
    
     /**  转换坐标系 ***/
    // 默认, frame是以父控件左上角为坐标原点
    // 可以转换坐标系原点, 改变frame的参考点
//    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    
    self.dropdownMenu.centerX = CGRectGetMidX(newFrame);
    self.dropdownMenu.y = CGRectGetMaxY(newFrame);
    
    if([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]){
        [self.delegate dropdownMenuDidShow:self];
    }
    
}

/**
 *  销毁
 */
- (void)dismiss
{
    [self removeFromSuperview];
    
    if([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]){
        [self.delegate dropdownMenuDidDismiss:self];
    }
}
@end
