//
//  WMDetailsLocalAccoutVC.m
//  WifiManager
//
//  Created by 陈华 on 16/9/26.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMDetailsLocalAccoutVC.h"
#import "CMNetworkManager.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WMUserAccoutViewModel.h"
#import "WMDetailsLocalAccoutCell.h"


@interface WMDetailsLocalAccoutVC () <WMDetailsLocalAccoutCellDelegate>

/**用户数组*/
@property(nonatomic,strong) NSMutableArray *localUsers;

/**索引*/
@property(nonatomic,assign) NSInteger start;
@property(nonatomic,weak) UILabel *tipsLabel;

@end

@implementation WMDetailsLocalAccoutVC

static NSString * const ID = @"cell";
static NSInteger const count = 2;

#pragma mark - 懒加载
-(NSMutableArray *)localUsers
{
    if (_localUsers == nil) {
        _localUsers = [NSMutableArray array];
    }
    return _localUsers;
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
    
    
    /**设置UI*/
    [self setupUI];
    
    /**加载数据*/
    [self loadNewData];

    
}

/**设置UI*/
-(void)setupUI
{
    //设置导航栏
    self.title = self.group.name;
    UIBarButtonItem *editBtn = [UIBarButtonItem itemWithTarget:self action:@selector(editState:) title:@"删除" selectedTitle:@"取消"];
//    UIBarButtonItem *plusBtn = [UIBarButtonItem itemWithTarget:self action:@selector(addLocalUser) image:[UIImage imageNamed:@"plus"] highImage:[UIImage imageNamed:@"plus_highlighted"] title:nil];
//    self.navigationItem.rightBarButtonItems = @[plusBtn,editBtn];
    self.navigationItem.rightBarButtonItem = editBtn;
    
    //设置刷新控件
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle]; //设置文字状态为空
    self.collectionView.mj_footer = footer;
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WMDetailsLocalAccoutCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    //设置其他属性
    self.collectionView.backgroundColor = WMColor(86, 171, 228);
    self.collectionView.contentInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    
    //提示
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"暂无数据";
    label.font = [UIFont systemFontOfSize:15.0];
    label.hidden = YES;
    [self.view addSubview:label];
    self.tipsLabel = label;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tipsLabel.frame = CGRectMake(0, CMNavigationBarMaxY, self.view.bounds.size.width, 44);
}


#pragma mark - 事件监听
/**刷新数据*/
-(void)loadNewData
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self requestForData:WMNetworkTypeNew];
}

/**加载更多*/
-(void)loadMoreData
{
    [self requestForData:WMNetworkTypeMore];
}

/**使进入编辑状态*/
-(void)editState:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        
        //让所有的cell进入编辑状态
        for (WMGroupAccoutModel *accout in self.localUsers) {
            accout.edit = YES;
        }
        
    }else{
        //让所有的cell退出编辑状态
        for (WMGroupAccoutModel *accout in self.localUsers) {
            accout.edit = NO;
        }
    }
    //刷新collectionView
    [self.collectionView reloadData];
}


/**新增本地用户*/
-(void)addLocalUser
{
    
}



#pragma mark - 数据请求
/**请求数据*/
-(void)requestForData:(WMNetworkType)type
{
    //1 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    //2 获取服务器地址
    NSString *server = userAccout.server;
    
    //3 如果是下拉刷新，start=0
    if (type == WMNetworkTypeNew) self.start = 0;
    
    //4 请求数据
    [CMNetworkManager requestForLocalUserAndGroup:server sortId:self.group.Id start:self.start limit:CMNetworkLimit competation:^(NSArray *data, NSError *error) {
       
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
            self.localUsers = [NSMutableArray arrayWithArray:array];
        }
        else {
            // 追加数据
            [self.localUsers addObjectsFromArray:array];
        }
        
        //8 改变start索引
        self.start = self.localUsers.count;
        
        //9 刷新表格
        [self.collectionView reloadData];
        
        //10 结束刷新
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

/**删除本地用户*/
-(void)removeLocalAccout:(WMGroupAccoutModel *)accout indexPath:(NSIndexPath *)indexPath
{
    //1 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    //2 获取服务器地址
    NSString *server = userAccout.server;
    
    //3 先删除本地
    NSUInteger index = [self.localUsers indexOfObject:accout];
    [self.localUsers removeObject:accout];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    //4 发起请求
    [CMNetworkManager requestForDeleteLocalAccout:server accout:accout competation:^(BOOL success) {
        //如果不成功，恢复
        if (!success) {
         
            [self.localUsers insertObject:accout atIndex:index];
            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        }
    }];
}



#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.tipsLabel.hidden = !(self.localUsers.count == 0);
    return self.localUsers.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     WMDetailsLocalAccoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //设置代理
    cell.delegate = self;
    
    
    //取出模型
    WMGroupAccoutModel *accout = self.localUsers[indexPath.row];
    
    //赋值
    cell.accout = accout;
    
    return  cell;
}
 

#pragma mark - WMDetailsLocalAccoutCellDelegate
-(void)detailsLocalAccoutCell:(WMDetailsLocalAccoutCell *)accoutCell didRemoveBtnClick:(UIButton *)button
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除当前用户?" preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        // 获取indexPath
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:accoutCell];
        
        // 获取模型
        WMGroupAccoutModel *accout = accoutCell.accout;
        
        // 删除本地用户
        [self removeLocalAccout:accout indexPath:indexPath];
        
    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:vc animated:YES completion:nil];
}



@end
