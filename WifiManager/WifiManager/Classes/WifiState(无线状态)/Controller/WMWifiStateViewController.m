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
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WMHeaderView.h"
#import "WMStateCell.h"
#import "WMApViewModel.h"
#import "WMApRadio.h"
#import "WMApAlterViewController.h"
#import "WMApInfo.h"
#import "WMChannelRateController.h"


@interface WMWifiStateViewController () <WMHeaderViewDelegate,WMStateCellDelegate>

/**AP无线状态数据*/
@property(nonatomic,strong) NSMutableArray *apViewModels;
/**请求索引*/
@property(nonatomic,assign) NSInteger start;


/**导航栏item*/
@property(nonatomic,weak) UIButton *tipsButton;



@end

@implementation WMWifiStateViewController

static NSString *const ID = @"cell";
static NSString *const HeaderID = @"header";

#pragma mark - 懒加载
-(UIButton *)tipsButton
{
    if (_tipsButton == nil) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitleColor:WMColor(97, 97, 97) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [btn sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        _tipsButton = btn;
    }
    return _tipsButton;
}
-(NSMutableArray *)apViewModels
{
    if (_apViewModels == nil) {
        _apViewModels = [NSMutableArray array];
    }
    return _apViewModels;
}



#pragma mark - 系统回调方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 设置UI
    [self setupUI];
    
    //2 开始刷新
    [self.tableView.mj_header beginRefreshing];
    
    
}

#pragma mark - 设置UI

/**设置UI*/
-(void)setupUI
{
    //1 设置导航栏
    self.title = @"无线状态";
    [self updateTips:@"在线0/离线0"];
    
    
    //2 设置下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    //3 设置上拉加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    //4 设置行高
    self.tableView.sectionHeaderHeight = 100;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.rowHeight = 180;
    
    //5 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WMStateCell" bundle:nil] forCellReuseIdentifier:ID];
    
    
    //6 设置其他属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WMColor(86, 171, 228);
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    
    
}

/**设置tipsButton内容*/
-(void)updateTips:(NSString *)title
{
    [self.tipsButton setTitle:title forState:UIControlStateNormal];
    [self.tipsButton sizeToFit];
}

#pragma mark - 事件监听
/**下拉刷新事件*/
-(void)loadNewData
{
    [self requestApData:WMNetworkTypeNew];
}


/**上拉加载更多事件*/
-(void)loadMoreData
{
    [self requestApData:WMNetworkTypeMore];
}

#pragma mark - 数据请求
/**获取AP的无线状态*/
-(void)requestApData:(WMNetworkType)type
{
    //1 获取服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //2 如果是下拉刷新，start=0
    if (type == WMNetworkTypeNew) self.start = 0;
    
    //3 发起请求
    [CMNetworkManager requestForApStatus:server start:self.start limit:CMNetworkLimit competation:^(NSDictionary *result, NSError *error) {
       
        //4 判断错误
        if (error) {
            [SVProgressHUD errorWithString:@"加载失败，请重试"];
            return ;
        }
        
        //5 获取当前的在线AP总数和离线AP总数--更新UI
        [self updateTips:[NSString stringWithFormat:@"在线%zd/离线%zd",[result[@"onlineCount"] integerValue],[result[@"offlineCount"] integerValue]]];
        
        //6 字典转模型
        NSMutableArray *aps = [WMAccessPoint mj_objectArrayWithKeyValuesArray:result[@"data"]];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (WMAccessPoint *ap in aps) {
            WMApViewModel *viewModel = [[WMApViewModel alloc]initWithAccessPoint:ap];
            [arrayM addObject:viewModel];
        }
        
        //7 根据类型来处理数据
        if (type == WMNetworkTypeNew) {
            self.apViewModels = arrayM;
        }else{
            [self.apViewModels addObjectsFromArray:arrayM];
        }
        
        //8 改变start索引
        self.start = self.apViewModels.count;
        
        //9 刷新表格
        [self.tableView reloadData];
        
        //10 停止刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];

        
    }];
}

/**获取指定AP的射频信息*/
-(void)requestForRadioWithAp:(WMApViewModel *)viewModel
{
    //1 获取服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //2 提示
    [SVProgressHUD showWithStatus:@"loading"];
    
    //3 发起请求
//    [CMNetworkManager requestForRadioInfoWithAp:viewModel.ap server:server competation:^(NSArray *data, NSError *error) {
//       
//        //4 判断错误
//        if(error){
//            [SVProgressHUD errorWithString:@"加载失败，请重试"];
//            return ;
//        }
//        
//        //5 字典转模型
//        NSMutableArray *array = [WMApRadio mj_objectArrayWithKeyValuesArray:data];
//        viewModel.apRadios = array;
//        
//        //6 刷新表格
//        [self.tableView reloadData];
//        
//        //7 关闭提示
//        [SVProgressHUD dismiss];
//        
//    }];
    
    [CMNetworkManager requestForDetailsRadioInfo:viewModel.ap server:server competation:^(NSArray *data, NSError *error) {
        //4 判断失败
        if(error){
            [SVProgressHUD errorWithString:@"加载失败，请重试"];
            return ;
        }
        
        //5 字典转模型
        NSMutableArray *array = [WMApRadio mj_objectArrayWithKeyValuesArray:data];
        viewModel.apRadios = array;
        
        //6 刷新表格
        [self.tableView reloadData];
        
        //7 关闭提示
        [SVProgressHUD dismiss];
    }];
    
}



#pragma mark - UITableViewDataSource数据源方法

/**确定有多少组*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.tableView.mj_footer.hidden = self.apViewModels.count == 0;
    return self.apViewModels.count;
}

/**确定有多少行*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.apViewModels[section] isUnFold] ? [self.apViewModels[section] apRadios].count : 0;
}

/**确定每行的内容*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMStateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    //取出viewmodel
    WMApViewModel *viewModel = self.apViewModels[indexPath.section];
    
    viewModel.indexPath = indexPath;
    
    cell.viewModel = viewModel;
    
    cell.delegate = self;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WMHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    if (view == nil) {
        view = [[WMHeaderView alloc]initWithReuseIdentifier:HeaderID];
        view.delegate = self;
    }
    
    view.viewModel = self.apViewModels[section];
    
    return view;
}


#pragma mark - UITableViewDelegate代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出当前的模型
    WMApViewModel *apViewModel = self.apViewModels[indexPath.section];
    apViewModel.indexPath = indexPath;
    
    //创建信道利用率控制器
    WMChannelRateController *channelVc = [[WMChannelRateController alloc]init];
    
    //赋值
    channelVc.apViewModel = apViewModel;
    
    //弹出
    [self presentViewController:channelVc animated:YES completion:nil];
}


#pragma mark - WMHeaderViewDelegate代理方法

-(void)headerViewDidViewClick:(WMHeaderView *)headerView
{
    
    // 选中的视图模型
    WMApViewModel *viewModel = headerView.viewModel;
    
    // 标记展开
    viewModel.isUnFold = !viewModel.isUnFold;
    
    // 加载数据
    if (viewModel.isUnFold) {
        
        [self requestForRadioWithAp:viewModel];
    }else{
        [self.tableView reloadData];
    }
}

#pragma mark - WMStateCellDelegate代理方法
-(void)stateCell:(WMStateCell *)stateCell didSettingBtnClick:(UIButton *)settingBtn
{
    //1 创建控制器
    WMApAlterViewController *alterVc = [[WMApAlterViewController alloc]init];
    
    //2 传值
    alterVc.ap = stateCell.viewModel.ap;
        
    //3 设置modal样式--避免被遮盖
    alterVc.modalPresentationStyle = UIModalPresentationCustom;
    alterVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    //4 设置block
    alterVc.myBlock = ^(WMApInfoViewModel *viewModel)
    {
        [self.tableView reloadData];
    };
    
    //5 弹出控制器
    [self presentViewController:alterVc animated:YES completion:nil];
}



@end
