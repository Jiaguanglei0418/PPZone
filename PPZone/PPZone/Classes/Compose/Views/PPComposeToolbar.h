//
//  PPComposeToolbar.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/11.
//  Copyright © 2016年 roseonly. All rights reserved.
//

/**
 *  自定义工具条  --- 显示在键盘上面
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PPComposeToolbarButtonType) {
    PPComposeToolbarButtonTypeCamera,
    PPComposeToolbarButtonTypePicture,
    PPComposeToolbarButtonTypeMention,
    PPComposeToolbarButtonTypeTrend,
    PPComposeToolbarButtonTypeEmotion
};

@class PPComposeToolbar;
@protocol PPComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(PPComposeToolbar *)toolbar didClickedToolbarButton:(PPComposeToolbarButtonType)composeToolbarButtonType;
@end


@interface PPComposeToolbar : UIView

PROPERTYDELEGATE(PPComposeToolbarDelegate, delegate)

+ (instancetype)composeToolbar;

@end
