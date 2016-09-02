//
//  WMUserAccoutViewModel.h
//  WifiManager
//
//  Created by 陈华 on 16/9/1.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMUserAccout.h"

@interface WMUserAccoutViewModel : NSObject

@property(nonatomic,strong) WMUserAccout *userAccout; //对用户信息进行处理
@property(nonatomic,assign,getter=isLogin) BOOL login; //判断是否登录
@property(nonatomic,assign,getter=isLogout) BOOL logout; //是否主动注销



/**
 *  提供单例
 *
 *  @return 单例对象
 */
+(instancetype)shareInstance;

/**
 *  存储沙盒
 */
-(void)savedUserAccoutToSandBox;

/**
 *  从沙盒中获取文件
 *
 *  @return 返回userAccout对象
 */
-(WMUserAccout *)getAccoutFromSandBox;

@end
