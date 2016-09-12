//
//  V2InitialManager.h
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class V2DrawerController;
@interface V2InitialManager : NSObject

+ (void)initializeRootViewControllerSuccess:(void (^)(__kindof V2DrawerController *rootViewController))success failure:(void (^)(NSError *error))failure;


@end
