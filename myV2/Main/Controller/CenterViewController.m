//
//  CenterViewController.m
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "CenterViewController.h"
#import "V2TabModel.h"
#import "V2NodeModel.h"
#import "YCGloble.h"
#import "MenuViewController.h"
#import "TabsViewController.h"
#import <MMDrawerBarButtonItem.h>
#import "ILTranslucentView.h"
#import "YCTool.h"
#import "TopicDetailViewController.h"
#import "V2BaseNavController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController



- (void)setTopics:(NSArray<V2TopicModel *> *)topics
{
    [super setTopics:topics];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     *   配置导航栏     */
    [self configNavigationBar];
    
    /**
     *   监听通知     */
    [self observingNotification];
    
//    UIImage *clearImage = [UIImage imageWithColor:[UIColor clearColor]];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.15];
//    UIVisualEffectView *cellBg = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//    [self.view insertSubview:cellBg atIndex:1];
    
//    self.tableView.backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    ILTranslucentView *blure = [[ILTranslucentView alloc] initWithFrame:self.view.bounds];
    blure.translucentAlpha = 0.8;
    blure.translucentStyle = UIBarStyleBlack;
    blure.translucentTintColor = [UIColor yellowColor];
//    blure.backgroundColor = [UIColor clearColor];
//    self.tableView.backgroundView =[[UIImageView alloc] initWithImage:clearImage];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
}

/**
 *    监听通知     */
- (void)observingNotification
{
    
    YCAddObserver(menuDidClickNotification:, MenuViewDidSelectMenuNotifacation);
    YCAddObserver(menuViewDidClickUserInfoNotification:, MenuViewDidSelectInfoBtnNotification);
}

- (void)dealloc
{
    [YCNotification removeObserver:self];
}

/**
 *   菜单栏中用户头像点击通知监听     */
- (void)menuViewDidClickUserInfoNotification:(NSNotification *)note
{
    YCLog(@"用户需要登录或者查看用户信息");
}

/**
 *   菜单点击方法     */
- (void)menuDidClickNotification:(NSNotification *)note
{
    YCLog(@"%@", note.userInfo[MenuViewSelectedMenuTypeUserinfoKey]);
}
/**
 *   配置导航栏     */
- (void)configNavigationBar
{
    MMDrawerBarButtonItem *item = [[MMDrawerBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem  = item;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"全部";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    /**
     *   跳转详情控制器     */
    TopicDetailViewController *detailVC = [[TopicDetailViewController alloc] init];
    detailVC.topic = self.topics[indexPath.row];
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
