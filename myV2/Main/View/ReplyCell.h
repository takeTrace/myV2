//
//  ReplyCell.h
//  myV2
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class V2ReplyModel;
@interface ReplyCell : UITableViewCell
@property (nonatomic, strong) V2ReplyModel *reply;

/**
 *   创建一个 cell     */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *    创建cell     */
+ (instancetype)cell;

- (CGFloat)heightForCellWithWidth:(CGFloat )width;
@end
