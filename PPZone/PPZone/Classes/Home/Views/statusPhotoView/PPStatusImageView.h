//
//  PPStatusImageView.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/7.
//  Copyright © 2016年 roseonly. All rights reserved.
//

// ----  一张配图

#import <UIKit/UIKit.h>
@class PPPhoto;

@interface PPStatusImageView : UIImageView

/**
 *  指示是否是GIF
 */
@property(nonatomic, strong) PPPhoto *photo;

@end
