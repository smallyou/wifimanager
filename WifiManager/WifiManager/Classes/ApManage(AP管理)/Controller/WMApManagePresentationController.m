//
//  WMPresentationController.m
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApManagePresentationController.h"

@interface WMApManagePresentationController ()

@property(nonatomic,weak) UIView *cover;

@end

@implementation WMApManagePresentationController

-(void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    
    // 设置尺寸位置
    self.presentedView.frame = self.presentedRect;
    
    
    // 添加蒙板
    UIView *cover = [[UIView alloc]init];
    cover.frame = self.containerView.bounds;
    cover.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.containerView insertSubview:cover atIndex:0];
    self.cover = cover;
    
}


@end
