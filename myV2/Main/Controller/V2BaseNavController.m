//
//  V2BaseNavController.m
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2BaseNavController.h"

@interface V2BaseNavController ()

@end

@implementation V2BaseNavController

+ (void)initialize
{
    if (self == [V2BaseNavController class]) {
        UINavigationBar *ap = [UINavigationBar appearance];
//        ap.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//        ap.barTintColor = [UIColor redColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
