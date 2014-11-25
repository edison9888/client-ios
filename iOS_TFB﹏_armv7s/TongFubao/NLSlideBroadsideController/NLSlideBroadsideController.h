//
//  NLSlideBroadsideController.h
//  NLUitlsLib
//
//  Created by MD313 on 13-8-12.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    NLSlideBroadsideCenterControllerMenuLeft=0,
    NLSlideBroadsideCenterControllerMenuRight
} NLSlideBroadsideCenterControllerMenuType;

@interface NLSlideBroadsideController : NSObject

/***
 创建滑动侧边控件
 centerViewController － 中间视窗控件
 leftDrawerViewController － 左边视窗控件
 rightDrawerViewController － 右边视窗控件
 leftWidth － 左边视窗控件的宽度(100 <= leftWidth <= 320)
rightWidth － 左边视窗控件的宽度(100 <= rightWidth <= 320)
 */
-(id)initWithCenterViewController:(UIViewController *)centerViewController
         leftDrawerViewController:(UIViewController *)leftDrawerViewController
        rightDrawerViewController:(UIViewController *)rightDrawerViewController
                        leftWidth:(float)leftWidth
                       rightWidth:(float)rightWidth;

/***
 创建中间视窗导航控件上的左按钮
 target － 回调地址
 action － 回调函数
 */
-(id)setupNavigationItemMenuButton:(id)target action:(SEL)action;

/***
 导航控件上的左右按钮点击事件
 type － 左或者右钮
 viewController － 中间视窗控件
 */
-(void)onDrawerButtonPressed:(NLSlideBroadsideCenterControllerMenuType)type
              viewController:(UIViewController*)viewController;

/***
 显示中间视窗控件
 centerViewController － 中间视窗控件
 viewController － 侧边视窗控件
 */
-(void)showCenterView:(UIViewController*)centerViewController viewController:(UIViewController*)viewController;

/***
 是否可以滑动侧边视窗控件
 centerViewController － 中间视窗控件
 viewController - 是否可以滑动侧边视窗控件
 type － 左或者右视窗
 viewController － 中间视窗控件
 */
-(void)enableSliderViewController:(UIViewController*)centerViewController
                   viewController:(UIViewController*)viewController
                             type:(NLSlideBroadsideCenterControllerMenuType)type
                           enable:(BOOL)enable;

/**
 设置右边控制器 */
-(void)sliderViewController:(UIViewController *)centerViewController setRightViewController:(UIViewController *)rightViewCtr;

- (void)sliderViewController:(UIViewController *)centerViewController setleftViewController:(UIViewController *)leftViewCtr;

@end
