//
//  PPTextView.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/8.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPTextView : UITextView
/**
 *  发送的图片
 */
PROPERTYSTRONG(NSArray, photos)
/**
 *  placeholder
 */
PROPERTYWEAK(UILabel, placeholder)
@end
