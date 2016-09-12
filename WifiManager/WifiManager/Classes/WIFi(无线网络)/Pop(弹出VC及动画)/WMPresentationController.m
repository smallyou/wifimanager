//
//  WMPresentationController.m
//  WifiManager
//
//  Created by 陈华 on 16/9/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMPresentationController.h"

@interface WMPresentationController ()

@property(nonatomic,weak) UIView *cover;

@end

@implementation WMPresentationController



-(void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    //1 改变尺寸
    self.presentedView.frame = self.presentedRect;
    
    //2 添加蒙板
    UIView *cover = [[UIView alloc]init];
    cover.frame = self.containerView.bounds;
    cover.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.containerView insertSubview:cover atIndex:0];
    self.cover = cover;
    
    //3 给蒙板添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCoverView)];
    [self.cover addGestureRecognizer:tap];
    
}





#pragma mark - 事件监听
-(void)tapCoverView
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
