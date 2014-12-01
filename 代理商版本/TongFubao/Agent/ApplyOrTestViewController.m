//
//  ApplyOrTestViewController.m
//  TongFubao
//
//  Created by Delpan on 14-7-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ApplyOrTestViewController.h"
#import "ApplyAgentViewController.h"
#import "TFAgentMainCtr.h"

@interface ApplyOrTestViewController ()
{
    NSInteger currentHeight;
    
}

@end

@implementation ApplyOrTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化视图
    [self initView];
}

#pragma mark - 初始化视图
- (void)initView
{
    UIImage *contentImage = imageName(@"bg@2x", @"png");
    
    self.view.layer.contents = (__bridge id)contentImage.CGImage;
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];

    self.title= @"代理商";
    //一键体验
    UIButton *tasteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tasteBtn.opaque = YES;
    tasteBtn.frame = CGRectMake(10, currentHeight - 114, 140, 35);
    [tasteBtn setTitle:@"一键体验" forState:UIControlStateNormal];
    [tasteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tasteBtn setBackgroundImage:imageName(@"yellowbtn_normal@2x", @"png") forState:UIControlStateNormal];
    [tasteBtn addTarget:self action:@selector(tasteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tasteBtn];
    
    //正式申请
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.opaque = YES;
    applyBtn.frame = CGRectMake(170, currentHeight - 114, 140, 35);
    [applyBtn setTitle:@"正式申请" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn setBackgroundImage:imageName(@"bluebtn_normal@2x", @"png") forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
}

#pragma mark - 正式申请
- (void)applyBtnAction:(UIButton *)sender
{
    ApplyAgentViewController *applyView = [[ApplyAgentViewController alloc] init];
    [self.navigationController pushViewController:applyView animated:YES];
}

#pragma mark - 一键体验
- (void)tasteBtnAction:(UIButton *)sender
{
    [self loadDataOfAgent];
}

#pragma mark - 虚拟代理商请求
- (void)loadDataOfAgent
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentApplyInsertPartt];
    REGISTER_NOTIFY_OBSERVER(self, checkDataOfAgentNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentApplyInsertPartt];
}

- (void)checkDataOfAgentNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataOfAgentNotify:response];
    }
}

- (void)getDataOfAgentNotify:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        NLProtocolData *agentcode = [response.data find:@"msgbody/agentcode" index:0];
        NLProtocolData *agentID = [response.data find:@"msgbody/agentid" index:0];
        
        NSString *message = agentcode.value;
        
        [NLUtils setAgentid:agentID.value];
        [NLUtils setAgenttypeid:@"2"];
        
        NSLog(@"[NLUtils getAgenttypeid] = %@",[NLUtils getAgenttypeid]);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"代号" message:message delegate:self cancelButtonTitle:@"体验" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //给默认第一次的NLSlideBroadsideController赋值、、、
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SlideBroadFlag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_Agent];
    
//    UIViewController *newLeftController = [[LeftController alloc] init];
//    UIViewController *newrightSideDrawerViewController = nil;
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
//    NLSlideBroadsideController* root = [[NLSlideBroadsideController alloc] initWithCenterViewController:navigationController
//                                                                               leftDrawerViewController:newLeftController
//                                                                              rightDrawerViewController:newrightSideDrawerViewController
//                                                                                              leftWidth:240
//                                                                                             rightWidth:0];
    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.feedController = vc;
    
    [UIView
     transitionWithView:delegate.window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         delegate.window.rootViewController = (UIViewController*)navigationController;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end














