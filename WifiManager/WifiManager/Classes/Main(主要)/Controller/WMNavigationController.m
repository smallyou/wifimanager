//
//  WMNavigationController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMNavigationController.h"

@interface WMNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation WMNavigationController

+(void)load
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.tintColor = WMColor(86, 171, 228);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    WMLog(@"%@",self.interactivePopGestureRecognizer);
    self.interactivePopGestureRecognizer.delegate = self;
    
    
    
    
}

#pragma mark - UIGestureRecognizerDelegate - 恢复系统的侧滑返回手势

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.childViewControllers.count < 2) {
        return NO;
    }
    
    return YES;
}



#pragma mark - 重写跳转方法

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //1 设置隐藏底部bar
    viewController.hidesBottomBarWhenPushed = YES;
    
    //2 设置返回按钮
    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backWithTarget:self action:@selector(backButtonItemDidClick) image:[UIImage imageNamed:@"nav_back_normal"] highImage:[UIImage imageNamed:@"nav_back_highlighted"] title:@"返回"];
    
    [super pushViewController:viewController animated:animated];
    
}

#pragma mark - 事件监听

-(void)backButtonItemDidClick
{
    //返回
    [self popViewControllerAnimated:YES];
}





@end
