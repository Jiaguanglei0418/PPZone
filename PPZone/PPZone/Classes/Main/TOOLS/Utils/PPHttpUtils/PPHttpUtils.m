//
//  PPHttpUtils.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/12.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPHttpUtils.h"
#import "AFNetworking.h"
@implementation PPHttpUtils
+ (void)GETWithURL:(NSString *)url prarams:(NSDictionary *)params success:(void (^) (id json))success failure:(void (^) (NSError *error))failure{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (success) {
            success(responseObject);
            
//            [MBProgressHUD showSuccess:@"发送成功"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
//            [MBProgressHUD showError:@"发送失败"];
        }
    }];
    
    
}

+ (void)POSTWithURL:(NSString *)url prarams:(NSDictionary *)params success:(void (^) (id json))success failure:(void (^) (NSError *error))failure
{
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    // 2.发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (success) {
            success(responseObject);
//            [MBProgressHUD showSuccess:@"发送成功"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
//            [MBProgressHUD showError:@"发送失败"];
        }
    }];
}


+ (void)POSTWithURL:(NSString *)url prarams:(NSDictionary *)params formDataArray:(NSArray *)dataArray success:(void (^) (id json))success failure:(void (^) (NSError *error))failure
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        
        for (PPFormData *formData in dataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (success) {
            success(responseObject);
//            [MBProgressHUD showSuccess:@"发送成功"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
//            [MBProgressHUD showError:@"发送失败"];
        }
    }];
}
@end

/**
 *  用来封装文件数据的模型
 */
@implementation PPFormData

@end
