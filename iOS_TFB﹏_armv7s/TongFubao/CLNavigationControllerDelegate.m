//
//  CLNavigationControllerDelegate.m
//  NavigationTrasionViewController
//
//  Created by 〝Cow﹏. on 14-7-3.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "CLNavigationControllerDelegate.h"
#import "CLAnimator.h"
#import "NLAppDelegate.h"
#import "CLPopAnimator.h"
static NSString * PushSegueIdentifier = @"push identifier";
@interface  CLNavigationControllerDelegate()
@property (weak,nonatomic) UINavigationController * navigationController;

@property (strong,nonatomic) CLAnimator * animator;//push 动画
@property (strong,nonatomic) CLPopAnimator * popanimator;//pop 动画
@property (strong,nonatomic) UIPercentDrivenInteractiveTransition * interactionController;
@end

@implementation CLNavigationControllerDelegate

-(id)init{
    if (self = [super init])
    {
        
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"navigationLeftBtnBack2.png"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navigationLeftBtnBack2.png"]];
        UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        UIApplication * app = [UIApplication sharedApplication];
        NLAppDelegate * appDel = app.delegate;
        self.navigationController = appDel.mNavCtrl;
        [self.navigationController.view addGestureRecognizer:panRecognizer];
        self.animator = [CLAnimator new];
        self.popanimator = [CLPopAnimator new];
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer *)recognizer{
    UIView* view = self.navigationController.view;
    NSLog(@"");
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1)
        { // left half
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([recognizer velocityInView:view].x > 0)
        {
            [self.interactionController finishInteractiveTransition];
        }
        else
        {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return self.animator;
    }
    if (operation == UINavigationControllerOperationPop){
        return self.popanimator;
    }
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactionController;
}
@end
