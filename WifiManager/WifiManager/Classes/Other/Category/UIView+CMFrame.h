//
//  UIView+CMFrame.h
//  01-BuDeJie
//
//  Created by 陈华 on 16/8/4.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CMFrame)

/**控件原点的x坐标*/
@property(nonatomic,assign) CGFloat cm_x;
/**控件原点的y坐标*/
@property(nonatomic,assign) CGFloat cm_y;
/**控件的width*/
@property(nonatomic,assign) CGFloat cm_width;
/**控件的height*/
@property(nonatomic,assign) CGFloat cm_height;
/**控件的centerX*/
@property(nonatomic,assign) CGFloat cm_centerX;
/**控件的centerY*/
@property(nonatomic,assign) CGFloat cm_centerY;

/**从xib文件中加载View*/
+(instancetype)loadViewFromNib;

@end
