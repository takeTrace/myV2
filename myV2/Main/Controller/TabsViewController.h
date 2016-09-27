//
//  TabsViewController.h
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   通知     */
#define TabViewDidSelectTabNotifacation @"TabViewDidSelectTabNotifacation"
#define TabViewSelectedTabTypeUserinfoKey @"TabViewSelectedTabTypeUserinfoKey"
//#define TabViewDidSelectInfoBtnNotification @"TabViewDidSelectInfoBtnNotification"
//#define TabViewSelectedInfoBtnUserInfoKey @"TabViewSelectedInfoBtnUserInfoKey"
@class MMDrawerController;
@interface TabsViewController : UITableViewController
@property (nonatomic, weak) MMDrawerController *drawer;
@end
