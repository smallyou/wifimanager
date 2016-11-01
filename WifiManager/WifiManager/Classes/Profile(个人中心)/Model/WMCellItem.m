//
//  WMCellItem.m
//  WifiManager
//
//  Created by 陈华 on 16/10/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMCellItem.h"

@implementation WMCellItem

+(instancetype)cellItemWithTitle:(NSString *)title leftDetail:(NSString *)leftDetail image:(NSString *)image
{
    WMCellItem *item = [[self alloc]init];
    item.title = title;
    item.leftDetail = leftDetail;
    item.image = image;
    return item;
}

@end
