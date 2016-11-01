//
//  WMProfileViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/10/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMProfileCell.h"
#import "WMCellItem.h"
#import "WMGroupItem.h"
#import "WMAccessoryCellItem.h"

@implementation WMBaseViewController

-(NSMutableArray *)cellItems
{
    if (_cellItems == nil) {
        _cellItems = [NSMutableArray array];
    }
    return _cellItems;
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellItems.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellItems[section] cells].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    WMProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WMProfileCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.item = [self.cellItems[indexPath.section] cells][indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出模型
    WMGroupItem *group = self.cellItems[indexPath.section];
    WMCellItem *item = group.cells[indexPath.row];
    
    if ([item isKindOfClass:[WMAccessoryCellItem class]]) {
        
        WMAccessoryCellItem *accessoryItem = (WMAccessoryCellItem *)item;
        if (accessoryItem.destinationVC) {
            UIViewController *vc = [[accessoryItem.destinationVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
    }

    if (item.option) {
        item.option(item.leftDetail);
    }
}



@end














