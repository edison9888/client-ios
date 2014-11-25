//
//  NLSlideBroadsideController.m
//  NLUitlsLib
//
//  Created by MD313 on 13-8-12.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLSlideBroadsideController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@implementation NLSlideBroadsideController

-(id)initWithCenterViewController:(UIViewController *)centerViewController
         leftDrawerViewController:(UIViewController *)leftDrawerViewController
        rightDrawerViewController:(UIViewController *)rightDrawerViewController
                        leftWidth:(float)leftWidth
                       rightWidth:(float)rightWidth
 
{
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:centerViewController
                                             leftDrawerViewController:leftDrawerViewController
                                             rightDrawerViewController:rightDrawerViewController];
    if (leftWidth > 100)
    {
        [drawerController setMaximumLeftDrawerWidth:leftWidth];
    }
    if (rightWidth > 100)
    {
        [drawerController setMaximumRightDrawerWidth:rightWidth];
    }
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    return (id)drawerController;
}

-(id)setupNavigationItemMenuButton:(id)target action:(SEL)action
{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:target action:action];
    return (id)leftDrawerButton;
}

-(void)onDrawerButtonPressed:(NLSlideBroadsideCenterControllerMenuType)type viewController:(UIViewController*)viewController
{
    switch (type)
    {
        case NLSlideBroadsideCenterControllerMenuLeft:
        {
            [viewController.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
            break;
        case NLSlideBroadsideCenterControllerMenuRight:
        {
            [viewController.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

-(void)showCenterView:(UIViewController*)centerViewController viewController:(UIViewController*)viewController
{
    [viewController.mm_drawerController setCenterViewController:centerViewController
                                             withCloseAnimation:YES
                                                     completion:nil];
    
}

-(void)enableSliderViewController:(UIViewController*)centerViewController
                   viewController:(UIViewController*)viewController
                             type:(NLSlideBroadsideCenterControllerMenuType)type
                           enable:(BOOL)enable
{
    switch (type)
    {
        case NLSlideBroadsideCenterControllerMenuLeft:
        {
            if (enable)
            {
                [centerViewController.mm_drawerController setLeftDrawerViewController:viewController];
            }
            else
            {
                [centerViewController.mm_drawerController closeDrawerAnimated:YES
                                                                         completion:^(BOOL finished)
                 {
                     [viewController.mm_drawerController setLeftDrawerViewController:nil];
                 }];
            }
        }
            break;
        case NLSlideBroadsideCenterControllerMenuRight:
        {
            if (enable)
            {
                [centerViewController.mm_drawerController setRightDrawerViewController:viewController];
            }
            else
            {
                [centerViewController.mm_drawerController closeDrawerAnimated:YES
                                                                         completion:^(BOOL finished)
                 {
                     [centerViewController.mm_drawerController setRightDrawerViewController:nil];
                 }];
            }
        }
            break;
            
        default:
            break;
    }
}

/**
 设置右边控制器 */
-(void)sliderViewController:(UIViewController *)centerViewController setRightViewController:(UIViewController *)rightViewCtr
{
    [centerViewController.mm_drawerController setRightDrawerViewController:rightViewCtr];
}

-(void)sliderViewController:(UIViewController *)centerViewController setleftViewController:(UIViewController *)leftViewCtr{
     [centerViewController.mm_drawerController setLeftDrawerViewController:leftViewCtr];
    
}

@end
