//
//  UIBarButtonItem+CMExtension.h
//  01-WifiManager
//
//  Created by 陈华 on 16/8/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CMExtension)

/**
 *  快速创建UIBarButtonItem
 *
 *  @param image     正常状态下的图片
 *  @param highImage 高亮状态下的图片
 *
 *  @return 返回一个UIBarButtomItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage title:(NSString *)title;

/**
 *  快速创建返回按钮
 *
 *  @param target    响应对象
 *  @param action    响应事件
 *  @param image     正常状态下的图片
 *  @param highImage 高亮状态下的图片
 *  @param title     标题
 *
 *  @return 返回返回按钮
 */
+(UIBarButtonItem *)backWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage title:(NSString *)title;


/**
 *  快速创建barButtonItem--文字类型
 *
 *  @param target        响应对象
 *  @param action        响应事件
 *  @param title         正常状态下的文字
 *  @param selectedTitle 选中状态下的文字
 *
 *  @return 按钮
 */
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title selectedTitle:(NSString *)selectedTitle;

@end
