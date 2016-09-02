//
//  UIBarButtonItem+CMExtension.m
//  01-WifiManager
//
//  Created by 陈华 on 16/8/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "UIBarButtonItem+CMExtension.h"

@implementation UIBarButtonItem (CMExtension)

/**快速创建UIBarButtonItem*/
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = button.bounds;
    [contentView addSubview:button];
    return [[UIBarButtonItem alloc]initWithCustomView:contentView];
}

/**快速创建返回按钮*/
+(UIBarButtonItem *)backWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:WMColor(97, 97, 97) forState:UIControlStateNormal];
    [button setTitleColor:WMColor(86, 171, 228) forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = button.bounds;
    [contentView addSubview:button];
    return [[UIBarButtonItem alloc]initWithCustomView:contentView];
}


@end
