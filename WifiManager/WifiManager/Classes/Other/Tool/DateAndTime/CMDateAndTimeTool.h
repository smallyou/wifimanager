//
//  CMDateAndTimeTool.h
//  WifiManager
//
//  Created by 陈华 on 16/10/15.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMDateAndTimeTool : NSObject

/**给定一个当前日期，取出对应的时间戳，获取日期的时分秒*/
+(NSTimeInterval)timeIntervalIgnorTimeWithDate:(NSDate *)date;

@end
