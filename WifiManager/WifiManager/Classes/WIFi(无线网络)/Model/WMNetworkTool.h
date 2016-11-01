//
//  WMNetworkTool.h
//  WifiManager
//
//  Created by 陈华 on 16/10/19.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMNetworkTool : NSObject

/**从数据库中查询无线网络*/
+(NSArray *)network:(NSDictionary *)dict;

/**将无线网络存储到数据库中*/
+(void)saveNetworks:(NSArray *)array;

/**清空无线网络*/
+(void)removeAllNetworks;

@end
