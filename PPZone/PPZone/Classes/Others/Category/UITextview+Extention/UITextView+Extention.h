//
//  UITextView+Extention.h
//  loveonly
//
//  Created by jiaguanglei on 15/10/29.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extention)
- (void)insertAttributedText:(NSAttributedString *)text;
- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock;
@end
