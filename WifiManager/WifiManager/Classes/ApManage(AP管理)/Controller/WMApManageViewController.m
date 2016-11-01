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
#import "CMNetworkManager.h"
#import "WMUserAccoutViewModel.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "WMApInfoViewModel.h"
#import "WMGroupInfo.h"
#import "WMGroupInfoViewModel.h"
#import "WMApAlterViewController.h"
#import "WMApAnimatorTool.h"
#import "WMApDataTool.h"



@interface WMApManageViewController ()

#pragma mark - APInfo数组
@property(nonatomic,strong) NSMutableArray<WMApInfoViewModel *> *apInfoViewModels;
@property(nonatomic,assign) NSInteger start;
@property(nonatomic,assign) NSInteger selectedGroupId;

/**筛选视图*/
@property(nonatomic,weak) UIView *filterView;
@property(nonatomic,weak) UITableView *filterTableView;
@property(nonatomic,strong) WMGroupInfoViewModel *groupViewModel;

/**转场代理*/
@property(nonatomic,strong) WMApAnimatorTool *animatorTool;

@property(nonatomic,assign) BOOL isLoadFromDB; //是否要从数据库加载

@end

@implementation WMApManageViewController

static NSString * const ID = @"cell";

#pragma mark - 懒加载
-(NSMutableArray *)apInfoViewModels
{
    if (_apInfoViewModels == nil) {
        _apInfoViewModels = [NSMutableArray array];
    }
    return _apInfoViewModels;
}

-(UIView *)filterView
{
    if (_filterView == nil) {
        // 初始化界面
        UIView *filterView = [[UIView alloc]init];
        filterView.frame = [UIScreen mainScreen].bounds;
        
        
        UITableView *filterTableView = [[UITableView alloc]init];
        filterTableView.cm_centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
        filterTableView.cm_centerY = [UIScreen mainScreen].bounds.size.height * 0.5;
        filterTableView.bounds = CGRectMake(0, 0, 240, 289);
        [filterView addSubview:filterTableView];
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:filterView];
        _filterView = filterView;
        _filterTableView = filterTableView;
        _filterView.hidden = YES;
        _filterView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];

        
        //添加点击手势
        UITapGestureRecognizer *tapFilterView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFilterView:)];
        [_filterView addGestureRecognizer:tapFilterView];
        
        //设置filterTableView的代理
        _filterTableView.delegate = self.groupViewModel;
        _filterTableView.dataSource = self.groupViewModel;
    }
    return _filterView;
}

-(WMGroupInfoViewModel *)groupViewModel
{
    if (_groupViewModel == nil) {
        _groupViewModel = [[WMGroupInfoViewModel alloc]init];
    }
    return _groupViewModel;
}

-(WMApAnimatorTool *)animatorTool
{
    if (_animatorTool == nil) {
        _animatorTool = [[WMApAnimatorTool alloc]init];
    }
    return _animatorTool;
}


#pragma mark - 系统回调方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self setupUI];
    
    self.isLoadFromDB = YES;
    
    //从数据库中获取分组信息
    [self getApGroupInfo];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

   
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止提示
    [SVProgressHUD dismiss];
    
    //取消所有的下载任务
    [[CMNetworkManager shareInstance].manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
}

#pragma mark - 设置UI
/**设置UI*/
-(void)setupUI
{
    //1 设置导航栏
    self.title = @"AP管理";
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(filterBtnClick) image:nil highImage:nil title:@"刷选"];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
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
    self.isLoadFromDB = NO;
    [self getApInfo:WMNetworkTypeNew groupId:self.selectedGroupId];
}

/**上拉加载事件*/
-(void)loadMoreData
{
    self.isLoadFromDB = NO;
    [self getApInfo:WMNetworkTypeMore groupId:self.selectedGroupId];
}

/**筛选按钮点击事件*/
-(void)filterBtnClick
{

    self.filterView.hidden = NO;
    [self.filterTableView reloadData];
    
}

/**filterView屏幕点击手势*/
-(void)tapFilterView:(UITapGestureRecognizer *)tap
{
//    self.filterView.hidden = YES;
}


#pragma mark - 数据请求

/**获取接入点分组信息*/
-(void)getApGroupInfo
{
    //1 获取服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //2 提示正在加载
    [SVProgressHUD showWithStatus:@"正在加载"];
    
    //定义处理数据的block
    void(^handleGroupInfo)(NSDictionary *) = ^(NSDictionary *groupInfo){
    
        //字典转模型
        WMGroupInfo *group = [WMGroupInfo mj_objectWithKeyValues:groupInfo];
        self.groupViewModel.groupInfo = group;
        
        
        //提取根区域的id
        self.selectedGroupId = group.Id;
        
        //加载最新AP信息
        [self getApInfo:WMNetworkTypeNew groupId:self.selectedGroupId];
    
    };
    
    //先从数据库获取数据，如果没有，从网络上获取
    if(self.isLoadFromDB)
    {
        //首先判断数据库中是否有缓存
        if([WMApDataTool apGroupInfo])
        {
            NSDictionary *groupInf0 = [WMApDataTool apGroupInfo];
            handleGroupInfo(groupInf0);
            
        }else{
            
            //3 发起请求
            [CMNetworkManager requestForGroupInfo:server competation:^(NSError *error, NSDictionary *groupInfo) {
                //判断错误
                if(error){
                    [SVProgressHUD errorWithString:@"分组加载失败，请重试!"];
                    return;
                }
                //存入数据库
                [WMApDataTool saveAPGroupInfo:groupInfo];
                handleGroupInfo(groupInfo);
            }];
            
        }
        
    }else{

        //3 发起请求
        [CMNetworkManager requestForGroupInfo:server competation:^(NSError *error, NSDictionary *groupInfo) {
            //判断错误
            if(error){
                [SVProgressHUD errorWithString:@"分组加载失败，请重试!"];
                return;
            }
            //存入数据库
            [WMApDataTool saveAPGroupInfo:groupInfo];
            handleGroupInfo(groupInfo);
        }];
        
    }
    
}




/**获取AP信息*/
-(void)getApInfo:(WMNetworkType)type groupId:(NSInteger)groupId
{
    //1 获取服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //2 如果是下拉刷新，start=0
    if (type == WMNetworkTypeNew) self.start = 0;
    
    //定义处理数据的block
    void(^handleApInfo)(NSArray *) = ^(NSArray *result){
        
        //4 字典转模型
        NSArray *dataArray = [WMApInfo mj_objectArrayWithKeyValuesArray:result];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (WMApInfo *apInfo in dataArray) {
            WMApInfoViewModel *viewModel = [[WMApInfoViewModel alloc]initWithApInfo:apInfo];
            [arrayM addObject:viewModel];
        }
        
        //5 根据类型来处理数据
        if (type == WMNetworkTypeNew) {
            self.apInfoViewModels = arrayM;
            

            
        }else{
            [self.apInfoViewModels addObjectsFromArray:arrayM];
        }
        
        //6 改变start索引
        self.start = self.apInfoViewModels.count;
        
        //7 刷新表格
        [self.tableView reloadData];
        
        //8 停止刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    
    };
    
    
    //先从数据库获取，如果没有，再从网络上获取
    if (self.isLoadFromDB) {
        
        //从数据库中获取
        NSArray *result = [WMApDataTool apInfo:@{@"start":@(self.start),@"limit":@(CMNetworkLimit)}];
        if(result.count)
        {
            handleApInfo(result);
        }
        else
        {
            [CMNetworkManager requestForApInfo:server start:self.start limit:CMNetworkLimit groupId:groupId search:nil competation:^(NSError *error, NSArray *result) {
                
                //3 判断错误
                if (error) {
                    [SVProgressHUD errorWithString:@"加载失败，请重试"];
                    return ;
                }
                
                handleApInfo(result);
                //存数据库
                [WMApDataTool saveApInfo:result];
                
            }];
        }
        
        
    }else{
        
        //直接从网络上获取
        [CMNetworkManager requestForApInfo:server start:self.start limit:CMNetworkLimit groupId:groupId search:nil competation:^(NSError *error, NSArray *result) {
            
            //3 判断错误
            if (error) {
                [SVProgressHUD errorWithString:@"加载失败，请重试"];
                return ;
            }
            handleApInfo(result);
            if (type == WMNetworkTypeNew) {
                [WMApDataTool removeAllApInfo];
            }
            
            //存数据库
            [WMApDataTool saveApInfo:result];
            
        }];
        
    }
}






#pragma mark - UITableViewDataSource数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.apInfoViewModels.count == 0);
    return self.apInfoViewModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    WMApManageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 取出ViewModel
    WMApInfoViewModel *viewModel = self.apInfoViewModels[indexPath.row];
    
    // 设置数据
    cell.viewModel = viewModel;
    
    // 返回cell
    return  cell;
}


#pragma mark - UITableViewDelegate代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建控制器
    WMApAlterViewController *alterVc = [[WMApAlterViewController alloc]init];
    
    
    //2 传值
    alterVc.viewModel = self.apInfoViewModels[indexPath.row];

    //3 设置modal样式--避免被遮盖
    alterVc.modalPresentationStyle = UIModalPresentationCustom;
    
    //4 设置转场代理
    alterVc.transitioningDelegate = self.animatorTool;
    self.animatorTool.presentedRect = [UIScreen mainScreen].bounds;
    
    //5 设置block
    alterVc.myBlock = ^(WMApInfoViewModel *viewModel)
    {
      
        
        [self.tableView reloadData];
    };


    
    //6 弹出控制器
    [self presentViewController:alterVc animated:YES completion:nil];
}



@end
