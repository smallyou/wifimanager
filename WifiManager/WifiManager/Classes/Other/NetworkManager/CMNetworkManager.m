//
//  CMNetworkManager.m
//  网络请求封装
//
//  Created by 陈华 on 16/8/31.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "CMNetworkManager.h"
#import "CMHTTPSessionManager.h"
#import "WMCustomMenuModel.h"
#import <MJExtension.h>
#import "WMAdPopModel.h"
#import "WMBlackListModel.h"



@implementation CMNetworkManager

#pragma mark - 实现单例
/**静态变量*/
static id _instance;

//提供工厂方法
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

//重写 allocWithZone 方法
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


//重写方法
-(instancetype)copyWithZone:(struct _NSZone *)zone
{
    return _instance;
}


#pragma mark - 网络请求

/**基础网络请求*/
+(void)request:(CMRequestType)methodType url:(NSString *)url parameters:(NSDictionary *)parameters competation:(void(^)(id result , NSError *error))competation
{
    //1 获取请求管理器
    CMHTTPSessionManager *manager = [CMHTTPSessionManager manager];
    [[self shareInstance] setManager:manager];
    
    
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
        BOOL success = [dict[@"success"] boolValue];
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


/**获取无线网络数据*/
+(void)requestforNetwork:(NSString *)server start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray<NSDictionary *> *data , NSError *error))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/wl_network
    NSString *url = [NSString stringWithFormat:@"%@/index.php/wl_network",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"direction"] = @"ASC";
    parameters[@"limit"] = @(limit);
    parameters[@"opr"] = @"list";
    parameters[@"sort"] = @"ssid";
    parameters[@"start"] = @(start);
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
       
        //判断错误
        if (error) {
            competation(nil,error);
            return ;
        }
        
        //json序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *data = dict[@"data"];
        competation(data,nil);
        
    }];
}

/**对无线网络操作*/
+(void)operationForNetwork:(NSString *)server opr:(WMNetworkOperation)opr ids:(NSArray *)ids competation:(void(^)(BOOL success))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/wl_network
    NSString *url = [NSString stringWithFormat:@"%@/index.php/wl_network",server];
    
    //2 拼接请求参数 {"opr":"setStatus","enable":true,"ids":[5]}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (opr == WMNetworkOperationEnable) {
        parameters[@"opr"] = @"setStatus";
        parameters[@"enable"] = @(YES);
        parameters[@"ids"] = ids;
    }
    else if (opr == WMNetworkOperationDisable){
        parameters[@"opr"] = @"setStatus";
        parameters[@"ids"] = ids;
    }
    else {
        parameters[@"opr"] = @"delete";
        parameters[@"ids"] = ids;
    }
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //判断错误
        if(error)
        {
            competation(false);
            return;
        }
        
        //json序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        competation([dict[@"success"] boolValue]);
        
    }];
}


/**获取AP信息*/
+(void)requestForApInfo:(NSString *)server start:(NSInteger)start limit:(NSInteger)limit groupId:(NSInteger)groupId search:(NSString *)search competation:(void(^)(NSError *error , NSArray *result))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/wl_ap
    NSString *url = [NSString stringWithFormat:@"%@/index.php/wl_ap",server];
    
    //2 拼接请求参数 {"opr":"list","start":0,"limit":25,"filter":{"id":100},"sort":"name","direction":"ASC"}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"list";
    parameters[@"start"] = @(start);
    parameters[@"limit"] = @(limit);
    NSMutableDictionary *filter = [NSMutableDictionary dictionary];
    filter[@"id"] = @(groupId);
    parameters[@"filter"] = filter;
    parameters[@"sort"] = @"name";
    parameters[@"direction"] = @"ASC";
    if (search) {
        //如果有搜索条件
        parameters[@"search"] = search;
    }
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        // 判断错误
        if (error) {
            competation(error,nil);
            return ;
        }
        
        // JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"data"];
        competation(nil,array);
        return;
    }];
}


/**获取接入点分组信息*/
+(void)requestForGroupInfo:(NSString *)server competation:(void(^)(NSError *error , NSDictionary *groupInfo))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/wl_apgroup
    NSString *url = [NSString stringWithFormat:@"%@/index.php/wl_apgroup",server];
    
    //2 拼接请求参数 {"opr":"query_apgroup_tree","node":"root"}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"query_apgroup_tree";
    parameters[@"node"] = @"root";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
       //判断错误
        if (error) {
            competation(error,nil);
            return;
        }
        
        // JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *data = dict[@"data"];
        NSArray *tree = data[@"tree"];
        NSDictionary *groupInfo = tree.firstObject;
        competation(nil,groupInfo);
    }];
}


/**修改AP的射频参数*/
+(void)modifyRadio:(NSString *)server apInfo:(WMApInfo *)apInfo competation:(void(^)(BOOL success))competation
{
    //1 构造服务器地址 https://115.85.207.229:4433/index.php/wl_ap
    NSString *url = [NSString stringWithFormat:@"%@/index.php/wl_ap",server];
    
    //2 拼接请求参数 
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *band2 = [NSMutableDictionary dictionary];
    NSMutableDictionary *band5 = [NSMutableDictionary dictionary];
    
    
    band2[@"bandwidth"] = apInfo.power2.bandwidth;
    band2[@"channel"] = apInfo.power2.channel;
    band2[@"enable"] = @(apInfo.power2.enable);
    band2[@"mode"] = apInfo.power2.mode;
    band2[@"transmit_power"] = @{@"value":apInfo.power2.txpower};
    
    band5[@"bandwidth"] = apInfo.power5.bandwidth;
    band5[@"channel"] = apInfo.power5.channel;
    band5[@"enable"] = @(apInfo.power5.enable);
    band5[@"mode"] = apInfo.power5.mode;
    band5[@"transmit_power"] = @{@"value":apInfo.power5.txpower};
    
    
    
    
    data[@"pattern"] = apInfo.pattern;
    data[@"id"] = apInfo.Id;
    data[@"client_ap_enable"] = @(apInfo.client_ap_enable);
    data[@"client_ap_radio"] = apInfo.client_ap_radio;
    data[@"band2"] = band2;
    data[@"band5"] = band5;
    
    parameters[@"opr"] = @"channelmodify";
    parameters[@"data"] = data;
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //判断错误
        if (error) {
            competation(NO);
            return;
        }
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        competation([dict[@"success"] boolValue]);
    }];
    
}


/**获取AP状态*/
+(void)requestForApStatus:(NSString *)server start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSDictionary *result , NSError *error))competation
{
    //1 构造请求地址  https://58.253.96.125/index.php/sys_runstat
    NSString *url = [NSString stringWithFormat:@"%@/index.php/sys_runstat",server];
    
    //2 拼接请求参数
    /**
     {"opr":"listap","data":{"search":null,"start":0,"limit":25,"sort":"joinTime","filter":null,"direction"
     :"DESC"}}
     **/
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"search"] = nil;
    data[@"start"] = @(start);
    data[@"limit"] = @(limit);
    data[@"sort"] = @"joinTime";
    data[@"filter"] = nil;
    data[@"direction"] = @"DESC";
    parameters[@"data"] = data;
    parameters[@"opr"] = @"listap";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        // 判断错误
        if(error){
            competation(nil,error);
            return;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        competation(dict,nil);
    }];
}


/**获取指定AP的射频信息--无线状态*/
+(void)requestForRadioInfoWithAp:(WMAccessPoint *)ap server:(NSString *)server competation:(void(^)(NSArray *data , NSError *error))competation
{
    //1 构造请求地址 https://58.253.96.125/index.php/sys_runstat
    NSString *url = [NSString stringWithFormat:@"%@/index.php/sys_runstat",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *rs = [ap mj_keyValues]; //将模型转换成字典
    data[@"rs"] = rs;
    parameters[@"data"] = data;
    parameters[@"opr"] = @"get_ap_radio";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        
        //判断错误
        if (error) {
            competation(nil,error);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *data = dict[@"data"];
        competation(data,nil);
    }];
   
}


/**获取指定AP的射频详细信息---无线状态的详细信息*/
+(void)requestForDetailsRadioInfo:(WMAccessPoint *)ap server:(NSString *)server competation:(void(^)(NSArray *data , NSError *error))competation
{
    //1 构造请求地址  https://115.85.207.229:4433/index.php/sys_runstat
    NSString *url = [NSString stringWithFormat:@"%@/index.php/sys_runstat",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *filter = [NSMutableDictionary dictionary];
    
    data[@"direction"] = @"DESC";
    data[@"filter"] = filter;
    data[@"limit"] = @25;
    data[@"search"] = ap.name;
//    data[@"sort"] = @"name";
    data[@"sort"] = @"workInfoChannel";
    data[@"start"] = @0;
    
    parameters[@"data"] = data;
    parameters[@"opr"] = @"listrf";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        
        //判断错误
        if (error) {
            competation(nil,error);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *data = dict[@"data"];
        competation(data,nil);
    }];
}



/**获取指定AP 指定频段的 信道利用率图标数据--用来绘制折线图*/
+(void)requestForChannelChartData:(WMApRadio *)radio server:(NSString *)server competation:(void(^)(NSArray *data , NSError *error))competation
{
    //1 构造请求地址  https://115.85.207.229:4433/index.php/sys_runstat
    NSString *url = [NSString stringWithFormat:@"%@/index.php/sys_runstat",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *filter = [NSMutableDictionary dictionary];
    
//    NSMutableDictionary *rowData = [radio mj_keyValues]; //将模型转换成字典
    NSDictionary *row = [radio dictionaryWithValuesForKeys:@[@"ap_power",@"band",@"errCodeRate",@"group",@"id",@"infoChannelRate",@"ip",@"name",@"noise",@"radioPHY",@"recv",@"repeatRate",@"retry_frames",@"send",@"tx_frames",@"usercount",@"wlan",@"workInfoChannel",@"workmodel"]];
    NSMutableDictionary *rowData = [NSMutableDictionary dictionaryWithDictionary:row];
    rowData[@"allocation"] = @"";
 
    
    filter[@"gridName"] = @"rf";
    filter[@"rowData"] = rowData;
    filter[@"timeRange"] = @"last5min";
    filter[@"type"] = @"chanel";
    
    parameters[@"filter"] = filter;
    parameters[@"opr"] = @"chartData";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
       
        //判断错误
        if (error) {
            competation(nil,error);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *data = dict[@"data"];
        competation(data,nil);
        
    }];
    
}


/**请求本地用户以及用户组*/
+(void)requestForLocalUserAndGroup:(NSString *)server sortId:(NSString *)Id start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray *data , NSError *error))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/auth_localuser
    NSString *url = [NSString stringWithFormat:@"%@/index.php/auth_localuser",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *search = [NSMutableDictionary dictionary];
    NSMutableDictionary *group = [NSMutableDictionary dictionary];
    group[@"id"] = Id;
    search[@"group"] = group;
    parameters[@"direction"] = @"ASC";
    parameters[@"limit"] = @(limit);
    parameters[@"opr"] = @"list";
    parameters[@"search"] = search;
    parameters[@"sort"] = @"";
    parameters[@"start"] = @(start);
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
       
        //判断失败
        if (error) {
            competation(nil,error);
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(nil,error);
            return ;
        }
        NSArray *data = dict[@"data"];
        competation(data,nil);
    }];
}



/**删除本地用户*/
+(void)requestForDeleteLocalAccout:(NSString *)server accout:(WMGroupAccoutModel *)accout  competation:(void(^)(BOOL success))competation
{
    
    //1 构造请求地址 https://115.85.207.229:4433/index.php/auth_localuser
    NSString *url = [NSString stringWithFormat:@"%@/index.php/auth_localuser",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"delete";
    NSMutableDictionary *accout0 = [accout mj_keyValuesWithKeys:@[@"desc",@"expiration",@"Id",@"logintime",@"name",@"realname",@"status",@"type"]];;
    parameters[@"data"] = @[accout0];
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        
        //判断失败
        if (error) {
            competation(NO);
            return;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(NO);
            return ;
        }
        
        competation([dict[@"success"] boolValue]);
    
    }];
}


/**获取临时访客列表*/
+(void)requestForTempoGuest:(NSString *)server start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray *data , NSError *error))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/guest_account
    NSString *url = [NSString stringWithFormat:@"%@/index.php/guest_account",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"direction"] = @"DESC";
    parameters[@"limit"] = @(limit);
    parameters[@"opr"] = @"list";
    parameters[@"sort"] = @"init";
    parameters[@"start"] = @(start);
    parameters[@"type"] = @"all";

    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
       
        //判断失败
        if (error) {
            competation(nil,error);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(nil,[[NSError alloc]init]);
            return;
        }
        NSArray *data = dict[@"data"];
        if (dict[@"success"] && data ) {
            competation(data,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            competation(nil,error);
        }
    }];
}



/**重置临时访客密码*/
+(void)requestForResetTempoGuest:(NSString *)server Id:(NSString *)Id pwd:(NSString *)pwd competation:(void(^)(BOOL success))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/guest_account
    NSString *url = [NSString stringWithFormat:@"%@/index.php/guest_account",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"reset";
    parameters[@"id"] = Id;
    data[@"name"] = @"";
    data[@"psw"] = pwd;
    parameters[@"data"] = data;
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        
        //判断失败
        if (error) {
            competation(NO);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(NO);
            return;
        }
        
        BOOL success = [dict[@"success"] boolValue];
        
        competation(success);
        
    }];
}


/**删除指定的临时访客账号*/
+(void)requestforDeleteTempoGuest:(NSString *)server accout:(WMGuestAccoutModel *)accout competation:(void(^)(BOOL success))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/guest_account
    NSString *url = [NSString stringWithFormat:@"%@/index.php/guest_account",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"delete";
    NSMutableDictionary *data1 = [accout mj_keyValues];
    parameters[@"data"] = @[data1];
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        
        //判断失败
        if (error) {
            competation(NO);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(NO);
            return;
        }
        
        BOOL success = [dict[@"success"] boolValue];
        
        competation(success);

        
    }];
}



/**创建临时访客账号*/
+(void)requestForAddTempoGuest:(NSString *)server dict:(NSDictionary *)dict competation:(void(^)(BOOL success))competation
{
    //1 构造请求地址 https://115.85.207.229:4433/index.php/guest_account
    NSString *url = [NSString stringWithFormat:@"%@/index.php/guest_account",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *group = [NSMutableDictionary dictionary];
    group[@"id"] = @0;
    group[@"name"] = @"默认组";
    data[@"group"] = group;
    [data setValuesForKeysWithDictionary:dict];
    
    parameters[@"opr"] = @"add";
    parameters[@"data"] = data;
    
    //3 请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //判断失败
        if (error) {
            competation(NO);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(NO);
            return;
        }
//        WMLog(@"%@",dict[@"msg"]);
        
        BOOL success = [dict[@"success"] boolValue];
        
        competation(success);
    }];
}



/**获取区域下的客流分析数据*/
+(void)requestForCustomFlowData:(NSString *)server area:(NSDictionary *)area timeType:(NSString *)timeType menuModel:(WMCustomMenuModel *)menuModel competation:(void(^)(id object,NSError *error))competation
{
    //1 构造请求地址 https://58.253.96.125/index.php/new_guest_analyse
    NSString *url = [NSString stringWithFormat:@"%@/index.php/new_guest_analyse",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"branch_id"] = @0;
    parameters[@"id"] = @(-1);
    parameters[@"limit"] = @3;
    parameters[@"name"] = @"/全部";
    parameters[@"opr"] = menuModel.opr;
    parameters[@"start"] = @0;
    parameters[@"timeRange"] = menuModel.timeRange;
    parameters[@"time_type"] = timeType?timeType:@"last7day";
    parameters[@"type"] = @"AP组";
    
    //3请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //判断失败
        if (error) {
            competation(nil,error);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            competation(nil,error);
            return;
        }
        
        if(dict[@"data"])
        {
            competation(dict[@"data"],nil);
        }
    }];
}


/**加载当前的设备的告警事件*/
+(void)requestForAlertEvent:(NSString *)server search:(NSString *)search start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray *array,NSError *error))competation
{
    //1 构造请求地址 https://58.253.96.125/index.php/warn_event
    NSString *url = [NSString stringWithFormat:@"%@/index.php/warn_event",server];
    
    //2 拼接请求参数 {"opr":"list","start":0,"limit":25,"search":"冲突","sort":"time","direction":"DESC"}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"list";
    parameters[@"start"] = @(start);
    parameters[@"limit"] = @(limit);
    parameters[@"sort"] =  @"time";
    parameters[@"direction"] = @"DESC";
    if (search.length > 0) {
        parameters[@"search"] = search;
    }
    
    //3 请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //判断失败
        if (error) {
            competation(nil,error);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            competation(nil,error);
            return;
        }
        
        if(dict[@"data"])
        {
            competation(dict[@"data"],nil);
        }

    }];
}


/**请求推广统计的汇总信息*/
+(void)requestForAdSummaryData:(NSString *)server competation:(void(^)(NSDictionary *dict,NSError *error))competation
{
    //1 构造请求地址 https://219.136.31.124/index.php/push_status
    NSString *url = [NSString stringWithFormat:@"%@/index.php/push_status",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"get_rule_census";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
       
        //判断失败
        if (error) {
            competation(nil,error);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            competation(nil,error);
            return;
        }
        
        if(dict[@"data"])
        {
            competation(dict[@"data"],nil);
        }
        
    }];
}


/**请求获取当前推广统计中的 对象定义 -- 定义的推送规则/微信公众平台*/
+(void)requestForAdPushRuleOrWechatPub:(NSString *)server oprType:(WMAdQueryType)oprType type:(NSString *)type competation:(void(^)(NSArray *data,NSError *error))competation
{
    //1 构造请求地址 https://58.253.96.125/index.php/
    NSString *url = [NSString stringWithFormat:@"%@/index.php/push_status",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"get_pub_wx_list"; //默认是查询微信
    //如果当前传入的查询类型是推送规则，则重新赋值
    if(oprType == WMAdQueryTypePushRule)
    {
        parameters[@"opr"] = @"get_push_rule_list";
        parameters[@"query"] = @"";
        parameters[@"rule_type"] = type;
        parameters[@"type"] = type;
    }
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //判断失败
        if (error) {
            competation(nil,error);
            return ;
        }
        
        
        //JSON序列化        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            competation(nil,error);
            
            return;
        }
        
        if(dict[@"data"])
        {
            competation(dict[@"data"],nil);
        }
        
    }];
}



/**请求获取当前推广统计趋势数据*/
+(void)requestForAdFlowTrend:(NSString *)server baseTime:(NSDictionary *)baseTime flowType:(NSString *)flowType plat:(WMAdPopModel *)plat rule:(WMAdPopModel *)rule timeRange:(const NSString *)timeRange competation:(void (^)(NSArray * _Nullable, NSError * _Nullable))competation
{
    
    //1 构造请求地址 https://219.136.31.124/index.php/push_status
    NSString *url = [NSString stringWithFormat:@"%@/index.php/push_status",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    parameters[@"branch_id"] = @(0);
    data[@"baseTime"] = baseTime;
    data[@"flowType"] = flowType;
    NSDictionary *platDict = [plat mj_keyValuesWithKeys:@[@"Id",@"name"]];
    NSDictionary *ruleDict = [rule mj_keyValuesWithKeys:@[@"Id",@"name",@"push"]];
    data[@"plat"] = platDict;
    data[@"rule"] = ruleDict;
    data[@"timeRange"] = timeRange?timeRange:@"lastWeek";
    parameters[@"data"] = data;
    parameters[@"opr"] = @"getPushFlowTrend";
    
    //3 发送请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //判断失败
        if (error) {
            competation(nil,error);
            return ;
        }
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if (dict == nil) {
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            competation(nil,error);
            
            return;
        }
        
        if(dict[@"data"])
        {
            competation(dict[@"data"],nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"参数错误" code:-1 userInfo:dict[@"msg"]];
            
            competation(nil,error);
        }
    }];
}



/**获取搜索分析中的排行*/
+(void)requestForSearchWordRank:(NSString *)server time_type:(NSString *)time_type opr:(NSString *)opr competation:(void(^)(NSArray *,NSError *))competation
{
    
    //1 构造请求地址 https://218.20.44.68/index.php/source_status
    NSString *url = [NSString stringWithFormat:@"%@/index.php/source_status",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"branch_id"] = @(0);
    parameters[@"id"] = @(-1);
    parameters[@"name"] = @"/全部";
    parameters[@"opr"] = opr;
    parameters[@"time_type"] = time_type;
    parameters[@"type"] = @"所有";
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        
        //判断失败
        if (error) {
            competation(nil,error);
            return ;
        }
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if (dict == nil) {
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            competation(nil,error);
            
            return;
        }
        
        if(dict[@"data"])
        {
            competation(dict[@"data"],nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"参数错误" code:-1 userInfo:dict[@"msg"]];
            
            competation(nil,error);
        }
        
    }];
}




/**获取黑名单*/
+(void)requestForBlackList:(NSString *)server search:(NSString *)search start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray *array,NSError *error))competation
{
    //1 构造请求地址 https://218.20.44.68/index.php/blacklist
    NSString *url = [NSString stringWithFormat:@"%@/index.php/blacklist",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"direction"] = @"ASC";
    parameters[@"limit"] = @(limit);
    parameters[@"opr"] = @"list";
    parameters[@"search"] = search;
    parameters[@"sort"] = @"addTime";
    parameters[@"start"] = @(start);
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        
        //判断失败
        if (error) {
            competation(nil,error);
            return ;
        }
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if (dict == nil) {
            NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
            competation(nil,error);
            
            return;
        }
        
        if(dict[@"data"])
        {
            competation(dict[@"data"],nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"参数错误" code:-1 userInfo:dict[@"msg"]];
            
            competation(nil,error);
        }
        
    }];
}


/**操作黑名单*/
+(void)requestForOperateBlackList:(NSString *)server opr:(WMBlackListOperation )opr blackList:(WMBlackListModel *)blackList competation:(void(^)(BOOL success))competation
{
    //1 构造请求地址 https://218.20.44.68/index.php/blacklist
    NSString *url = [NSString stringWithFormat:@"%@/index.php/blacklist",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (opr == WMBlackListOperationDelete) {
        NSDictionary *data = [blackList mj_keyValuesWithKeys:@[@"addTime",@"event",@"mac",@"releaseTime"]];
        parameters[@"opr"] = @"delete";
        parameters[@"data"] = @[data];
    }else{
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        NSDictionary *time_length = [blackList mj_keyValuesWithKeys:@[@"rate",@"unit"]];
        data[@"mac"] = blackList.mac;
        data[@"time_length"] = time_length;
        parameters[@"opr"] = @"add";
        parameters[@"data"] = data;
    }
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        
        //判断失败
        if (error) {
            competation(NO);
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(NO);
            return;
        }
        
        BOOL success = [dict[@"success"] boolValue];
        
        competation(success);
        
    }];
    
}



/**新增全局排除地址*/
+(void)requestForAddGlobalExIP:(NSString *)server descirption:(NSString *)desc iplist:(NSString *)iplist competation:(void(^)(BOOL success,NSString *info))competation
{
    //1 构造请求地址 https://218.20.44.68/index.php/sys_exclude_addr
    NSString *url = [NSString stringWithFormat:@"%@/index.php/sys_exclude_addr",server];
    
    //2 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    parameters[@"opr"] = @"add";
    data[@"discription"] = desc;
    data[@"iplist"] = iplist;
    parameters[@"data"] = data;
    
    //3 发起请求
    [self request:CMRequestTypePost url:url parameters:parameters competation:^(id result, NSError *error) {
        //判断失败
        if (error) {
            competation(NO,@"请求失败");
            return ;
        }
        
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(NO,@"添加失败，重试");
            return;
        }
        
        BOOL success = [dict[@"success"] boolValue];
        if (success) {
            competation(success,nil);
        }else{
            competation(success,[dict[@"msg"] firstObject]);
        }
    }];
    
}



/**检查新版本*/
+(void)checkNewVersion:(void(^)(BOOL isNewVersion))competation
{
    NSString *url = @"http://chmn.applinzi.com/chmn.php?opr=get_new_version";
    [self request:CMRequestTypeGet url:url parameters:nil competation:^(id result, NSError *error) {
        
        if (error) {
            competation(NO);
        }
        //JSON序列化
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (dict == nil) {
            competation(NO);
            return;
        }
        
        BOOL isNewVersion = [dict[@"avaible"] boolValue];
         
        competation(isNewVersion);

        
    }];
}




@end

















