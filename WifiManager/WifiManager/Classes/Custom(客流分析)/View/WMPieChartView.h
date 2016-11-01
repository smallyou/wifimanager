//
//  WMPieChartView.h
//  WifiManager
//
//  Created by 陈华 on 16/10/11.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMChartModel;
@interface WMPieChartView : UIView
@property(nonatomic,strong) WMChartModel *chartModel;


-(instancetype)initWithPieChartCount:(NSInteger)count titles:(NSArray *)titles;
@end
