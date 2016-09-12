//
//  WMWifiViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMWifiViewController.h"
#import <MJRefresh.h>
#import "CMNetworkManager.h"
#import "WMNetworkViewModel.h"
#import <MJExtension.h>
#import "WMUserAccoutViewModel.h"
#import "WMNetworkCell.h"
#import <SVProgressHUD.h>
#import "WMPlusPopViewController.h"
#import "WMWifiAnimatorTool.h"
#import "WMAddPskViewController.h"
#import "WMAddSmsViewController.h"
#import "WMAddWechatViewController.h"
#import "WMAddQrcodeViewController.h"

typedef NS_ENUM(NSInteger,WMNetworkType){
    WMNetworkTypeNew = 0,
    WMNetworkTypeMore = 1
};


@interface WMWifiViewController ()  <WMNetworkCellDelegate>

/**服务器地址*/
@property(nonatomic,copy) NSString *server;
/**动画代理*/
@property(nonatomic,strong) WMWifiAnimatorTool<UIViewControllerTransitioningDelegate> *animator;


#pragma mark - 数据数组
@property(nonatomic,strong) NSMutableArray *networkViewModels;
@property(nonatomic,assign) NSInteger start;

@end

@implementation WMWifiViewController

static NSString *const ID = @"cell";

#pragma mark - 懒加载

-(NSMutableArray *)networkViewModels
{
    if (_networkViewModels == nil) {
        _networkViewModels = [NSMutableArray array];
    }
    return _networkViewModels;
}

-(NSString *)server
{
    if (_server == nil) {
        //获取userAccout
        WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
        //取出server
        _server = userAccout.server;
    }
    return _server;
}

-(WMWifiAnimatorTool<UIViewControllerTransitioningDelegate> *)animator
{
    if (_animator == nil) {
        _animator = [[WMWifiAnimatorTool alloc]init];
    }
    return _animator;
}



#pragma mark - 系统回调方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 设置UI
    [self setupUI];
    
    //2 下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 设置UI
/**设置UI*/
-(void)setupUI
{
    //1 设置导航栏
    self.title = @"无线网络";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(plusButtonDidClick) image:[UIImage imageNamed:@"plus"] highImage:[UIImage imageNamed:@"plus_highlighted"] title:nil];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"WMNetworkCell" bundle:nil] forCellReuseIdentifier:ID];
    
    //6 设置其他属性 
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WMColor(86, 171, 228);
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    

}





#pragma mark - 事件监听
/**1 添加按钮被点击事件*/
-(void)plusButtonDidClick
{
    [self presentPopControllerWithAnimation];
}

/**1.1 弹出Pop控制器，带动画效果 --- 见文件夹 Pop*/
-(void)presentPopControllerWithAnimation
{
    //1 创建pop控制器
    WMPlusPopViewController *popVc = [[WMPlusPopViewController alloc]init];
    
    //2 传入block
    popVc.myBlock = ^(NSString *authName){
        [self createAddNetwork:authName];
    };
    
    //3 设置modal样式
    popVc.modalPresentationStyle = UIModalPresentationCustom;
    
    //4 设置转场动画代理
    self.animator.presentedRect = CGRectMake(WMScreenWidth - margin - 130, 66, 130, 180);
    popVc.transitioningDelegate = self.animator;
    
    //5 modal出控制器
    [self presentViewController:popVc animated:YES completion:nil];

}

/**1.2 创建添加无线网络控制器*/
-(void)createAddNetwork:(NSString *)authName
{
    UIViewController *vc = nil;
    if ([authName isEqualToString:@"PSK个人认证"])
    {
        vc = [[WMAddPskViewController alloc]init];
    }
    else if([authName isEqualToString:@"短信认证"])
    {
        vc = [[WMAddSmsViewController alloc]init];
    }
    else if([authName isEqualToString:@"微信认证"])
    {
        vc = [[WMAddWechatViewController alloc]init];
    }
    else {
        //二维码认证
        vc = [[WMAddQrcodeViewController alloc]init];
    }
    UINavigationController *nav  = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


/**2 下拉刷新事件监听*/
-(void)loadNewData
{
    [self requestForNetwork:WMNetworkTypeNew];
}

/**3 上拉加载事件监听*/
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
    [CMNetworkManager requestforNetwork:server start:self.start limit:CMNetworkLimit  competation:^(NSArray<NSDictionary *> *data, NSError *error) {
        
        if (error) {
            WMLog(@"错误");
            return;
        }
        
        //5 字典转模型
        [WMNetwork mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"Id":@"id"};
        }];
        NSArray *array = [WMNetwork mj_objectArrayWithKeyValuesArray:data];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (WMNetwork *network in array) {
            WMNetworkViewModel *viewModel = [[WMNetworkViewModel alloc]initWithNetwork:network];
            [arrayM addObject:viewModel];
        }
        
        //6 根据刷新类型，处理数据
        if (type == WMNetworkTypeNew)
        {
            // 覆盖数据
            self.networkViewModels = [NSMutableArray arrayWithArray:arrayM];
        }
        else {
            // 追加数据
            [self.networkViewModels addObjectsFromArray:arrayM];
        }
        
        //7 改变start索引
        self.start = self.networkViewModels.count;
        
        //8 刷新表格
        [self.tableView reloadData];
        
        //9 结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}



#pragma mark - UITableViewDataSource数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.networkViewModels.count == 0);
    return self.networkViewModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出cell
    WMNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 取出数据
    WMNetworkViewModel *viewModel = self.networkViewModels[indexPath.row];
    
    // 设置代理
    cell.delegate = self;
    
    // 设置数据
    cell.viewModel = viewModel;
    
    // 返回
    return cell;
}


#pragma mark - 实现WMNetworkCellDelegate
-(void)networkCell:(WMNetworkCell *)networkCell didDisableBtnClick:(UIButton *)disableButton competation:(void (^)(BOOL))competation
{
    //发起禁止WiFi操作
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"禁用后，当前在线用户将会下线" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"禁用" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //1 取出当前点击cell的viewModel
        WMNetworkViewModel *viewModel = networkCell.viewModel;
        
        //2 获取当前的WiFi的id
        NSArray *ids = @[@(viewModel.network.Id)];
        
        
        //3 发起请求
        [CMNetworkManager operationForNetwork:self.server opr:WMNetworkOperationDisable ids:ids competation:^(BOOL success) {
            if (success) {
                [SVProgressHUD successWithString:@"操作成功"];
                competation(YES);
                
            }
            else{
                [SVProgressHUD errorWithString:@"操作失败"];
                competation(NO);
            }
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        competation(NO);
    }];
    [alert addAction:delete];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

/**启用WiFi按钮被点击后的回调方法*/
-(void)networkCell:(WMNetworkCell *)networkCell didEnableBtnClick:(UIButton *)enableButton competation:(void (^)(BOOL))competation
{
    //发起启用WiFi操作
    //1 取出当前点击cell的viewModel
    WMNetworkViewModel *viewModel = networkCell.viewModel;
    
    //2 获取当前的WiFi的id
    NSArray *ids = @[@(viewModel.network.Id)];
    
    
    //3 发起请求
    [CMNetworkManager operationForNetwork:self.server opr:WMNetworkOperationEnable ids:ids competation:^(BOOL success) {
        if (success) {
            [SVProgressHUD successWithString:@"操作成功"];
            competation(YES);
        }
        else{
            [SVProgressHUD errorWithString:@"操作失败"];
            competation(NO);
        }
    }];
    
}

/**删除按钮点击后的回调方法*/
-(void)networkCell:(WMNetworkCell *)networkCell didDeleteBtnClick:(UIButton *)deleteButton competation:(void (^)(BOOL))competation
{
    //发起删除WiFi操作
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除后不可恢复，确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //1 取出当前点击cell的viewModel
        WMNetworkViewModel *viewModel = networkCell.viewModel;
        
        //2 获取当前的WiFi的id
        NSArray *ids = @[@(viewModel.network.Id)];
        
        
        //3 发起请求
        [CMNetworkManager operationForNetwork:self.server opr:WMNetworkOperationDelete ids:ids competation:^(BOOL success) {
            if (success) {
                [SVProgressHUD successWithString:@"操作成功"];
                [self.networkViewModels removeObject:viewModel];
                [self.tableView reloadData];
            }
            else{
                [SVProgressHUD errorWithString:@"操作失败"];
            }
        }];

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:delete];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


@end
