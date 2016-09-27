//
//  V2OperationManager.h
//  myV2
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCTool.h"

@interface V2SettingManager : NSObject
@property (nonatomic, assign) int outDateBeforeNow;

- (NSString *)outDate;

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL nightMode;

+ (void)setToLoading:(BOOL)loading;
+ (void)setToNightMode:(BOOL)night;

+ (void)clearImageCache;
+ (CGFloat)getDiskImageCacheSize;

singleton_h(SettingManager)
@end
