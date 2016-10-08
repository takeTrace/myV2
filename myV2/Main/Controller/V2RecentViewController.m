//
//  V2RecentViewController.m
//  myV2
//
//  Created by Mac on 16/9/27.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2RecentViewController.h"
#import "TopicDetailViewController.h"
#import "V2hHistoryViewController.h"
#import "V2OperationTool.h"
#import "V2DataManager.h"
#import "YCTool.h"

@interface V2RecentViewController ()
@property (nonatomic, strong) NSNumber *currentPage;
@end

@implementation V2RecentViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPage = @(2);
        typeof(self) weakSelf = self;
        if (!_showedNode) {
            [V2DataManager updateMoreTopicsWithPage:nil success:^(NSArray<V2TopicModel *> *topics) {
                
                weakSelf.topics = topics;
                [weakSelf.tableView reloadData];
                
                //                [weakSelf.tableView.mj_header endRefreshing];
            } failure:^(NSError *error) {
                
                YCLog(@"更新最近tab 失败-- error: %@", error);
                //                [weakSelf.tableView.mj_header endRefreshing];
                [self recentHistrory];
            }];
        } else {

            [V2DataManager updateTopicsWithNode:_showedNode page:nil success:^(NSArray<V2TopicModel *> *topics) {
                weakSelf.topics = topics;
                [weakSelf.tableView reloadData];
                
//                [weakSelf.tableView.mj_header endRefreshing];
            } failure:^(NSError *error) {
                YCLog(@"更新%@节点失败", _showedNode);
                
//                [weakSelf.tableView.mj_header endRefreshing];
            }];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:nil];
    
    UIBarButtonItem *histrory = [[UIBarButtonItem alloc] initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(recentHistrory)];
    self.navigationItem.rightBarButtonItem = histrory;
    
    typeof(self) weakSelf = self;
    
    void (^refresh) (NSArray<V2TopicModel *> * _Nonnull topics) = ^( NSArray<V2TopicModel *> * _Nonnull topics){
        NSMutableArray *arrayM = [weakSelf.topics mutableCopy];
        [arrayM insertObjects:topics atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, topics.count)]];
        
        weakSelf.topics = arrayM;
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
    };
    
    void (^loadMore)(NSArray<V2TopicModel *> *topics) = ^(NSArray<V2TopicModel *> *topics){
        
        weakSelf.topics = [weakSelf.topics arrayByAddingObjectsFromArray:topics];
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.currentPage = @(weakSelf.currentPage.intValue + 1);
        
    };
    
    if (!_showedNode) {
        self.title = @"最近";
        self.tableView.mj_header.refreshingBlock = ^{
            
            [V2DataManager updateMoreTopicsWithPage:nil success:^(NSArray<V2TopicModel *> *topics) {
                
                refresh(topics);
                
            } failure:^(NSError *error) {
                
                YCLog(@"更新最近失败-- error: %@", error);
                [weakSelf.tableView.mj_header endRefreshing];
            }];
        };
        
        self.tableView.mj_footer.refreshingBlock = ^{
            [V2DataManager updateMoreTopicsWithPage:weakSelf.currentPage success:^(NSArray<V2TopicModel *> *topics) {
                loadMore(topics);
                
            } failure:^(NSError *error) {
                
                YCLog(@"加载最近的更多失败");
                [weakSelf.tableView.mj_footer endRefreshing];
                
            }];
        };
        
    } else
    {
        self.title = _showedNode.title;
        
        self.tableView.mj_header.refreshingBlock = ^{
            [V2DataManager updateTopicsWithNode:weakSelf.showedNode page:nil success:^(NSArray<V2TopicModel *> *topics) {
                refresh(topics);
            } failure:^(NSError *error) {
                YCLog(@"刷新%@节点失败", weakSelf.showedNode);
                [weakSelf.tableView.mj_header endRefreshing];
            }];
        };
        
        self.tableView.mj_footer.refreshingBlock = ^{
            [V2DataManager updateTopicsWithNode:weakSelf.showedNode page:weakSelf.currentPage success:^(NSArray<V2TopicModel *> *topics) {
                loadMore(topics);
            } failure:^(NSError *error) {
                YCLog(@"加载%@节点更堵失败", weakSelf.showedNode);
                [weakSelf.tableView.mj_footer endRefreshing];
            }];
        };
    }
    
    
    /**
     *   判断是否联网, 未联网就条到历史     */
//    if (![V2OperationTool isConnect]) {
//        [self recentHistrory];
//    }
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

- (void)recentHistrory
{
    V2hHistoryViewController *hisCtller = [[V2hHistoryViewController alloc] init];
    hisCtller.showedNode = self.showedNode;
    [self.navigationController pushViewController:hisCtller animated:YES];
}
@end
