//
//  CMNetworkManager.h
//  网络请求封装
//
//  Created by 陈华 on 16/8/31.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMNetworkManager : NSObject

/**
 *  发起登录请求
 *
 *  @param server      服务器地址
 *  @param username    用户名
 *  @param password    密码
 *  @param competation 完成调用的block
 */
+(void)loginRequest:(NSString *)server username:(NSString *)username password:(NSString *)password competation:(void(^)(BOOL success , NSError *error))competation;


/**
 *  请求控制台超时时间
 *
 *  @param server      服务器地址
 *  @param competation 完成后调用的block
 */
+(void)requestForConsoleTimeout:(NSString *)server competation:(void(^)(BOOL isSuccess ,NSTimeInterval timeout , NSError *error))competation;


/**
 *  注销登录请求
 *
 *  @param server      服务器地址
 *  @param competation 完成后回调block
 */
+(void)logoutRequest:(NSString *)server competation:(void(^)(BOOL isSuccess))competation;


/**
 *  请求设备的客户名称
 *
 *  @param server      服务器地址
 *  @param competation 完成后调用的block
 */
+(void)requestForCustomer:(NSString *)server competation:(void(^)(NSString *customer,NSError *error))competation;

@end
