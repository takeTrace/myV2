//
//  V2DrawerManager.h
//  myV2
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMDrawerController.h>
#import "YCTool.h"

@interface V2DrawerManager : NSObject
@property (nonatomic, strong) MMDrawerController *drawer;
@property (nonatomic, assign, readonly) MMDrawerSide openSide;

- (void)closeDrawer;
- (void)disableDrawerGesture;
- (void)enableDrawerGesture;
-(void)closeDrawerAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

//-(void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
singleton_h(drawerManager);
@end
