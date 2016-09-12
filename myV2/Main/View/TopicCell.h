//
//  TopicCell.h
//  myV2
//
//  Created by Mac on 16/9/7.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class V2TopicModel;
@interface TopicCell : UITableViewCell
@property (nonatomic, strong) V2TopicModel *topic;

/**
 *   创建一个 cell     */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *    创建cell     */
+ (instancetype)cell;
@end
