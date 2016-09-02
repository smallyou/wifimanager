//
//  WMUserAccout.h
//  WifiManager
//
//  Created by 陈华 on 16/9/1.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMUserAccout : NSObject <NSCoding>

@property(nonatomic,copy) NSString *server; //服务器地址
@property(nonatomic,copy) NSString *username; //用户名
@property(nonatomic,copy) NSString *password; //密码

@property(nonatomic,assign,getter=isAutoLogin) BOOL autoLogin; //自动登录
@property(nonatomic,assign,getter=isRemberPwd) BOOL remberPwd; //记住密码

@property(nonatomic,assign) NSTimeInterval timeout_time; //控制台超时时间
@property(nonatomic,strong,readonly) NSDate *timeout_date; //控制台超时具体时间

@property(nonatomic,copy) NSString *customer; // 客户名称


 


@end
