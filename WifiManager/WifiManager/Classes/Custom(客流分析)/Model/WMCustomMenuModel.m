//
//  WMCustomMenuModel.m
//  WifiManager
//
//  Created by 陈华 on 16/10/7.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMCustomMenuModel.h"

@implementation WMCustomMenuModel

+(NSMutableArray *)customMenu
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"customMenus.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict  in array) {
        [arrayM addObject:[self customMenuWithDictionary:dict]];
    }
    return arrayM;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+(instancetype)customMenuWithDictionary:(NSDictionary *)dict
{
    return [[self alloc]initWithDictionary:dict];
}




@end
