//
//  V2ReplyModel.m
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2ReplyModel.h"
#import <MJExtension.h>
#import <NSDate+TimeAgo.h>
@implementation V2ReplyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"ID" : @"id" };
}

- (void)setCreated:(NSString *)created
{
    if ([created rangeOfString:@"前"].length > 0) {
        _created = created;
        return;
    }
    _created = [NSDate dateWithTimeIntervalSince1970:created.doubleValue].timeAgoSimple;
}

@end
