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
@end
