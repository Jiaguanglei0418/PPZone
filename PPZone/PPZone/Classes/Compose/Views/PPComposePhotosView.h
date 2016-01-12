//
//  PPComposePhotosView.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/12.
//  Copyright © 2016年 roseonly. All rights reserved.
//
/**
 *  发微博  ----   整体imageView
 */
#import <UIKit/UIKit.h>

@interface PPComposePhotosView : UIView

/**
 *  添加一张新的图片
 */
- (void)addPhoto:(UIImage *)photo;


/**
 *  返回所有照片
 */
- (NSArray *)totalPhotos;
@end
