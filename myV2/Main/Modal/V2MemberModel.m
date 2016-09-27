//
//  V2MemberModel.m
//  myV2
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2MemberModel.h"

@implementation V2MemberModel
- (void)setAvatar_normal:(NSString *)avatar_normal
{
    if (![avatar_normal hasPrefix:@"htt"]) {
        avatar_normal = [@"https:" stringByAppendingString:avatar_normal];
    }
    
    _avatar_normal = avatar_normal;
}

- (void)setUrl:(NSString *)url
{
    if ([url hasPrefix:@"http:"]) {
        url = [url stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
    }
    
    _url = url;
}


/**
 *   使这个类的对象能够归档, 加这句代码会自动添加这些 coding 和 decoding 代码
 */
MJCodingImplementation
@end
