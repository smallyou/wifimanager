//
//  WMPieChartView.m
//  WifiManager
//
//  Created by 陈华 on 16/10/11.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMPieChartView.h"
#import "WMPieChart.h"
#import "WMChartModel.h"
#import "WMPieData.h"

@interface WMPieChartView () <PNChartDelegate>


@property(nonatomic,strong) NSMutableArray<WMPieChart *> *pieCharts;
@property(nonatomic,strong) NSMutableArray<UILabel *> *titleLabels;
@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,weak) UIView *legend;
@property(nonatomic,weak) UIView *legendContent;
@property(nonatomic,strong) UILabel *tipsLabel;

@end


@implementation WMPieChartView

-(UILabel *)tipsLabel
{
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        _tipsLabel.font = [UIFont systemFontOfSize:12.0];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}


-(NSMutableArray<WMPieChart *> *)pieCharts
{
    if (_pieCharts == nil) {
        _pieCharts = [NSMutableArray array];
    }
    return _pieCharts;
}

-(NSMutableArray<UILabel *> *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}



-(instancetype)initWithPieChartCount:(NSInteger)count titles:(NSArray *)titles
{
    if (self = [super init]) {
        
        //根据模型个数初始化
        for (int i = 0; i < count; i++) {
         
            //创建饼图
            WMPieChart *pieChart = [[WMPieChart alloc] init];
            pieChart.legendStyle = PNLegendItemStyleStacked;
            pieChart.legendFont = [UIFont systemFontOfSize:12.0];
            pieChart.delegate = self;
            
            //创建图表标题
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:13.0];
            
            //添加子控件
            [self addSubview:pieChart];
            [self addSubview:titleLabel];
            
            //添加元素
            [self.pieCharts addObject:pieChart];
            [self.titleLabels addObject:titleLabel];
            
        }
        //创建图例
        UIView *legend = [[UIView alloc]init];
        self.legend = legend;
        [self addSubview:legend];
        
        //初始化title的数组
        self.titles = titles;
    }
    return self;
}


-(void)setChartModel:(WMChartModel *)chartModel
{
    _chartModel = chartModel;
    
    
    for (int i = 0;i< chartModel.datas.count; i++) {
        NSArray *array = chartModel.datas[i];
        NSMutableArray *items = [NSMutableArray array];
        for (WMPieData *pieData in array) {
            
            PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:[pieData.value floatValue] color:pieData.color description:pieData.desc];
            [items addObject:item];
        }
        
        
        //设置图表数据
        [self.pieCharts[i] updateChartData:items];
        
        //渲染饼图
        [self.pieCharts[i] strokeChart];
        
        //设置标题
        self.titleLabels[i].text = self.titles[i];
        
        
    }
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.chartModel.datas.count;
    
    CGFloat titleHeight = 20;
    CGFloat marginH = 20; //水平间距
    CGFloat marginV = 20; //垂直间距
    CGFloat width = ( self.frame.size.width - marginH * (count + 1 + 1) ) / (count + 1);
    CGFloat height = self.frame.size.height - marginV * 3 - titleHeight;
    CGFloat wh = width < height?width:height;
    
    for (int i = 0;i< count; i++) {
    
        WMPieChart *pieChart = self.pieCharts[i];
        UILabel *titleLabel = self.titleLabels[i];
        
        
        pieChart.frame = CGRectMake(marginH + i * (width + marginH) , marginV, wh, wh);
        
        titleLabel.frame = CGRectMake(20 + i * (width + marginH), CGRectGetMaxY(pieChart.frame) + marginV, wh, titleHeight);
    
    }
    
    WMPieChart *pieChart = self.pieCharts.firstObject;
    
    [self.legendContent removeFromSuperview];
    UIView *legend = [pieChart getLegendWithMaxWidth:width];
    self.legend.frame = CGRectMake(marginH + count * (wh + marginH), marginV, wh, wh);
    legend.frame = self.legend.bounds;
    [self.legend addSubview:legend];
    self.legendContent = legend;
}


#pragma mark - PNChartDelegate
-(void)userClickedOnPieChart:(id)pieChart atIndex:(NSInteger)pieIndex atTouchPoint:(CGPoint)point
{
    [self.tipsLabel removeFromSuperview];
    
    //获取当前的item
    WMPieChart *pie = (WMPieChart *)pieChart;
    PNPieChartDataItem *item = pie.items[pieIndex];
    
    //计算尺寸
    
    self.tipsLabel.text = [NSString stringWithFormat:@"%@(%0.0f人)",item.textDescription,item.value];
    
    CGPoint pointNew = [self convertPoint:point fromView:pie];
    self.tipsLabel.frame = CGRectMake(pointNew.x, pointNew.y, 100, 30);
    
    [self addSubview:self.tipsLabel];
}


@end
