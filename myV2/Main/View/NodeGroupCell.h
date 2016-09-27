//
//  nodeGroupCell.h
//  myV2
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>



@class V2NodesGroup;
@interface NodeGroupCell : UITableViewCell
@property (nonatomic, strong) V2NodesGroup *group;

+ (instancetype)cellForTableView:(UITableView *)tableView;
@end
