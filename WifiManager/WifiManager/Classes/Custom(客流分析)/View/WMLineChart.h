//
//  WMLineChart.h
//  WifiManager
//
//  Created by 陈华 on 16/10/9.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <PNChart/PNChart.h>

#import "WMChartModel.h"

@interface WMLineChart : PNLineChart

@property(nonatomic,strong) WMChartModel *chartModel;

@end
