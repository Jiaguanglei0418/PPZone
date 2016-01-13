//
//  PPBaseParams.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/13.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PPAccount;
@interface PPBaseParams : NSObject
PROPERTYCOPY(NSString, access_token)


+ (instancetype)param;
@end
