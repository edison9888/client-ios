//
//  WaterEleBillSure.m
//  TongFubao
//
//  Created by ec on 14-5-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "UIViewController+NavigationItem.h"
#import "TFAgentAddgoodsBill.h"
#import "NLProgressHUD.h"
#import "NLProtocolRegister.h"
#import "NLTransferResultViewController.h"
#import "ProtocolDefine.h"
#import "NLProtocolResponse.h"
#import "NLProtocolRequest.h"
#import "NLContants.h"
#import "UPPayPlugin.h"
#import "GTMBase64.h"
#import "PayMoneyOK.h"

@interface TFAgentAddgoodsBill ()
{
    CGFloat IOS7HEIGHT;
    CGFloat ctrH;
    NLProgressHUD* _hud;
}

@property (nonatomic,strong) NSDictionary *information;

@property (nonatomic,strong) UITextField *inputTextField;
@property (nonatomic,strong) UIImageView *inputImg;

//刷卡器
@property (nonatomic,strong)  VisaReader* visaReader;

//刷卡器Id
@property (nonatomic,strong) NSString *paycardid;

//刷卡号
@property (nonatomic,strong) NSString *cardno;

//流水号
@property (nonatomic,strong) NSString *bkntno;

//刷卡后得到数据数组
@property (nonatomic,strong) NSArray *visaReaderArray;

@property (nonatomic,strong) NSString *result;

//滚动视图
@property (nonatomic,strong) UIScrollView *mainScroll;

@end

@implementation TFAgentAddgoodsBill

-(id)initWithInfor:(NSDictionary*)infor
{
    if (self = [super init])
    {
        if (infor)
        {
            _information = [NSDictionary dictionaryWithDictionary:infor];
        }
        else
        {
            _information = [NSDictionary dictionary];
        }
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
    [self UIInit];
}

-(void)UIInit
{
    //加一层 背景 防止整体向上滚的时候部分黑色
    UIView *bigV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 800)];
    bigV.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    [self.view addSubview:bigV];
    
    self.view.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    
    ctrH = [NLUtils getCtrHeight];
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    
    //初始化刷卡器
    [self initVisaReader];
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    UILabel *billInfo = [[UILabel alloc]initWithFrame:CGRectMake(16, IOS7HEIGHT+16, 95, 15)];
    billInfo.backgroundColor = [UIColor clearColor];
    billInfo.textColor = [UIColor grayColor];
    billInfo.text = @"账单信息";
    billInfo.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:billInfo];
    
    //分割线
    UIImageView *lineA = [[UIImageView alloc]initWithFrame:CGRectMake(17, IOS7HEIGHT+35, 286,2)];
    [lineA setImage:[UIImage imageNamed:@"dashed_line"]];
    [self.view addSubview:lineA];
    
    UILabel *productNameText = [[UILabel alloc]initWithFrame:CGRectMake(15, 46+IOS7HEIGHT, 100, 15)];
    productNameText.backgroundColor = [UIColor clearColor];
    productNameText.textColor = [UIColor grayColor];
    productNameText.text = @"产品名称";
    productNameText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:productNameText];
    
    UILabel *productName = [[UILabel alloc]initWithFrame:CGRectMake(115, 46+IOS7HEIGHT, 190, 15)];
    productName.backgroundColor = [UIColor clearColor];
    productName.textColor = [UIColor grayColor];
    productName.textAlignment = UITextAlignmentRight;
    productName.text = _information[@"productName"];
    productName.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:productName];
    
    UILabel *customerNumText = [[UILabel alloc]initWithFrame:CGRectMake(15, 72+IOS7HEIGHT, 100, 15)];
    customerNumText.backgroundColor = [UIColor clearColor];
    customerNumText.textColor = [UIColor grayColor];
    customerNumText.text = @"数量（台）";
    customerNumText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:customerNumText];
    
    UILabel *customerNum = [[UILabel alloc]initWithFrame:CGRectMake(115, 72+IOS7HEIGHT, 190, 15)];
    customerNum.textAlignment = UITextAlignmentRight;
    customerNum.backgroundColor = [UIColor clearColor];
    customerNum.textColor = [UIColor grayColor];
    customerNum.text = _information[@"num"];
    customerNum.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:customerNum];
    
    UILabel *billNumText = [[UILabel alloc]initWithFrame:CGRectMake(15, 98+IOS7HEIGHT, 100, 15)];
    billNumText.backgroundColor = [UIColor clearColor];
    billNumText.textColor = [UIColor grayColor];
    billNumText.text = @"进货价（元）";
    billNumText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:billNumText];
    
    UILabel *billNum = [[UILabel alloc]initWithFrame:CGRectMake(115, 98+IOS7HEIGHT, 190, 15)];
    billNum.textAlignment = UITextAlignmentRight;
    billNum.backgroundColor = [UIColor clearColor];
    billNum.textColor = [UIColor grayColor];
    billNum.text = _information[@"factBill"];
    billNum.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:billNum];
    
    
    UILabel *payMoneyText = [[UILabel alloc]initWithFrame:CGRectMake(15, 124+IOS7HEIGHT, 125, 15)];
    payMoneyText.backgroundColor = [UIColor clearColor];
    payMoneyText.textColor = [UIColor grayColor];
    payMoneyText.text = @"支付总额（元）";
    payMoneyText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:payMoneyText];
    
    UILabel *payMoney = [[UILabel alloc]initWithFrame:CGRectMake(115, 135+IOS7HEIGHT, 190, 50)];
    payMoney.textAlignment = UITextAlignmentRight;
    payMoney.font = [UIFont systemFontOfSize:39];
    payMoney.textColor = RGBACOLOR(251, 156, 12, 1.0);
    payMoney.backgroundColor = [UIColor clearColor];
    payMoney.text = [NSString stringWithFormat:@"￥%@",_information[@"totalPay"]];
    [self.view addSubview:payMoney];
    
    UILabel *payCountText = [[UILabel alloc]initWithFrame:CGRectMake(15, 217+IOS7HEIGHT, 110, 15)];
    payCountText.backgroundColor = [UIColor clearColor];
    payCountText.textColor = [UIColor grayColor];
    payCountText.text = @"支付账号信息";
    payCountText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:payCountText];
    
    //分割线
    UIImageView *lineB = [[UIImageView alloc]initWithFrame:CGRectMake(17, 238+IOS7HEIGHT, 286,2)];
    [lineB setImage:[UIImage imageNamed:@"dashed_line"]];
    [self.view addSubview:lineB];
    
    //刷卡
    UIImageView *inputView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 261+IOS7HEIGHT, 320, 40)];
    inputView.userInteractionEnabled = YES;
    [inputView setImage:[UIImage imageNamed:@"input_field"]];
    [self.view addSubview:inputView];
    
    UILabel *inputLabelText  = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 80, 20)];
    inputLabelText.textColor = SACOLOR(70, 1.0);
    inputLabelText.text = @"收款账户";
    inputLabelText.font = [UIFont systemFontOfSize:14];
    [inputView addSubview:inputLabelText];
    
    _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(95, 5, 155, 30)];
    _inputTextField.delegate = self;
    _inputTextField.font = [UIFont systemFontOfSize:14];
    _inputTextField.placeholder = @"刷卡或手动输入卡号";
    _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inputTextField.returnKeyType = UIReturnKeyDone;
    [_inputTextField addTarget:self action:@selector(changeTextEvent:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:_inputTextField];
    
    _inputImg = [[UIImageView alloc]initWithFrame:CGRectMake(260, 5, 30, 30)];
    [_inputImg setImage:[UIImage imageNamed:@"swipingCard"]];
    [inputView addSubview:_inputImg];
    
    UIButton *sureBt = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBt.frame = CGRectMake(15, 322+IOS7HEIGHT, 290, 40);
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [sureBt setTitle:@"前往银联支付" forState:UIControlStateNormal];
    sureBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBt setBackgroundImage:[UIImage imageNamed:@"water_elec_change_btn_normal"] forState:UIControlStateNormal];
    [sureBt setBackgroundImage:[UIImage imageNamed:@"water_elec_change_btn_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:sureBt];
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    
    [self startVisaReader];
    
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    
    [self stopVisaReader];
    
    [super viewWillDisappear:animated];
}

#pragma mark VisaReader
-(void)initVisaReader
{
    _visaReader = [VisaReader initWithDelegate:self];
    [_visaReader createVisaReader];
}

-(void)startVisaReader
{
    if (_visaReader)
    {
        [_visaReader resetVisaReader:YES];
    }
}

-(void)stopVisaReader
{
    if (_visaReader)
    {
        [_visaReader resetVisaReader:NO];
    }
}

#pragma mark - VisaReaderDelegate
-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString*)object
{
    //NSLog(@"event = %d,object = %@",event,object);
    if (SRS_DeviceAvailable == event && [object isEqualToString:@"0"])
    {
        [self resetCardImage:YES];
    }
    else if (SRS_DeviceUnavailable == event)
    {
        [self resetCardImage:NO];
    }
    else if (SRS_OK == event)
    {
        [self doSRS_OK:object];
    }
}


-(void)resetCardImage:(BOOL)enable
{
    if (enable == YES)
    {
        _inputImg.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _inputImg.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        _inputTextField.text = str;
    }
}

#pragma mark -textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self performSelector:@selector(change:) withObject:nil];
}

-(void)changeTextEvent:(UITextField *)textField;
{
    _cardno = textField.text;
}

#pragma mark - oPayCardCheck
//验证刷卡器卡号的长度
-(BOOL)checkTransferInfo
{
    if (_cardno.length<=0)
    {
        [self showErrorInfo:@"请刷卡或手动输入卡号" status:NLHUDState_Error];
        return NO;
    }
    
    NSString* mach = @"^[0-9]{14,20}$";
    
    if (![NLUtils matchRegularExpressionPsy:_cardno match:mach])
    {
        [self showErrorInfo:@"请确定您输入的银行卡是正确的" status:NLHUDState_Error];
        return NO;
    }
    
    return YES;
}

-(void)doSRS_OK:(NSString*)str
{
    _visaReaderArray = [str componentsSeparatedByString:@"***@@@$$$"];
    
    if (_visaReaderArray.count >= 3)
    {
        NSString *str = [_visaReaderArray objectAtIndex:0];
        
        if ([str isEqualToString:@""])
        {
            return;
        }
        if ([[str substringToIndex:2] intValue] >0)
        {
            _cardno = [_visaReaderArray objectAtIndex:0];
            _paycardid = [_visaReaderArray objectAtIndex:1];
            
            if (_paycardid.length >= 14)
            {
                _paycardid = [_paycardid substringToIndex:14];
                _paycardid = [_paycardid lowercaseString];
            }
            
            [self resetCardNumber:_cardno];
            
            [self payCardCheck];
        }
    }
}

-(void)payCardCheck
{
    NSString* name = [NLUtils getNameForRequest:Notify_payCardCheck];
    
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payCardCheck:_paycardid];
    
    [self showErrorInfo:@"正在验证刷卡器" status:NLHUDState_None];
    
}

-(void)payCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    NSString* detail = response.detail;
    
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self doPayCardCheckNotify:response];
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
            detail = @"请求失败，请检查网络";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}


-(void)doPayCardCheckNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString* result = data.value;
    
    [self showErrorInfo:result status:NLHUDState_NoError];
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"cancel"] || [result isEqualToString:@"fail"])
    {
        _result = result;
    }
    else
    {
        return;
    }
    
    [self performSelector:@selector(completeOrder) withObject:nil afterDelay:0.1];
    
}

- (BOOL)doStartPay:(NSString *)payData sysProvide:(NSString*)sysProvide spId:(NSString*)spId mode:(NSString*)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate;
{
   return [UPPayPlugin startPay:payData mode:mode viewController:viewController delegate:delegate];
}

#pragma showErrorInfo
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

//超时
- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
    
}

#pragma mark
-(void)clickSure
{
    if ([self checkTransferInfo])//确认提交 检查是否正确信息
    {
        [self performSelector:@selector(payBill) withObject:nil afterDelay:0.1];
    }
    
}

//刷卡后信息正确提交
-(void)payBill
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_payagentOrderRq];
    
    REGISTER_NOTIFY_OBSERVER(self, payagentOrderRqNotify, name);
    
    [[[NLProtocolRequest alloc] initWithRegister:YES] payagentOrderRq:_information[@"productId"] ordernum:_information[@"num"] orderprice:_information[@"factBill"] ordermoney:_information[@"totalPay"] rechabkcardno:_cardno orderfucardbank:@"" ordermemo:@""];
}


-(void)payagentOrderRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)//正确的话
    {
        [self doPayMoneyRqNotify:response];
    }
    else if (error == RSP_TIMEOUT)//错误代码 或超时登陆
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        
        return;
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//获取流水线并跳到银联
-(void)doPayMoneyRqNotify:(NLProtocolResponse*)response
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
        data =  [response.data find:@"msgbody/bkntno" index:0];
        
        _bkntno = data.value;
        
        [_hud hide:YES];
        
        [self doStartPay:_bkntno
              sysProvide:nil
                    spId:nil
                    mode:[NLUtils get_req_bkenv]
          viewController:self
                delegate:self];
    }
}

#pragma mark 交易反馈接口
-(void)completeOrder
{
    NSString* name = [NLUtils getNameForRequest:Notify_agentorderPayrqStatus];
    
    REGISTER_NOTIFY_OBSERVER(self, completeOrderNotify, name);
    
    [[[NLProtocolRequest alloc] initWithRegister:YES] agentorderPayrqStatus:_bkntno result:_result];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)completeOrderNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doCompleteOrderNotifyNotify:response];
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
        
        if ([detail isEqualToString:@"支付失败!"])
            
            if (!detail || detail.length <= 0)
            {
                detail = @"请求失败，请检查网络";
            }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}


//充值完成返回来的页面
-(void)doCompleteOrderNotifyNotify:(NLProtocolResponse*)response
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
        //跳转成功页面
        PayMoneyOK* payOk = [[PayMoneyOK alloc] initWithNibName:@"PayMoneyOK" bundle:nil];
        payOk.title = @"支付成功";
        payOk.dict = @{BUY_SUC_TITLT: @"支付成功",BUY_SUC_CONTENT: @"恭喜您提交购买通付宝刷卡器订单成功"};
        [self.navigationController pushViewController:payOk animated:YES];
    }
}

#pragma mark 键盘移动

- (void)change:(id)sender
{
    //创建一个仿射变换
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, -100-IOS7HEIGHT);
    
    //使视图使用这个变换
    [UIView
     transitionWithView:self.view
     duration:0.5
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^(void) {
         self.view.transform = pTransform;
     }
     completion:nil];
}


//弹回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    //使视图回到原来的位置
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, 0);
    //使视图使用这个变换
    [UIView
     transitionWithView:self.view
     duration:0.5
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^(void) {
         self.view.transform = pTransform;
     }
     completion:nil];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //使视图回到原来的位置
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, 0);
    //使视图使用这个变换
    [UIView
     transitionWithView:self.view
     duration:0.5
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^(void) {
         self.view.transform = pTransform;
     }
     completion:nil];
    
}

//弹回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
