//
//  WMApInfo.h
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMApInfo : NSObject

/**AP的id*/
@property(nonatomic,copy) NSString *Id;
/**AP的name*/
@property(nonatomic,copy) NSString *name;
/**ip地址*/
@property(nonatomic,copy) NSString *ip;
/**mac*/
@property(nonatomic,copy) NSString *mac;
/**AP位置*/
@property(nonatomic,copy) NSString *position;
/**无线参数-组配置/独立配置*/
@property(nonatomic,copy) NSString *params;
/**信道*/
@property(nonatomic,copy) NSString *channel;
/**带宽*/
@property(nonatomic,copy) NSString *bandwidth;
/**发射功率*/
@property(nonatomic,copy) NSString *txpower;
/**AP型号*/
@property(nonatomic,copy) NSString *pattern;
/**mode*/
@property(nonatomic,copy) NSString *mode;
/**是否可用*/
@property(nonatomic,assign) BOOL enable;
/**2.4G射频参数*/
@property(nonatomic,strong) WMApInfo *power2;
/**5.8G射频参数*/
@property(nonatomic,strong) WMApInfo *power5;
/**client_ap_enable*/
@property(nonatomic,assign) BOOL client_ap_enable;
/**client_ap_radio*/
@property(nonatomic,copy) NSString *client_ap_radio;
/**软件版本*/
@property(nonatomic,copy) NSString *software_version;
/**序列号*/
@property(nonatomic,copy) NSString *sequenceNO;
/**SN*/
@property(nonatomic,copy) NSString *sequenceNO_SN;



@end
