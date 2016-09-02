//
//  WMUserAccoutViewModel.m
//  WifiManager
//
//  Created by 陈华 on 16/9/1.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMUserAccoutViewModel.h"
#import "CMCookiesHandler.h"

@interface WMUserAccoutViewModel ()

@property(nonatomic,copy) NSString *path; //存储路径
@property(nonatomic,strong) id viewModel;


@end

@implementation WMUserAccoutViewModel




#pragma mark - 懒加载

-(NSString *)path{
    if (_path == nil) {
        
        //1 获取document路径
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        //2 构造存储路径
        _path = [docPath stringByAppendingPathComponent:@"accout.data"];
    }
    return _path;
}

/**判断是否登录*/
-(BOOL)isLogin
{
    //1 获取当前日期
    NSDate *nowDate = [NSDate new];
    
    //2 获取过期日期
    NSDate *expireDate = self.userAccout.timeout_date;
    
    //3 判断是否过期
    NSComparisonResult result = [nowDate compare:expireDate];
    if (result == NSOrderedAscending) {
        return YES;
    }    
    return NO;
}


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



#pragma mark - 数据存储

-(void)savedUserAccoutToSandBox
{    
    //1 将userAccout对象存储
    [NSKeyedArchiver archiveRootObject:self.userAccout toFile:self.path];
    
    //2 将cookies存储
    [CMCookiesHandler cookiesPersistence];
    
}


-(WMUserAccout *)getAccoutFromSandBox
{
    WMUserAccout * userAccout = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];
    self.userAccout = userAccout;
    return userAccout;
}



@end
