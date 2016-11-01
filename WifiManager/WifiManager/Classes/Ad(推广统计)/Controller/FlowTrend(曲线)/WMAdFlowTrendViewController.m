//
//  WMAdFlowTrendViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAdFlowTrendViewController.h"
#import "WMDetailsInfoModel.h"
#import "WMFlowTrendCell.h"
#import "WMFlowTrendGroupItem.h"
#import "WMFlowTrendCellItem.h"
#import "WMFlowTrendAccessoryCellItem.h"
#import "WMFlowTrendChartCellItem.h"
#import "WMAdPopViewController.h"
#import "WMAdPopModel.h"
#import "WMApAnimatorTool.h"
#import "CMNetworkManager.h"
#import "WMUserAccoutViewModel.h"
#import "CMDateAndTimeTool.h"
#import "WMLineChart.h"


@interface WMAdFlowTrendViewController ()

/**用来定义cell样式的数据*/
@property(nonatomic,strong) NSMutableArray *cellItems;

@property(nonatomic,strong) WMApAnimatorTool *animatorTool;

@property(nonatomic,strong) NSArray *colors;

@property(nonatomic,strong) NSMutableDictionary *currentResult; //保存当前选择的条件

@property(nonatomic,strong) WMFlowTrendChartCellItem *chartCellItem; //曲线图cell的数据模型--用来保存

@end

@implementation WMAdFlowTrendViewController

static NSString * const WMAdTimeRange = @"时间范围";
static NSString * const WMAdPushRule = @"推送规则";
static NSString * const WMAdWechatPub = @"微信公众平台";



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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self sendRequest];
}


#pragma mark -设置UI
/**设置UI*/
-(void)setupUI
{
    //设置title
    self.title = self.detailsInfo.title;
    
    //设置其他
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WMColor(86, 171, 228);
    self.tableView.scrollEnabled = NO;
    
}


#pragma mark - 数据处理
/**获取cell的显示样式的数据*/
-(void)getCellDisplayData
{
    __weak typeof(self) weakSelf = self;
    
    //定义block
    void(^optionBlock)(WMFlowTrendCellItem *,NSIndexPath *) = ^(WMFlowTrendCellItem *cellItem,NSIndexPath *indexPath){
        
        WMAdPopViewController *adPop = [[WMAdPopViewController alloc]init];
        adPop.title = self.detailsInfo.titleKey; //通过title,传值过去 方便一点
        adPop.modalPresentationStyle = UIModalPresentationCustom;
        adPop.cellItem = cellItem;
        adPop.confirmBtnClick = ^(WMAdPopModel *popModel){
            
            //修改模型，在条件选择控制器中选中的选项，此处赋值
            if (popModel.name) {
                cellItem.leftDetail = popModel.name;
                if ([cellItem.title isEqualToString:WMAdTimeRange]) {
                    self.chartCellItem.title = [NSString stringWithFormat:@"%@ %@推广统计",self.detailsInfo.title,cellItem.leftDetail];
                }
            }
            //刷新当前行
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //根据当前选择，修改选中的条件，发送网络请求获取折线图数据
            self.currentResult[cellItem.title] = popModel;
            [self sendRequest];
            
        
        };
        WMApAnimatorTool *animator = [[WMApAnimatorTool alloc]init];
        adPop.transitioningDelegate = animator;
        self.animatorTool = animator;
        self.animatorTool.presentedRect = [UIScreen mainScreen].bounds;
        [weakSelf presentViewController:adPop animated:YES completion:nil];
    };
    
    //第0组
    WMFlowTrendAccessoryCellItem *item01 = [WMFlowTrendAccessoryCellItem cellItemWithTitle:WMAdTimeRange leftDetail:@"最近7天" image:nil];
    item01.separtorType = WMSepartorTypeShort;
    WMAdPopModel *pop011 = [[WMAdPopModel alloc]init];
    pop011.name = @"最近7天";
    pop011.selected = YES;
    WMAdPopModel *pop012 = [[WMAdPopModel alloc]init];
    pop012.name = @"最近15天";
    item01.childMenus = @[pop011,pop012];
    item01.option = optionBlock;
   
    
    WMFlowTrendAccessoryCellItem *item02 = [WMFlowTrendAccessoryCellItem cellItemWithTitle:WMAdPushRule leftDetail:@"全部" image:nil];
    item02.separtorType = WMSepartorTypeShort;
    item02.option = optionBlock;
    WMAdPopModel *pop021 = [[WMAdPopModel alloc]init];
    pop021.name = @"全部";
    pop021.Id = @"all";
    pop021.push = @{@"portal_enable":@(YES),@"sms_enable":@(YES),@"wexin_enable":@(YES)};
    pop021.selected = YES;
    item02.childMenus = @[pop021];
    
    WMFlowTrendAccessoryCellItem *item03 = [WMFlowTrendAccessoryCellItem cellItemWithTitle:WMAdWechatPub leftDetail:@"全部" image:nil];
    item03.separtorType = WMSepartorTypeLong;
    item03.option = optionBlock;
    WMAdPopModel *pop031 = [[WMAdPopModel alloc]init];
    pop031.name = @"全部";
    pop031.Id = @"all";
    pop031.selected = YES;
    item03.childMenus = @[pop031];
    
    WMFlowTrendGroupItem *group0 = [WMFlowTrendGroupItem groupWithHeader:nil footer:nil cells:@[item01,item02,item03]];
    
    
    WMFlowTrendChartCellItem *item11 = [[WMFlowTrendChartCellItem alloc]init];
    item11.title = [NSString stringWithFormat:@"%@ %@推广统计",self.detailsInfo.title,pop011.name];
    item11.separtorType = WMSepartorTypeNone;
    self.chartCellItem = item11;
    WMFlowTrendGroupItem *group1 = [WMFlowTrendGroupItem groupWithHeader:nil footer:nil cells:@[item11]];
    
    
    [self.cellItems addObject:group0];
    [self.cellItems addObject:group1];
    
    
    //保存当前的默认选择条件:
    self.currentResult[WMAdTimeRange] = pop011;
    self.currentResult[WMAdPushRule] = pop021;
    self.currentResult[WMAdWechatPub] = pop031;
    
}


#pragma mark - 业务逻辑及事件处理
/**根据当前的选择条件，发送网络请求*/
-(void)sendRequest
{
    WMAdPopModel *timePop = self.currentResult[WMAdTimeRange];
    __block const NSString *timeRange = @"";
    NSMutableDictionary *baseTime = [NSMutableDictionary dictionary];
    
    //定义处理参数的block ，处理条件
    void(^handleParameter)(NSInteger,NSString *) = ^(NSInteger day,NSString *range){
        
        timeRange = range;
        
        //当前的时间
        NSDate *now = [NSDate new];
        NSTimeInterval endTimeInterval = [CMDateAndTimeTool timeIntervalIgnorTimeWithDate:now];
        
        //30天前
        NSTimeInterval startTimeInterval = endTimeInterval -  (day-1) * 24 * 60 * 60;
        
        baseTime[CMAdBaseTimeStart] = @(startTimeInterval);
        baseTime[CMAdBaseTimeEnd] = @(endTimeInterval);
    
    };

    //根据条件，调用对应的block
    [timePop.name isEqualToString:@"最近7天"]?handleParameter(7,@"lastWeek"):handleParameter(15,@"lastMonth");
    
    [self requestForData:baseTime timeRange:timeRange];
    
}

#pragma mark - 数据请求
-(void)requestForData:(NSDictionary *)baseTime timeRange:(const NSString *)timeRange
{
    //获取服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //发起请求
    [CMNetworkManager requestForAdFlowTrend:server baseTime:baseTime flowType:self.detailsInfo.titleKey plat:self.currentResult[WMAdWechatPub] rule:self.currentResult[WMAdPushRule] timeRange:timeRange competation:^(NSArray * _Nullable array, NSError * _Nullable error) {
        
        //判断错误
        if(error)
        {
            return ;
        }
        
        // 创建模型数据
        WMChartModel *chartModel = [WMChartModel chartModelWithDatas:array colors:self.colors type:WMChartTypeLine];
        
        // 赋值
        self.chartCellItem.chartModel = chartModel;
        
        //刷新表格
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
    }
    
    cell.item = [self.cellItems[indexPath.section] cells][indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMFlowTrendCellItem *item =  [self.cellItems[indexPath.section] cells][indexPath.row];
    if ([item isKindOfClass:[WMFlowTrendChartCellItem class]]) {
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
    
    if([self.detailsInfo.title isEqualToString:@"所有推广"] && ![item.title isEqualToString:WMAdTimeRange])
    {        
        return;
    }

    if (item.option) {
        item.option(item,indexPath);
    }
    
}


@end
