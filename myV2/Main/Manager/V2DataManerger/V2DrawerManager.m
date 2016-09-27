//
//  V2DrawerManager.m
//  myV2
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2DrawerManager.h"

@implementation V2DrawerManager

- (void)setOpenSide:(MMDrawerSide)openSide
{
    [_drawer setValue:@(openSide) forKey:@"openSide"];
}

- (void)closeDrawer
{
    [self closeDrawerAnimated:YES completion:nil];
}

- (void)disableDrawerGesture
{
    [self setOpenSide:MMDrawerSideNone];
}
- (void)enableDrawerGesture
{
    [self setOpenSide:MMDrawerSideLeft | MMDrawerSideRight];
}
- (void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [_drawer closeDrawerAnimated:animated completion:completion];
}


singleton_m(drawerManager);
@end
