//
//  WMSummaryInfoModel.h
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDetailsInfoModel : NSObject

/**今天*/
@property(nonatomic,copy) NSString *lastDay;
/**最近30天*/
@property(nonatomic,copy) NSString *lastMonth;
/**最近7天*/
@property(nonatomic,copy) NSString *lastWeek;
/**总计*/
@property(nonatomic,copy) NSString *total;
/**标题*/
@property(nonatomic,copy) NSString *title;
/**标题对应的key*/
@property(nonatomic,copy) NSString *titleKey;

@end
