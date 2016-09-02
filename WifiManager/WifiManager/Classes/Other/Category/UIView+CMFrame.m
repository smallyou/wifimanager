//
//  UIView+CMFrame.m
//  01-BuDeJie
//
//  Created by 陈华 on 16/8/4.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "UIView+CMFrame.h"

@implementation UIView (CMFrame)

/**从xib文件中加载View*/
+(instancetype)loadViewFromNib
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


-(void)setCm_x:(CGFloat)cm_x
{
    CGRect rect = self.frame;
    rect.origin.x = cm_x;
    self.frame = rect;
}

-(CGFloat)cm_x
{
    return self.frame.origin.x;
}


-(void)setCm_y:(CGFloat)cm_y
{
    CGRect rect = self.frame;
    rect.origin.y = cm_y;
    self.frame = rect;
}

-(CGFloat)cm_y
{
    return self.frame.origin.y;
}


-(void)setCm_width:(CGFloat)cm_width
{
    CGRect rect = self.frame;
    rect.size.width = cm_width;
    self.frame = rect;
    
}

-(CGFloat)cm_width
{
    return self.frame.size.width;
}


-(void)setCm_height:(CGFloat)cm_height
{
    CGRect rect = self.frame;
    rect.size.height = cm_height;
    self.frame = rect;
    
}

-(CGFloat)cm_height
{
    return self.frame.size.height;
}

-(void)setCm_centerX:(CGFloat)cm_centerX
{
    CGPoint center = self.center;
    center.x = cm_centerX;
    self.center = center;
}

-(CGFloat)cm_centerX
{
    return self.center.x;
}

-(void)setCm_centerY:(CGFloat)cm_centerY
{
    CGPoint center = self.center;
    center.y = cm_centerY;
    self.center = center;
}

-(CGFloat)cm_centerY
{
    return self.center.y;
}



@end
