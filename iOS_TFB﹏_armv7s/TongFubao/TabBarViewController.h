//
//  TabBarViewController.h
//  TabBarAndReturn
//
//  Created by Delpan on 14-6-26.
//  Copyright (c) 2014年 Delpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UIViewController

//视图控制器数
@property (nonatomic, readonly) NSArray *viewControllers;

//视图控制器名称
@property (nonatomic, copy) NSArray *controllerName;

//视图控制器名称字体
@property (nonatomic, strong) UIFont *controllerFont;

//视图控制器名称颜色
@property (nonatomic, strong) UIColor *controllerColor;

//视图控制器按扭背景
@property (nonatomic, copy) NSArray *backgroundImage;

//视图控制器按扭选择背景
@property (nonatomic, copy) NSArray *selectImage;

//视图控制器按扭的父视图
@property (nonatomic, readonly) UIView *currentView;

//视图控制器按扭边框颜色，默认是灰色
@property (nonatomic, strong) UIColor *buttonBorderColor;

- (id)initWithViewControllers:(NSArray *)viewControllers;

@end






