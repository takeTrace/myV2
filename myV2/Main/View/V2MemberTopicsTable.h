//
//  V2MemberTopicsTable.h
//  myV2
//
//  Created by Mac on 16/9/25.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class V2TopicModel;
@interface V2MemberTopicsTable : UITableView
@property (nonatomic, strong) NSArray<V2TopicModel *> *topics;
@end
