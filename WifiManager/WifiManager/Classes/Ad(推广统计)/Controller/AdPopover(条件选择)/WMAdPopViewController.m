//
//  WMAdPopViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAdPopViewController.h"
#import "WMFlowTrendCellItem.h"
#import "WMAdPopCell.h"
#import "WMAdPopModel.h"
#import "CMNetworkManager.h"
#import "WMUserAccoutViewModel.h"
#import <MJExtension.h>


@interface WMAdPopViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;



@property(nonatomic,strong) NSMutableArray *datas;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) WMAdPopModel *lastSelectedPopModel; //上一个选中的模型

@end

@implementation WMAdPopViewController

static NSString *const ID = @"cell";

-(NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self setupUI];
    
    
    
}



#pragma mark - 设置UI
-(void)setupUI
{
    //设置圆角
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    //设置标题
    self.titleLabel.text = self.cellItem.title;
    
    //根据模型类型，确定tableView的内容
    [self contentOfTableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMAdPopCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

/**根据模型类型，确定点击 时间周期 后 tableView的内容*/
-(void)contentOfTableView
{
    if(self.cellItem.childMenus.count)
    {
        //说明直接传过来tableView的数据源，说明是时间周期
        self.datas  = [NSMutableArray arrayWithArray:self.cellItem.childMenus];
        
    }
        
}

/**在完全显示后，如果不是 时间周期，需要联网加载 tableView的数据源*/
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.cellItem.title isEqualToString:@"推送规则"]) {
     
        //联网请求 当前的 推送规则
        [self requestForRules];
        
        
    }
    else if([self.cellItem.title isEqualToString:@"微信公众平台"]) {
        
        //联网请求 当前的 微信公众平台
        [self requestForWechatPub];
        
        
    }
}


#pragma mark - 事件监听

/**取消按钮被点击事件*/
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/**确定按钮被点击事件*/
- (IBAction)confirmBtnClick:(UIButton *)sender {
    
    if (self.confirmBtnClick) {
        self.confirmBtnClick(self.lastSelectedPopModel);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 数据请求

/**请求推送规则条目*/
-(void)requestForRules
{
    [self requestForData:WMAdQueryTypePushRule];
    [self.activityIndicator startAnimating];
}

/**请求微信公众平台条目*/
-(void)requestForWechatPub
{
    [self requestForData:WMAdQueryTypeWechatPub];
    [self.activityIndicator startAnimating];
}

/**发起请求，并解析*/
-(void)requestForData:(WMAdQueryType)queryType
{
    //服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //当前控制器的title作为查询的条件
    NSString *type = self.title; //通过self.title传过来的，方便一些
    
    [CMNetworkManager requestForAdPushRuleOrWechatPub:server oprType:queryType type:type competation:^(NSArray *array, NSError *error) {
        
        //判断错误
        if (error) {
            [SVProgressHUD errorWithString:@"加载失败，请重试"];
            return ;
        }
        
        //字典转模型
        NSArray *arrayM = [WMAdPopModel mj_objectArrayWithKeyValuesArray:array];
        if (arrayM == 0) {
            return;
        }
        //默认第一个为选中状态
        WMAdPopModel *popModel = arrayM.firstObject;
        popModel.selected = YES;
        
        
        //赋值
        self.datas = [NSMutableArray arrayWithArray:arrayM];
        
        //刷新表格
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    }];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    WMAdPopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    WMAdPopModel *popModel = self.datas[indexPath.row];

    if (popModel.selected) {
        self.lastSelectedPopModel = popModel;
    }
    
    cell.popModel = popModel;

    
    return cell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //将上一个选中的模型，标记成未选中
    self.lastSelectedPopModel.selected = NO;
    
    //取出当前选中的模型,标记为选中
    WMAdPopModel *currentModel = self.datas[indexPath.row];
    currentModel.selected = YES;
    
    //记录当前选中的模型
    self.lastSelectedPopModel = currentModel;

    //刷新表格
    [self.tableView reloadData];
}


@end
