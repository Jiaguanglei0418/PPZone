//
//  PPNewFeatherViewController.m
//  PPZone
//
//  Created by jiaguanglei on 15/11/16.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "PPNewFeatherViewController.h"
#import "PPTabBarController.h"
#define PPNewFeatherImageCount 4

@interface PPNewFeatherViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageCon;
@end

@implementation PPNewFeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建一个scrollview, 显示所有新特性
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(scrollView.width * PPNewFeatherImageCount, 0);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2. 添加内容
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    
    for(int i = 0; i < PPNewFeatherImageCount; i++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;

        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d",i+1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView
        if (i == PPNewFeatherImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3. 设置scrollView的其他属性
    // 3.1 去除弹簧效果
    scrollView.bounces = NO;
    // 3.2 设置分页
    scrollView.pagingEnabled = YES;
    // 3.3 隐藏水平滚动指示条
    scrollView.showsHorizontalScrollIndicator = NO;
    // 3.4 添加分页控制
    UIPageControl *pageCon = [[UIPageControl alloc] init];
    pageCon.centerX = scrollW * 0.5;
    pageCon.centerY = scrollH * 0.9;
    pageCon.numberOfPages = PPNewFeatherImageCount;
    pageCon.currentPageIndicatorTintColor = PPCOLOR_RGB(253, 98, 42);
    pageCon.pageIndicatorTintColor = PPCOLOR_RGB(189, 189, 189);
    [self.view addSubview:pageCon];
    self.pageCon = pageCon;
}

/**
 *  初始化最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    /**  1. 分享给大家 ***/
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"分享给好友" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    btn.size = CGSizeMake(150, 30);
    btn.centerX = imageView.width * 0.5;
    btn.centerY = imageView.height * 0.65;
    [btn addTarget:self action:@selector(shareMethod:) forControlEvents:UIControlEventTouchUpInside];
    btn.adjustsImageWhenHighlighted = NO;
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:btn];
    
    // 2. 开始微博
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始体验PPZone" forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    startBtn.frame = CGRectMake(btn.x, CGRectGetMaxY(btn.frame) + 30, btn.width, btn.height + 10);
    startBtn.layer.cornerRadius = 8;
    startBtn.layer.masksToBounds = YES;
    [imageView addSubview:startBtn];
}

#pragma mark - 监听分享给好友btn点击
- (void)shareMethod:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
}

#pragma mark - 监听开始按钮点击
- (void)start
{
    // 切换控制器
    // 1. push
    // 2. modal
    // 3. 设置根控制器
    [UIApplication sharedApplication].keyWindow.rootViewController = [[PPTabBarController alloc] init];
    
}

#pragma mark -  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 选择整数页码
    self.pageCon.currentPage = scrollView.contentOffset.x / scrollView.width + 0.5;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
