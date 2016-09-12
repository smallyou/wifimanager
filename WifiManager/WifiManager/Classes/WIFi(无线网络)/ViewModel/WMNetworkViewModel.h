//
//  WMNetworkViewModel.h
//  WifiManager
//
//  Created by 陈华 on 16/9/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMNetwork.h"

@interface WMNetworkViewModel : NSObject

/**拥有模型对象*/
@property(nonatomic,strong) WMNetwork *network;


//--添加额外属性
/**cell的操作视图是否展开*/
@property(nonatomic,assign,getter=isOperationViewUnFold) BOOL operationViewUnFold;
/**接入点位置aps可显示字符串*/
@property(nonatomic,copy) NSString *apsStr;
/**认证类型auth可显示字符串*/
@property(nonatomic,copy) NSString *authStr;
/**数据模式mode可显示字符串*/
@property(nonatomic,copy) NSString *modeStr;
/**协议类型band可显示字符串*/
@property(nonatomic,copy) NSString *bandStr;



/**初始化构造方法*/
-(instancetype)initWithNetwork:(WMNetwork *)network;


@end
