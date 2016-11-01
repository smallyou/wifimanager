//
//  WMApAnimatorTool.h
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>






@interface WMApAnimatorTool : NSObject <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>


// 设置弹出view的大小
@property(nonatomic,assign) CGRect presentedRect;

// 当前点击cell的indexPath
@property(nonatomic,strong) NSIndexPath *indexPath;



@end
