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

@interface TabsViewController ()
@property (nonatomic, strong) NSArray<V2TabModel *> *tabs;

@end

@implementation TabsViewController

/**
 *   懒加载     */
- (NSArray<V2TabModel *> *)tabs
{
    if (!_tabs) {
        [V2DataManager getTabsSuccess:^(NSArray<V2TabModel *> *tabs) {
            _tabs = tabs;
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"error %@", error);
        } ];
        
    }
    return _tabs;
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
    cell.detailTextLabel.text = tab.urlStr;
//    cell.imageView.image = nil;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
    
    // Configure the cell...

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
