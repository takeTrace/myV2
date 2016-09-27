//
//  NodesGroup.m
//  myV2
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2NodesGroup.h"
#import <MJExtension.h>
#import "V2NodeModel.h"
#import "YCTool.h"


@interface V2NodesGroup ()
//{
//    NSNumber *_heightForCell;
//}
@end

@implementation V2NodesGroup
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"nodes" : [V2NodeModel class], @"nodeFrames": [NSValue class]};
}

- (void)setNodes:(NSMutableArray<V2NodeModel *> *)nodes
{
    _nodes = nodes;
    
    [self calculateBtnFrame];
    
}

/**
 *   计算按钮的 frame     */
- (void)calculateBtnFrame
{
    if (!self.nodeFrames) {
        //  没有 frame 数据, 就计算
        self.nodeFrames = [NSMutableArray arrayWithCapacity:self.nodes.count];
        
        __block CGPoint origin = CGPointMake(NodeButtonPadding, NodeButtonPadding);
        [self.nodes enumerateObjectsUsingBlock:^(V2NodeModel * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGRect btnRect;
            CGSize size = [node.title sizeWithFont:NodeButtonFont boundingSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            size.width += 5;
            size.height += 5;
            
            CGFloat maxX = origin.x + size.width +NodeButtonPadding;
            if (maxX < YCScreenW) {
                btnRect = (CGRect){origin, size};
                origin.x = maxX;
            } else
            {
                origin.x = NodeButtonPadding;
                origin.y = size.height + NodeButtonPadding + origin.y;
                btnRect = (CGRect){origin, size};
                origin.x += size.width +NodeButtonPadding;
            }
            
            [self.nodeFrames addObject:[NSValue valueWithCGRect:btnRect]];
        }];
        
    }
}

- (NSNumber *)heightForCell
{
    if (_heightForCell) {
        return _heightForCell;
    } else {
        
        if (!self.nodeFrames) {
            [self calculateBtnFrame];
        }
        CGRect rect = [[self.nodeFrames lastObject] CGRectValue];
        return @(CGRectGetMaxY(rect) + NodeButtonPadding);
    }
}
@end
