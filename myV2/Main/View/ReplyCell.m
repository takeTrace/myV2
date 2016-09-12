
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


@property (weak, nonatomic) IBOutlet UILabel *userNameLabe;
//@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *thxButton;
@property (weak, nonatomic) IBOutlet UIButton *floorBtn;
@property (nonatomic, weak) UILabel *compatLabel;
@end
@implementation ReplyCell

- (void)awakeFromNib {
    // Initialization code
    
    //    UIVisualEffectView *blureView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    //    [self.timeLabel.superview insertSubview:blureView atIndex:0];
    
    UIVisualEffectView *cellBg = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.backgroundView = cellBg;
    //    ILTranslucentView *blure = [[ILTranslucentView alloc] initWithFrame:self.bounds];
    //    blure.translucentAlpha = 0.7;
    //    blure.translucentStyle = UIBarStyleBlack;
    //    blure.translucentTintColor = [UIColor clearColor];
    //    blure.backgroundColor = [UIColor clearColor];
    //    self.backgroundView = blure;
    
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



#pragma mark- 公开接口

+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"ReplyCell";
    
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
        UILabel *la = [[UILabel alloc] init];
        [self.contentView insertSubview:la belowSubview:self.contentLabel];
//        la.frame = self.contentLabel.frame;
        la.hidden = YES;
        self.compatLabel = la;
        
    }
    return self;
}
//- (void)layoutSubviews
//{
//    
//    self.contentLabel.preferWidth = self.width - 10;
//    self.compatLabel.frame = self.contentLabel.frame;
//    [super layoutSubviews];
//}

- (void)setReply:(V2ReplyModel *)reply
{
    _reply = reply;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:reply.member.avatar_normal]];
    self.contentLabel.attributedString = [[NSAttributedString alloc] initWithData:[reply.content_rendered dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.userNameLabe.text = _reply.member.username;
//    self.nodeLabel.text = _reply.node.title;
    self.timeLabel.text = @"123123131123231";
}

- (CGFloat)heightForCellWithWidth:(CGFloat )width
{
    self.contentLabel.preferWidth = self.width - 10;
//    YCLog(@"contentLabel.Size: %f", self.contentLabel.contentHeight);
    
    //    [self.label setNeedsUpdateConstraints];
    //    [self.label updateConstraintsIfNeeded];
    
    //        [de setNeedsLayout];
    
    YCLog(@"reply 的 高 %g",self.contentLabel.height);

    CGSize si = CGSizeMake(self.width, [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + self.contentLabel.height);
    self.height = si.height;
    YCLog(@"replyCell的高: %g", si.height);
    return si.height;
}

@end
