//
//  WMFlowTrendCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMFlowTrendCell.h"
#import "WMFlowTrendCellItem.h"
#import "WMFlowTrendAccessoryCellItem.h"
#import "WMFlowTrendChartCellItem.h"
#import "WMFlowTrendBarChartCellItem.h"
#import "WMAdChartView.h"
#import "WMBarChart.h"

@interface WMFlowTrendCell ()

@property(nonatomic,weak) WMAdChartView *chartView;
@property(nonatomic,weak) UIView *separtor;

@property(nonatomic,strong) WMBarChart *barChart;

@end

@implementation WMFlowTrendCell

-(UIView *)separtor
{
    if (_separtor == nil) {
        
        UIView *separtor = [[UIView alloc]init];
        separtor.backgroundColor =  WMColor(178, 178, 178);
        [self addSubview:separtor];
        _separtor = separtor;
    }
    return _separtor;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return self;
}



-(void)setItem:(WMFlowTrendCellItem *)item
{
    _item = item;
    
    
    
    //赋值
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.leftDetail;
    if (item.image) {
        self.imageView.image = [UIImage imageNamed:item.image];
    }
    
    
    
    //设置cell
    [self setupCell];
    
}


#pragma mark - 设置UI
/**设置cell的样式*/
-(void)setupCell
{
    
    if ([self.item isKindOfClass:[WMFlowTrendAccessoryCellItem class]]) {
        //普通表格
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellArrow"]];
        self.accessoryView = imgView;
        self.selectionStyle = UITableViewCellSelectionStyleBlue; //默认的选中类型
        
    }else if([self.item isKindOfClass:[WMFlowTrendChartCellItem class]])
    {
        //绘制曲线图
        WMFlowTrendChartCellItem *chartItem = (WMFlowTrendChartCellItem *)self.item;
        WMAdChartView *chartView = [WMAdChartView adChartView];
        chartView.backgroundColor = [UIColor whiteColor];
        chartView.chartItem = chartItem;
        [self addSubview:chartView];
        self.chartView = chartView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if ([self.item isKindOfClass:[WMFlowTrendBarChartCellItem class]])
    {
        //绘制饼状图
        [self.barChart removeFromSuperview];
        WMFlowTrendBarChartCellItem *chartItem = (WMFlowTrendBarChartCellItem *)self.item;
        WMBarChart *barChart = [[WMBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        barChart.chartModel = chartItem.chartModel;
        self.barChart = barChart;
        [self.contentView addSubview:barChart];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.chartView.frame = CGRectMake(0, 0, self.cm_width, 360);
    
    //根据模型属性，确定分割线的显示样式
    switch (self.item.separtorType) {
            
        case WMSepartorTypeShort:
            self.separtor.hidden = NO;
            self.separtor.frame = CGRectMake(18, self.cm_height - 1, self.cm_width - 18, 1);
            break;
            
        case WMSepartorTypeLong:
            self.separtor.hidden = NO;
            self.separtor.frame = CGRectMake(0, self.cm_height - 1, self.cm_width - 0, 1);
            break;
            
        default:
            self.separtor.hidden = YES;
            break;
    }
    
}






@end
