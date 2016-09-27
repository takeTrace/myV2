//
//  V2SettingViewController.m
//  myV2
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2SettingViewController.h"
#import <MJExtension.h>
#import "V2SettingModel.h"
#import "YCTool.h"
#import "V2SettingCell.h"
#import "V2SettingManager.h"

#define SettingsFile [YCDocumentPath stringByAppendingPathComponent:@"settings.plist"]
@interface V2SettingViewController ()

@property (nonatomic, strong) NSArray<V2SettingModel *> *settings;

@end

@implementation V2SettingViewController

- (NSArray *)settings
{
    if (!_settings) {
        
        _settings = [V2SettingModel mj_objectArrayWithFile:SettingsFile];
        if (!_settings) {
            _settings = [V2SettingModel mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"settingInit.plist" ofType:nil]];
        }
        
       __block __weak typeof(self) weaS = self;
        [_settings enumerateObjectsUsingBlock:^(V2SettingModel * _Nonnull setting, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (setting.cellType) {
                case V2SettingCellTypeArrow:
                    setting.desc = NSStringFromFormat(@"%g",[V2SettingManager getDiskImageCacheSize]);
                    [setting setOperation:^(V2SettingModel *set) {
                        [weaS alert];
                        set.desc = NSStringFromFormat(@"%g",[V2SettingManager getDiskImageCacheSize]);
                        
                    }];
                    break;
                case V2SettingCellTypeCheck:
                    setting.isOn =  [V2SettingManager shareSettingManager].loading;
                    [setting setOperation:^(V2SettingModel *set) {
                        set.isOn = !set.isOn;
                        [V2SettingManager setToLoading:set.isOn];
                    }];
                    break;
                case V2SettingCellTypeSwitch:
                    setting.isOn = [V2SettingManager shareSettingManager].nightMode;
                    [setting setOperation:^(V2SettingModel *set) {
                        set.isOn = !set.isOn;
                        [V2SettingManager setToNightMode:set.isOn];
                    }];
                    break;
                    
                default:
                    break;
            }
        }];
        
    }
    return _settings;
}

- (void)alert
{
    /**
     *   创建 alert     */
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存?" message:NSStringFromFormat(@"%g", [V2SettingManager getDiskImageCacheSize]) preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
        [V2SettingManager clearImageCache];
//    }]];
//    
//    [self addChildViewController:alert];
//    
//    [self showViewController:alert sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- tableViewDelegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    V2SettingCell *cell = [V2SettingCell cellWithTableView:tableView];
    
    V2SettingModel *settingM = self.settings[indexPath.row];
    
    cell.settingModel = settingM;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    V2SettingModel *setting = self.settings[indexPath.row];
    YCLog(@"setting = settings[indexPath.row? %d", setting == self.settings[indexPath.row]);
    typeof(setting) __weak sett = setting;
    if (!setting.operation) return;
    setting.operation(sett);

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
