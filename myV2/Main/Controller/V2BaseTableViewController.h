//
//  V2BaseTableViewController.h
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class V2TopicModel;
@interface V2BaseTableViewController : UITableViewController

/**
 *   话题数据组     */
@property (nonatomic, strong) NSArray<V2TopicModel *> *topics;

@end
