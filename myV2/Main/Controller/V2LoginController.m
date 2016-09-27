//
//  V2LoginController.m
//  myV2
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2LoginController.h"
#import "YCTool.h"
#import "V2DataManager.h"
#import "V2DrawerManager.h"

@interface V2LoginController ()
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UITextField *userNameVField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *siteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteInfoDesc;
- (IBAction)cancel:(UIButton *)sender;

- (IBAction)loginBtnDidClick:(UIButton *)sender;
@end

@implementation V2LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //  关闭抽屉行为
    [[V2DrawerManager sharedrawerManager] disableDrawerGesture];
    
}


- (IBAction)cancel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[V2DrawerManager sharedrawerManager] enableDrawerGesture];
    }];
}

- (IBAction)loginBtnDidClick:(UIButton *)sender {
    
    NSString *userName = _userNameVField.text;
    NSString *pwd = _pwdField.text;
    //  检测都填入信息
    if (!userName || !pwd) return;
    //  检测不是邮箱
    if ([_userNameVField.text rangeOfString:@"@"].length > 0) return;
    
    //  输入符合要求, 取出用户名和密码登录
    [V2DataManager loginWithUserName:userName password:pwd success:^(V2MemberModel *user) {
        
        if (!user) return;
        /**
         *   保存登录的用户     */
        [V2DataManager loginUser:user];
        /**
         *   发出通知     */
        YCSendNotification(V2UserLoginNotification, @{V2UserLoginSuccessKey : user});
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
        YCLog(@"登录失败");
    }];
    
}
@end
