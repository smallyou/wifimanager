//
//  CMNetworkManager.h
//  网络请求封装
//
//  Created by 陈华 on 16/8/31.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CMRequestType){
    
    CMRequestTypePost = 0, //POST请求
    CMRequestTypeGet = 1 //GET请求
    
} ;

typedef NS_ENUM(NSInteger,CMErrorCode){
    
    CMErrorCodeLoginFailed = -1 , //登录失败
    CMErrorCodeLoginSuccessed = 0 , //登录成功
    CMErrorCodeLoginException = 1  //登录异常，可能是用户名密码错误
    
};

typedef NS_ENUM(NSInteger,WMNetworkOperation){
    WMNetworkOperationEnable = 0, //启用
    WMNetworkOperationDisable = 1 , //禁用
    WMNetworkOperationDelete = 2 //删除
};




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


/**
 *  获取无线网络数据
 *
 *  @param server      服务器地址
 *  @param competation 请求回调的block
 *  @param data        返回的结果解析成字典数组
 */
+(void)requestforNetwork:(NSString *)server start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray<NSDictionary *> *data , NSError *error))competation;

/**
 *  对无线网络进行删除、禁用、启用操作
 *
 *  @param server      服务器地址
 *  @param opr         操作类型
 *  @param ids         待操作WiFi的id 数组
 *  @param competation 完成后的回调
 */
+(void)operationForNetwork:(NSString *)server opr:(WMNetworkOperation)opr ids:(NSArray *)ids competation:(void(^)(BOOL success))competation;


@end
