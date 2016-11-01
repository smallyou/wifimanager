//
//  WMApInfoViewModel.h
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMApInfo.h"

@interface WMApInfoViewModel : NSObject

/**拥有模型属性*/
@property(nonatomic,strong) WMApInfo *apInfo;

//--额外添加属性
/**可显示IP地址*/
@property(nonatomic,copy) NSString *ipStr;
/**可显示信道*/
@property(nonatomic,copy) NSString *channelStr;
/**可显示带宽*/
@property(nonatomic,copy) NSString *bandWidthStr;
/**可显示功率*/
@property(nonatomic,copy) NSString *txPowerStr;
/**可显示位置*/
@property(nonatomic,copy) NSString *positionStr;
/**可显示MAC*/
@property(nonatomic,copy) NSString *macStr;




/**初始化构造方法*/
-(instancetype)initWithApInfo:(WMApInfo *)apInfo;

@end
