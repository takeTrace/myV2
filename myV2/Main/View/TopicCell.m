//
//  TopicCell.m
//  myV2
//
//  Created by Mac on 16/9/7.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "TopicCell.h"
#import <UIImageView+WebCache.h>
#import "V2MemberModel.h"
#import "V2TopicModel.h"
#import "V2NodeModel.h"
#import "ILTranslucentView.h"

@interface TopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabe;
@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) UIImage *placeholdImage;
@end

@implementation TopicCell

/**
 *   占位图     */
- (UIImage *)placeholdImage
{
    if (!_placeholdImage) {
        _placeholdImage = [UIImage imageNamed:@"icon"];
    }
    return _placeholdImage;
}

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
    return [[[NSBundle mainBundle] loadNibNamed:@"TopicCell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"TopicCell";
    
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [self cell];
    }
    
    return cell;
}

- (void)setTopic:(V2TopicModel *)topic
{
    _topic = topic;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:_topic.member.avatar_normal] placeholderImage:self.placeholdImage];
    self.userNameLabe.text = _topic.member.username;
    self.contentLabel.text = _topic.title;
    self.nodeLabel.text = _topic.node.title;
    self.timeLabel.text = @"123123131123231";
}
@end
