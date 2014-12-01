//
//  NLOrderPayForthViewController.m
//  TongFubao
//
//  Created by MD313 on 13-10-8.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLOrderPayForthViewController.h"
#import "NLUtils.h"
#import "NLProtocolRequest.h"
#import "NLProgressHUD.h"
#import "GTMBase64.h"
#import "UPPayPlugin.h"
#import "NLTransferResultViewController.h"

typedef enum
{
	OrderPayForth_Star = 0,
	OrderPayForth_Bank
}OrderPayForthRequestType;

@interface NLOrderPayForthViewController ()
{
    NLProgressHUD* _hud;
    OrderPayForthRequestType _requestType;
    NSString* _bkntno;
    NSString* _result;
}

@property(nonatomic,strong)IBOutlet UILabel* myLabel;
@property(nonatomic,strong)IBOutlet UIButton* myButton;

-(IBAction)onButtonBtnClicked:(id)sender;

@end

@implementation NLOrderPayForthViewController

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
    self.navigationController.topViewController.title = @"个人信用";
    _requestType = OrderPayForth_Star;
    _result = @"";
    [self orderPayBankCardStar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onButtonBtnClicked:(id)sender
{
    _requestType = OrderPayForth_Bank;
    [self orderPayReq];
}

-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    
    return;
}

-(void)doOrderPayBankCardStarNotify:(NLProtocolResponse*)response
{
//    NLProtocolData* data = nil;
//    if (_requestType == OrderPayForth_Star)
//    {
        NLProtocolData*data = [response.data find:@"msgbody/bankcardstar" index:0];
        if (data.value == nil || data.value.length <= 0)
        {
            self.myLabel.text = @"未知";
        }
        else
        {
            self.myLabel.text = data.value;
        }
//    }
//    else if (_requestType == OrderPayForth_Bank)
//    {
//        data = [response.data find:@"msgbody/bkntno" index:0];
//        NSLog(@"bkntno = %@",data.value);
//    }
}

-(void)orderPayBankCardStarNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    NSString* detail = response.detail;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self doOrderPayBankCardStarNotify:response];
        [_hud hide:YES];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)orderPayBankCardStar
{
    NSString* name = [NLUtils getNameForRequest:Notify_orderPayBankCardStar];
    REGISTER_NOTIFY_OBSERVER(self, orderPayBankCardStarNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] orderPayBankCardStar:[self.myDictionary objectForKey:@"orderid"]
                                                                   orderno:[self.myDictionary objectForKey:@"orderno"]
                                                                  paymoney:[self.myDictionary objectForKey:@"ordermoney"]
                                                                bankcardno:[self.myDictionary objectForKey:@"cardno"]
                                                                  bankname:[self.myDictionary objectForKey:@"bankname"]];
    [self showErrorInfo:nil status:NLHUDState_None];
}

-(void)doOrderPayReqNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/bkntno" index:0];
    data = [response.data find:@"msgbody/bkntno" index:0];
    _bkntno = data.value;
    [_hud hide:YES];
    [self doStartPay:_bkntno
          sysProvide:nil
                spId:nil
                mode:[NLUtils get_req_bkenv]
      viewController:self
            delegate:self];
}

-(void)orderPayReqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    NSString* detail = response.detail;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self doOrderPayReqNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)orderPayReq
{
    NSString* name = [NLUtils getNameForRequest:Notify_orderPayReq];
    REGISTER_NOTIFY_OBSERVER(self, orderPayReqNotify, name);
    NSString* str = [self.myDictionary objectForKey:@"merReserved"];
    NSData* data = [NLUtils stringToData:str];
    NSString* base64Str = [GTMBase64 stringByEncodingData:data];
    [[[NLProtocolRequest alloc] initWithRegister:YES] orderPayReq:[self.myDictionary objectForKey:@"orderid"]
                                                          orderno:[self.myDictionary objectForKey:@"orderno"]
                                                         paymoney:[self.myDictionary objectForKey:@"ordermoney"]
                                                       bankcardno:[self.myDictionary objectForKey:@"cardno"]
                                                         bankname:[self.myDictionary objectForKey:@"bankname"]
                                                      merReserved:base64Str];
    [self showErrorInfo:nil status:NLHUDState_None];
}

-(void)doOrderPayFeedbackNotify:(NLProtocolResponse*)response
{
    NSRange range = [_result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
        
        [self createInforForResultView:vc];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)orderPayFeedbackNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doOrderPayFeedbackNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
//        if ([detail isEqualToString:@"支付失败!"])
//        {
//            [self performSelector:@selector(showMainView) withObject:nil afterDelay:2.0f];
//            
//        }
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)orderPayFeedback
{
    NSString* name = [NLUtils getNameForRequest:Notify_orderPayFeedback];
    REGISTER_NOTIFY_OBSERVER(self, orderPayFeedbackNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] orderPayFeedback:_result bkntno:_bkntno];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
//    NSString* msg = [NSString stringWithFormat:@"支付结果：%@", result];
//    [self showErrorInfo:msg status:NLHUDState_None];
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"cancel"] || [result isEqualToString:@"fail"])
    {
        _result = result;
    }
    else
    {
        return;
    }
    [self orderPayFeedback];
}

- (BOOL)doStartPay:(NSString *)payData sysProvide:(NSString*)sysProvide spId:(NSString*)spId mode:(NSString*)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate;
{
    return [UPPayPlugin startPay:payData mode:mode viewController:viewController delegate:delegate];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

-(void)createInforForResultView:(NLTransferResultViewController*)vc
{
    vc.myNavigationTitle = @"订单支付结果";
    vc.myTitle = @"订单支付成功";
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", [self.myDictionary objectForKey:@"bankname"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", [self.myDictionary objectForKey:@"cardno"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款金额",@"header", [self.myDictionary objectForKey:@"ordermoney"],@"content", nil];
    [arr addObject:dic];
    vc.myArray = [NSArray arrayWithArray:arr];    
}

-(void)showMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
