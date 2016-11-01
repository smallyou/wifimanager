
//
//  WMAdViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAdViewController.h"
#import "WMAdSummayCell.h"
#import "WMUserAccoutViewModel.h"
#import "CMNetworkManager.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "WMSummaryInfoModel.h"
#import "WMAdFlowTrendViewController.h"

@interface WMAdViewController ()

@property(nonatomic,strong) NSMutableArray *summaryDatas;

@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,strong) NSArray *titleKeys;



@end

@implementation WMAdViewController

static NSString * const ID = @"cell";
static NSInteger const count = 2;

-(NSMutableArray *)summaryDatas
{
    if (_summaryDatas == nil) {
        _summaryDatas = [[NSMutableArray alloc]init];
        
        //赋初值
        for (NSString *title in self.titles) {
             WMDetailsInfoModel *detail = [[WMDetailsInfoModel alloc]init];
            detail.total = @"-";
            detail.lastMonth = @"-";
            detail.lastWeek = @"-";
            detail.lastDay = @"-";
            detail.title = title;
            detail.titleKey = self.titleKeys[_summaryDatas.count];
            [_summaryDatas addObject:detail];
        }
    }
    return _summaryDatas;
}





-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((WMScreenWidth - (count + 1) * margin) / count , (WMScreenWidth - (count + 1) * margin) / count);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    //设置UI
    [self setupUI];
    
    //设置数据
    self.titles = @[@"所有推广",@"终端出现",@"首次接入",@"在线时长",@"搜索行为",@"应用访问"];
    self.titleKeys = @[@"total",@"known",@"unknown",@"online",@"keyword",@"appaccess"];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //发起请求
    [self requestForData];
    
}


#pragma mark - 设置UI
-(void)setupUI
{
    self.title = @"推广统计";
    
    //刷新按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(loadNewData) title:@"刷新" selectedTitle:nil];
    
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WMAdSummayCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    //设置其他属性
    self.collectionView.backgroundColor = WMColor(86, 171, 228);
    self.collectionView.contentInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    self.collectionView.contentSize = CGSizeMake(0, self.collectionView.contentSize.height);
}

#pragma mark - 事件监听
-(void)loadNewData
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self requestForData];
}


#pragma mark - 数据请求

-(void)requestForData
{
    // 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    // 获取服务器地址
    NSString *server = userAccout.server;
    
    // 发起请求
    [CMNetworkManager requestForAdSummaryData:server competation:^(NSDictionary *dict, NSError *error) {
       
        //判断错误
        if (error) {
            
            return;
        }
        
        //字典转模型
        WMSummaryInfoModel *summaryInfo = [WMSummaryInfoModel mj_objectWithKeyValues:dict];
        
        //将模型属性转换成数组，并赋值
        self.summaryDatas = [summaryInfo arrayWithTitles:self.titles keys:self.titleKeys ];

        
        //刷新
        [self.collectionView reloadData];
        
        //结束刷新
        [SVProgressHUD dismiss];
        
    }];
}


#pragma mark - Table view data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.summaryDatas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMAdSummayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //取出数据
    WMDetailsInfoModel *detailsInfo = self.summaryDatas[indexPath.item];
    
    //赋值
    cell.detailsInfo = detailsInfo;
    
    
    return cell;
}


#pragma  mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMAdFlowTrendViewController *trendAc = [[WMAdFlowTrendViewController alloc]init];
    trendAc.detailsInfo = self.summaryDatas[indexPath.item];
    [self.navigationController pushViewController:trendAc animated:YES];
    
}


@end
