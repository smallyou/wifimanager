//
//  WMApRadio.h
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMApRadio : NSObject

/**射频类型*/
@property(nonatomic,copy) NSString *type;
/**无线协议*/
@property(nonatomic,copy) NSString *radioPHY;
/**信道*/
@property(nonatomic,assign) NSInteger channel;
/**工作模式*/
@property(nonatomic,copy) NSString *workmodel;
/**信道利用率*/
@property(nonatomic,assign) CGFloat channelRate;
/**重传率*/
@property(nonatomic,assign) CGFloat repeatRate;
/**噪声*/
@property(nonatomic,assign) NSInteger noise;
/**误码率*/
@property(nonatomic,assign) CGFloat errCodeRate;
/**功率*/
@property(nonatomic,assign) NSInteger ap_power;


@property(nonatomic,assign) NSInteger band;
@property(nonatomic,copy) NSString *group;
@property(nonatomic,assign) NSInteger group_id;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,assign) CGFloat infoChannelRate;
@property(nonatomic,copy) NSString *ip;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) NSInteger recv;
@property(nonatomic,assign) NSInteger retry_frames;
@property(nonatomic,assign) NSInteger send;
@property(nonatomic,assign) NSInteger tx_frames;
@property(nonatomic,assign) NSInteger usercount;
@property(nonatomic,assign) NSInteger wlan;
@property(nonatomic,assign) NSInteger workInfoChannel;





@end
