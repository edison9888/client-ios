//
//  tabViewController.m
//  TongFubao
//
//  Created by  俊   on 14-7-25.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "tabViewController.h"

//设备当前版本
#define IOSVERSion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define selfWidth self.view.bounds.size.width
#define selfHeight self.view.bounds.size.height

#define StatusBar 20.0

#define ButtonTag 100001

@interface tabViewController ()
{
    //当前页面的视图控制器
    UIViewController *currentController;
    //视图控制器按扭的父视图
    UIView *_currentView;
    //视图控制器大小
    CGRect controllerRect;
}
@end

@implementation tabViewController

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif

    //设置视图控制器的大小
    controllerRect = CGRectMake(0, 0, selfWidth, selfHeight - 70);
    
    if (IOSVERSion >= 7.0)
    {
        controllerRect = CGRectMake(0, 0, selfWidth, selfHeight-49);
    }
    
    //加载相应的视图控制器
    [self subViewControllers];
    
    //生成视图控制器切换按钮底图
    [self createViewControllerBasicView];
    
    //获取当前的视图控制器
    currentController = _viewControllers[0];
    
    //生成视图控制器切换按钮
    [self createViewControllerBtn];

}

#pragma mark - 加载相应的视图控制器
- (void)subViewControllers
{
    //    NSLog(@"%s",__FUNCTION__);
    
    for (int i = _viewControllers.count - 1; i >= 0; i--)
    {
        UIViewController *controller = _viewControllers[i];
        controller.view.frame = controllerRect;
        [self.view addSubview:controller.view];
        
        if (i != 0)
        {
            controller.view.hidden = YES;
            
            continue;
        }
        
        controller.view.hidden = NO;
    }
}

#pragma mark - 生成视图控制器切换按扭底图
- (void)createViewControllerBasicView
{
    _currentView = [[UIView alloc] initWithFrame:CGRectMake(0, selfHeight - 49, selfWidth, 49)];
    _currentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_currentView];
}

#pragma mark - 生成视图控制器切换按扭
- (void)createViewControllerBtn
{
 
   
    //生成按钮
    for (NSInteger i = 0; i < _viewControllers.count; i++)
    {
        UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        viewBtn.frame = CGRectMake(selfWidth / _viewControllers.count * i, 0, selfWidth / _viewControllers.count, 49);
        viewBtn.tag = ButtonTag + i;
        viewBtn.layer.borderWidth = 0.25;
        [viewBtn addTarget:self action:@selector(viewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_currentView addSubview:viewBtn];
        
        //设置按钮边框颜色
        if (_buttonBorderColor)
        {
            viewBtn.layer.borderColor = _buttonBorderColor.CGColor;
        }
        else
        {
            viewBtn.layer.borderColor = [UIColor grayColor].CGColor;
        }
        
        //设置按钮名称
        if (_controllerName)
        {
            [viewBtn setTitle:_controllerName[i] forState:UIControlStateNormal];
        }
        
        //设置按钮字体颜色
        if (_controllerColor)
        {
            [viewBtn setTitleColor:_controllerColor forState:UIControlStateNormal];
        }
        
        //设置按钮字体大小
        if (_controllerFont)
        {
            viewBtn.titleLabel.font = _controllerFont;
        }
        
        //设置按钮背景图片
        if (_backgroundImage)
        {
            if (_selectImage)
            {
                if (i == 0)
                {
                    viewBtn.selected = YES;
                    [viewBtn setBackgroundImage:_selectImage[0] forState:UIControlStateNormal];
                    
                    continue;
                }
            }
            
            [viewBtn setBackgroundImage:_backgroundImage[i] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 视图控制器切换
- (void)viewBtnAction:(UIButton *)sender
{
    if (_backgroundImage)
    {
        [self unSelectBtnImage:sender];
    }
    
    if (_selectImage)
    {
        if (!sender.selected)
        {
            sender.selected = YES;
            [sender setBackgroundImage:_selectImage[sender.tag - ButtonTag] forState:UIControlStateNormal];
        }
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

#pragma mark - 按扭的背景
- (void)unSelectBtnImage:(UIButton *)sender
{
    //设置按钮的基本背景图片
    for (int i = 0; i < _backgroundImage.count; i++)
    {
        UIButton *btn = (UIButton *)_currentView.subviews[i];
        
        if (btn.selected)
        {
            if (btn != sender)
            {
                btn.selected = NO;
                [btn setBackgroundImage:_backgroundImage[i] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
