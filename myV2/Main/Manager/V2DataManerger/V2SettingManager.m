//
//  V2OperationManager.m
//  myV2
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2SettingManager.h"
#import "YCTool.h"
#import <SDImageCache.h>
@implementation V2SettingManager
- (NSString *)outDate
{
    if (!_outDateBeforeNow) {
        _outDateBeforeNow = 1;
        
    }
    NSDate *previousDate = [NSDate dateWithTimeIntervalSinceNow:(-24*60*60*_outDateBeforeNow)];
    
    return NSStringFromFormat(@"%g", [previousDate timeIntervalSince1970]);
}

+ (void)clearImageCache
{
    [[SDImageCache sharedImageCache] clearDisk];
}

+ (CGFloat)getDiskImageCacheSize
{
    return [[SDImageCache sharedImageCache] getSize] * 0.001 * 0.001 ;
}

+ (void)setToLoading:(BOOL)loading
{
    V2SettingManager *mgr = [self shareSettingManager];
    mgr.loading = loading;
}
+ (void)setToNightMode:(BOOL)night
{
    V2SettingManager *mgr = [self shareSettingManager];
    mgr.nightMode = night;
}
singleton_m(SettingManager)
@end
