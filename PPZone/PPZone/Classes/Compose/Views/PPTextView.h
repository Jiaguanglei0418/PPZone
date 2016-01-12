//
//  PPTextView.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/8.
//  Copyright © 2016年 roseonly. All rights reserved.
//

/**
 *  自定义 textView --- 能够展示placeHolder, imageView
 **/

#import <UIKit/UIKit.h>

@interface PPTextView : UITextView
/**
 *  发送的图片
 */
//PROPERTYSTRONG(NSMutableArray, photos)
/**
 *  placeholder
 */
PROPERTYWEAK(UILabel, placeholder)
@end
