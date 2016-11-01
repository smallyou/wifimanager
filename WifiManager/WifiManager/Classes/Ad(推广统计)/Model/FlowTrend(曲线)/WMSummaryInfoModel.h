//
//  WMSummaryInfoModel.h
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDetailsInfoModel.h"

@interface WMSummaryInfoModel : NSObject

/**应用访问*/
@property(nonatomic,strong) WMDetailsInfoModel *appaccess;

/**搜索行为*/
@property(nonatomic,strong) WMDetailsInfoModel *keyword;

/**终端出现*/
@property(nonatomic,strong) WMDetailsInfoModel *known;

/**在线时长*/
@property(nonatomic,strong) WMDetailsInfoModel *online;

/**所有推广*/
@property(nonatomic,strong) WMDetailsInfoModel *total;

/**首次接入*/
@property(nonatomic,strong) WMDetailsInfoModel *unknown;


/**将当前模型中所有的模型元素按一定顺序存入到数组中*/
-(NSMutableArray *)arrayWithTitles:(NSArray *)titles keys:(NSArray *)titleKeys;


@end
