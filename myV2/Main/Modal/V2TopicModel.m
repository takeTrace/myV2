//
//  V2TopicModel.m
//  myV2
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2TopicModel.h"
#import <MJExtension.h>
#import <NSDate+TimeAgo.h>
@implementation V2TopicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"ID" : @"id"};
}

- (void)setCreated:(NSString *)created
{
    if (([created rangeOfString:@"回复"].length > 0) || ([created rangeOfString:@"前"].length > 0) || ([created rangeOfString:@"置顶"].length > 0)) {
        _created = created;
        return;
    } else if ([created rangeOfString:@"字符"].length > 0)
    {
        return;
    } else if (!created)
    {
        return;
    }
    
    
    _created = [NSDate dateWithTimeIntervalSince1970:created.doubleValue].timeAgo;
    
}
@end
