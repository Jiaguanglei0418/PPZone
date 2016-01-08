//
//  PPStatusPhotoView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/6.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPStatusPhotoView.h"
#import "PPStatusImageView.h"

// cell的边框宽度
#define PPStatusPhotoViewBorderW 10
// 配图宽度/高度
#define PPStatusPhotoW floor((PP_SCREEN_WIDTH - 4 * PPStatusPhotoViewBorderW) / 3)

// 最大列数
#define PPStatusPhotoViewMaxColum(count) ((count == 4) ? 2 : 3)

@implementation PPStatusPhotoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

/**
 *  此方法调用非常频繁, 需要判断
 */
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    // 创建足够的imageView
    while (self.subviews.count < photos.count) {
        PPStatusImageView *image = [[PPStatusImageView alloc] init];
        [self addSubview:image];
    }

    // 遍历图片控件, 设置图片
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        PPStatusImageView *image = self.subviews[i];
        
        if (i < photos.count) { // 显示
            image.hidden = NO;
            
            // 设置 PPStatusImageView 的photo属性(判断 是否显示gif)
            image.photo = photos[i];
            
        }else{ // 隐藏
            image.hidden = YES;
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片尺寸和位置
    for (int i = 0; i < self.photos.count; i++) {
        PPStatusImageView *image = self.subviews[i];
        
        int row = i / PPStatusPhotoViewMaxColum(self.photos.count);
        int colum = i % PPStatusPhotoViewMaxColum(self.photos.count);
        image.frame = CGRectMake(colum * (PPStatusPhotoW + PPStatusPhotoViewBorderW), row * (PPStatusPhotoW + PPStatusPhotoViewBorderW), PPStatusPhotoW, PPStatusPhotoW);
    }
}

/**
 *  根据 配图计算 size
 */
+ (CGSize)sizeWithCount:(NSInteger)count
{
    NSInteger row = ceilf((CGFloat)count / PPStatusPhotoViewMaxColum(count));
    /**  计算页数   */
    //    int maxColum = 3;
    //    int rows = (count + maxColum - 1) / maxColum;
    
    NSInteger colum = (count >= PPStatusPhotoViewMaxColum(count)) ? PPStatusPhotoViewMaxColum(count) : count;
    
    return CGSizeMake(PPStatusPhotoW * colum + PPStatusPhotoViewBorderW * (colum - 1), PPStatusPhotoW * row + PPStatusPhotoViewBorderW * (colum - 1));
}
@end
