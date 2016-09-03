//
//  V2TopicModel.m
//  myV2
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2TopicModel.h"
#import <MJExtension.h>
@implementation V2TopicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"ID" : @"id"};
}
@end
