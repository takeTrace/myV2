//
//  TopicDetailViewController.m
//  myV2
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "TopicDetailViewController.h"
#import <Ono.h>
#import "V2DataManager.h"
#import "YCGloble.h"
#import "YCTool.h"
#import "V2TopicModel.h"
#import "V2ReplyModel.h"
#import "V2MemberModel.h"
#import <UIImageView+WebCache.h>
#import "DetailHeaderView.h"
#import "YCGloble.h"
#import "YCTool.h"
#import "ReplyCell.h"

@interface TopicDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *DetailLabel;
@property (nonatomic, strong) DetailHeaderView *headerView;
@property (nonatomic, strong) NSArray<V2ReplyModel *> *replies;
@end

@implementation TopicDetailViewController
- (DetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [DetailHeaderView headerView];
//        _headerView.backgroundColor = [UIColor greenColor];
        
    }
    return _headerView;
}

- (void)setReplies:(NSArray<V2ReplyModel *> *)replies
{
    if (replies != _replies) {
        _replies = replies;
        
        /**
         *    计算每个回复模型的高     */
        __block ReplyCell *cell = [ReplyCell cell];
        [replies enumerateObjectsUsingBlock:^(V2ReplyModel * _Nonnull reply, NSUInteger idx, BOOL * _Nonnull stop) {
            cell.reply = reply;
            reply.heightInCell = [cell heightForCellWithWidth:YCScreenW];
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.DetailLabel.estimatedRowHeight = 60;
    self.DetailLabel.rowHeight = UITableViewAutomaticDimension;
    
//    self.view.backgroundColor = [UIColor clearColor];
//    self.DetailLabel.backgroundColor = [UIColor clearColor];
    self.DetailLabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupheaderView];
}

- (void)setupheaderView
{
    self.headerView.height = [self.headerView heightForHeaderViewWithWidth:self.DetailLabel.width];
    YCLog(@"headerViewHeight: %f", self.headerView.height);
    self.DetailLabel.tableHeaderView = self.headerView;
//    self.DetailLabel.contentInset = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
//    self.DetailLabel.contentOffset = CGPointMake(0, -self.headerView.height);
}


- (void)setTopic:(V2TopicModel *)topic
{
    _topic = topic;
    
    self.headerView.topic = _topic;
    [self setupheaderView];

    
    /**
     *   根据传入模型来发出请求获取更详细的信息     */
    [V2DataManager getTopicWithId:_topic.ID success:^(V2TopicModel *newTopic) {
        _topic = newTopic;
        
        self.headerView.topic = _topic;
        
        [self setupheaderView];
        
                [self.DetailLabel reloadData];
//        [self.DetailLabel beginUpdates];
//        [self.DetailLabel endUpdates];
        
    } failure:^(NSError *error) {
        YCLog(@"网络获取 topic 详情失败");
    }];
    
    [V2DataManager getRepliesInTopic:_topic.ID andPage:nil pageSize:nil success:^(NSArray<V2ReplyModel *> *replies) {
        self.replies = replies;
        
//        [self.DetailLabel beginUpdates];
//        [self.DetailLabel endUpdates];
        
        [self.DetailLabel reloadData];
        
    } failure:^(NSError *error) {
        YCLog(@"获取 topic 回复失败");
    }];
    
    
    
    
//    [V2DataManager getTopicAndRepliesFromHtmlWithTopic:_topic success:^(V2TopicModel *newTopic, NSArray<V2ReplyModel *> *replies) {
//        _topic = newTopic;
//        _replies = replies;
//        
//        self.headerView.topic = _topic;
//        
//        [self setupheaderView];
//        
////        [self.DetailLabel reloadData];
//        [self.DetailLabel beginUpdates];
//        [self.DetailLabel endUpdates];
//        
//    } failure:^(NSError *error) {
//        YCLog(@"网络获取 topic 详情失败");
//    }];
}


#pragma mark- tableViewDelegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyCell *cell = [ReplyCell cellWithTableView:tableView];
    
    V2ReplyModel *reply = self.replies[indexPath.row];
    
    cell.reply = reply;
    cell.floorIndex = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    YCLog(@"cell.size = %@", NSStringFromCGSize(cell.viewSize));
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    V2ReplyModel *reply = self.replies[indexPath.row];
//    YCPlog;
//    YCLog(@"%g", reply.heightInCell);
    return reply.heightInCell;
    
//    ReplyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    return [cell heightForCellWithWidth:YCScreenW];
}



@end
