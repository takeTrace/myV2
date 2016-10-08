//
//  V2hHistoryViewController.m
//  myV2
//
//  Created by Mac on 16/10/8.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2hHistoryViewController.h"
#import "TopicDetailViewController.h"
#import "V2DataManager.h"
#import "V2OperationTool.h"
#import "YCTool.h"

@interface V2hHistoryViewController ()

@end

@implementation V2hHistoryViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        typeof(self) weakSelf = self;
        if (!_showedNode) {
            
            [V2DataManager getMoreTpoics:nil page:nil success:^(NSArray<V2TopicModel *> *topics) {
                
                weakSelf.topics = topics;
                [weakSelf.tableView reloadData];
            } failure:^(NSError *error) {
                
                YCLog(@"更新最近tab 失败-- error: %@", error);
            }];
        } else {
            [V2DataManager getTopicsWithNode:_showedNode success:^(NSArray<V2TopicModel *> *topics) {
                weakSelf.topics = topics;
            } failure:^(NSError *error) {
                YCLog(@"加载%@节点历史失败", _showedNode);
            }];
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"历史";
    self.tableView.mj_header = nil;

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
