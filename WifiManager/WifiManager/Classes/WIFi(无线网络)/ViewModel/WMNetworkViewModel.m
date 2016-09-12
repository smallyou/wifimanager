//
//  WMNetworkViewModel.m
//  WifiManager
//
//  Created by 陈华 on 16/9/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMNetworkViewModel.h"
#import "WMNetworkCell.h"

@interface WMNetworkViewModel ()

@end

@implementation WMNetworkViewModel

/**初始化构造方法*/
-(instancetype)initWithNetwork:(WMNetwork *)network
{
    if (self = [super init]) {
        //初始化模型属性
        self.network = network;
        
        //初始化其他属性
        [self instanceAttribute:network];
    }
    return self;
}


/**初始化属性*/
-(void)instanceAttribute:(WMNetwork *)network
{
    //1 aps
    self.apsStr = [NSString stringWithFormat:@"接入点:%@",network.aps];
    
    //2 auth
    self.authStr = [NSString stringWithFormat:@"认证类型:%@",network.auth];
    
    //3 mode
    if ([network.mode isEqualToString:@"locally"]) {
        self.modeStr = @"数据模式:本地转发";
    }else{
        self.modeStr = @"数据模式:集中转发";
    }
    
    
    //4 band
    self.bandStr = [NSString stringWithFormat:@"协议类型:%@",network.band];
}






@end
