//
//  WMApAnimatorTool.m
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApAnimatorTool.h"
#import "WMApManagePresentationController.h"

@interface WMApAnimatorTool()

/**标记当前是否为显示动画*/
@property(nonatomic,assign) BOOL isPresented;

@end

@implementation WMApAnimatorTool


#pragma mark - UIViewControllerTransitioningDelegate

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    WMApManagePresentationController *vc = [[WMApManagePresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    vc.presentedRect = self.presentedRect;
    return vc;
}




/**重写，用来设置显示动画*/
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresented = YES;
    return self;
}

/**重写，用来设置消失动画*/
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresented = NO;
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

/**设置动画事件*/
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

/**设置动画*/
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.isPresented ? [self setupPresentedAnimation:transitionContext] : [self setupDismissedAnimation:transitionContext];
}

#pragma mark - 封装具体的动画
/**设置显示动画的具体实现过程*/
-(void)setupPresentedAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1 获取当前正要显示的presentedView
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //2 将presentedView添加到containerView上
    [[transitionContext containerView] addSubview:presentedView];
    
    //3 设置动画
    presentedView.alpha = 0.0001;
    presentedView.transform = CGAffineTransformMakeScale(1.0, 0.00001);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        presentedView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        
        presentedView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
       //告诉上下文，动画结束
        [transitionContext completeTransition:YES];
    }];
    
}

/**设置消失动画的具体实现过程*/
-(void)setupDismissedAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1 获取当前正要显示的presentedView
    UIView *dismissedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //2 将dismissedView添加到containerView上
    [[transitionContext containerView] addSubview:dismissedView];
    
    //3 设置动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        dismissedView.alpha = 0.00001;
        dismissedView.transform = CGAffineTransformMakeScale(1, 0.00001);
        
    } completion:^(BOOL finished) {
        
        //移除dismissedView
        [dismissedView removeFromSuperview];
        //告诉上下文，动画结束
        [transitionContext completeTransition:YES];
        
    }];
}




@end
