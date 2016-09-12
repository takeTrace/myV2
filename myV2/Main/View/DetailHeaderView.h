//
//  DetailHeaderView.h
//  tableViewtest
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCAttributeLabel, V2TopicModel;
@interface DetailHeaderView : UIView


@property (nonatomic, strong)  V2TopicModel*topic;
+ (instancetype)headerView;

- (CGFloat)heightForHeaderViewWithWidth:(CGFloat)width;


@end
