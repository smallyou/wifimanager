//
//  WMApManageViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApManageViewController.h"
#import <MJRefresh.h>
#import "WMApManageCell.h"

@interface WMApManageViewController ()

@end

@implementation WMApManageViewController

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self setupUI];
    
}
#pragma mark - 设置UI
/**设置UI*/
-(void)setupUI
{
    //1 设置导航栏
    self.title = @"AP管理";
    
    //2 设置下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    //3 设置上拉加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    //4 设置行高
    self.tableView.rowHeight = 140;
    //    self.tableView.rowHeight = 400;
    
    //5 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WMApManageCell" bundle:nil] forCellReuseIdentifier:ID];

    
    //6 设置其他属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WMColor(86, 171, 228);
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    
    
}


#pragma mark - 事件监听
/**下拉刷新事件*/
-(void)loadNewData
{
    
}

/**上拉加载事件*/
-(void)loadMoreData
{
    
}


#pragma mark - UITableViewDataSource数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMApManageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    
    return  cell;
}


@end
