//
//  WMAddWechatViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/9/11.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAddWechatViewController.h"

@interface WMAddWechatViewController ()

@end

@implementation WMAddWechatViewController

#pragma mark - 设置UI
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 初始化导航栏
    [self setupNavigationBar];
    
}

/**初始化导航栏*/
-(void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelBtnClick) image:nil highImage:nil title:@"取消"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(createBtnClick) image:nil highImage:nil title:@"创建"];
    self.navigationItem.title = @"创建微信认证";
}

#pragma mark - 事件监听
/**取消按钮点击事件*/
- (void)cancelBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**创建按钮点击事件*/
-(void)createBtnClick
{
    
}

@end
