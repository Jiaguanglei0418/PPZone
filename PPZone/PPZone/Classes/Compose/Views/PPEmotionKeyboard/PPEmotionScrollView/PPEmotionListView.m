//
//  PPEmotionListView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/18.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionListView.h"
#import "PPEmotionListPageView.h"
// [注意]: 写成小数否则, 0.5只能取到0
#define PPEmotionListViewPageNumber ceilf((CGFloat)(self.emotions.count / 20.0))

@interface PPEmotionListView ()<UIScrollViewDelegate>

PROPERTYWEAK(UIScrollView, scrollview)

PROPERTYWEAK(UIPageControl, pageCon)
@end

@implementation PPEmotionListView
//- (UIScrollView *)scrollview
//{
//    if (!_scrollview) {
//        UIScrollView *scrollview = [[UIScrollView alloc] init];
//        scrollview.pagingEnabled = YES;
//        scrollview.delegate = self;
//        [self addSubview:scrollview];
//        _scrollview = scrollview;
//    }
//    return _scrollview;
//}


- (UIPageControl *)pageCon
{
    if (!_pageCon) {
        UIPageControl *page = [[UIPageControl alloc] init];
//        page.pageIndicatorTintColor = [UIColor redColor];
//        page.currentPageIndicatorTintColor = [UIColor greenColor];
//        page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
//        page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
        // 图片格式修改
        [page setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [page setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        page.numberOfPages = PPEmotionListViewPageNumber;
        page.currentPage = 0;
        // 当只有一页时, 自动隐藏
        page.hidesForSinglePage = YES;
        [self addSubview:page];
        _pageCon = page;
    }
    return _pageCon;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 开始显示默认的表情
        // 1. scrollView
        UIScrollView *scrollview = [[UIScrollView alloc] init];
        scrollview.pagingEnabled = YES;
        // 去除水平方向滚动条 - subview中不会有了
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.bounces = NO;
        scrollview.delegate = self;
        [self addSubview:scrollview];
        self.scrollview = scrollview;
//        self.scrollview.backgroundColor = [UIColor redColor];
        
        // 2. pagecon
//        self.pageCon.backgroundColor = PPCOLOR_RANDOM;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. scrollview
    self.scrollview.frame = self.bounds;
    self.scrollview.height = self.height * 0.9;
//    设置scrollView contentSize
    self.scrollview.contentSize = CGSizeMake(self.scrollview.width * PPEmotionListViewPageNumber, 0);
    
    // 2. page
    CGFloat pageCenterX = self.centerX;
    CGFloat pageCenterY = self.height * 0.95;
    self.pageCon.size = CGSizeMake(self.width * 0.2, 20);
    self.pageCon.center = CGPointMake(pageCenterX, pageCenterY);
    
    // 3. 子控件
    for (int i = 0; i < self.scrollview.subviews.count; i++) {
        PPEmotionListPageView *pageView = self.scrollview.subviews[i];
        pageView.frame = CGRectMake(self.scrollview.width * i, 0, self.scrollview.width, self.scrollview.height);
    }

}


- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 删除之前的视图, 重新计算
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 1. 设置页数
    self.pageCon.numberOfPages = PPEmotionListViewPageNumber;
    
    // 2. 创建表情容器
    // 设置表情
    // 1. scrollview
    for (int i = 0; i < PPEmotionListViewPageNumber; i++) {
        PPEmotionListPageView *pageView = [[PPEmotionListPageView alloc] init];
        
        // 计算每一页, 表情个数
        NSRange range;
        range.location = i * PPEmotionListPageViewMaxNum;
        // left: 剩余表情数
        NSUInteger left = emotions.count - range.location;
        // 满页
        if (left >= PPEmotionListPageViewMaxNum) {
            range.length = PPEmotionListPageViewMaxNum;
        }else{
            range.length = left;
        }
        
        // 设置表情
        pageView.datas = [emotions subarrayWithRange:range];
        
//        LogGreen(@"count --- %ld", pageView.datas.count);
//        pageView.backgroundColor = PPCOLOR_RANDOM;
        [self.scrollview addSubview:pageView];
    }
    
    // 3. 重新计算frame
    [self setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageCon.currentPage = (NSInteger)(scrollView.contentOffset.x / PP_SCREEN_WIDTH + 0.5);
}

@end
