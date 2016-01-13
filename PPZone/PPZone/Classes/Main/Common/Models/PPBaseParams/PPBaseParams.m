//
//  PPBaseParams.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/13.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPBaseParams.h"
#import "PPAccountManager.h"
@implementation PPBaseParams
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.access_token = [PPAccountManager account].access_token;
    }
    return self;
}


+ (instancetype)param
{
    return [[self alloc] init];
}
@end
