//
//  WMNetworkTool.m
//  WifiManager
//
//  Created by 陈华 on 16/10/19.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMNetworkTool.h"
#import <FMDB.h>
#import "WMUserAccoutViewModel.h"

@implementation WMNetworkTool

static FMDatabase *_db;

+(void)initialize
{
    //打开或者创建数据库
    NSString *filename = [[WMUserAccoutViewModel shareInstance].userAccout.server stringByReplacingOccurrencesOfString:@"." withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:filename];
     
    _db = [FMDatabase databaseWithPath:path];
    if (![_db open]) {
        _db = nil;
        return;
    }
    
    //打开或者创建数据表
    NSString *sql_network = @"CREATE TABLE IF NOT EXISTS t_network (id integer PRIMARY KEY AUTOINCREMENT,networks blob NOT NULL,ssid text NOT NULL) ";
    
    [_db executeUpdate:sql_network];

    
}

/**从数据库中查询无线网络*/
+(NSArray *)network:(NSDictionary *)dict
{
    //根据输入条件，构造sql
    NSMutableArray *arrayM = [NSMutableArray array];
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_network ORDER BY ssid limit %@,%@",dict[@"start"],dict[@"limit"]];
    while (set.next) {
        NSData *apInfoData = [set objectForColumnName:@"networks"];
        NSDictionary *apInfo = [NSKeyedUnarchiver unarchiveObjectWithData:apInfoData];
        [arrayM addObject:apInfo];
    }
    return arrayM;
}


/**将无线网络存储到数据库中*/
+(void)saveNetworks:(NSArray *)array
{
    for (NSDictionary *apInfo in array) {
        NSData *apInfoData = [NSKeyedArchiver archivedDataWithRootObject:apInfo];
        [_db executeUpdateWithFormat:@"insert into t_network(networks,ssid) values(%@,%@)",apInfoData,apInfo[@"ssid"]];
    }
}

/**清空无线网络*/
+(void)removeAllNetworks
{
    NSString *sql_delete = @"delete from t_network";
    [_db executeUpdate:sql_delete];
}


@end
