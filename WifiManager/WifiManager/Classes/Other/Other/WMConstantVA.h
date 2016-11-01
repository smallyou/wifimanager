//
//  WMConstantVA.h
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//
//常量文件

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/***界面布局间距*/
UIKIT_EXTERN const CGFloat margin;


/**cookies持久化*/
UIKIT_EXTERN NSString * const CMCookiesStoredKey;

/**无线网络请求数据个数*/
UIKIT_EXTERN const NSInteger CMNetworkLimit;

/**AP的统计图中，顶部视图的高度*/
UIKIT_EXTERN const CGFloat CMOptionalViewHeight;

/**导航栏的最大Y值*/
UIKIT_EXTERN const CGFloat CMNavigationBarMaxY;


#pragma mark - 认证授权相关常量
/**menuView的高度*/
UIKIT_EXTERN const CGFloat CMAuthMenuViewHeight;


#pragma mark - 推广统计相关常量 lastMonth define

/**时间周期--起始时间*/
UIKIT_EXTERN const NSString *CMAdBaseTimeStart;
/**时间周期--结束时间*/
UIKIT_EXTERN const NSString *CMAdBaseTimeEnd;

/**时间周期--最近7天*/
UIKIT_EXTERN const NSString *CMAdTimeRangeLastWeek;
/**时间周期--最近30天*/
UIKIT_EXTERN const NSString *CMAdTimeRangeLastMonth;
/**时间周期--自定义*/
UIKIT_EXTERN const NSString *CMAdTimeRangeDefine;

