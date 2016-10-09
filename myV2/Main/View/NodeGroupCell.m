//
//  nodeGroupCell.m
//  myV2
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "NodeGroupCell.h"
#import "V2NodesGroup.h"
#import "V2NodeModel.h"
#import "YCTool.h"

#define NodeButtonFont [UIFont systemFontOfSize:12]
#define NodeButtonPadding 10

@interface NodeButton : UIButton
@property (nonatomic, strong) V2NodeModel *node;
//@property (nonatomic, copy) void (^btnDidClick)(V2NodeModel *node);
//- (void)setBtnClickBlock:(void (^)(V2NodeModel *node))btnDidClick;
@end

@implementation NodeButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor lightGrayColor];
        self.titleLabel.font =NodeButtonFont;
        self.normalTitleColor = [UIColor blackColor];
        self.highlightTitleColor = [UIColor redColor];
//        [self addTapTarget:self action:@selector(nodeBtnDidClick:)];
        
//        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        self.layer.cornerRadius = 10;
//        self.clipsToBounds = YES;
    }
    return self;
}

//- (void)setBtnClickBlock:(void (^)(V2NodeModel *))btnDidClick
//{
//    self.btnDidClick = btnDidClick;
//}
//
//- (void)nodeBtnDidClick:(NodeButton *)nodeBtn
//{
//    self.btnDidClick(nodeBtn.node);
//}
- (void)setNode:(V2NodeModel *)node
{
    _node = node;
    self.title = node.title;
}
@end
@interface NodeGroupCell ()
@property (nonatomic, strong) NSMutableArray<NodeButton *> *nodeBtns;
@end

@implementation NodeGroupCell
- (NSMutableArray *)nodeBtns
{
    if (!_nodeBtns) {
        _nodeBtns = [[NSMutableArray alloc] init];
        
    }
    return _nodeBtns;
}
- (void)setup
{
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"NodeGroupCell";
    
    NodeGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[NodeGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setGroup:(V2NodesGroup *)group
{
    _group = group;
    
    /**
     *   匹配按钮和 node 的数量     */
    [self matchingNodeBtn];
}



/**
 *   匹配按钮和 node     */
- (void)matchingNodeBtn
{
    int nodeCount = self.group.nodes.count;
    int btnCount = self.nodeBtns.count;
    int maxCount = MAX(nodeCount, btnCount);
    
    for (int i = 0; i < maxCount; i++) {
        
        NodeButton *btn = nil;
        V2NodeModel *node = nil;
        if (i >= btnCount) {
            //  遍历到比当前所拥有的按钮多时, 就创建
            btn = [NodeButton buttonWithType:UIButtonTypeCustom];
            [self.nodeBtns addObject:btn];
            [self.contentView addSubview:btn];
            [btn addTapTarget:self action:@selector(btnDidClick:)];
//            typeof(btn) weak b = btn;
//            [btn setBtnClickBlock:^(V2NodeModel *node) {
//                /**
//                 *   发送通知     */
//                YCSendNotification(NodeBtnDidClickNotification, @{NodeBtnClickWithNodeKey : b.node});
//            }];
            
            
        } else
        {   //  按钮够的情况下
            btn = self.nodeBtns[i];
            
            if (i >= nodeCount) {  // 按钮比节点多的情况
                //  多余的原来的按钮, 要隐藏
                btn.hidden = YES;
                //  现在就跳过继续循环, 不做下面传模型的操作
                continue;
            }
        }
        //  能到这里. 就是节点数范围内, 因为上面的 continue, 越界的 node 不会取出
        node = self.group.nodes[i];
        btn.node = node;
        btn.frame = [self.group.nodeFrames[i] CGRectValue];
        btn.hidden = NO;
    }
}

/**
 *    监听按钮点击     */
- (void)btnDidClick:(NodeButton *)sender
{
    /**
      *   发送通知     */
    YCSendNotification(NodeBtnDidClickNotification, @{NodeBtnClickWithNodeKey : sender.node});
}
@end
