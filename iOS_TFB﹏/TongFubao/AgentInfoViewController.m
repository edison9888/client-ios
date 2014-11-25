//
//  AgentInfoViewController.m
//  TongFubao
//
//  Created by Delpan on 14-7-23.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AgentInfoViewController.h"

@interface AgentInfoViewController ()
{
    BOOL activation;
    
    NSInteger currentHeight;
}

@end

@implementation AgentInfoViewController

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
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"服务信息";
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    //返回按扭
    UIButton *backBtn = [NLUtils createNavigationLeftBarButtonImage];
    [backBtn setBackgroundImage:imageName(@"navigationLeftBtnBack2@2x", @"png") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    //加载数据
    [self loadData];
}

#pragma mark - 返回操作
- (void)backBtnAction:(UIButton *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - 数据请求
- (void)loadData
{
    //创建通知名
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentInfo];
    //创建通知
    REGISTER_NOTIFY_OBSERVER(self, getDataWithNotify, name);
    //发送请求
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentInfo];
}

#pragma mark - 数据判断
- (void)getDataWithNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    //判断信息是否正确
    if (RSP_NO_ERROR == error)
    {
        [self getDataWithResponse:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        activation = NO;
        
        [self createLabelWith:nil agentarea:nil];
    }
}

#pragma mark - 获取数据
- (void)getDataWithResponse:(NLProtocolResponse *)response
{
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"%@",errorData);
    }
    else
    {
        activation = YES;
        
        NSArray *agentids = [response.data find:@"msgbody/agentno"];
        NSArray *agentareas = [response.data find:@"msgbody/agentarea"];
        
        [self createLabelWith:agentids agentarea:agentareas];
    }
}

#pragma mark - 提示文本
- (void)createLabelWith:(NSArray *)agentids agentarea:(NSArray *)agentarea
{
    if (!activation)
    {
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, currentHeight - 400, 260, 80)];
        errorLabel.opaque = YES;
        errorLabel.backgroundColor = [UIColor clearColor];
        errorLabel.textColor = [UIColor blackColor];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.text = @"您还没有激活服务";
        errorLabel.font = [UIFont systemFontOfSize:25.0];
        errorLabel.numberOfLines = 0;
        [self.view addSubview:errorLabel];
    }
    else
    {
        NLProtocolData *data_1 = agentids[0];
        NLProtocolData *data_2 = agentarea[0];
        
        //代理商ID
        NSMutableString *agentidLabelText = [NSMutableString stringWithFormat:@"服务代号："];
        
        if (data_1.value)
        {
            [agentidLabelText appendString:data_1.value];
        }
        
        //代理商地区
        NSMutableString *agentareaLabelText = [NSMutableString stringWithFormat:@"服务地区："];
        
        if (data_2.value)
        {
            [agentareaLabelText appendString:data_2.value];
        }
        
        UILabel *agentidLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, currentHeight - 500, 260, 80)];
        agentidLabel.opaque = YES;
        agentidLabel.backgroundColor = [UIColor clearColor];
        agentidLabel.textColor = [UIColor blackColor];
        agentidLabel.text = agentidLabelText;
        agentidLabel.font = [UIFont systemFontOfSize:25.0];
        agentidLabel.numberOfLines = 0;
        [self.view addSubview:agentidLabel];
        
        UILabel *agentAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, currentHeight - 440, 260, 80)];
        agentAreaLabel.opaque = YES;
        agentAreaLabel.backgroundColor = [UIColor clearColor];
        agentAreaLabel.textColor = [UIColor blackColor];
        agentAreaLabel.text = agentareaLabelText;
        agentAreaLabel.font = [UIFont systemFontOfSize:25.0];
        agentAreaLabel.numberOfLines = 0;
        [self.view addSubview:agentAreaLabel];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
