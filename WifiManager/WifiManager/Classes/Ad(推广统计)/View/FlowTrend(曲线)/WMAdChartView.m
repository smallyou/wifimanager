//
//  WMAdChartView.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAdChartView.h"
#import "WMLineChart.h"
#import "WMFlowTrendChartCellItem.h"

@interface WMAdChartView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *legendContentView;


@property (weak, nonatomic) WMLineChart *lineChart;
@property (weak, nonatomic) UIView *legend;



@end

@implementation WMAdChartView

-(void)setChartItem:(WMFlowTrendChartCellItem *)chartItem
{
    _chartItem = chartItem;
    self.titleLabel.text = chartItem.title;
    
    self.lineChart.chartModel = chartItem.chartModel;
    
    
    [self updateLegend];
    
}


/**刷新图例*/
-(void)updateLegend
{
    //添加图例
    [self.legend removeFromSuperview];
    UIView *legend = [self.lineChart getLegendWithMaxWidth:WMScreenWidth - margin];
    legend.frame = CGRectMake(0, 0, legend.frame.size.width, legend.frame.size.height);
    legend.cm_x = (self.legendContentView.cm_width - legend.cm_width) * 0.5;
    legend.cm_y = (self.legendContentView.cm_height - legend.cm_height) * 0.5;
    [self.legendContentView addSubview:legend];
}


-(void)awakeFromNib
{
    [super awakeFromNib];



    [self.lineChart removeFromSuperview];
    // 创建折线图chart
    WMLineChart *lineChart = [[WMLineChart alloc]initWithFrame:CGRectMake(0, 0,  WMScreenWidth,self.contentView.cm_height)];
    
    lineChart.yLabelBlockFormatter = ^(CGFloat y){
        
        if (self.chartItem.chartModel == nil) {
            return @"";
        }
        return [NSString stringWithFormat:@"%0.0f",y];
    };
    
    
    self.lineChart = lineChart;
    self.lineChart.chartModel = self.chartItem.chartModel;
    self.lineChart.frame = CGRectMake(0, 0, WMScreenWidth,self.contentView.cm_height);
    [self.contentView addSubview:self.lineChart];
    
    
    
    
}


+(instancetype)adChartView
{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


@end
