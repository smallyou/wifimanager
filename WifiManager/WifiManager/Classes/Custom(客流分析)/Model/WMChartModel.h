//
//  WMChartModel.h
//  WifiManager
//
//  Created by 陈华 on 16/10/9.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMLineData.h"

typedef NS_ENUM(NSUInteger,WMChartType){
    WMChartTypeLine = 0, //折线图
    WMChartTypePie = 1 //饼状图
};

@interface WMChartModel : NSObject

/**图表的类型*/
@property(nonatomic,assign) WMChartType chartType;

/**x轴数值名称*/
@property(nonatomic,copy) NSString *xTitle;
/**x轴数值集合*/
@property(nonatomic,strong) NSArray *xData;

/**数据集合*/
@property(nonatomic,strong) NSArray *datas;


/**
 *  快速创建图表模型
 *
 *  @param object 数据模型相关结构--如果是折线图传入数组 如果是饼图传入字典
 *  @param colors 颜色数组
 *  @param type 图表的类型
 *
 *  @return 图表数据模型
 */
+(instancetype)chartModelWithDatas:(id)object colors:(NSArray *)colors type:(WMChartType)type;


@end
