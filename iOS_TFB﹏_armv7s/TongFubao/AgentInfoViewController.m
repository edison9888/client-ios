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
    NLProgressHUD  * _hud;
    NSInteger currentHeight;
    UIButton    *treatyBtn;
    UITextField *agentnoTF;
    UILabel     *agentidLabel;
    UILabel     *agentidRightLabel;
    UILabel     *agentAreaLabel;
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

    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
    //加载数据
    [self loadData];
}

#pragma mark - 返回操作
- (void)leftItemClick:(id)sender
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
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark - 数据判断
- (void)getDataWithNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    //判断信息是否正确
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self getDataWithResponse:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
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


- (void)loadDataWithAgentNo:(NSString *)agentNo
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentInfoBind];
    REGISTER_NOTIFY_OBSERVER(self, checkDataWithNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentInfoBind:agentNo];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

- (void)checkDataWithNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self getAuthorBindAgentWithResponse:response];
    }else{
        
      
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

- (void)getAuthorBindAgentWithResponse:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    [_hud hide:YES];
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@", errorData);
    }
    else
    {
        [self showErrorInfo:@"激活成功" status:NLHUDState_NoError];
        
        [treatyBtn setHidden:YES];
        [agentnoTF setHidden:YES];
        [agentidRightLabel setHidden:YES];
        
        [NLUtils setRelateAgent:@"1"];
        //加载数据
        [self loadData];
    }
}

#pragma mark - 提示文本
- (void)createLabelWith:(NSArray *)agentids agentarea:(NSArray *)agentarea
{
    if (!activation)
    {
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 260, 80)];
        errorLabel.opaque = YES;
        errorLabel.backgroundColor = [UIColor clearColor];
        errorLabel.textColor = [UIColor blackColor];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.text = @"您还没有激活服务";
        errorLabel.font = [UIFont systemFontOfSize:18.0];
        errorLabel.numberOfLines = 0;
        [self.view addSubview:errorLabel];
    }
    else
    {
        agentidLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 260, 80)];
        agentidLabel.opaque = YES;
        agentidLabel.backgroundColor = [UIColor clearColor];
        agentidLabel.textColor = [UIColor blackColor];
        agentidLabel.font = [UIFont systemFontOfSize:18.0];
        agentidLabel.numberOfLines = 0;
        [self.view addSubview:agentidLabel];
        
        agentAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 260, 80)];
        agentAreaLabel.opaque = YES;
        agentAreaLabel.backgroundColor = [UIColor clearColor];
        agentAreaLabel.textColor = [UIColor blackColor];
        agentAreaLabel.font = [UIFont systemFontOfSize:18.0];
        agentAreaLabel.numberOfLines = 0;
        [self.view addSubview:agentAreaLabel];
        
        NLProtocolData *agentnoData = agentids[0];
        NLProtocolData *agentareaData = agentarea[0];
        
        //代理商ID
        NSMutableString *agentidLabelText = [NSMutableString stringWithFormat:@"服务代号："];
        [agentidLabelText appendString:agentnoData.value];
        
        //代理商地区
        NSMutableString *agentareaLabelText = [NSMutableString stringWithFormat:@"服务区域："];
        
        if (agentareaData.value)
        {
            [agentareaLabelText appendString:agentareaData.value];
        }
        
        agentidLabel.text = agentidLabelText;
        agentAreaLabel.text = agentareaLabelText;
   
        if ([agentnoData.value isEqualToString:@"020001"])
        {
            /*本部*/
            [self addRightButtonItemWithTitle:@"编辑"];
            
        }
    }
}

/*编辑*/
-(void)rightItemClick:(id)sender{
    
    [agentAreaLabel setHidden:YES];
    [agentidLabel setHidden:YES];
    [agentAreaLabel removeFromSuperview];
    [self addRightButtonItemWithTitle:nil];
   
    agentidRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 100, 40)];
    agentidRightLabel.text= @"服务代号：";
    agentidRightLabel.opaque = YES;
    agentidRightLabel.backgroundColor = [UIColor clearColor];
    agentidRightLabel.textColor = [UIColor blackColor];
    agentidRightLabel.font = [UIFont systemFontOfSize:18.0];
    agentidRightLabel.numberOfLines = 0;
    [self.view addSubview:agentidRightLabel];
    
    agentnoTF = [[UITextField alloc]initWithFrame:CGRectMake(105, 25, 200, 35)];
    agentnoTF.placeholder = @"请输入服务代号";
    agentnoTF.textAlignment = UITextAlignmentCenter;
    agentnoTF.layer.cornerRadius = 5;
    agentnoTF.layer.borderWidth = 1.0;
    agentnoTF.layer.borderColor = SACOLOR(196, 1.0).CGColor;
    agentnoTF.backgroundColor = [UIColor whiteColor];
    agentnoTF.keyboardType = UIKeyboardTypeNumberPad;
    agentnoTF.textColor = [UIColor grayColor];
    agentnoTF.delegate= self;
    [self.view addSubview:agentnoTF];
    
    treatyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    treatyBtn.opaque = YES;
    treatyBtn.frame = CGRectMake(16, 85, 288, 40);
    [treatyBtn setTitle:@"完成提交" forState:UIControlStateNormal];
    [treatyBtn setBackgroundImage:[UIImage imageNamed:@"next_press.png"] forState:UIControlStateNormal];
    [treatyBtn setTintColor:[UIColor whiteColor]];
    treatyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [treatyBtn addTarget:self action:@selector(AddRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:treatyBtn];

}

-(void)AddRightAction:(UIButton*)sender
{
    if ([self checkData]) {
        [self.view endEditing:YES];
        [self loadDataWithAgentNo:agentnoTF.text];
    }
}



-(BOOL)checkData
{
    BOOL check = YES;
    if (agentnoTF.text.length<6) {
        [self showErrorInfo:@"请输入正确的支付服务代号" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    return check;
}


//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{

    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = detail;
            [_hud show:YES];
        }
            
        default:
            break;
    }
    return;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if (textField== agentnoTF) {
        
        if([[textField text] length] - range.length + string.length > 6)
        {
            retValue=NO;
        }
    }
    return retValue;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [agentnoTF resignFirstResponder];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
