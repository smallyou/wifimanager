//
//  WMFlowTrendBarChartCellItem.h
//  WifiManager
//
//  Created by 陈华 on 16/10/18.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WMFlowTrendCellItem.h"
#import "WMChartModel.h"

@interface WMFlowTrendBarChartCellItem : WMFlowTrendCellItem

@property(nonatomic,strong) WMChartModel *chartModel;

@end
