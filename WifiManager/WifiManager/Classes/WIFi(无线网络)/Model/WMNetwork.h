//
//  WMNetwork.h
//  WifiManager
//
//  Created by 陈华 on 16/9/4.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WMNetwork : NSObject

/**WiFi的标识符*/
@property(nonatomic,assign) NSInteger Id;

/**ssid*/
@property(nonatomic,copy) NSString *ssid;

/**可用状态*/
@property(nonatomic,assign) BOOL enable;

/**接入点(分组)*/
@property(nonatomic,copy) NSString *aps;

/**数据模式*/
@property(nonatomic,copy) NSString *mode;

/**协议类型*/
@property(nonatomic,copy) NSString *band;

/**认证类型*/
@property(nonatomic,copy) NSString *auth;

/**未知*/
@property(nonatomic,copy) NSString *wifiqr;

/**创建者*/
@property(nonatomic,copy) NSString *creator;

@end
