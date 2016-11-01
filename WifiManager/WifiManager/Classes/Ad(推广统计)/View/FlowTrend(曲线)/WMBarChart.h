//
//  WMBarChart.h
//  WifiManager
//
//  Created by 陈华 on 16/10/18.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <PNChart/PNChart.h>

@class WMChartModel;

@interface WMBarChart : PNBarChart

@property(nonatomic,strong) WMChartModel *chartModel;

@end
