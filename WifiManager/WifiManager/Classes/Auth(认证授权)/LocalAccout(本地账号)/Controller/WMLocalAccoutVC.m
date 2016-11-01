//
//  WMLocalAccoutVC.m
//  WifiManager
//
//  Created by 陈华 on 16/9/26.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMLocalAccoutVC.h"
#import "CMNetworkManager.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WMUserAccoutViewModel.h"
#import "WMGroupAccoutModel.h"
#import "WMDetailsLocalAccoutVC.h"


@interface WMLocalAccoutVC ()

@property(nonatomic,assign) NSInteger start;
@property(nonatomic,strong) NSMutableArray *localGroups;

@end

@implementation WMLocalAccoutVC

#pragma mark - 懒加载
-(NSMutableArray *)localGroups
{
    if (_localGroups == nil) {
        _localGroups = [NSMutableArray array];
    }
    return _localGroups;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**设置UI*/
    [self setupUI];
    
    /**加载数据*/
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 设置UI
/**设置UI*/
-(void)setupUI
{
    // 设置下拉刷新及上拉加载控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    self.tableView.mj_footer = footer;
    

    
    
}


#pragma mark - 事件监听
/**下拉刷新*/
-(void)loadNewData
{
    
    [self requestForData:WMNetworkTypeNew];
}

/**上拉加载*/
-(void)loadMoreData
{
    
    [self requestForData:WMNetworkTypeMore];
}


#pragma mark - 数据请求

-(void)requestForData:(WMNetworkType)type
{
    //1 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    //2 获取服务器地址
    NSString *server = userAccout.server;
    
    //3 如果是下拉刷新，start=0
    if (type == WMNetworkTypeNew) self.start = 0;
    
    //4 请求数据
    [CMNetworkManager requestForLocalUserAndGroup:server sortId:@"root" start:self.start limit:CMNetworkLimit competation:^(NSArray *data, NSError *error) {
        
        //5 判断错误
        if (error) {
            
            return;
        }
        
        //6 字典转模型
        NSArray *array = [WMGroupAccoutModel mj_objectArrayWithKeyValuesArray:data];
        
        //7 根据刷新类型，处理数据
        if (type == WMNetworkTypeNew)
        {
            // 覆盖数据
            self.localGroups = [NSMutableArray arrayWithArray:array];
        }
        else {
            // 追加数据
            [self.localGroups addObjectsFromArray:array];
        }
        
        //8 改变start索引
        self.start = self.localGroups.count;
        
        //9 刷新表格
        [self.tableView reloadData];
        
        //10 结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];   
        
    }];
    
    
    
}




#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.localGroups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    WMGroupAccoutModel *group = self.localGroups[indexPath.row];
    
    cell.textLabel.text = group.name;
    
    return cell;
}


#pragma mark - UITableViewDelegate - 监听cell的点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前选择的模型
    WMGroupAccoutModel *group = self.localGroups[indexPath.row];
    
    //push控制器
    WMDetailsLocalAccoutVC *localVc = [[WMDetailsLocalAccoutVC alloc]init];
    localVc.group = group;
    [self.navigationController pushViewController:localVc animated:YES];
}


@end
