//
//  WMCustomChartVC.m
//  WifiManager
//
//  Created by 陈华 on 16/10/7.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMCustomChartVC.h"
#import "WMCustomMenuModel.h"
#import "WMUserAccoutViewModel.h"
#import "CMNetworkManager.h"
#import "WMLineChart.h"
#import "WMPieChartView.h"

#import "WMPieData.h"

@interface WMCustomChartVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *chartView;
//@property(nonatomic,weak) UIView *customChartView;

@property(nonatomic,strong) NSArray *colors;

@end

@implementation WMCustomChartVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = self.customMenu.title;
    
    self.colors = @[WMGreenColor,WMRedColor,WMBlueColor,WMOrangeColor,WMLightBlueColor,WMOrangeColor];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    self.customChartView.frame = self.chartView.bounds;

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**设置横屏*/
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.transform = CGAffineTransformIdentity;
    } else if(orientation == UIInterfaceOrientationLandscapeRight) {
        self.view.transform =  CGAffineTransformIdentity;
    } else if(orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.view.transform =  CGAffineTransformIdentity;
    } else{
        self.view.transform =  CGAffineTransformMakeRotation(M_PI/2);
    }
    
}

/**页面显示完成后加载数据画图*/
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self requestForData];
    
    
    
}


/**数据请求*/
-(void)requestForData
{
    // 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    // 获取服务器地址
    NSString *server = userAccout.server;
    
    // 发起请求
    [CMNetworkManager requestForCustomFlowData:server area:nil timeType:nil menuModel:self.customMenu competation:^(id object, NSError *error) {
        
        // 判断错误
        if (error) {
            return;
        }
        
        if (![self.customMenu.opr isEqualToString:@"getStatTypePie"]) {
           
            //如果不是获取终端类型分布，返回的数据就是数组--强制转换--用来画折线图的数据
            NSArray *array = (NSArray *)object;
            
            // 创建折线图chart
            WMLineChart *lineChart = [[WMLineChart alloc]initWithFrame:CGRectMake(0, 0, self.chartView.bounds.size.width, self.chartView.bounds.size.height)];
            lineChart.yLabelBlockFormatter = ^(CGFloat y){
                
                return [NSString stringWithFormat:@"%0.0f",y];
            };
            
            
            
            // 创建模型数据
            WMChartModel *chartModel = [WMChartModel chartModelWithDatas:array colors:self.colors type:WMChartTypeLine];
            
            // 赋值
            lineChart.chartModel = chartModel;
            
            // 创建图例
            UIView *legend = [lineChart getLegendWithMaxWidth:320];
            [legend setFrame:CGRectMake(100, 0, legend.frame.size.width, legend.frame.size.height)];
            
            // 添加折线图以及图例
            [self.chartView addSubview:lineChart];
            [self.chartView addSubview:legend];
            
        }else{
         
            //如果请求的是终端类型分布，返回的数据就是字典--强制转换--用来画饼图
            NSDictionary *dict = (NSDictionary *)object;
            
            //创建模型数据
            WMChartModel *chartModel = [WMChartModel chartModelWithDatas:dict colors:self.colors type:WMChartTypePie];
            
            //创建饼图view
            NSArray *titles = @[@"累积到店终端分布图",@"接入用户终端分布图"];
            WMPieChartView *pieChartView = [[WMPieChartView alloc]initWithPieChartCount:chartModel.datas.count titles:titles];
            
            //赋值
            pieChartView.chartModel = chartModel;
            
            //添加
            pieChartView.frame = self.chartView.bounds;
            [self.chartView addSubview:pieChartView];
            
        }
    }];
}




/**退出按钮点击事件*/
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
