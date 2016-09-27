//
//  V2RecentViewController.m
//  myV2
//
//  Created by Mac on 16/9/27.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2RecentViewController.h"
#import "TopicDetailViewController.h"
#import "V2DataManager.h"
#import "YCTool.h"
@interface V2RecentViewController ()

@end

@implementation V2RecentViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [V2DataManager getMoreTpoics:nil page:nil success:^(NSArray<V2TopicModel *> *topics) {
            
            self.topics = topics;
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            YCLog(@"recentTopicLoadFailure");
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    typeof(self) weakSelf = self;
    self.tableView.mj_header.refreshingBlock = ^{
        
        [V2DataManager updateMoreTopicsWithPage:nil success:^(NSArray<V2TopicModel *> *topics) {
            
            weakSelf.topics = topics;
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            
            YCLog(@"更新最近tab 失败-- error: %@", error);
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    };
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

@end
