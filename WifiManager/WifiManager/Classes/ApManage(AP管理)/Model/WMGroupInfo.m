//
//  WMGroupInfo.m
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMGroupInfo.h"
#import <MJExtension.h>

@implementation WMGroupInfo


/**重写MMJExtension方法，告诉框架，children中装的是WMGroupInfo模型*/
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"children":@"WMGroupInfo"};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

@end
