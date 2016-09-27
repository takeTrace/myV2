//
//  V2OperationManager.m
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2OperationTool.h"

@implementation V2OperationTool

static AFHTTPRequestOperationManager *_mgr;

+ (void)initialize
{
    if (self == [V2OperationTool class]) {
        _mgr = [AFHTTPRequestOperationManager manager];
    }
}

+ (BOOL)cancelRequestOperation
{
    return YES;
}

+ (BOOL)isConnect
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)cancelAllOperations
{
    [_mgr.operationQueue cancelAllOperations];
}

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString dataType:(V2DataType)type parameters:(id)parameters tag:(id)tag success:(void (^)(id))success failure:(void (^)(NSError *))failure
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
        NSLog(@"_mgr 的序列化: %@", [_mgr.responseSerializer class]);
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}



+ (AFHTTPRequestOperation *)POST:(NSString *)URLString dataType:(V2DataType)type parameters:(id)parameters otherSeeting:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    if (dict) {
        
        [mgr.requestSerializer setValue:@"https://v2ex.com/signin" forHTTPHeaderField:@"Referer"];
    }
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
        NSLog(@"_mgr 的序列化: %@", [_mgr.responseSerializer class]);
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}


+ (BOOL)isJsonResponseSerializer
{
    return [_mgr.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]];
}

+ (BOOL)isHttpResponseSerializer
{
    return [_mgr.responseSerializer isKindOfClass:[AFHTTPRequestSerializer class]];
}
@end
