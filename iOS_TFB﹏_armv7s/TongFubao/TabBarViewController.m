//
//  TabBarViewController.m
//  TabBarAndReturn
//
//  Created by Delpan on 14-6-26.
//  Copyright (c) 2014年 Delpan. All rights reserved.
//


#import "TabBarViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ButtonTag 10000001

@interface TabBarViewController ()
{
    NSInteger currentHeight;
    //当前页面的视图控制器
    UIViewController *currentController;
    //视图控制器按扭的父视图
    UIView *_currentView;
    //视图控制器大小
    CGRect controllerRect;
}

@end

@implementation TabBarViewController

@synthesize viewControllers = _viewControllers;
@synthesize controllerName = _controllerName;
@synthesize controllerColor = _controllerColor;
@synthesize controllerFont = _controllerFont;
@synthesize backgroundImage = _backgroundImage;
@synthesize selectImage = _selectImage;
@synthesize currentView = _currentView;
@synthesize buttonBorderColor = _buttonBorderColor;

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    if (self = [super init])
    {
        _viewControllers = viewControllers;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

    ViewControllerProperty;
    
#endif
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //当前高度
    currentHeight = iphoneSize;
    
    //设置视图控制器的大小
    controllerRect = CGRectMake(0, 0, SelfWidth, currentHeight - 69);
    
    //加载相应的视图控制器
    [self subViewControllers];
    
    //生成视图控制器切换按扭底图
    [self createViewControllerBasicView];
    
    //获取当前的视图控制器
    currentController = _viewControllers[0];
    
    //生成视图控制器切换按扭
    [self createViewControllerBtn];
}

#pragma mark - 加载相应的视图控制器
- (void)subViewControllers
{
    for (int i = _viewControllers.count - 1; i >= 0; i--)
    {
        UIViewController *controller = _viewControllers[i];
        controller.view.frame = controllerRect;
        [self.view addSubview:controller.view];
        
        controller.view.hidden = i == 0? NO : YES;
    }
}

#pragma mark - 生成视图控制器切换按扭底图
- (void)createViewControllerBasicView
{
    _currentView = [[UIView alloc] initWithFrame:CGRectMake(0, currentHeight - 69, SelfWidth, 49)];
    _currentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_currentView];
}

#pragma mark - 生成视图控制器切换按扭
- (void)createViewControllerBtn
{
    //生成按扭
    for (NSInteger i = 0; i < _viewControllers.count; i++)
    {
        UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        viewBtn.frame = CGRectMake(SelfWidth / _viewControllers.count * i, 0, SelfWidth / _viewControllers.count, 49);
        viewBtn.tag = ButtonTag + i;
        viewBtn.layer.borderWidth = 0.25;
        [viewBtn addTarget:self action:@selector(viewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_currentView addSubview:viewBtn];
        
        //设置按扭边框颜色
        viewBtn.layer.borderColor = _buttonBorderColor? _buttonBorderColor.CGColor : [UIColor grayColor].CGColor;
        
        //设置按扭名称
        [viewBtn setTitle:(_controllerName? _controllerName[i] : nil) forState:UIControlStateNormal];
        
        //设置按扭字体颜色
        [viewBtn setTitleColor:(_controllerColor? _controllerColor : nil) forState:UIControlStateNormal];
        
        //设置按扭字体大小
        viewBtn.titleLabel.font = _controllerFont? _controllerFont : [UIFont systemFontOfSize:10.0];
        
        //设置按扭背景图片
        if (_backgroundImage)
        {
            [viewBtn setBackgroundImage:_backgroundImage[i] forState:UIControlStateNormal];
            
            if (_selectImage)
            {
                viewBtn.selected = i == 0? YES : NO;
                
                [viewBtn setBackgroundImage:_selectImage[i] forState:UIControlStateSelected];
            }
        }
    }
}

#pragma mark - 视图控制器切换
- (void)viewBtnAction:(UIButton *)sender
{
    if (_backgroundImage)
    {
        for (int i = 0; i < _backgroundImage.count; i++)
        {
            UIButton *btn = (UIButton *)_currentView.subviews[i];
            btn.selected = NO;
        }
        
        sender.selected = YES;
    }
    
    //获取将切换的视图控制器
    UIViewController *changeController = (UIViewController *)[_viewControllers objectAtIndex:sender.tag - ButtonTag];
    
    if (changeController != currentController)
    {
        currentController.view.hidden = !currentController.view.hidden;
        changeController.view.hidden = !changeController.view.hidden;
        
        currentController = changeController;
    }
}

@end











