//
//  NodesNavController.m
//  myV2
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "NodesNavController.h"
#import "YCTool.h"
#import "V2DataManager.h"
#import "V2NodesGroup.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "NodeGroupCell.h"

@interface NodesNavController ()
@property (nonatomic, strong) NSArray<V2NodesGroup *> *nodesGroups;
@end

@implementation NodesNavController

- (NSArray *)nodesGroups
{
    if (!_nodesGroups) {
        [V2DataManager nodesNavigateGroupsSuccess:^(NSArray<V2NodesGroup *> *nodesGroups) {
            _nodesGroups = [V2NodesGroup mj_objectArrayWithKeyValuesArray:nodesGroups];
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            YCLog(@"获取节点导航失败 %@", error);
        }];
        
    }
    return _nodesGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.nodesGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    V2NodesGroup *group = self.nodesGroups[section];
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    V2NodesGroup *group = self.nodesGroups[section];
    return group.groupTitle;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NodeGroupCell *cell = [NodeGroupCell cellForTableView:tableView];
    
    cell.group = self.nodesGroups[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    V2NodesGroup *group = self.nodesGroups[indexPath.section];

    return group.heightForCell.floatValue;
}



@end
