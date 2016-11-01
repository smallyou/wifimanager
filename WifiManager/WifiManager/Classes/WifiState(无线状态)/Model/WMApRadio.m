//
//  WMApRadio.m
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApRadio.h"

@implementation WMApRadio

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

-(NSString *)type
{
    if (self.workInfoChannel < 20) {
        return @"2.4G";
    }
    else {
        return @"5.8G";
    }
}

@end
