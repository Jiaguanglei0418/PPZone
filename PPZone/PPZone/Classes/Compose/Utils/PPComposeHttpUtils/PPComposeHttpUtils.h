//
//  PPComposeHttpUtils.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/13.
//  Copyright © 2016年 roseonly. All rights reserved.
//

/// -----  发微博业务工具类
#import <Foundation/Foundation.h>
#import "PPBaseParams.h"
@class PPComposeHttpUtilsParams;

@interface PPComposeHttpUtils : NSObject



/**
 *  发微博 -  微博数据
 *
 *  @param params  请求参数
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)composeWithPhotoesParams:(PPComposeHttpUtilsParams *)params success:(void(^)())success failure:(void(^)(NSError *error)) failure;


/**
 *  发微博 -  微博数据 - 没有图片
 *
 *  @param params  请求参数
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)composeParams:(PPComposeHttpUtilsParams *)params success:(void(^)())success failure:(void(^)(NSError *error)) failure;

@end
#pragma mark - PPComposeSentPhotoesParams
@interface PPComposeHttpUtilsParams : PPBaseParams
PROPERTYCOPY(NSString, status)

PROPERTYSTRONG(NSMutableArray, formdata) // 图片
@end

