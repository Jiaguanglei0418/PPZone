//
//  PPHttpUtils.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/12.
//  Copyright © 2016年 roseonly. All rights reserved.
//

/**
 *  封装一个工具类  ----  网络请求工具类
 *  代码耦合性, 降低 --  高内聚, 低耦合
 */
#import <Foundation/Foundation.h>

@interface PPHttpUtils : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)GETWithURL:(NSString *)url prarams:(NSDictionary *)params success:(void (^) (id json))success failure:(void (^) (NSError *error))failure;


/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)POSTWithURL:(NSString *)url prarams:(NSDictionary *)params success:(void (^) (id json))success failure:(void (^) (NSError *error))failure;


/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formData  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)POSTWithURL:(NSString *)url prarams:(NSDictionary *)params formDataArray:(NSArray *)dataArray success:(void (^) (id json))success failure:(void (^) (NSError *error))failure;
@end


/**
 *  用来封装文件数据的模型
 */
@interface PPFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;
@end

