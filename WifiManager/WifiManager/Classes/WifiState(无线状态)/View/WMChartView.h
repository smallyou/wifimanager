//
//  WMChartView.h
//  WifiManager
//
//  Created by 陈华 on 16/9/24.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMChartView : UIView

/**数据接口*/
@property(nonatomic,strong) NSArray *data;

+(instancetype)chartView;

@end
