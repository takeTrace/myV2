//
//  V2InitialManager.m
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2InitialManager.h"
#import "V2DataManager.h"
#import "V2DrawerController.h"
#import "MenuViewController.h"
#import "TabsViewController.h"
#import "CenterViewController.h"
#import "YCTool.h"
#import <MMDrawerController+Subclass.h>
#import <MMDrawerVisualState.h>
#import "V2DrawerManager.h"

@implementation V2InitialManager

+ (void)initializeRootViewControllerSuccess:(void (^)(__kindof V2DrawerController *))success failure:(void (^)(NSError *))failure
{
    YCLog(@"%@", YCDocumentPath);
    
    CenterViewController *centr = [[CenterViewController alloc] initWithStyle:UITableViewStylePlain];
    MenuViewController *menu = [[MenuViewController alloc] init];
    TabsViewController *tabs = [[TabsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    V2DrawerController *drawer = [V2DrawerController drawerControllerWithCenterVC:centr leftVC:menu rightVC:tabs];
    
    
    MMDrawerController *dc = (MMDrawerController *)drawer;
    V2DrawerManager *mgr = [[V2DrawerManager alloc] init];
    mgr.drawer = dc;
    
    centr.drawer = dc;
    menu.drawer = dc;
    tabs.drawer = dc;
    
    dc.showsShadow = YES;
    dc.maximumLeftDrawerWidth = 200;
    dc.maximumRightDrawerWidth = 120;
    dc.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    dc.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    dc.restorationIdentifier = @"drawer";
    [dc setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
//    [dc setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//            MMDrawerControllerDrawerVisualStateBlock block;
//            block = [[MMExampleDrawerVisualStateManager sharedManager]
//                     drawerVisualStateBlockForDrawerSide:drawerSide];
//            if(block){
//                block(drawerController, drawerSide, percentVisible);
//            }
//        }];
    
    if (drawer) {
        success(drawer);
    } else
    {
        failure([NSError errorMessage:@"创建抽屉失败"]);
    }
}

@end
