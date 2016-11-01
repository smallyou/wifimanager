//
//  WMGroupInfoViewModel.m
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMGroupInfoViewModel.h"

@implementation WMGroupInfoViewModel


#pragma mark - UITableViewDataSource 数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupInfo.children.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WMGroupInfo *group = self.groupInfo.children[section];

    return group.children.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.groupInfo.children[section] name];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"haha";
    return cell;
}


#pragma  mark - UITableViewDelegate代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD successWithString:@"yes"];
}


@end
