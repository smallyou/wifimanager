//
//  WMWifiAnimatorTool.m
//  WifiManager
//
//  Created by 陈华 on 16/9/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMWifiAnimatorTool.h"
#import "WMPresentationController.h"

@interface WMWifiAnimatorTool () <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) BOOL isPresented; //标记当前是否为显示的动画

@end

@implementation WMWifiAnimatorTool


#pragma  mark - 实现UIViewControllerTransitaionDelegate
/**重写方法--改变弹出来的控制器尺寸*/
-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    WMPresentationController *vc = [[WMPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    vc.presentedRect = self.presentedRect;
    return vc;
}

/**显示动画*/
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresented = YES; //标记当前为显示动画
    return self;
}

/**消失动画*/
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresented = NO; //标记当前为消失动画
    return self;
}


#pragma mark - 实现UIViewControllerAnimatedTransitioning动画协议

/**设置动画时间*/
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

/**设置动画行为*/
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    //根据当前的标记，确认是执行消失动画还是显示动画
    self.isPresented ? [self presentedAnimation:transitionContext] : [self dismissedAnimation:transitionContext];
    
}

/**封装显示动画的整个过程*/
-(void)presentedAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1 根据key找到即将显示的View
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //2 将presentedView加到containerView上
    [[transitionContext containerView] addSubview:presentedView];
    
    //3 设置presentedView的尺寸改为不可见
    presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0);
    presentedView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    [transitionContext completeTransition:YES];
    
    //3 设置动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        presentedView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        //告诉上下文，结束动画
        [transitionContext completeTransition:YES];
    }];
    
}

/**封装消失动画的整个过程*/
-(void)dismissedAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1 根据key找到即将消失的View
    UIView *dismissedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //2 将dismissedView添加到containerView
    [[transitionContext containerView] addSubview:dismissedView];
    
    //3 设置动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
       
        dismissedView.transform = CGAffineTransformMakeScale(1.0, 0.00000001);
        
    } completion:^(BOOL finished) {
        
        //将dismissedView移除
        [dismissedView removeFromSuperview];
        
        //告诉上下文，动画结束
        [transitionContext completeTransition:YES];
        
    }];
    
}


@end
