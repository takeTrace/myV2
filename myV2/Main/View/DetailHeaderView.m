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
    
//    _contentLabel.attributedString = [[NSMutableAttributedString alloc] initWithData:[_topic.content_rendered dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    _contentLabel.recongnizeLinkName = NSLinkAttributeName;
    
    
    _contentLabel.htmlString = _topic.content_rendered;
    
    
    _nodeLabel.text = topic.node.title;
    _createTimeLabel.text = [self getTime:_topic.created];
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:topic.member.avatar_normal] placeholderImage:[UIImage imageNamed:@"icon"]];
    _userNameLabel.text = topic.member.username;
    _titleLabel.text = topic.title;
    
    
    [self setNeedsLayout];

}

- (NSString *)getTime:(NSString *)created
{
    int time = created.intValue;
    if (!time || [created rangeOfString:@"置顶"].length>0
        || [created rangeOfString:@"前"].length>0
        || [created rangeOfString:@"go"].length>0) return created;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY-MM-dd | HH:mm";
    
    return [fmt stringFromDate:date];
}
@end
