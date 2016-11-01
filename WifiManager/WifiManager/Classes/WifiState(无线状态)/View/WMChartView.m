//
//  WMChartView.m
//  WifiManager
//
//  Created by 陈华 on 16/9/24.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMChartView.h"
#import "WMFlowView.h"

@interface WMChartView ()

/**画折线图的view*/
@property (weak, nonatomic) IBOutlet WMFlowView *flowView;

/**时间标签数据*/
@property(nonatomic,strong) NSMutableArray *timeStrs;

/**用来显示时间的标签*/
@property (weak, nonatomic) IBOutlet UIView *timeLabels;



@end


@implementation WMChartView

-(NSMutableArray *)timeStrs
{
    if ( _timeStrs == nil) {
        _timeStrs = [NSMutableArray array];
    }
    return _timeStrs;
}

+(instancetype)chartView
{
    return [[NSBundle mainBundle] loadNibNamed:@"WMChartView" owner:nil options:nil].firstObject;
}

-(void)setData:(NSArray *)data
{
    _data = data;
    
    self.flowView.data = self.data;
    
    //更新时间刻度标签
    [self updateTimeLabel];
    
}

/**更新时间刻度标签*/
-(void)updateTimeLabel
{
    /**取出用来显示时间刻度的部分时间值*/
    for (NSDictionary *dict in self.data) {
    
        if ([dict[@"name"] isEqualToString:@"time"]) {
            
            NSArray *times = dict[@"data"];
            
            //取出中间的数据，用于显示时间刻度
            NSInteger count = times.count;
            NSString *lastTime = @"";
            for (int i = 0; i < count; i++) {
                NSTimeInterval timeInterval = [times[i] doubleValue];
                NSString *timeStr = [self timeStrWithTimeInterval:timeInterval];
                if (![lastTime isEqualToString:timeStr]) {
                    [self.timeStrs addObject:timeStr];
                    lastTime = timeStr;
                }
            }
        }
    }
    
    
    
    //更新时间标签
    NSInteger count = self.timeLabels.subviews.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UILabel *label = self.timeLabels.subviews[i];
        label.text = self.timeStrs[i];
        
    }
    
    
    //清空时间刻度值数组
    [self.timeStrs removeAllObjects];
    
    
    
}


/**NSTimeInterval转换成当前时间字符串*/
-(NSString *)timeStrWithTimeInterval:(NSTimeInterval )timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    formatter.dateFormat = @"HH:mm";
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

@end
