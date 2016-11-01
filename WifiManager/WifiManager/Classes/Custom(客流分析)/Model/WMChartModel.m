//
//  WMChartModel.m
//  WifiManager
//
//  Created by 陈华 on 16/10/9.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMChartModel.h"
#import "WMPieData.h"

@implementation WMChartModel

+(instancetype)chartModelWithDatas:(id)object colors:(NSArray *)colors type:(WMChartType)type
{
    //如果是折线图
    if (type == WMChartTypeLine) {
        NSArray *array = (NSArray *)object;
        
        NSMutableArray *datas = [NSMutableArray array];
        WMChartModel *chartModel = [[self alloc]init];
        for(int i = 0 ; i < array.count ; i++)
        {
            //设置x轴的数据
            if (i == 0) {
                NSArray *xdata = array[i][@"data"];
                NSMutableArray *arrayM = [NSMutableArray array];
                for (id obj in xdata) {
                    NSTimeInterval time = [obj doubleValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    formatter.dateFormat = @"MM-dd";
                    NSString *str = [formatter stringFromDate:date];
                    [arrayM addObject:str];
                }
                chartModel.xData = arrayM;
            }
            else{
                //设置具体数据
                WMLineData *data = [[WMLineData alloc]init];
                NSArray *ydata = array[i][@"data"];
                data.title = array[i][@"name"];
                data.color = colors[i-1];
                data.values = ydata;
                [datas addObject:data];
            }
        }
        chartModel.datas = datas;
        return chartModel;
    }
    //如果是饼图
    else if(type == WMChartTypePie)
    {
        NSDictionary *dict =  (NSDictionary *)object;
        
        //定义变量
        NSArray *fluxDatas = [NSArray array];
        NSArray *xaxisDatas = [NSArray array];
        WMChartModel *chartModel = [[self alloc]init];
        NSMutableArray *datas = [NSMutableArray array];
        
        //累积到店终端 模型
        NSArray *guest = dict[@"guest"];
        NSArray *guestReal = guest.firstObject;
        for (NSDictionary *dictM in guestReal) {
            NSString *name = dictM[@"name"];
            NSArray *data = dictM[@"data"];
            if ([name isEqualToString:@"flux"]) {
                fluxDatas = data;
            }else {
                xaxisDatas = data;
            }
        }
        NSMutableArray<WMPieData *> *guestsM = [NSMutableArray array];
        for (int i=0; i<fluxDatas.count; i++) {
            WMPieData *pieData = [[WMPieData alloc]init];
            NSString *value = fluxDatas[i];
            NSString *desc = xaxisDatas[i];
            pieData.value = value;
            pieData.desc = desc;
            pieData.color = colors[i];
            [guestsM addObject:pieData];
        }
        [datas addObject:guestsM];
        
        
        //接入用户终端 模型
        NSArray *stat = dict[@"stat"];
        NSArray *statReal = stat.firstObject;
        for (NSDictionary *dictM in statReal) {
            NSString *name = dictM[@"name"];
            NSArray *data = dictM[@"data"];
            if ([name isEqualToString:@"flux"]) {
                fluxDatas = data;
            }else {
                xaxisDatas = data;
            }
        }
        NSMutableArray<WMPieData *> *statsM = [NSMutableArray array];
        for (int i=0; i<fluxDatas.count; i++) {
            WMPieData *pieData = [[WMPieData alloc]init];
            NSString *value = fluxDatas[i];
            NSString *desc = xaxisDatas[i];
            pieData.value = value;
            pieData.desc = desc;
            pieData.color = colors[i];
            [statsM addObject:pieData];
        }
        [datas addObject:statsM];
        
        chartModel.datas = datas;
        
        return chartModel;
    }
    return nil;
}


@end
