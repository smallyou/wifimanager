//
//  WMTempoVistorVC.m
//  WifiManager
//
//  Created by 陈华 on 16/9/26.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMTempoVistorVC.h"
#import "WMUserAccoutViewModel.h"
#import "CMNetworkManager.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "WMGuestAccoutModel.h"
#import "WMTempoGuestCell.h"
#import "WMAddTempoVistorVC.h"

@interface WMTempoVistorVC () <WMTempoGuestCellDelegate>

/**索引*/
@property(nonatomic,assign) NSInteger start;

/**数据数组*/
@property(nonatomic,strong) NSMutableArray *tempoUsers;

/**当前操作的cell*/
@property(nonatomic,weak) WMTempoGuestCell *selectedCell;

@end

@implementation WMTempoVistorVC

static NSString * const ID = @"cell";

-(NSMutableArray *)tempoUsers
{
    if (_tempoUsers == nil) {
        _tempoUsers = [NSMutableArray array];
    }
    return _tempoUsers;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置UI
    [self setupUI];
    
    //刷新数据
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 设置UI
-(void)setupUI
{
    //设置行高
    self.tableView.rowHeight = 64;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMTempoGuestCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    //设置刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

#pragma mark - 业务逻辑
/**刷新数据*/
-(void)loadNewData
{
   [self requestForData:WMNetworkTypeNew];
}

/**加载更多数据*/
-(void)loadMoreData
{
    [self requestForData:WMNetworkTypeMore];
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
    [CMNetworkManager requestForTempoGuest:server start:self.start limit:CMNetworkLimit competation:^(NSArray *data, NSError *error) {
        
        //5 判断错误
        if (error) {
            return;
        }
        
        //6 字典转模型
        NSArray *array = [WMGuestAccoutModel mj_objectArrayWithKeyValuesArray:data];
        
        //7 根据刷新类型，处理数据
        if (type == WMNetworkTypeNew)
        {
            // 覆盖数据
            self.tempoUsers = [NSMutableArray arrayWithArray:array];
        }
        else {
            // 追加数据
            [self.tempoUsers addObjectsFromArray:array];
        }
        
        //8 改变start索引
        self.start = self.tempoUsers.count;
        
        //9 刷新表格
        [self.tableView reloadData];
        
        //10 结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];

        
    }];
}

/**重置临时访客的密码*/
-(void)resetTempoGuest:(NSString *)password
{
    // 获取当前选中cell的模型
    WMGuestAccoutModel *accout = self.selectedCell.accout;
    
    // 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    // 获取服务器地址
    NSString *server = userAccout.server;
    
    // 重置密码
    [CMNetworkManager requestForResetTempoGuest:server Id:accout.Id pwd:password competation:^(BOOL success) {
        
        if (success) {
            [SVProgressHUD successWithString:@"重置成功"];
        }else{
            [SVProgressHUD errorWithString:@"重置失败"];
        }
        
    }];
}

/**删除指定的临时访客*/
-(void)deleteTempoGuest
{
    // 获取当前选中cell的模型
    WMGuestAccoutModel *accout = self.selectedCell.accout;
    
    // 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    // 获取服务器地址
    NSString *server = userAccout.server;
    
    // 保存模型相关位置信息
    NSUInteger index = [self.tempoUsers indexOfObject:accout];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.selectedCell];
    
    // 先删除本地的信息
    [self.tempoUsers removeObject:accout];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    // 删除
    [CMNetworkManager requestforDeleteTempoGuest:server accout:accout competation:^(BOOL success) {
        
        if (success) {
            
            [SVProgressHUD successWithString:@"成功删除..."];
            
        }else{
         
            [SVProgressHUD errorWithString:@"删除失败，正在恢复..."];
            
            //恢复
            [self.tempoUsers insertObject:accout atIndex:index];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.tempoUsers.count == 0);
    return  self.tempoUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WMTempoGuestCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.delegate = self;
    
    //取出模型
    WMGuestAccoutModel *accout = self.tempoUsers[indexPath.row];
    
    cell.accout = accout;

    
    return cell;
}

#pragma mark - WMTempoGuestCellDelegate

-(void)tempoGuestCell:(WMTempoGuestCell *)guestCell didLongPress:(UILongPressGestureRecognizer *)longPress
{
    //保存
    self.selectedCell = guestCell;
    
    //设置第一响应者
    [self becomeFirstResponder];
    
    //设置菜单item
    UIMenuItem *itemResetPwd = [[UIMenuItem alloc]initWithTitle:@"重置密码" action:@selector(resetPwd)];
//    UIMenuItem *itemDelete = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(delete)];
    UIMenuItem *itemAdd = [[UIMenuItem alloc]initWithTitle:@"新增" action:@selector(add)];
    
//    [UIMenuController sharedMenuController].menuItems = @[itemResetPwd,itemDelete,itemAdd];
    [UIMenuController sharedMenuController].menuItems = @[itemResetPwd,itemAdd];
    
    
    //设置菜单显示的位置 frame设置其位置 inView设置其所在的视图
    CGPoint point = [longPress locationInView:guestCell];
    [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(point.x, point.y, 100, 44) inView:guestCell];
    
    //将菜单控件设置为可见
    [UIMenuController sharedMenuController].menuVisible = YES;
}



//是否可以成为第一相应
-(BOOL)canBecomeFirstResponder{
    return YES;
}
//是否可以接收某些菜单的某些交互操作
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(delete) || action == @selector(resetPwd) || action == @selector(add)) {
        return YES;
    }
    return NO;
}


-(void)delete
{
    
    [self deleteTempoGuest];
    
    
}

-(void)resetPwd
{
    
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"重置密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"输入新密码...";
    }];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [vc addAction:[UIAlertAction actionWithTitle:@"重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *password = vc.textFields.firstObject.text;
        if (password.length <= 0) {
            [SVProgressHUD infoWithString:@"密码不能为空"];
            return ;
        }
        //重置密码
        [self resetTempoGuest:password];
        
    }]];
    [self presentViewController:vc animated:YES completion:nil];
    
}


-(void)add
{
    WMAddTempoVistorVC *addVc = [[WMAddTempoVistorVC alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
}

@end
