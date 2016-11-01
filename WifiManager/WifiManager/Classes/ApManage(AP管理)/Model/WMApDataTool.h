//
//  WMApDataTool.h
//  WifiManager
//
//  Created by 陈华 on 16/10/19.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMApDataTool : NSObject


/**从数据库中查询AP的分组信息，始终保持一个记录*/
+(NSDictionary *)apGroupInfo;


/**将AP的分组信息存储到数据库中*/
+(void)saveAPGroupInfo:(NSDictionary *)group;


/**从数据库中查询AP的信息*/
+(NSArray *)apInfo:(NSDictionary *)dict;


/**将AP信息存储到数据库中*/
+(void)saveApInfo:(NSArray *)array;

/**清空AP信息*/
+(void)removeAllApInfo;

@end
