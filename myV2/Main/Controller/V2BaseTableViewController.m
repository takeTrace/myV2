//
//  V2BaseTableViewController.m
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2BaseTableViewController.h"
#import "V2DataManager.h"
#import <UIImageView+WebCache.h>
#import "TopicCell.h"

@interface V2BaseTableViewController ()

@end


@implementation V2BaseTableViewController


/**
 *   懒加载     */
//- (NSArray *)topics
//{
//    if (!_topics) {
//        
//        [V2DataManager getTopicsWithTab:nil success:^(NSArray<V2TopicModel *> *hotestTopics) {
//            
//            _topics = hotestTopics;
//            
//            [self.tableView reloadData];
//            
//        } failure:^(NSError *error) {
//            NSLog(@"%@", error);
//        }];
//        
//    }
//    return _topics;
//}


//- (void)loadView
//{
//    [super loadView];
//    
//
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.rowHeight = 77;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCell *cell = [TopicCell cellWithTableView:tableView];
    
    V2TopicModel *topic = self.topics[indexPath.row];
    
    cell.topic = topic;
    
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
@end
