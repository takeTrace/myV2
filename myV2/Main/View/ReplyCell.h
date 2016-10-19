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
@property (nonatomic, assign) NSUInteger floorIndex;
/**
 *   创建一个 cell     */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *    创建cell     */
+ (instancetype)cell;

/**
 *   拿到固定的能自动布局的高度     */
//- (CGFloat)heightForAutoLayout;

/**
 // *   拿到富文本控件的宽度     */
//- (CGFloat)widthForContentLabel;

- (CGFloat)heightForCellWithWidth:(CGFloat )width;
@end
