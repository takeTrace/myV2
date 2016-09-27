//
//  V2SettingCell.h
//  myV2
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class V2SettingModel;
@interface V2SettingCell : UITableViewCell
@property (nonatomic, strong) V2SettingModel *settingModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
