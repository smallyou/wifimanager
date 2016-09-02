//
//  WMWifiStateViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMWifiStateViewController.h"
#import "CMNetworkManager.h"
#import "WMUserAccoutViewModel.h"
#import "WMUserAccout.h"

@interface WMWifiStateViewController ()

@end

@implementation WMWifiStateViewController

#pragma mark - 系统回调方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 设置导航栏
    [self setupNavigationBar];
    
    [CMNetworkManager requestForCustomer:[WMUserAccoutViewModel shareInstance].userAccout.server competation:^(NSString *customer, NSError *error) {
        NSLog(@"%@", customer);
        
    }];
    
}

#pragma mark - 设置UI

/**设置导航栏*/
-(void)setupNavigationBar
{
    self.title = @"无线状态";
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ss"];
    
    return cell;
}


@end
