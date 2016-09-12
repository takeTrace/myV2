//
//  V2DrawerController.h
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V2DrawerController : UIViewController

/**
 *   创建一个抽屉控制器
 *
 *  @param centrVC 中心 vc
 *  @param leftVC  左边菜单 vc
 *  @param rightVC 右边菜单 vc
 *
 *  @return 抽屉控制器
 */
+ (__kindof UIViewController *)drawerControllerWithCenterVC:(__kindof UIViewController *)centrVC leftVC:(__kindof UIViewController *)leftVC rightVC:(__kindof UIViewController *)rightVC;

/**
 *   只有左菜单的抽屉     */
+ (__kindof UIViewController *)drawerControllerCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController;

/**
 *   只有右菜单的抽屉     */
+ (__kindof UIViewController *)drawerControllerCenterViewController:(UIViewController *)centerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController;

@end
