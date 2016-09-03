//
//  V2NodeModel.m
//  myV2
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2NodeModel.h"
#import <MJExtension.h>
@implementation V2NodeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"ID" : @"id"};
}

//- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
//{
//    if ([property isKindOfClass:[NSString class]]) {
//        if (oldValue == nil) {
//            return @"";
//        }
//    }
//    
//    return oldValue;
//}

- (void)setFooter:(NSString *)footer
{
    if (!footer) {
        footer = @"";
    }
    
    _footer = footer;
    
    
}

- (void)setHeader:(NSString *)header
{
    if (!header) {
        header = @"";
    }
    
    _header = header;
}
@end
