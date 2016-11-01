//
//  WMWechatViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMWechatViewController.h"
#import "WMBlackListCell.h"
#import "WMUserAccoutViewModel.h"
#import "CMNetworkManager.h"
#import "WMBlackListModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "WMAddBlackListViewController.h"
#import "WMApAnimatorTool.h"


@interface WMWechatViewController () <UISearchBarDelegate>

@property(nonatomic,assign) NSInteger start; //索引

@property(nonatomic,strong) NSMutableArray *blackLists;

@property(nonatomic,weak) UISearchBar *searchBar;

@property(nonatomic,strong) WMApAnimatorTool *animatorTool; //动画代理

@property(nonatomic,weak) UILabel *tipsLabel; //提示标签


@end

@implementation WMWechatViewController

static NSString * const ID = @"cell";

-(NSMutableArray *)blackLists
{
    if (_blackLists == nil) {
        _blackLists = [NSMutableArray array];
    }
    return _blackLists;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
   //设置UI
    [self setupUI];
    
    
    [self loadNewData];
    
    
}


#pragma mark - 设置UI
-(void)setupUI
{
    //设置title
    self.title = @"黑名单";
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMBlackListCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    //设置cell高度
    self.tableView.rowHeight = 127;
    
    //设置刷新
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"" forState:MJRefreshStateIdle];
    [header setTitle:@"" forState:MJRefreshStatePulling];
    [header setTitle:@"" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;

    MJRefreshAutoNormalFooter *footer =  [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
    
    
    //设置搜索
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"搜索mac地址";
    searchBar.cm_height = 44;
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    self.searchBar = searchBar;
    
    //设置新增按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(addBlackList) image:[UIImage imageNamed:@"plus"] highImage:[UIImage imageNamed:@"plus_highlighted"] title:nil];
    
    
    //提示标签
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"暂无数据";
    label.font = [UIFont systemFontOfSize:15.0];
    [self.tableView addSubview:label];
    self.tipsLabel = label;
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tipsLabel.frame =  CGRectMake(0, CMNavigationBarMaxY, self.view.bounds.size.width, 44);
}



#pragma mark - 数据请求
/**下拉刷新*/
-(void)loadNewData
{
    [self requestForNetwork:WMNetworkTypeNew];
}

/**上拉加载*/
-(void)loadMoreData
{
    [self requestForNetwork:WMNetworkTypeMore];
}

/**新增按钮点击*/
-(void)addBlackList
{
    WMAddBlackListViewController *addVc = [[WMAddBlackListViewController alloc]init];
    addVc.modalPresentationStyle = UIModalPresentationCustom;
    WMApAnimatorTool *animator = [[WMApAnimatorTool alloc]init];
    addVc.transitioningDelegate = animator;
    self.animatorTool = animator;
    self.animatorTool.presentedRect = [UIScreen mainScreen].bounds;
    addVc.confirmBtnBlock= ^(WMBlackListModel *blackList){
    
        [self requestForOperateBlackList:WMBlackListOperationAdd blackModel:blackList indexPath:nil];
    
    };
    [self presentViewController:addVc animated:YES completion:nil];

}

/**获取黑名单列表*/
-(void)requestForNetwork:(WMNetworkType)type
{

    //服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //如果是下拉刷新，start=0
    if (type == WMNetworkTypeNew) self.start = 0;

    //发起请求
    [CMNetworkManager requestForBlackList:server search:self.searchBar.text start:self.start limit:CMNetworkLimit competation:^(NSArray *array, NSError *error) {
       
        if (error) {
            return;
        }

        //字典转模型
        NSArray *arrayM = [WMBlackListModel mj_objectArrayWithKeyValuesArray:array];
        
        //6 根据刷新类型，处理数据
        if (type == WMNetworkTypeNew)
        {
            // 覆盖数据
            self.blackLists = [NSMutableArray arrayWithArray:arrayM];
        }
        else {
            // 追加数据
            [self.blackLists addObjectsFromArray:arrayM];
        }

        //改变索引
        self.start = self.blackLists.count;
        
        //刷新表格
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

/**操作黑名单*/
-(void)requestForOperateBlackList:(WMBlackListOperation)opr blackModel:(WMBlackListModel *)blackList indexPath:(NSIndexPath *)indexPath
{
    //服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //发起请求
    [CMNetworkManager requestForOperateBlackList:server opr:opr blackList:blackList competation:^(BOOL success) {
       
        if (success) {
         
            [SVProgressHUD successWithString:@"操作成功"];
            [self.tableView.mj_header beginRefreshing];
            
        }else{
            [SVProgressHUD errorWithString:@"操作失败，请重试"];
            //删除失败，回滚
            [self.blackLists insertObject:blackList atIndex:indexPath.row];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}



#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tipsLabel.hidden = !(self.blackLists.count == 0);
    self.tableView.mj_footer.hidden = (self.blackLists.count == 0);
    return self.blackLists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WMBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    WMBlackListModel *blackList = self.blackLists[indexPath.row];
    
    cell.blackList = blackList;
  
    return cell;
}

#pragma mark - UITableDelegate
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //获取当前的model
        WMBlackListModel *blackList = self.blackLists[indexPath.row];
        
        //移除并刷新
        [self.blackLists removeObject:blackList];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //发起请求
        [self requestForOperateBlackList:WMBlackListOperationDelete blackModel:blackList indexPath:indexPath];
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}



#pragma mark - UISearchBarDelegate
/**点击搜索按钮后的方法*/
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    //搜索
    [self requestForNetwork:WMNetworkTypeNew];
    
    //取消键盘
    [self.view endEditing:YES];
    
}





@end
