//
//  WMGroupItem.m
//  WifiManager
//
//  Created by 陈华 on 16/10/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMGroupItem.h"

@implementation WMGroupItem

+(instancetype)groupWithHeader:(NSString *)headerTitle footer:(NSString *)footerTitle cells:(NSArray *)cells
{
    WMGroupItem *groupModel = [[self alloc]init];
    groupModel.headerTitle = headerTitle;
    groupModel.footerTitle = footerTitle;
    groupModel.cells = cells;
    return groupModel;
}

@end
