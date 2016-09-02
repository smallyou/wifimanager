//
//  WMDeviceViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMDeviceViewController.h"
#import "WMDeviceIcon.h"
#import <MJExtension.h>
#import "WMDeviceCell.h"
#import "WMUserAccoutViewModel.h"
#import "WMUserAccout.h"
#import "CMNetworkManager.h"
#import <SVProgressHUD.h>
#import <Masonry.h>
#import "WMLoginView.h"


@interface WMDeviceViewController ()

@property(nonatomic,strong) NSMutableArray *devices;
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic,strong) WMLoginView *loginView;
@property(nonatomic,weak) UILabel *customerLabel;

@end

@implementation WMDeviceViewController

static NSString * const reuseIdentifier = @"Cell";


#pragma mark - 懒加载
-(NSMutableArray *)devices
{
    if (_devices == nil) {
        
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"deviceIcon.plist" ofType:nil]];
        
        _devices = [WMDeviceIcon mj_objectArrayWithKeyValuesArray:array];
        
    }
    return _devices;
}

-(UILabel *)customerLabel
{
    if (_customerLabel == nil) {
        UILabel *label = [[UILabel alloc]init];
        [self.view addSubview:label];
        _customerLabel = label;
        label.textColor = [UIColor orangeColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13.0];
        label.hidden = YES;
        //设置约束
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(85);
        }];
    }
    return _customerLabel;
}


#pragma mark - 登录界面-懒加载
-(WMLoginView *)loginView
{
    if (_loginView == nil) {
        
        _loginView = [[NSBundle mainBundle]loadNibNamed:@"WMLoginView" owner:nil options:nil].firstObject;
        _loginView.frame = [UIScreen mainScreen].bounds;
    }
    return _loginView;
}



#pragma mark - 系统回调方法

-(void)loadView
{
    //1 获取userAccoutViewModel
    WMUserAccoutViewModel *viewModel = [WMUserAccoutViewModel shareInstance];
    
    //2 从沙盒中获取userAccout
    [viewModel getAccoutFromSandBox];
    
    //3 判断是否过期
    self.isLogin = viewModel.isLogin;
    
    //4 获取主动注销标志
    BOOL logout = viewModel.isLogout;
    
    
    self.isLogin && !logout ? [super loadView] : [self setupLoginView];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1 获取布局
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    //--计算item的尺寸
    CGFloat itemWH =( [UIScreen mainScreen].bounds.size.width - 2 * margin - 2 * margin ) / 3;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    //--设置collectionView的内边距
    self.collectionView.contentInset = UIEdgeInsetsMake(5 * margin, margin, margin, margin);
    
    //--设置背景色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    //2 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMDeviceCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    //3 刚加载的时候，设置注销按钮不可用
    self.navigationItem.leftBarButtonItem.enabled = ![WMUserAccoutViewModel shareInstance].isLogout;
    
    
    //4 加载客户名称;
    self.customerLabel.hidden = [WMUserAccoutViewModel shareInstance].isLogout;
    [self loadCustomer];
    
}

#pragma mark - 数据请求

/**加载客户名称*/
-(void)loadCustomer
{
    //1 获取userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    //2 判断当前客户名称是否为空
    if (userAccout.customer) {
        self.customerLabel.text = [NSString stringWithFormat:@"授权用户:%@",userAccout.customer];
        return ;
    }
    
    //3 发起请求获取
    [CMNetworkManager requestForCustomer:userAccout.server competation:^(NSString *customer, NSError *error) {
        if (error) {
            return ;
        }
        //3.1 设置
        self.customerLabel.text = [NSString stringWithFormat:@"授权用户:%@",customer];
        //3.2 保存
        [WMUserAccoutViewModel shareInstance].userAccout.customer = customer;
        [[WMUserAccoutViewModel shareInstance] savedUserAccoutToSandBox];
        
    }];
}




#pragma mark - 设置登录界面

-(void)setupLoginView
{
    //设置当前View为登录界面
    self.view = self.loginView;
    
    //隐藏客户名称
    self.customerLabel.hidden = YES;
    
}



#pragma mark - 实现数据源方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.devices.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.device = self.devices[indexPath.item];
    
    return cell;
}


#pragma mark - 实现代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *controller = [self.devices[indexPath.item] controller];
    Class class = NSClassFromString(controller);
    UIViewController *vc = [[class alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 事件监听

/**注销按钮点击事件*/
- (IBAction)logoutBtnClick:(UIBarButtonItem *)sender {
    
    sender.enabled = NO;
   
    //1 获取server
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //2 发起注销请求
    [CMNetworkManager logoutRequest:server competation:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"注销成功"];
            [WMUserAccoutViewModel shareInstance].logout = YES; //标记主动注销
            [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        }
        else{
            [SVProgressHUD showSuccessWithStatus:@"操作失败，请重试"];
            sender.enabled = YES;
        }
    }];
}



@end









































