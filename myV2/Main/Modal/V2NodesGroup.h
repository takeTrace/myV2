//
//  NodesGroup.h
//  myV2
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <Foundation/Foundation.h>
@class V2NodeModel;
@interface V2NodesGroup : NSObject
@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, strong) NSArray<V2NodeModel *> *nodes;
@end
