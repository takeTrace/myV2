//
//  MenuViewController.h
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MenuButtonType) {
    MenuButtonTypeTpoic,
    MenuButtonTypeNodes,
    MenuButtonTypeSettings,
    MenuButtonTypeRecent,
    
};


/**
 *   通知     */
#define MenuViewDidSelectMenuNotifacation @"MenuViewDidSelectMenuNotifacation"
#define MenuViewSelectedMenuTypeUserinfoKey @"MenuViewSelectedMenuTypeUserinfoKey"
#define MenuViewDidSelectInfoBtnNotification @"MenuViewDidSelectInfoBtnNotification"
#define MenuViewSelectedInfoBtnUserInfoKey @"MenuViewSelectedInfoBtnUserInfoKey"

@class MMDrawerController;
@interface MenuViewController : UIViewController
@property (nonatomic, weak) MMDrawerController *drawer;
@end
