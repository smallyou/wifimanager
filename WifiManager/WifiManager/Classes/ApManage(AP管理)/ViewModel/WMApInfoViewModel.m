//
//  WMApInfoViewModel.m
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApInfoViewModel.h"

@implementation WMApInfoViewModel

-(instancetype)initWithApInfo:(WMApInfo *)apInfo
{
    if (self = [super init]) {
        
        self.apInfo = apInfo;
        //初始化其他属性
        [self instanceAttribute:apInfo];
    }
    return self;
}



/**初始化其他属性*/
-(void)instanceAttribute:(WMApInfo *)apInfo
{
    //1 初始化可显示IP
    if ([apInfo.ip isEqualToString:@""]) {
        self.ipStr = @"IP:自动获取";
    }
    else{
        self.ipStr = [NSString stringWithFormat:@"IP:%@",apInfo.ip];
    }
    
    //2 初始化可显示频宽
    self.bandWidthStr = [NSString stringWithFormat:@"频宽:%@/%@",self.apInfo.power2.bandwidth,self.apInfo.power5.bandwidth];
    
    //3 初始化可显示功率
    self.txPowerStr = [NSString stringWithFormat:@"功率:%@/%@",self.apInfo.power2.txpower,self.apInfo.power5.txpower];
    
    //4 初始化可显示信道
    self.channelStr = [NSString stringWithFormat:@"信道:%@/%@",self.apInfo.power2.channel,self.apInfo.power5.channel];
    
    //5 初始化可显示位置
    if ([apInfo.position isEqualToString:@""]) {
        self.positionStr = @"暂未标记位置";
    }else{
        self.positionStr = apInfo.position;
    }
    
    //6 初始化可显示MAC
    self.macStr = [NSString stringWithFormat:@"MAC:%@",apInfo.mac];
    
    
}


/**重写get方法，确保额外增加的属性能够随模型值改变*/
-(NSString *)bandWidthStr
{
    _bandWidthStr = [NSString stringWithFormat:@"频宽:%@/%@",self.apInfo.power2.bandwidth,self.apInfo.power5.bandwidth];
    return _bandWidthStr;
}

-(NSString *)txPowerStr
{
    _txPowerStr = [NSString stringWithFormat:@"功率:%@/%@",self.apInfo.power2.txpower,self.apInfo.power5.txpower];
    return _txPowerStr;
}

-(NSString *)channelStr
{
    _channelStr = [NSString stringWithFormat:@"信道:%@/%@",self.apInfo.power2.channel,self.apInfo.power5.channel];
    return _channelStr;
}




@end
