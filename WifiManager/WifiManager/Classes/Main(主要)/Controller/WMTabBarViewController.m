//
//  WMTabBarViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMTabBarViewController.h"

@interface WMTabBarViewController ()

@end

@implementation WMTabBarViewController

+(void)load // 86 171 228
{
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.tintColor = WMColor(86, 171, 228);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
