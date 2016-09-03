//
//  V2ReplyModel.m
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2ReplyModel.h"
#import <MJExtension.h>
@implementation V2ReplyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"ID" : @"id" };
}

@end
