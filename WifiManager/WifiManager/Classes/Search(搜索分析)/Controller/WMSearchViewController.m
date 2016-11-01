//
//  WMSearchViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMSearchViewController.h"
#import "WMApAnimatorTool.h"
#import "WMAdPopViewController.h"
#import "WMAdPopModel.h"
#import "WMFlowTrendCellItem.h"
#import "WMFlowTrendChartCellItem.h"
#import "WMAdSummayCell.h"
#import "WMFlowTrendAccessoryCellItem.h"
#import "WMFlowTrendGroupItem.h"
#import "WMFlowTrendCell.h"
#import "WMFlowTrendBarChartCellItem.h"
#import "WMUserAccoutViewModel.h"
#import "CMNetworkManager.h"

@interface WMSearchViewController ()


/**用来定义cell样式的数据*/
@property(nonatomic,strong) NSMutableArray *cellItems;

@property(nonatomic,strong) WMApAnimatorTool *animatorTool;

@property(nonatomic,strong) NSArray *colors;

@property(nonatomic,strong) NSMutableDictionary *currentResult; //保存当前选择的条件

@property(nonatomic,strong) WMFlowTrendBarChartCellItem *chartCellItem; //曲线图cell的数据模型--用来保存


@end

@implementation WMSearchViewController

static NSString * const WMAdTimeRange = @"时间范围";
static NSString * const WMAdChartType = @"图表类型";


-(NSMutableArray *)cellItems
{
    if (_cellItems == nil) {
        _cellItems = [NSMutableArray array];
    }
    return _cellItems;
}


-(NSMutableDictionary *)currentResult
{
    if (_currentResult == nil) {
        _currentResult = [NSMutableDictionary dictionary];
    }
    return _currentResult;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置UI
    [self setupUI];
    
    //获取cell的样式数据
    [self getCellDisplayData];
    
    self.colors = @[WMGreenColor,WMRedColor,WMBlueColor,WMOrangeColor,WMLightBlueColor,WMOrangeColor];
    
}


#pragma mark -设置UI
/**设置UI*/
-(void)setupUI
{
    //设置title
    self.title = @"搜索分析";
    
    //设置其他
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WMColor(86, 171, 228);
    self.tableView.scrollEnabled = NO;
    
}


#pragma mark - 业务逻辑处理

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //第一次发起请求，根据当前条件选择框中的选项记录
    [self sendRequest];
}

-(void)sendRequest
{
    NSString *time_type = @"last7day";
    WMAdPopModel *timePop = self.currentResult[WMAdTimeRange];
    if (![timePop.name isEqualToString:@"最近7天"]) {
        time_type = @"last30day";
    }
    
    NSString *opr = @"getKeywordRank";
    WMAdPopModel *oprModel = self.currentResult[WMAdChartType];
    if ([oprModel.name isEqualToString:@"关键字分组"]) {
        opr = @"getKSortRank";
    }else if ([oprModel.name isEqualToString:@"搜索来源"])
    {
        opr = @"sourceRank";
    }
    
    [self requestForData:time_type opr:opr];
    
}



#pragma mark - 数据处理
/**获取cell的显示样式的数据*/
-(void)getCellDisplayData
{
    __weak typeof(self) weakSelf = self;
    void(^optionBlock)(id,id) = ^(WMFlowTrendCellItem *cellItem , NSIndexPath *indexPath){
        
        WMAdPopViewController *adPop = [[WMAdPopViewController alloc]init];
        adPop.modalPresentationStyle = UIModalPresentationCustom;
        adPop.cellItem = cellItem;
        WMApAnimatorTool *animator = [[WMApAnimatorTool alloc]init];
        adPop.transitioningDelegate = animator;
        self.animatorTool = animator;
        self.animatorTool.presentedRect = [UIScreen mainScreen].bounds;
        [weakSelf presentViewController:adPop animated:YES completion:nil];
        
        /**在Popover中点击确定按钮后的回调block*/
        adPop.confirmBtnClick = ^(WMAdPopModel *popModel){
            
            if (popModel.name) {
                cellItem.leftDetail = popModel.name;
            }
            
            //刷新当前行
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //根据当前选择，修改选中的条件，发送网络请求获取折线图数据
            self.currentResult[cellItem.title] = popModel;
            [self sendRequest];
        
        };
    };
    
    
    
    /**定义第一组数据*/
    WMFlowTrendAccessoryCellItem *item00 = [WMFlowTrendAccessoryCellItem cellItemWithTitle:WMAdTimeRange leftDetail:@"最近7天" image:nil];
    WMAdPopModel *pop001 = [[WMAdPopModel alloc]init];
    pop001.name = @"最近7天";
    pop001.selected = YES;
    WMAdPopModel *pop002 = [[WMAdPopModel alloc]init];
    pop002.name = @"最近30天";
    item00.childMenus = @[pop001,pop002];
    item00.separtorType = WMSepartorTypeShort;
    item00.option = optionBlock;
    
    
    WMFlowTrendAccessoryCellItem *item01 = [WMFlowTrendAccessoryCellItem cellItemWithTitle:WMAdChartType leftDetail:@"搜索关键字" image:nil];
    WMAdPopModel *pop011 = [[WMAdPopModel alloc]init];
    pop011.name = @"搜索关键字";
    pop011.selected = YES;
    WMAdPopModel *pop012 = [[WMAdPopModel alloc]init];
    pop012.name = @"关键字组";
    WMAdPopModel *pop013 = [[WMAdPopModel alloc]init];
    pop013.name = @"搜索来源";
    item01.childMenus = @[pop011,pop012,pop013];
    item01.separtorType = WMSepartorTypeLong;
    item01.option = optionBlock;
    
    
    
    WMFlowTrendGroupItem *item0 = [WMFlowTrendGroupItem groupWithHeader:nil footer:nil cells:@[item00,item01]];
    
    
    /**定义第二组数据*/
    WMFlowTrendBarChartCellItem *item10 = [WMFlowTrendBarChartCellItem cellItemWithTitle:nil leftDetail:nil image:nil];
    WMFlowTrendGroupItem *item1 = [WMFlowTrendGroupItem groupWithHeader:nil footer:nil cells:@[item10]];
    
    
    [self.cellItems addObjectsFromArray:@[item0,item1]];
    
    //保存信息
    self.currentResult[WMAdTimeRange] = pop001;
    self.currentResult[WMAdChartType] = pop011;
    self.chartCellItem = item10;
    
    
}

/**发起网络请求*/
-(void)requestForData:(NSString *)time_type opr:(NSString *)opr
{
    //获取服务器的地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //发起网络请求
    [CMNetworkManager requestForSearchWordRank:server time_type:time_type opr:opr competation:^(NSArray *array, NSError * error) {
       
        //处理获取的数据
        NSArray *counts = [array valueForKeyPath:@"count"];
        NSArray *cols = [array valueForKeyPath:@"col"];
        WMChartModel *chartModel = [[WMChartModel alloc]init];
        if (counts.count && cols.count) {
            chartModel.datas = counts;
            chartModel.xData = cols;
            
        }
        self.chartCellItem.chartModel = chartModel;
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellItems.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellItems[section] cells].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    WMFlowTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WMFlowTrendCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    cell.item = [self.cellItems[indexPath.section] cells][indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMFlowTrendCellItem *item =  [self.cellItems[indexPath.section] cells][indexPath.row];
    if ([item isKindOfClass:[WMFlowTrendBarChartCellItem class]]) {
        return WMScreenHeight - (indexPath.row + 1) * 44 - (indexPath.section + 1) * 20;
    }
    return 44;
}



#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取出模型
    WMFlowTrendGroupItem *group = self.cellItems[indexPath.section];
    WMFlowTrendCellItem *item = group.cells[indexPath.row];
    
    if (item.option) {
        item.option(item,indexPath);
    }
    
}




@end
