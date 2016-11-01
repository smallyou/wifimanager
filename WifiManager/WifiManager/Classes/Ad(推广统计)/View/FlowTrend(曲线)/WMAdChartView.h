//
//  WMAdChartView.h
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMChartModel.h"

@class WMFlowTrendChartCellItem;
@interface WMAdChartView : UIView

/**画折线图所需要的数据*/
@property(nonatomic,strong) WMFlowTrendChartCellItem *chartItem;

+(instancetype)adChartView;

@end
