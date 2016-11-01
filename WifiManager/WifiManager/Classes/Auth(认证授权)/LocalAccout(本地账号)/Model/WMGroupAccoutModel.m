//
//  WMGroupAccoutModel.m
//  WifiManager
//
//  Created by 陈华 on 16/9/26.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMGroupAccoutModel.h"

@implementation WMGroupAccoutModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id",@"isDefault":@"default"};
}


@end
