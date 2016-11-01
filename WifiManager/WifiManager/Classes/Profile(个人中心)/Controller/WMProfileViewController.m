//
//  WMProfileViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/10/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMProfileViewController.h"
#import "WMAccessoryCellItem.h"
#import "WMGroupItem.h"
#import "WMUserAccoutViewModel.h"
#import "CMFileTool.h"
#import "WMAlertEventViewController.h"
#import "CMNetworkManager.h"

#define CMCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

@implementation WMProfileViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取cell的显示数据
    [self getDisplayData];
    
    //获取缓存大小
    [self getCache];
}





/**获取cell的显示数据*/
-(void)getDisplayData
{
    //取出用户
    NSString *customer = [WMUserAccoutViewModel shareInstance].userAccout.customer;
    
    //第0组
    WMCellItem *item01 = [WMCellItem cellItemWithTitle:@"授权客户" leftDetail:customer image:@"auth_user"];
    WMAccessoryCellItem *item02 = [WMAccessoryCellItem cellItemWithTitle:@"告警事件" leftDetail:@"" image:@"alertEvent"];
    item02.destinationVC = [WMAlertEventViewController class];
    
    
    WMCellItem *item03 = [WMCellItem cellItemWithTitle:@"无线客服" leftDetail:@"400-878-3389" image:@"customService"];
    item03.option = ^(id obj){
        
        //打电话
        NSURL *url = [NSURL URLWithString:@"tel://400-878-3389"];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    };
    WMGroupItem *group0 = [WMGroupItem groupWithHeader:nil footer:nil cells:@[item01,item02,item03]];
    
    
    //第1组
    WMCellItem *item11 = [WMCellItem cellItemWithTitle:@"清空缓存" leftDetail:@"" image:@"clean"];
    item11.option = ^(NSString *detail){
        
        if ([detail isEqualToString:@"暂无缓存"]) {
            return ;
        }
        
        [CMFileTool cleanItemAtPath:CMCachePath competation:^{
           
            //提示
            [SVProgressHUD successWithString:@"清理完毕"];
            
            //重新计算缓存
            [self getCache];
            
        }];
    };
    
//    WMAccessoryCellItem *item12 = [WMAccessoryCellItem cellItemWithTitle:@"检查新版本" leftDetail:@"" image:@"checkUpdate"];
//    item12.option = ^(id obj){
//    
//        [SVProgressHUD showWithStatus:@"正在检查更新"];
//        
//        [CMNetworkManager checkNewVersion:^(BOOL isNewVersion) {
//        
//            if (!isNewVersion) {
//                [SVProgressHUD successWithString:@"当前版本已是最新"];
//            }else{
//                [SVProgressHUD successWithString:@"有新版本，是否更新"];
//            }
//            
//        }];
//        
//    };
    
    WMAccessoryCellItem *item13 = [WMAccessoryCellItem cellItemWithTitle:@"反馈" leftDetail:@"" image:@"feedback"];
    item13.option = ^(id obj){
        //发邮件
        NSURL *url = [NSURL URLWithString:@"mailto://smallyou@126.com"];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    };
    
    WMAccessoryCellItem *item14 = [WMAccessoryCellItem cellItemWithTitle:@"关于" leftDetail:@"联系作者" image:@"about"];
    item14.option = ^(id obj){
        //打开主页
        NSURL *url = [NSURL URLWithString:@"http://www.jianshu.com/users/ebb60643b57c/latest_articles"];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    };
    
    WMGroupItem *group1 = [WMGroupItem groupWithHeader:nil footer:nil cells:@[item11,item13,item14]];

    [self.cellItems addObject:group0];
    [self.cellItems addObject:group1];
    
}


#pragma mark - 缓存相关
/**获取缓存大小*/
-(void)getCache
{
    //获取缓存大小
    [CMFileTool getTotalSizeAtPath:CMCachePath competation:^(NSUInteger totalSize) {
        
        WMGroupItem *group = self.cellItems[1];
        WMCellItem *item =  group.cells.firstObject;
        item.leftDetail = [CMFileTool formatString:totalSize];
        
        [self.tableView reloadData];
    }];

}




@end
