//
//  V2TabModel.m
//  myV2
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2TabModel.h"

#define V2Domian @"https://www.v2ex.com"

@implementation V2TabModel
- (void)setUrlStr:(NSString *)urlStr
{

    if ([urlStr rangeOfString:@"www.v2ex"].length > 0) {
        _urlStr = urlStr;
    } else {
        _urlStr = [V2Domian stringByAppendingString:urlStr];
    }
}
@end
