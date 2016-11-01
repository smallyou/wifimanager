//
//  WMBarChart.m
//  WifiManager
//
//  Created by 陈华 on 16/10/18.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMBarChart.h"
#import "WMChartModel.h"


@interface WMBarChart()

@property(nonatomic,weak) UILabel *tipsLabel;

@end

@implementation WMBarChart

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
        self.showLabel = YES;
        self.backgroundColor = [UIColor clearColor];
        
        
        self.yChartLabelWidth = 20.0;
        self.chartMarginLeft = 30.0;
        self.chartMarginRight = 10.0;
        self.chartMarginTop = 5.0;
        self.chartMarginBottom = 10.0;
        
        
        self.labelMarginTop = 5.0;
        self.showChartBorder = YES;
        self.isGradientShow = NO;
        self.isShowNumbers = NO;
        
        
        UILabel *tipsLabel = [[UILabel alloc]init];
        tipsLabel.text = @"暂无数据";
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.textColor = [UIColor blackColor];
        self.tipsLabel = tipsLabel;
        [self addSubview:tipsLabel];
        
        
        
    }
    return self;
}

-(void)setChartModel:(WMChartModel *)chartModel
{
    _chartModel = chartModel;
    
//    [self setXLabels:@[@"2",@"3",@"4",@"5",@"2",@"3",@"4",@"5"]];
//    [self setYValues:@[@10.82,@1.88,@6.96,@33.93,@10.82,@1.88,@6.96,@33.93]];

    if (chartModel.xData.count && chartModel.datas.count) {        
        [self setXLabels:chartModel.xData];
        [self setYValues:chartModel.datas];
        self.tipsLabel.hidden = YES;
    }else{
        self.tipsLabel.hidden = NO;
    }
    
    
    [self strokeChart];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.tipsLabel.frame = CGRectMake(0, 0, self.cm_width, 30);
}


@end
