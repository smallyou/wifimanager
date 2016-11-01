//
//  WMLineChart.m
//  WifiManager
//
//  Created by 陈华 on 16/10/9.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMLineChart.h"

@interface WMLineChart () <PNChartDelegate>

@property(nonatomic,strong) UILabel *tipsLabel;
@property(nonatomic,weak) UILabel *alertLabel;

@end

@implementation WMLineChart

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




-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.showSmoothLines = YES;
        self.showYGridLines = YES;
        self.thousandsSeparator = YES;
        self.showCoordinateAxis = YES;
        self.showLabel = YES;
        
        self.legendStyle = PNLegendItemStyleSerial;
        self.legendFont = [UIFont systemFontOfSize:12.0];
        self.showGenYLabels = YES;
        
        self.delegate = self;
        
        
        UILabel *alertLabel = [[UILabel alloc]init];
        alertLabel.text = @"暂无数据";
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.textColor = [UIColor blackColor];
        self.alertLabel = alertLabel;
        [self addSubview:alertLabel];
        self.alertLabel.frame = CGRectMake(0, 0, self.cm_width, 30);
        
        
    }
    return self;
}



-(void)setChartModel:(WMChartModel *)chartModel
{
    _chartModel = chartModel;
    
    // 设置x轴数据
    [self setXLabels:chartModel.xData];
    
    // 设置数据
    NSMutableArray *arrayM = [NSMutableArray array];
    for (WMLineData *lineData in chartModel.datas) {
        PNLineChartData *data01 = [PNLineChartData new];
        NSString *title = lineData.title;
        if ([title containsString:@"率"]) {
            title = [NSString stringWithFormat:@"%@ (%%)",title];
        }else if([title containsString:@"时间"]){
            title = [NSString stringWithFormat:@"%@ (min)",title];
        }else{
//            title = [NSString stringWithFormat:@"%@ (人)",title];
        }
        data01.dataTitle = title;
        data01.color = lineData.color;
        data01.itemCount = lineData.values.count;
        data01.getData = ^(NSUInteger index) {
                CGFloat yValue = [lineData.values[index] floatValue] ;
                return [PNLineChartDataItem dataItemWithY:yValue];
        };
        [arrayM addObject:data01];
    }
    self.alertLabel.hidden = !(chartModel.datas.count == 0);
    self.chartData = arrayM;
    
    // 渲染
    [self strokeChart];
}

#pragma mark - PNLineChartDelegate

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex
{

}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex
{
//    WMLog(@"keyPoint = %@ , lineIndex = %ld , pointIndex = %ld",NSStringFromCGPoint(point),lineIndex,pointIndex);
    WMLineData *lineData =  self.chartModel.datas[lineIndex];
    NSArray *values = lineData.values;
    CGFloat value = [values[pointIndex] floatValue];
    NSString *title = lineData.title;
    NSString *text = @"";
    if ([title containsString:@"率"]) {
        text = [NSString stringWithFormat:@"%0.1f%%",value];
    }else{
        text = [NSString stringWithFormat:@"%0.0f",value];
    }
   
    
    
    //移除
    [self.tipsLabel removeFromSuperview];
    
    //计算尺寸
    self.tipsLabel.frame = CGRectMake(point.x, point.y, 60, 30);
    
    //赋值
    self.tipsLabel.text = text;
    
    //添加
    [self addSubview:self.tipsLabel];
    
}





@end















