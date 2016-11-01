//
//  WMFlowTrendGroupItem.h
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMFlowTrendGroupItem : NSObject

@property(nonatomic,copy) NSString *headerTitle; //组的头部标题
@property(nonatomic,copy) NSString *footerTitle; //组的尾部标题
@property(nonatomic,strong) NSArray *cells; //包含的单元格


+(instancetype)groupWithHeader:(NSString *)headerTitle footer:(NSString *)footerTitle cells:(NSArray *)cells;


@end
