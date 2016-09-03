//
//  V2OperationManager.m
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2OperationTool.h"

@implementation V2OperationTool

+ (BOOL)isConnect
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString dataType:(V2DataType)type parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    switch (type) {
        case V2DataTypeJSON:
            break;
        case V2DataTypeHTTP:
            mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    return [mgr GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}



+ (AFHTTPRequestOperation *)POST:(NSString *)URLString dataType:(V2DataType)type parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    switch (type) {
        case V2DataTypeJSON:
            break;
        case V2DataTypeHTTP:
            mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    return [mgr POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}
@end
