//
//  WMUserAccout.m
//  WifiManager
//
//  Created by 陈华 on 16/9/1.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMUserAccout.h"

@implementation WMUserAccout

#pragma mark - NSCoding

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.server = [aDecoder decodeObjectForKey:@"server"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.autoLogin = [aDecoder decodeBoolForKey:@"autoLogin"];
        self.remberPwd = [aDecoder decodeBoolForKey:@"remberPwd"];
        _timeout_date = [aDecoder decodeObjectForKey:@"timeout_date"];
        self.customer = [aDecoder decodeObjectForKey:@"customer"];
        
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.server forKey:@"server"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeBool:self.autoLogin forKey:@"autoLogin"];
    [aCoder encodeBool:self.remberPwd forKey:@"remberPwd"];
    [aCoder encodeObject:self.timeout_date forKey:@"timeout_date"];
    [aCoder encodeObject:self.customer forKey:@"customer"];
    
}

-(void)setTimeout_time:(NSTimeInterval)timeout_time
{
    _timeout_time = timeout_time;
    
    // 计算过期时间(减去10秒的误差，防止出现异常)
    _timeout_date = [NSDate dateWithTimeIntervalSinceNow:(timeout_time - 10)];
}


@end
