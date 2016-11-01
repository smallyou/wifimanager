//
//  WMFlowTrendChartCellItem.h
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMFlowTrendCellItem.h"

@class WMChartModel;
@interface WMFlowTrendChartCellItem : WMFlowTrendCellItem

@property(nonatomic,copy) NSString *chartTitle;

@property(nonatomic,strong) WMChartModel *chartModel;

@end
