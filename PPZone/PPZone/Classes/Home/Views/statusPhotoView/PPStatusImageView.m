//
//  PPStatusImageView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/7.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPStatusImageView.h"
#import "PPPhoto.h"
#import "UIImageView+WebCache.h"

@interface PPStatusImageView ()

@property (nonatomic, weak) UIImageView *gif;
@end

@implementation PPStatusImageView

/**
 *  lazy
 */
- (UIImageView *)gif
{
    if (!_gif) {
        UIImageView *gif = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        [self addSubview:gif];
        _gif = gif;
    }
    return _gif;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        /**
         UIViewContentModeScaleToFill,         // 按设置尺寸 - 填充
         UIViewContentModeScaleAspectFit,      // 按设置尺寸 - 等比例填充, 有边界
         UIViewContentModeScaleAspectFill,     // 按原来尺寸 - 填充, clipsToBounds切除边界
         UIViewContentModeRedraw,              // 调用了setNeedDisplay方法时, 将会对图片重新渲染       
         UIViewContentModeCenter,              //
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
         
         1. 凡是带有scale单词的, 图片会被拉伸
         2. 凡是带有Aspect单词的, 图片会保持原来宽高比
         */
        // 设置 图片按比例拉伸
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gif.x = self.width - self.gif.width;
    self.gif.y = self.height - self.gif.height;
}

- (void)setPhoto:(PPPhoto *)photo
{
    _photo = photo;
    
    // 设置 图片
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
//    LogYellow(@"%@", photo.thumbnail_pic);
    // 设置 显示gif
    self.gif.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}
@end
