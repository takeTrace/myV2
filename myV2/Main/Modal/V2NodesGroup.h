//
//  NodesGroup.h
//  myV2
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>


#define NodeButtonFont [UIFont systemFontOfSize:14]
#define NodeButtonPadding 10



@class V2NodeModel;
@interface V2NodesGroup : NSObject
@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, strong) NSMutableArray<V2NodeModel *> *nodes;
/**
 *   该节点组所在 cell 应该的高度     */
@property (nonatomic, strong) NSNumber *heightForCell;
/**
 *   额外属性: 在 cell 中的 frames     */
@property (nonatomic, strong) NSMutableArray<NSValue *> *nodeFrames;

/**
 *   该节点组所在 cell 应该的高度     */


@end
