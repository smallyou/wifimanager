//
//  WMApDataTool.m
//  WifiManager
//
//  Created by 陈华 on 16/10/19.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApDataTool.h"
#import <FMDB.h>
#import "WMUserAccoutViewModel.h"

@implementation WMApDataTool

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
    NSString *sql_apgroup = @"CREATE TABLE IF NOT EXISTS t_apgroup (id integer PRIMARY KEY AUTOINCREMENT,groups blob NOT NULL) ";
    NSString *sql_apinfo = @"CREATE TABLE IF NOT EXISTS t_apinfo (id integer PRIMARY KEY AUTOINCREMENT,aps blob NOT NULL,name text NOT NULL) ";
    
   [_db executeUpdate:sql_apgroup];
    [_db executeUpdate:sql_apinfo];
    
}


/**从数据库中查询AP的分组信息，始终保持一个记录*/
+(NSDictionary *)apGroupInfo
{
    //创建sql
    NSString *sql = @"select * from t_apgroup";
    
    //执行sql
    FMResultSet *set = [_db executeQuery:sql]; //查询到的结果集
    if (set.next) {
        NSData *groupData = [set objectForColumnName:@"groups"];
        NSDictionary *group = [NSKeyedUnarchiver unarchiveObjectWithData:groupData];
        return group;
    }
    return nil;
}

/**将AP的分组信息存储到数据库中*/
+(void)saveAPGroupInfo:(NSDictionary *)group
{
    //存储之前,先删除数据表中的所有记录，只保持最新的
    NSString *sql_delete = @"delete from t_apgroup";
    [_db executeUpdate:sql_delete];
    
    //存储
    NSData *groupData = [NSKeyedArchiver archivedDataWithRootObject:group];
    [_db executeUpdateWithFormat:@"insert into t_apgroup(groups) values(%@)",groupData];
    
}

/**从数据库中查询AP的信息*/
+(NSArray *)apInfo:(NSDictionary *)dict
{
    //根据输入条件，构造sql
    NSMutableArray *arrayM = [NSMutableArray array];
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_apinfo ORDER BY name limit %@,%@",dict[@"start"],dict[@"limit"]];
    while (set.next) {
        NSData *apInfoData = [set objectForColumnName:@"aps"];
        NSDictionary *apInfo = [NSKeyedUnarchiver unarchiveObjectWithData:apInfoData];
        [arrayM addObject:apInfo];
    }
    return arrayM;
}

/**将AP信息存储到数据库中*/
+(void)saveApInfo:(NSArray *)array
{
    for (NSDictionary *apInfo in array) {
        NSData *apInfoData = [NSKeyedArchiver archivedDataWithRootObject:apInfo];
        [_db executeUpdateWithFormat:@"insert into t_apinfo(aps,name) values(%@,%@)",apInfoData,apInfo[@"name"]];
    }
}

/**清空AP信息*/
+(void)removeAllApInfo
{
    NSString *sql_delete = @"delete from t_apinfo";
    [_db executeUpdate:sql_delete];
}




@end
