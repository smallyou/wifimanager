//
//  WMAccessPoint.h
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ApStatus){
    ApStatusOnline = 1,
    ApStatusOffline = 2
};

@interface WMAccessPoint : NSObject

/**id*/
@property(nonatomic,copy) NSString *Id;
/**组id*/
@property(nonatomic,copy) NSString *group_id;
/**local_id*/
@property(nonatomic,copy) NSString *local_id;
/**name*/
@property(nonatomic,copy) NSString *name;
/**组*/
@property(nonatomic,copy) NSString *group;
/**ip*/
@property(nonatomic,copy) NSString *ip;
/**用户数*/
@property(nonatomic,assign) NSInteger usercount;
/**发送流量*/
@property(nonatomic,assign) CGFloat send;
/**接收流量*/
@property(nonatomic,assign) CGFloat recv;
/**joinTime*/
@property(nonatomic,copy) NSString *joinTime;
/**状态*/
@property(nonatomic,assign) ApStatus status;
/**工作模式*/
@property(nonatomic,assign) NSString *workmodel;
/**位置*/
@property(nonatomic,copy) NSString *position;
/**MAC*/
@property(nonatomic,copy) NSString *mac;
/**type*/
@property(nonatomic,copy) NSString *type;
/**sn*/
@property(nonatomic,copy) NSString *sn;
@property(nonatomic,copy) NSString *softVersion;
@property(nonatomic,copy) NSString *hardVersion;
@property(nonatomic,copy) NSString *wac_name;
@property(nonatomic,assign) NSInteger connection;
@property(nonatomic,assign) NSInteger wlan_count;
@property(nonatomic,copy) NSString *apauth;
@property(nonatomic,copy) NSString *wdscnt;
@property(nonatomic,copy) NSString *hw_ver;
@property(nonatomic,assign) BOOL apvpn_status;
@property(nonatomic,strong) NSArray *apvpn_conflict_msg;
@property(nonatomic,copy) NSString *wds_type;


@end
