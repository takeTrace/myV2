//
//  V2MemberRepliesTable.m
//  myV2
//
//  Created by Mac on 16/9/25.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2MemberRepliesTable.h"
#import "V2MemberReplyModel.h"

@interface V2MemberRepliesTable ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation V2MemberRepliesTable

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
    return self.replies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"rep";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    V2MemberReplyModel *reply = self.replies[indexPath.row];
    
    cell.textLabel.text = reply.content;
    cell.detailTextLabel.text = reply.replyHeader;
    
    return cell;
}

- (void)setReplies:(NSArray<V2MemberReplyModel *> *)replies
{
    _replies = replies;
    
    [self reloadData];
}

@end
