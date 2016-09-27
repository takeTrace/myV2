//
//  V2MemberInfoController.m
//  myV2
//
//  Created by Mac on 16/9/25.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2MemberInfoController.h"
#import "YCTool.h"
#import "V2DataManager.h"
#import "V2MemberRepliesTable.h"
#import "V2MemberTopicsTable.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

static CGFloat aniDuration = 0.3;

@interface V2MemberInfoController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *topicsBtn;
@property (weak, nonatomic) IBOutlet UIButton *repliesBtn;
@property (weak, nonatomic) IBOutlet UIView *btnIndicator;


@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *infoView;

- (IBAction)scrollToPersonalInfo:(UIButton *)sender;
- (IBAction)scrollToTopicsTable:(UIButton *)sender;
- (IBAction)scrollToRepliesTable:(UIButton *)sender;
- (IBAction)backward:(UIButton *)sender;
- (IBAction)broswerIcon:(UITapGestureRecognizer *)sender;

/**
 *   显示主题的 table     */
@property (weak, nonatomic) IBOutlet V2MemberTopicsTable *topicsTable;

/**
 *    显示评论的 table     */
@property (weak, nonatomic) IBOutlet V2MemberRepliesTable *repliesTable;

/**
 *   标记选中的按钮     */
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation V2MemberInfoController

//- (void)loadView
//{
//    [super loadView];
//    
//}

- (void)viewDidAppear:(BOOL)animated
{
    _iconView.layer.cornerRadius = 5;
    _iconView.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.user = [V2DataManager getLoginUser];
    
    self.btnIndicator.width = self.personalBtn.width;
    self.btnIndicator.centerX = self.personalBtn.centerX;
    
    if (!_user) return;
    /**
     *   设置头像     */
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_user.avatar_normal]];
    //  用户名
    _nameLabel.text = _user.username;
    _bioLabel.text = _user.bio;
    
    /**
     *   初始化 tableView     */
    [self setupTableViews];
    
    
    
    
    
    [V2DataManager getMemberTopics:self.user page:nil success:^(NSArray<V2TopicModel *> *topics) {
        
        _topicsTable.topics = topics;
    } failure:^(NSError *error) {
        YCLog(@"error: %@", error);
    }];
    
    [V2DataManager getMemberReplies:_user page:nil success:^(NSArray<V2MemberReplyModel *> *replies) {
        
        _repliesTable.replies = replies;
        
    } failure:^(NSError *error) {
        YCLog(@"error: %@", error);
    }];
}


/**
 *   初始化 tableViews     */
- (void)setupTableViews
{
    /**
     *    传递模型, 设置代理     */
}


- (IBAction)scrollToPersonalInfo:(UIButton *)sender {

    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (IBAction)scrollToTopicsTable:(UIButton *)sender {

    [_scrollView setContentOffset:CGPointMake(YCScreenW, 0) animated:YES];
    
}
- (IBAction)scrollToRepliesTable:(UIButton *)sender {

    [_scrollView setContentOffset:CGPointMake(YCScreenW * 2, 0) animated:YES];
    
    
}

- (IBAction)backward:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        YCPlog;
        YCLog(@"销毁查看控制器");
    }];
}

- (IBAction)broswerIcon:(UITapGestureRecognizer *)sender {
    CGFloat scale = YCScreenW/_iconView.width;
    [UIView animateWithDuration:aniDuration animations:^{
        _iconView.transform = CGAffineTransformTranslate(_iconView.transform, 0, self.view.centerY - _iconView.centerY);
        _iconView.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}



#pragma mark- scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _btnIndicator.x = scrollView.contentOffset.x / 3;
}


@end
