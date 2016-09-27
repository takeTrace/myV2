//
//  MenuViewController.m
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "MenuViewController.h"
#import <SDAutoLayout.h>
#import <Masonry.h>
#import "YCGloble.h"
#import "YCTool.h"
#import <UIImageView+WebCache.h>
#import "V2LoginController.h"
#import "V2MemberModel.h"
#import "V2DataManager.h"

/**
 *   按钮数据模型     */
@interface MenuButtonModel : NSObject
@end

/**
 *   自定义按钮     */
@interface MenuButton : UIButton
//@property (nonatomic, assign) MenuButtonType type;
@end
@implementation MenuButton

- (void)setHighlighted:(BOOL)highlighted{}


@end

@interface MenuViewController ()

/**
 *    上部用户信息取     */
@property (nonatomic, weak) UIView *userInfoView;
/**
 *   菜单按钮区     */
@property (nonatomic, weak) UIView *MenuView;

@property (nonatomic, weak) UIButton *iconBtn;
@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation MenuViewController

/**
 *   改变 self.view 为毛玻璃     */
- (void)loadView
{
    [super loadView];
    
    self.view = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    /**
     *    监听通知     */
    YCAddObserver(userDidLogin:, V2UserLoginNotification);
}

/**
 *   收到通知操作     */
- (void)userDidLogin:(NSNotification *)note
{   V2MemberModel *user = note.userInfo[V2UserLoginSuccessKey];
    _iconBtn.normalImage = [UIImage imageWithURLString:user.avatar_normal];
    _nameLabel.text = user.username;
}




#pragma mark- 懒加载
- (UIView *)userInfoView
{
    if (!_userInfoView) {
        UIView *uv = [[UIView alloc] init];
        _userInfoView = uv;
        [self.view addSubview:uv];
        
        /**
         *    自动布局     */
        [uv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(20);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(100);
        }];
        
        
        
        
        
        /**
         *   添加头像     */
        UIButton *icon = [UIButton buttonWithTitle:nil Image:[UIImage imageNamed:@"icon" withRenderingMode:UIImageRenderingModeAlwaysOriginal] HighlightImage:nil Target:self action:@selector(userInfoDidClick:) btnType:0];
        icon.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [uv addSubview:icon];
        self.iconBtn = icon;
        
        /**
         *   添加标签     */
        UILabel *userNameLabel = [[UILabel alloc] init];
        [uv addSubview:userNameLabel];
        userNameLabel.text = @"请点击头像来登录";
        userNameLabel.backgroundColor = YCRandomColor;
        userNameLabel.numberOfLines = 0;
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel = userNameLabel;
        
        
        /**
         *   是否登录     */
        V2MemberModel *user = [V2DataManager getLoginUser];
        if (user) {
            icon.normalImage = [UIImage imageWithURLString:user.avatar_normal];
            userNameLabel.text = user.username;
        }
        
        
        /**
         *   设置约束     */
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(uv.mas_left).offset(20);
            make.top.equalTo(uv.mas_top).offset(20);
            make.bottom.equalTo(uv.mas_bottom).offset(-20);
            make.width.mas_equalTo(50);
//            make.right.mas_equalTo(50);
        }];
        
        
        
        [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(10);
            make.top.equalTo(icon.mas_top);
            make.right.equalTo(uv.mas_right).offset(-10);
//            make.height.mas_equalTo(30);
        }];
        
        
    }
    return _userInfoView;
}

- (UIView *)MenuView
{
    if (!_MenuView) {
        UIView *mv = [[UIView alloc] init];
        _MenuView = mv;
        [self.view addSubview:mv];

        
        mv.sd_layout
        .topSpaceToView(self.userInfoView, 10)
        .leftEqualToView(self.userInfoView)
        .widthRatioToView(self.userInfoView, 1)
        .bottomEqualToView(self.view);
        
        [self setupButtonOnView:mv];
    }
    return _MenuView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor redColor];
    [self configNavigationBar];
    
    self.userInfoView.backgroundColor = [UIColor clearColor];
    self.MenuView.backgroundColor = [UIColor clearColor];
    
    
    
}


/**
 *   配置导航栏     */
- (void)configNavigationBar
{
    self.navigationItem.title = @"导航菜单";
    
    self.navigationController.navigationBarHidden = YES;
    
    
}

/**
 *   配置按钮     */
- (void)setupButtonOnView:(UIView *)view
{
    MenuButton *recentBtn = (MenuButton *)[MenuButton buttonWithTitle:@"最新" Image:nil HighlightImage:nil Target:self action:@selector(menuBtnDidClick:) btnType:MenuButtonTypeRecent];
    MenuButton *topicsBtn = (MenuButton *)[MenuButton buttonWithTitle:@"主题分类" Image:nil HighlightImage:nil Target:self action:@selector(menuBtnDidClick:) btnType:MenuButtonTypeTpoic];
    MenuButton *nodesBtn = (MenuButton *)[MenuButton buttonWithTitle:@"节点导航" Image:nil HighlightImage:nil Target:self action:@selector(menuBtnDidClick:) btnType:MenuButtonTypeNodes];
    MenuButton *settingBtn = (MenuButton *)[MenuButton buttonWithTitle:@"设置" Image:nil HighlightImage:nil Target:self action:@selector(menuBtnDidClick:) btnType:MenuButtonTypeSettings];
//    recentBtn.type = MenuButtonTypeRecent;
//    topicsBtn.type = MenuButtonTypeTpoic;
//    nodesBtn.type = MenuButtonTypeNodes;
    
    [view addSubview:recentBtn];
    [view addSubview:topicsBtn];
    [view addSubview:nodesBtn];
    [view addSubview:settingBtn];
    
    
    recentBtn.sd_layout
    .topEqualToView(recentBtn.superview)
    .leftSpaceToView(recentBtn.superview, 0)
    .rightSpaceToView(recentBtn.superview, 0)
    .heightIs(44);
    
    topicsBtn.sd_layout
    .topSpaceToView(recentBtn, 5)
    .leftSpaceToView(recentBtn.superview, 0)
    .rightSpaceToView(recentBtn.superview, 0)
    .heightRatioToView(recentBtn, 1);
    
    nodesBtn.sd_layout
    .topSpaceToView(topicsBtn, 5)
    .leftSpaceToView(recentBtn.superview, 0)
    .rightSpaceToView(recentBtn.superview, 0)
    .heightRatioToView(recentBtn, 1);

    settingBtn.sd_layout
    .topSpaceToView(nodesBtn, 5)
    .leftSpaceToView(recentBtn.superview, 0)
    .rightSpaceToView(recentBtn.superview, 0)
    .heightRatioToView(recentBtn, 1);
    
}


/**
 *    按钮点击     */
- (void)menuBtnDidClick:(MenuButton *)sender
{
    YCPlog;
    
    /**
     *   发送通知     */
    YCSendNotification(MenuViewDidSelectMenuNotifacation, @{MenuViewSelectedMenuTypeUserinfoKey : @(sender.tag)});
}


/**
 *   头像点击     */
- (void)userInfoDidClick:(UIButton *)sender
{
    /**
     *   发送通知     */
    YCSendNotification(MenuViewDidSelectInfoBtnNotification, nil);
}


@end
