//
//  WMAlertEventViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAlertEventViewController.h"
#import "WMUserAccoutViewModel.h"
#import "CMNetworkManager.h"
#import "WMAlertEventModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "WMAlertEventCell.h"

@interface WMAlertEventViewController () <UISearchBarDelegate>

@property(nonatomic,weak) UISearchBar *searchBar;
@property(nonatomic,assign) NSInteger start;
@property(nonatomic,strong) NSMutableArray *alertEvents;
@property(nonatomic,weak) UILabel *tipsLabel;
@property(nonatomic,weak) UIActivityIndicatorView *indicator;

@end

@implementation WMAlertEventViewController

static NSString *const ID = @"cell";

-(NSMutableArray *)alertEvents
{
    if (_alertEvents == nil) {
        _alertEvents = [NSMutableArray array];
    }
    return _alertEvents;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置UI
    [self setupUI];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //加载数据
    [self loadNewData];
    
}

#pragma mark - 事件监听
/**加载最新数据*/
-(void)loadNewData
{
    [self requestForNetwork:WMNetworkTypeNew];
}

/**加载更多数据*/
-(void)loadMoreData
{
    [self requestForNetwork:WMNetworkTypeMore];
}


#pragma mark - 数据请求

/**请求无线网络数据*/
-(void)requestForNetwork:(WMNetworkType)type
{
    //1 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    //2 获取服务器地址
    NSString *server = userAccout.server;
    
    //3 如果是下拉刷新，start=0
    if (type == WMNetworkTypeNew) self.start = 0;
    
    //4 请求数据
    NSString *search = self.searchBar.text;
    [CMNetworkManager requestForAlertEvent:server search:search start:self.start limit:CMNetworkLimit competation:^(NSArray *data, NSError *error) {
       
        if (error) {
            return;
        }
        
        //5 字典转模型
        NSArray *array = [WMAlertEventModel mj_objectArrayWithKeyValuesArray:data];
        
        //6 根据刷新类型，处理数据
        if (type == WMNetworkTypeNew)
        {
            // 覆盖数据
            self.alertEvents = [NSMutableArray arrayWithArray:array];
        }
        else {
            // 追加数据
            [self.alertEvents addObjectsFromArray:array];
        }
        
        //7 改变start索引
        self.start = self.alertEvents.count;
        
        //8 刷新表格
        [self.tableView reloadData];
        
        //9 结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.indicator stopAnimating];
        
    }];
}


#pragma mark - 设置UI
/**设置UI*/
-(void)setupUI
{
    self.title = @"告警事件";
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.cm_height = 44;
    searchBar.placeholder = @"搜索事件";
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    self.searchBar = searchBar;
    
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"暂无数据";
    label.font = [UIFont systemFontOfSize:15.0];
    label.hidden = YES;
    [self.view addSubview:label];
    self.tipsLabel = label;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.color = WMLightBlueColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:indicator];
    self.indicator = indicator;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMAlertEventCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.estimatedRowHeight = 64;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    self.tableView.mj_footer = footer;
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tipsLabel.frame =  CGRectMake(0, CMNavigationBarMaxY, self.view.bounds.size.width, 44);
}



#pragma mark - UITableViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tipsLabel.hidden = !(self.alertEvents.count == 0);
    return self.alertEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WMAlertEventCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //取出模型
    WMAlertEventModel *alertEvent = self.alertEvents[indexPath.row];
    
    //赋值
    cell.alertEvent = alertEvent;
    
    return cell;
}



#pragma mark - UISearchBarDelegate
/**点击搜索按钮后的方法*/
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.indicator startAnimating];
    
    //搜索
    [self requestForNetwork:WMNetworkTypeNew];
    
    //取消键盘
    [self.view endEditing:YES];
    
}



@end
