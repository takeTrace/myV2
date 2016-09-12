//
//  DetailHeaderView.m
//  tableViewtest
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "DetailHeaderView.h"
#import "YCAttributeLabel.h"
#import "YCTool.h"
#import "YCGloble.h"
#import "V2TopicModel.h"
#import <UIImageView+WebCache.h>
#import "V2NodeModel.h"
#import "V2MemberModel.h"
#import <SDAutoLayout.h>

@interface DetailHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet YCAttributeLabel *contentLabel;

@end

@implementation DetailHeaderView


- (CGFloat)heightForHeaderViewWithWidth:(CGFloat)width
{
    self.width = width;

    return [self sizeThatFitWidth:width].height;
}

- (CGSize)sizeThatFitWidth:(CGFloat)width
{
    self.contentLabel.preferWidth = width;
    NSLog(@"contentLabel.Size: %f", self.contentLabel.contentHeight);
    
    //    [self.label setNeedsUpdateConstraints];
    //    [self.label updateConstraintsIfNeeded];
    
    //        [de setNeedsLayout];
    
    NSLog(@"高高高%g",self.contentLabel.height);
    self.titleLabel.preferredMaxLayoutWidth = width - 10;
    CGSize si = CGSizeMake(width, [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + self.contentLabel.height);
    self.height = si.height;
    return si;
}

+ (instancetype)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    /**
     *   主题设置     */
//    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.viewSize = [self sizeThatFitWidth:self.width];
    
//    
//    NSLog(@"size %@", NSStringFromCGSize(si));
    
}

- (void)setTopic:(V2TopicModel *)topic
{
    _topic = topic;
    
    _contentLabel.attributedString = [[NSAttributedString alloc] initWithData:[_topic.content_rendered dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    _contentLabel.recongnizeLinkName = NSLinkAttributeName;
    
    
    
    _nodeLabel.text = topic.node.title;
    _createTimeLabel.text = NSStringFromFormat(@"%@", [NSDate dateWithTimeIntervalSince1970:[topic.created intValue]]);
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:topic.member.avatar_normal] placeholderImage:[UIImage imageNamed:@"icon"]];
    _userNameLabel.text = topic.member.username;
    _titleLabel.text = topic.title;
    
    
    [self setNeedsLayout];

}
@end