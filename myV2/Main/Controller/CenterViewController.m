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
#import "NodesNavController.h"
#import <MMDrawerController.h>
#import "V2DataManager.h"
#import <MJRefresh.h>
#import "V2SettingViewController.h"
#import "V2DrawerManager.h"
#import "V2LoginController.h"
#import "V2MemberInfoController.h"
#import "V2RecentViewController.h"


@interface CenterViewController ()
@property (nonatomic, strong ) V2TabModel *currentTab;
@property (nonatomic, strong) V2NodeModel *currentNode;
@property (nonatomic, assign) BOOL isRecent;
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.15];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    ILTranslucentView *blure = [[ILTranslucentView alloc] initWithFrame:self.view.bounds];
    //    blure.translucentAlpha = 0.8;
    //    blure.translucentStyle = UIBarStyleBlack;
    //    blure.translucentTintColor = [UIColor yellowColor];
}

/**
 *    监听通知     */
- (void)observingNotification
{
    /**
     *   监听菜单点击通知     */
    YCAddObserver(menuDidClickNotification:, MenuViewDidSelectMenuNotifacation);
    YCAddObserver(menuViewDidClickUserInfoNotification:, MenuViewDidSelectInfoBtnNotification);
    
    /**
     *   监听 tab 点击通知     */
    YCAddObserver(tabViewDidClickTabNotification:, TabViewDidSelectTabNotifacation);
    
    /**
     *   监听nodeNav 按钮点击     */
    YCAddObserver(nodeNavBtnDidClick:, NodeBtnDidClickNotification);
    
    
}

- (void)dealloc
{
    [YCNotification removeObserver:self];
}

/**
 *   nodeNav节点按钮被点击     */
- (void)nodeNavBtnDidClick:(NSNotification *)note
{
    [self.navigationController popViewControllerAnimated:YES];
    
    V2NodeModel *node = (V2NodeModel *)note.userInfo[NodeBtnClickWithNodeKey];
    self.currentNode = node;
    
    V2RecentViewController *nodeCtller = [[V2RecentViewController alloc] init];
    nodeCtller.showedNode = self.currentNode;
    [self.navigationController pushViewController:nodeCtller animated:YES];
    
}

/**
 *   tab栏点击了按钮    */
- (void)tabViewDidClickTabNotification:(NSNotification *)note
{
    V2TabModel *tab = (V2TabModel *)note.userInfo[TabViewSelectedTabTypeUserinfoKey];
    YCLog(@"点击了 tab: %@", tab);
    self.currentTab = tab;
    
    [[V2DrawerManager sharedrawerManager] closeDrawerAnimated:YES completion:nil];
    typeof(self) weakSelf = self;
    self.tableView.mj_header.refreshingBlock = ^{
        [V2DataManager updateTopicsWithTab:weakSelf.currentTab success:^(NSArray<V2TopicModel *> *topics) {
            weakSelf.topics = topics;
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            YCLog(@"更新'%@'tab 失败-- error: %@", weakSelf.currentTab.name , error  );
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    };
    [V2DataManager getTopicsWithTab:tab success:^(NSArray<V2TopicModel *> *topics) {
        weakSelf.topics = topics;
        weakSelf.title = tab.name;
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        YCLog(@"获取'%@'的数据失败--error: %@", tab.name , error);
    }];
    
    
}

/**
 *   菜单栏中用户头像点击通知监听     */
- (void)menuViewDidClickUserInfoNotification:(NSNotification *)note
{
    YCLog(@"用户需要登录或者查看用户信息");
    [[V2DrawerManager sharedrawerManager] closeDrawerAnimated:YES completion:nil];
    
    UIViewController *openVC = nil;
    V2MemberModel *user = [V2DataManager getLoginUser];
    if (user) {
        /**
         *    打开用户信息页面     */
        openVC = [[V2MemberInfoController alloc] init];
        
    } else
    {
         openVC = [[V2LoginController alloc] init];
    }
    [self presentViewController:openVC animated:YES completion:^{
        YCLog(@"弹出登录视图");
    }];
}

/**
 *   菜单点击方法     */
- (void)menuDidClickNotification:(NSNotification *)note
{
    [[V2DrawerManager sharedrawerManager] closeDrawerAnimated:YES completion:nil];
    MenuButtonType menuType = [(NSNumber *)note.userInfo[MenuViewSelectedMenuTypeUserinfoKey] intValue];

    switch (menuType) {
        case MenuButtonTypeNodes:
            YCLog(@"点击节点按钮");
            [self pushController:[NodesNavController class]];
            break;
        case MenuButtonTypeRecent:
            [self pushController:[V2RecentViewController class]];
            YCLog(@"点击了最近最新");
            break;
        case MenuButtonTypeSettings:
            YCLog(@"点击了设置");
            [self pushController:[V2SettingViewController class]];
            break;
        case MenuButtonTypeTpoic:
            YCLog(@"点击了分类");
            [self.navigationController popToRootViewControllerAnimated:YES];
            YCSendNotification(TabViewDidSelectTabNotifacation, @{TabViewSelectedTabTypeUserinfoKey : self.currentTab});
            break;
            
        default:
            break;
    }
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

#pragma mark- 跳转控制器
- (void)pushController:(Class)aclass
{
    UIViewController *currentVc = [self.navigationController topViewController];
    if ([currentVc isKindOfClass:aclass]) return;
    
    UIViewController *vc = [[aclass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
