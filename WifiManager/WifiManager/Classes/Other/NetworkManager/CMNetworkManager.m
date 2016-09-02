//
//  CMNetworkManager.m
//  网络请求封装
//
//  Created by 陈华 on 16/8/31.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "CMNetworkManager.h"
#import "CMHTTPSessionManager.h"

typedef NS_ENUM(NSInteger,CMRequestType){
    
    CMRequestTypePost = 0, //POST请求
    CMRequestTypeGet = 1 //GET请求
    
} ;

typedef NS_ENUM(NSInteger,CMErrorCode){
    
    CMErrorCodeLoginFailed = -1 , //登录失败
    CMErrorCodeLoginSuccessed = 0 , //登录成功
    CMErrorCodeLoginException = 1 , //登录异常，可能是用户名密码错误
    
};




@implementation CMNetworkManager


/**基础网络请求*/
+(void)request:(CMRequestType)methodType url:(NSString *)url parameters:(NSDictionary *)parameters competation:(void(^)(id result , NSError *error))competation
{
    //1 获取请求管理器
    CMHTTPSessionManager *manager = [CMHTTPSessionManager manager];
    
    //2 判断请求类型
    if (CMRequestTypeGet == methodType) {
        //Get请求
        //3 发起GET请求
        [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            competation(responseObject,nil);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            competation(nil,error);
        }];
        
    }
    else{
        //POST请求
        //3 发起POST请求
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            competation(responseObject,nil);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            competation(nil,error);
        }];
    }
    
}

/**发起登录请求*/
+(void)loginRequest:(NSString *)server username:(NSString *)username password:(NSString *)password competation:(void(^)(BOOL success , NSError *error))competation
{
    //1 构造服务器地址
    NSString *url = [NSString stringWithFormat:@"%@/index.php/welcome/login",server];
    
    //2 构造请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = username;
    parameters[@"password"] = password;
    parameters[@"times"] = @"0";
    
    //3 发起登录请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //4 判断是否出错
        if (error != nil) {
            competation(NO,error);
            return ;
        }
        
        //5 将登录结果转换成字符串
        NSString *resultStr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([resultStr containsString:@"加载中"]) {
            //登录成功
            competation(YES,nil);
        }else{
            //登录异常
            NSError *error = [NSError errorWithDomain:@"login exception" code:CMErrorCodeLoginException userInfo:nil];
            competation(NO,error);
        }
        
    }];
}


/**请求控制台的超时时间*/
+(void)requestForConsoleTimeout:(NSString *)server competation:(void(^)(BOOL isSuccess ,NSTimeInterval timeout , NSError *error))competation
{
    //1 构造服务器地址 https://115.85.207.229:4433/index.php/system_option
    NSString *url = [NSString stringWithFormat:@"%@/index.php/system_option",server];
    
    //2 构造请求参数 {"opr":"list"}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"list";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //4 判断是否出错
        if (error != nil) {
            NSLog(@"%@",error);
            competation(NO,0,nil);
            return ;
        }
        //5 将登录结果转换成json
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *data = resultDict[@"data"];
        NSDictionary *sys = data[@"sys"];
        NSNumber *timeout = sys[@"timeout"];
        NSTimeInterval time = timeout.doubleValue * 60;
        competation(YES,time,nil);
        
    }];
}


/**发起注销登录请求*/
+(void)logoutRequest:(NSString *)server competation:(void(^)(BOOL isSuccess))competation
{
    //1 构造服务器请求地址 https://115.85.207.229:4433/index.php/welcome/logout
    NSString *url = [NSString stringWithFormat:@"%@/index.php/welcome/logout",server];
    
    //2 参数为空
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:nil competation:^(id result, NSError *error) {
        if (error) {
            competation(NO);
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        BOOL success = dict[@"success"];
        competation(success);
    }];
    
}

/**获取用户名称*/
+(void)requestForCustomer:(NSString *)server competation:(void(^)(NSString *customer,NSError *error))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/maintenance_sn
    NSString *url = [NSString stringWithFormat:@"%@/index.php/maintenance_sn",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"getAuthStatus";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        if (error) {
            competation(nil,error);
            return ;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSString *customer = dict[@"customer"];
        competation(customer,nil);
    }];
}

@end

















