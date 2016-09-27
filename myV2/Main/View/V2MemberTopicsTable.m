//
//  V2MemberTopicsTable.m
//  myV2
//
//  Created by Mac on 16/9/25.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2MemberTopicsTable.h"
#import "V2TopicModel.h"
#import "V2MemberModel.h"
#import "V2NodeModel.h"

@interface V2MemberTopicsTable ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation V2MemberTopicsTable

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark- tableViewDelegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"test";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    V2TopicModel *topic = self.topics[indexPath.row];
    
    cell.textLabel.text = topic.title;
    cell.detailTextLabel.text = topic.member.username;
    
    return cell;
}

- (void)setTopics:(NSArray<V2TopicModel *> *)topics
{
    _topics = topics;
    
    [self reloadData];
}


@end
