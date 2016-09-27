//
//  V2SettingCell.m
//  myV2
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2SettingCell.h"
#import "V2SettingModel.h"
#import "YCTool.h"

@interface V2SettingCell ()

@property (nonatomic, weak) UISwitch *switchBtn;
@property (nonatomic, weak) UILabel *label;
//@property (nonatomic, weak) check *check check 暂时用自带的

@end
@implementation V2SettingCell

#pragma mark- 懒加载   
- (UISwitch *)switchBtn
{
    if (!_switchBtn) {
        UISwitch *sw = [[UISwitch alloc] init];
        [self.contentView addSubview:sw];
        _switchBtn = sw;
        [sw addTarget:self action:@selector(switchBtnDidClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}
- (void)switchBtnDidClick:(UISwitch *)sender
{
    self.settingModel.operation(self.settingModel);
}

- (UILabel *)label
{
    if (!_label) {
        UILabel *la = [[UILabel alloc] init];
        [self.contentView addSubview:la];
        self.label = la;
    }
    return _label;
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
    #warning Note:  这里暂时没有初始化设置, 之后如果添加背景色背景图在这里设置
}


- (void)setSettingModel:(V2SettingModel *)settingModel
{
    _settingModel = settingModel;

    self.textLabel.text = settingModel.title;
    self.detailTextLabel.text = settingModel.desc;
    self.accessoryView = nil;
    switch (settingModel.cellType) {
        case V2SettingCellTypeNone:
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case V2SettingCellTypeArrow:
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case V2SettingCellTypeCheck:
            self.accessoryType = settingModel.isOn ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        case V2SettingCellTypeLabel:
            self.accessoryView = self.label;
            self.label.text = settingModel.state;
            break;
        case V2SettingCellTypeSwitch:
            self.accessoryView = self.switchBtn;
            self.switchBtn.on = settingModel.isOn;
            break;
        default:
            break;
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"V2SettingCell";
    
    V2SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[V2SettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    return cell;
}

//
//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:NO animated:animated];
//
//    // Configure the view for the selected
////    YCPlog;
////    YCLog(@"---------------------------");
////    if (!self.settingModel.operation) return;
////    typeof(self.settingModel) __weak sett = self.settingModel;
////    self.settingModel.operation(sett);
//        //  这咯配置 view 才好, 不然再加载 cell 的时候也会调用一次, 这就在不该执行的时候执行了
//    
//    
//}


@end
