//
//  V2MemberRepliesTable.h
//  myV2
//
//  Created by Mac on 16/9/25.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class V2MemberReplyModel;
@interface V2MemberRepliesTable : UITableView
@property (nonatomic, strong) NSArray<V2MemberReplyModel *> *replies;
@end
