//
//  PPToolbar.h
//  PPZone
//
//  Created by jiaguanglei on 15/11/25.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPStatus;
@interface PPToolbar : UIView
+ (instancetype)toolbar;
@property (nonatomic, strong) PPStatus *status;
@end
