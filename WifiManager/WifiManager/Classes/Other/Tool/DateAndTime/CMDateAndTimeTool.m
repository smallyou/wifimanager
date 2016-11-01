//
//  CMDateAndTimeTool.m
//  WifiManager
//
//  Created by 陈华 on 16/10/15.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "CMDateAndTimeTool.h"

@implementation CMDateAndTimeTool


/**给定一个当前日期，取出对应的时间戳，获取日期的时分秒*/
+(NSTimeInterval)timeIntervalIgnorTimeWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSDate *nowIgnorTime = [formatter dateFromString:[NSString stringWithFormat:@"%zd-%zd-%zd",component.year,component.month,component.day]];
    return [nowIgnorTime timeIntervalSince1970];
}


@end
