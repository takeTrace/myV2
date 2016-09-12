//
//  V2DrawerController.m
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2DrawerController.h"
#import <MMDrawerController+Subclass.h>
#import <MMDrawerController.h>
#import <MMDrawerVisualState.h>
#import "V2BaseNavController.h"
#import <MMDrawerController+Subclass.h>

@interface V2DrawerController ()

@end

@implementation V2DrawerController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 公开方法

+ (__kindof UIViewController *)drawerControllerWithCenterVC:(__kindof UIViewController *)centrVC leftVC:(__kindof UIViewController *)leftVC rightVC:(__kindof UIViewController *)rightVC
{
    V2BaseNavController *cNav = [[V2BaseNavController alloc] initWithRootViewController:centrVC];
    V2BaseNavController *lNav = leftVC ? [[V2BaseNavController alloc] initWithRootViewController:leftVC] : nil;
    V2BaseNavController *rNav = rightVC ? [[V2BaseNavController alloc] initWithRootViewController:rightVC] : nil;
    MMDrawerController *drawer = [[MMDrawerController alloc] initWithCenterViewController:cNav leftDrawerViewController:lNav rightDrawerViewController:rNav];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:drawer.view.frame];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.image = [UIImage imageNamed:@"bg"];
    [drawer.view insertSubview:bgView atIndex:0];   
    
    return drawer;
    
}

+ (__kindof UIViewController *)drawerControllerCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController{
    return [self drawerControllerWithCenterVC:centerViewController leftVC:leftDrawerViewController rightVC:nil];
}

+ (__kindof UIViewController *)drawerControllerCenterViewController:(UIViewController *)centerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController{
    return [self drawerControllerWithCenterVC:centerViewController leftVC:nil rightVC:rightDrawerViewController];
}


@end
