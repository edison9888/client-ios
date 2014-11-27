//
//  NLCashMorePay.m
//  TongFubao
//
//  Created by  俊   on 14-8-25.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NLCashMorePay.h"
#import "NLTowLinesCell.h"
#import "NLUtils.h"
#import "NLUserInforSettingsCell.h"

@interface NLCashMorePay ()
{
    int             _offset;
    NLProgressHUD  * _hud;
}
@property (weak, nonatomic) IBOutlet UITextField *MoneyStr;
@property (weak, nonatomic) IBOutlet UIButton *onbtnClick;
@end

@implementation NLCashMorePay

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
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    self.navigationController.topViewController.title = @"确认付款";
   
     [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    NSString *str= [NSString stringWithFormat:@"%f",self.view.frame.size.height-70];
    [_onbtnClick.layer setValue:str forKeyPath:@"frame.origin.y"];
    
     self.view.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    _MoneyStr.text= [NSString stringWithFormat:@"需支付金额：%@元",_couponmoneyStr];
    _MoneyStr.userInteractionEnabled= NO;

    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[_weburl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (IBAction)onBtnClick:(id)sender {
    
    [self ApiExpresspayInfoToPay];
    
}

/*汇通宝-商户收款（抵用券）交易状态显示*/
-(void)ApiExpresspayInfoToPay
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiExpresspayInfoToPay];
    REGISTER_NOTIFY_OBSERVER(self, readSKQInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiExpresspayInfoToPay:_bknordernumber];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

//刷卡器的读取选项
-(void)readSKQInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doreadSKQInfoNotify:response];
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
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//获取到的刷卡器信息选项
-(void)doreadSKQInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        [self performSelector:@selector(backPay) withObject:nil afterDelay:2];
    }
}

-(void)backPay
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)input,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    
    return
    outputStr;
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
