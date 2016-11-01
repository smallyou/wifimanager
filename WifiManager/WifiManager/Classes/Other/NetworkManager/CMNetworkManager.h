//
//  CMNetworkManager.h
//  网络请求封装
//
//  Created by 陈华 on 16/8/31.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMHTTPSessionManager.h"
#import "WMApInfo.h"
#import "WMApViewModel.h"
#import "WMAccessPoint.h"
#import "WMGroupAccoutModel.h"
#import "WMGuestAccoutModel.h"
@class WMCustomMenuModel,WMAdPopModel,WMBlackListModel;

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

typedef NS_ENUM(NSInteger,WMAdQueryType){
    WMAdQueryTypePushRule = 0 , //查询推送规则
    WMAdQueryTypeWechatPub //查询微信公众账号
};


typedef NS_ENUM(NSInteger,WMBlackListOperation){
    WMBlackListOperationDelete = 0, //黑名单删除操作
    WMBlackListOperationAdd = 1 //黑名单增加操作
};






@interface CMNetworkManager : NSObject

@property(nonatomic,strong) CMHTTPSessionManager * manager;


/**
 *  实现单利
 *
 *  @return 返回单利对象
 */
+(instancetype)shareInstance;


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

/**
 *  获取无线AP的信息-AP管理
 *
 *  @param server      服务器地址
 *  @param start       开始索引
 *  @param limit       每次请求数据的个数
 *  @param groupId     过滤条件--组id
 *  @param search      搜索指定的AP -- 可以为空
 *  @param competation 完成后的回调
 */
+(void)requestForApInfo:(NSString *)server start:(NSInteger)start limit:(NSInteger)limit groupId:(NSInteger)groupId search:(NSString *)search competation:(void(^)(NSError *error , NSArray *result))competation;

/**
 *  获取接入点分组信息
 *
 *  @param server      服务器地址
 *  @param competation 回调block - 返回组信息
 */
+(void)requestForGroupInfo:(NSString *)server competation:(void(^)(NSError *error , NSDictionary *groupInfo))competation;


/**
 *  修改AP的射频参数
 *
 *  @param server      服务器地址
 *  @param apInfo      AP的信息模型，用来构造请求参数
 *  @param competation 回调block
 */
+(void)modifyRadio:(NSString *)server apInfo:(WMApInfo *)apInfo competation:(void(^)(BOOL success))competation;


/**
 *  获取AP的状态-无线状态
 *
 *  @param server      服务器地址
 *  @param start       开始索引
 *  @param limit       每页请求数据的个数
 *  @param competation 完成后的回调
 */
+(void)requestForApStatus:(NSString *)server start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSDictionary *result , NSError *error))competation;


/**
 *  获取指定AP的射频信息--无线状态
 *
 *  @param ap          指定AP
 *  @param server      服务器地址
 *  @param competation 完成后的回调
 */
+(void)requestForRadioInfoWithAp:(WMAccessPoint *)ap server:(NSString *)server competation:(void(^)(NSArray *data , NSError *error))competation NS_DEPRECATED_IOS(2_0, 7_0, "Use -requestForDetailsRadioInfo:server:competation:") ;



/**
 *  获取指定AP的射频详细信息---无线状态的详细信息
 *
 *  @param ap          指定AP
 *  @param server      服务器地址
 *  @param competation 完成后的回调
 */
+(void)requestForDetailsRadioInfo:(WMAccessPoint *)ap server:(NSString *)server competation:(void(^)(NSArray *data , NSError *error))competation;




/**
 *  获取指定AP 指定频段的 信道利用率图标数据--用来绘制折线图
 *
 *  @param radio       当前AP的当前频段的射频信息
 *  @param server      服务器地址
 *  @param competation 回调
 */
+(void)requestForChannelChartData:(WMApRadio *)radio server:(NSString *)server competation:(void(^)(NSArray *data , NSError *error))competation;




/**
 *  请求本地用户以及用户组
 *
 *  @param server      服务器地址
 *  @param Id          搜索的条件（当id为用户组是，搜索的是当前组的用户；当id传入root时，搜索的是根目录下的所有组）
 *  @param start       开始索引
 *  @param competation 完成后的回调
 */
+(void)requestForLocalUserAndGroup:(NSString *)server sortId:(NSString *)Id start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray *data , NSError *error))competation;



/**
 *  删除本地用户
 *
 *  @param server      服务器地址
 *  @param accout      待删除的本地用户
 *  @param competation 完成后的回调
 */
+(void)requestForDeleteLocalAccout:(NSString *)server accout:(WMGroupAccoutModel *)accout  competation:(void(^)(BOOL success))competation;



/**
 *  获取临时访客列表
 *
 *  @param server      服务器地址
 *  @param start       开始索引
 *  @param limit       请求的限制
 *  @param competation 完成后的回调
 */
+(void)requestForTempoGuest:(NSString *)server start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray *data , NSError *error))competation;



/**
 *  重置临时访客密码
 *
 *  @param server      服务器地址
 *  @param Id          当前账号的id
 *  @param pwd         新密码
 *  @param competation 完成后的回调
 */
+(void)requestForResetTempoGuest:(NSString *)server Id:(NSString *)Id pwd:(NSString *)pwd competation:(void(^)(BOOL success))competation;



/**
 *  删除指定的临时访客账号
 *
 *  @param server      服务器地址
 *  @param accout      临时访客账号
 *  @param competation 完成后的回调
 */
+(void)requestforDeleteTempoGuest:(NSString *)server accout:(WMGuestAccoutModel *)accout competation:(void(^)(BOOL success))competation;



/**
 *  创建临时访客账号
 *
 *  @param server      服务器地址
 *  @param dict        新增的账户信息
 *  @param competation 完成后的回调
 */
+(void)requestForAddTempoGuest:(NSString *)server dict:(NSDictionary *)dict competation:(void(^)(BOOL success))competation;




/**
 *  获取区域下的客流分析数据
 *
 *  @param server      服务器地址
 *  @param area        区域(字典，有组id等构成)
 *  @param timeType    查询的时间区间，默认是最近7天
 *  @param menuModel   当前点击的菜单详情(里面包含了opr和timeRange两个重要的请求参数)
 *  @param competation 完成后的回调
 */
+(void)requestForCustomFlowData:(NSString *)server area:(NSDictionary *)area timeType:(NSString *)timeType menuModel:(WMCustomMenuModel *)menuModel competation:(void(^)(id object,NSError *error))competation;



/**
 *  加载当前的设备的告警事件
 *
 *  @param server      服务器地址
 *  @param search      搜索条件
 *  @param start       开始索引
 *  @param limit       结果个数限制
 *  @param competation 完成后的回调
 */
+(void)requestForAlertEvent:(NSString *)server search:(NSString *)search start:(NSInteger)start limit:(NSInteger)limit competation:(void(^)(NSArray *array,NSError *error))competation;


/**
 *  请求推广统计的汇总信息
 *
 *  @param server      服务器地址
 *  @param competation 完成后的回调
 */
+(void)requestForAdSummaryData:(NSString *)server competation:(void(^)(NSDictionary *dict,NSError *error))competation;


/**
 *  请求获取当前推广统计中的 对象定义 -- 定义的推送规则/微信公众平台
 *
 *  @param server      服务器地址
 *  @param oprType     查询的类型：推送规则/微信公众账号
 *  @param type        当前状态类型：在线推送/首次接入/搜索行为 等参数
 *  @param competation 完成后的回调
 */
+(void)requestForAdPushRuleOrWechatPub:(NSString *)server oprType:(WMAdQueryType)oprType type:(NSString *)type competation:(void(^)(NSArray *data,NSError *error))competation;




/**
 *  请求获取指定查询条件下，当前推广统计趋势数据
 *
 *  @param server      服务器地址
 *  @param baseTime    起始时间，key的取值 CMAdBaseTimeStart CMAdBaseTimeEnd
 *  @param flowTime    请求的统计类型：在线推送/首次接入/搜索行为 等参数
 *  @param plat        当前查询条件--微信公众平台
 *  @param rule        当前查询条件--推送规则
 *  @param timeRange   时间范围 取值 CMAdTimeRangeLastWeek CMAdTimeRangeLastMonth CMAdTimeRangeDefine
 *  @param competation 完成后的回调
 */
+(void)requestForAdFlowTrend:(NSString *)server baseTime:(NSDictionary *)baseTime flowType:(NSString *)flowType plat:(WMAdPopModel *)plat rule:(WMAdPopModel *)rule timeRange:(  const NSString * _Nullable )timeRange competation:(void(^ _Nullable )(NSArray * _Nullable data,NSError * _Nullable error))competation;


/**
 *  获取搜索分析中的排行
 *
 *  @param server      服务器地址
 *  @param time_type   时间周期
 *  @param opr         操作（搜索关键字getKeywordRank 关键字分组getKSortRank 搜索来源sourceRank）
 *  @param competation 完成后的回调
 */
+(void)requestForSearchWordRank:(NSString * _Nonnull)server time_type:(NSString * _Nonnull)time_type opr:(NSString * _Nonnull)opr competation:(void(^ _Nullable)(NSArray * _Nullable,NSError * _Nullable))competation;



/**
 *  获取黑名单
 *
 *  @param server      服务器地址
 *  @param search      搜索条件
 *  @param start       开始索引
 *  @param limit       搜索结果限制
 *  @param competation 完成后的回调   
 */
+(void)requestForBlackList:(NSString * _Nonnull)server search:(NSString * _Nullable)search start:(NSInteger)start limit:(NSInteger)limit competation:(void(^ _Nullable)(NSArray * _Nullable array,NSError * _Nullable  error))competation;


/**
 *  操作黑名单
 *
 *  @param server      服务器地址
 *  @param opr         增加还是删除的操作
 *  @param blackList   当前的黑名单对象
 *  @param competation 完成后的回调
 */
+(void)requestForOperateBlackList:(NSString * _Nonnull)server opr:(WMBlackListOperation )opr blackList:(WMBlackListModel * _Nonnull)blackList competation:(void(^ _Nullable)(BOOL success))competation;




/**
 *  新增全局排除地址
 *
 *  @param server      服务器地址
 *  @param desc        描述
 *  @param iplist      iplist
 *  @param competation 完成后的回调
 */
+(void)requestForAddGlobalExIP:(NSString * _Nonnull)server descirption:(NSString * _Nullable)desc iplist:(NSString * _Nonnull)iplist competation:(void(^ _Nullable)(BOOL success,NSString * _Nullable))competation;



/**检查新版本*/
+(void)checkNewVersion:(void(^ _Nonnull)(BOOL isNewVersion))competation;

@end





























