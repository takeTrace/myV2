
//
//  ReplyCell.m
//  myV2
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "ReplyCell.h"
#import "V2ReplyModel.h"
#import "V2MemberModel.h"
#import <UIImageView+WebCache.h>
#import "YCAttributeLabel.h"
#import "YCTool.h"
#import "YCGloble.h"

@interface ReplyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet YCAttributeLabel *contentLabel;
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, assign) CGFloat baseHeight;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabe;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *thxButton;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@end
@implementation ReplyCell

- (CGFloat)baseHeight
{
    if (!_baseHeight) {
        _baseHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height ;
        
    }
    return _baseHeight;
}

#pragma mark- 公开接口
+ (instancetype)cell
{
    return (ReplyCell *)[[[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:nil options:nil] lastObject];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"ReplyCellreuse";
    
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [self cell];
    }
    
    return cell;
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

- (void)setup
{
    [self.thxButton addTapTarget:self action:@selector(thxDidClick:)];
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
}

- (void)setFloorIndex:(NSUInteger)floorIndex
{
    _floorIndex = floorIndex;
    
    self.floorLabel.text = NSStringFromFormat(@"%d 楼", floorIndex + 1);
}

- (void)setReply:(V2ReplyModel *)reply
{
    _reply = reply;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:reply.member.avatar_normal]];
    self.contentLabel.htmlString = reply.content_rendered;
    self.userNameLabe.text = _reply.member.username;
    self.timeLabel.text = _reply.created;
}


- (CGFloat)heightForCellWithWidth:(CGFloat )width
{
    self.contentLabel.preferWidth = self.contentLabel.width;
    NSAssert(_contentLabel.htmlString.length > 0, @"htmlString 未有值, 不能获得高度");
    CGSize si = CGSizeMake(width, self.baseHeight + self.contentLabel.contentHeight);
    _reply.heightInCell = si.height;
    return si.height;
}


- (void)thxDidClick:(UIButton *)sender
{
    YCLog(@"以感谢");
}
@end