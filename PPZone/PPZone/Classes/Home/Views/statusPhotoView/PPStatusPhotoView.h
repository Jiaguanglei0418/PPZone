//
//  PPStatusPhotoView.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/6.
//  Copyright © 2016年 roseonly. All rights reserved.
//
/**
 *  用于显示 微博的配图 ----    1 - 9张照片
 */
#import <UIKit/UIKit.h>

@interface PPStatusPhotoView : UIView

/**
 *  配图数组
 */
@property (nonatomic, strong) NSArray *photos;


/**
 *  根据配图个数, 计算size
 */
+ (CGSize)sizeWithCount:(NSInteger)count;

@end
