//
//  WMLineData.h
//  WifiManager
//
//  Created by 陈华 on 16/10/9.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PNChart.h>

@interface WMLineData : NSObject

/**数据名称*/
@property(nonatomic,copy) NSString *title;
/**数据值集合*/
@property(nonatomic,strong) NSArray *values;
/**数据表示颜色*/
@property(nonatomic,strong) UIColor *color;


@end
