//
//  TabsViewController.m
//  myV2
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "TabsViewController.h"
#import "V2TabModel.h"
#import "V2DataManager.h"
#import "ILTranslucentView.h"
#import "YCTool.h"



@interface TabsViewController ()
@property (nonatomic, strong) NSArray<V2TabModel *> *tabs;

@end

@implementation TabsViewController


- (NSArray<V2TabModel *> *)tabs
{
    if (!_tabs) {
        [V2DataManager getTabsSuccess:^(NSArray<V2TabModel *> *tabs) {
            _tabs = tabs;
            [self.tableView reloadData];
            /**
             *   初始化选中, 因为异步返回数据, 如果放其他地方的话会有_tabs=nil 的现象     */
            [self initSelect];
        } failure:^(NSError *error) {
            NSLog(@"error %@", error);
        } ];
        
    }
    return _tabs;
}

- (void)initSelect
{
    if ([V2DataManager getSelectedIndexInTabViewTable]) {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[V2DataManager getSelectedIndexInTabViewTable] inSection:0]];
    } else
    {
        [self.tabs enumerateObjectsUsingBlock:^(V2TabModel * _Nonnull tab, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tab.name isEqualToString:@"全部"]) {
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                
                *stop = YES;
            }
        }];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    ILTranslucentView *blure = [[ILTranslucentView alloc] initWithFrame:self.view.bounds];
    blure.translucentAlpha = 0.8;
    blure.translucentStyle = UIBarStyleBlack;
    blure.translucentTintColor = [UIColor blackColor];
    blure.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = blure;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.tabs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"tabs";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    V2TabModel *tab = self.tabs[indexPath.row];
    
    cell.textLabel.text = tab.name;
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.detailTextLabel.text = tab.urlStr;
//    cell.imageView.image = nil;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
    
    // Configure the cell...

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [V2DataManager setSelectedIndexInTabViewTable:indexPath.row];
    
    V2TabModel *tab = self.tabs[indexPath.row];
    /**
     *   发送通知     */
    YCSendNotification(TabViewDidSelectTabNotifacation, @{TabViewSelectedTabTypeUserinfoKey: tab});
    
    
}
@end
