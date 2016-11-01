//
//  WMFlowTrendGroupItem.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMFlowTrendGroupItem.h"

@implementation WMFlowTrendGroupItem

+(instancetype)groupWithHeader:(NSString *)headerTitle footer:(NSString *)footerTitle cells:(NSArray *)cells
{
    WMFlowTrendGroupItem *groupModel = [[self alloc]init];
    groupModel.headerTitle = headerTitle;
    groupModel.footerTitle = footerTitle;
    groupModel.cells = cells;
    return groupModel;
}


@end
