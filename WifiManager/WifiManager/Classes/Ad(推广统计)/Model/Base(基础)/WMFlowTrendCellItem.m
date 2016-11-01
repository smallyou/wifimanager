//
//  WMFlowTrendCellItem.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMFlowTrendCellItem.h"

@implementation WMFlowTrendCellItem

+(instancetype)cellItemWithTitle:(NSString *)title leftDetail:(NSString *)leftDetail image:(NSString *)image
{
    WMFlowTrendCellItem *item = [[self alloc]init];
    item.title = title;
    item.leftDetail = leftDetail;
    item.image = image;
    return item;
}

@end
