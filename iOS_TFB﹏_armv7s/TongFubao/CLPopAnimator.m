//
//  CLPopAnimator.m
//  NavigationTrasionViewController
//
//  Created by 〝Cow﹏. on 14-7-3.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "CLPopAnimator.h"
#import "NLAppDelegate.h"

@implementation CLPopAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.45;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@"Hello2");
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //fromViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        toViewController.view.alpha = 1;
        UIApplication * app = [UIApplication sharedApplication];
        NLAppDelegate * appDel = app.delegate;
        appDel.mTouchView.frame = CGRectMake(appDel.mTouchPoint.x, appDel.mTouchPoint.y, 80, 80);
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

@end
