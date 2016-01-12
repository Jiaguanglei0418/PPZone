//
//  PPComposePhotosView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/12.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPComposePhotosView.h"

#define PPComposePhotosView_COL 4
//#define PPComposePhotosView_ROW 3
#define PPComposePhotosView_PHOTO_Margin 10
#define PPComposePhotosView_PHOTO_W ((self.width - (PPComposePhotosView_COL+1) * PPComposePhotosView_PHOTO_Margin) / PPComposePhotosView_COL)
#define PPComposePhotosView_PHOTO_H PPComposePhotosView_PHOTO_W

@implementation PPComposePhotosView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}

- (void)addPhoto:(UIImage *)photo
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = photo;
    [self addSubview:imageView];
}

- (NSArray *)totalPhotos
{
    NSMutableArray *photos = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[UIImageView class]]) {
            [photos addObject:obj.image];
        }
    }];
    return photos;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageW = PPComposePhotosView_PHOTO_W;
    CGFloat imageH = PPComposePhotosView_PHOTO_H;
    for (int i = 0 ; i < self.subviews.count; i++) {
        int row = i / PPComposePhotosView_COL;
        int col = i % PPComposePhotosView_COL;
        CGFloat imageX = col * (PPComposePhotosView_PHOTO_W + PPComposePhotosView_PHOTO_Margin) + PPComposePhotosView_PHOTO_Margin;
        CGFloat imageY = row * (PPComposePhotosView_PHOTO_H + PPComposePhotosView_PHOTO_Margin);
        
        UIImageView *imageView = (UIImageView *)self.subviews[i];
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    }
    
}

@end
