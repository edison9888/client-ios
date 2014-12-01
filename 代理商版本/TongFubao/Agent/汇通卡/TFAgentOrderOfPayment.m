//
//  TFAgentOrderOfPayment.m
//  TongFubao
//
//  Created by ec on 14-9-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFAgentOrderOfPayment.h"
#import "UIViewController+NavigationItem.h"
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

#import "NLpublic.h"


@interface TFAgentOrderOfPayment ()
{
    CGFloat IOS7HEIGHT;
    CGFloat ctrH;
    NLProgressHUD* _hud;
    
    NSString *bkntno;
    
    UIView *defaultPaymentView;
    UIImageView *BKIcone;
    UILabel *BKBankname;
    UILabel *BKnumber;
    UILabel *BKtype;
    UILabel *BKweihao;
    UILabel *BKmanname;
    UILabel *lablemoren;
    
    UIView *BKcardPaymentView;
    
    UIImageView *inputView;
    UIButton *sureBt;
    
    int _payChannel;/*0:银行卡； 1：信用卡_选卡； 11：信用卡_刷卡；  2：不确认*/
    
    /*刷卡对比信息*/
    NSString * bkcardyxmonthStr;
    NSString * bkcardbanknameStr;
    NSString * bkcardbankidCheckStr;
    NSString * bkcardphoneStr;
    NSString * bkcardmanCheckStr;
    NSString * bkcardnoCheckStr;
    NSString * bkcardtypeStr;
    NSString * bkcardidcardStr;
    NSString * bkcardcvvStr;
    NSString * bkcardyxyearStr;
    NSString * paytype_check;
    NSString * _payCardCheck;
    
    /*默认卡信息*/
    NSMutableDictionary * cardDictionary_defualt;
    
    /*选择付款卡信息*/
    NSMutableDictionary * cardDictionary_choose;
    
    /*刷卡信息*/
    NSMutableDictionary * cardDictionary_VisaReader;
    
    /*短信验证输入框*/
    UITextField    *alertText;
    /*短信验证数据*/
    NSMutableDictionary * SmsVerifyData;
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

@implementation TFAgentOrderOfPayment

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
    //初始化刷卡器
    [self initVisaReader];

    [self UIInit];
    
    ((UIButton *)[self.view viewWithTag:114]).selected = YES;
    
    /*读取默认信用卡支付*/
    [self ApiPaychannelInfo];
    
    bkntno = nil;
    
    //home键事件注册
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:app];
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
    _payChannel = 2;
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
    NSLog(@"_visaReaderArray %@",_visaReaderArray);
    if (_visaReaderArray.count >=  5)
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
            NSString *time= [_visaReaderArray objectAtIndex:3];
            if (_paycardid.length >= 14)
            {
                _paycardid = [_paycardid substringToIndex:14];
                _paycardid = [_paycardid lowercaseString];
            }
            
            _payCardCheck = _paycardid;
            [self resetCardNumber:_cardno];
            /*验证刷卡器*/
            //            [self payCardCheck];
            /*刷卡验证是否有此默认信用卡*/
            [self ApipayCardCheck];
        }
    }
}

/*刷卡验证*/
-(void)ApipayCardCheck
{
    /*刷卡器唯一码*/
    NSString *paycardkey_check= _payCardCheck;
    /*银行卡号*/
    NSString *bkcardno_check= _cardno;
    /*交易类型*/
    paytype_check= [[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0];
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApipayCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, ApipayCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApipayCardCheck:paycardkey_check bkcardno:bkcardno_check paytype:paytype_check readmode:@""];
}

/*信用卡刷卡信息对比*/
-(void)ApipayCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self doApiPayCardCheckNotify:response];
    }
    else
    {
        NSString *detailA = response.detail;
        if (!detailA || detailA.length <= 0)
        {
            detailA = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detailA status:NLHUDState_Error];
    }
}

#pragma mark  刷卡回调
/*信用卡信息对比*/
-(void)doApiPayCardCheckNotify:(NLProtocolResponse*)response
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
        //银行卡类型
        NLProtocolData* bkcardtypeCheck = [response.data find:@"msgbody/bkcardtype" index:0];
        bkcardtypeStr= bkcardtypeCheck.value;
        if ([bkcardtypeStr isEqualToString:@"creditcard"]) {
            _payChannel = 11;
        }else if([bkcardtypeStr isEqualToString:@"bankcard"]){
            _payChannel = 0;
            return;
        }else{
            _payChannel = 2;
            return;
        }
        
        cardDictionary_VisaReader = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [cardDictionary_VisaReader setValue:bkcardtypeCheck.value forKey:@"bkcardcardtypes"];//银行类型

        
        //银行卡号
        NLProtocolData* bkcardnoCheck = [response.data find:@"msgbody/bkcardno" index:0];
        bkcardnoCheckStr = bkcardnoCheck.value;
        [cardDictionary_VisaReader setValue:bkcardnoCheck.value forKey:@"bkCardno"];//银行卡号

        //执卡人
        NLProtocolData* bkcardmanCheck = [response.data find:@"msgbody/bkcardman" index:0];
        bkcardmanCheckStr = bkcardmanCheck.value;
        [cardDictionary_VisaReader setValue:bkcardmanCheck.value forKey:@"bkcardman"];//持卡人
        
        //预留手机号码
        NLProtocolData* bkcardphoneCheck = [response.data find:@"msgbody/bkcardphone" index:0];
        bkcardphoneStr= bkcardphoneCheck.value;
        [cardDictionary_VisaReader setValue:bkcardphoneCheck.value forKey:@"bkcardPhone"];//预留手机号码
        
        //银行id
        NLProtocolData* bkcardbankidCheck = [response.data find:@"msgbody/bkcardbankid" index:0];
        bkcardbankidCheckStr= bkcardbankidCheck.value;
        [cardDictionary_VisaReader setValue:bkcardbankidCheck.value forKey:@"bankid"];//银行id
        
        //银行名
        NLProtocolData* bkcardbanknameCheck = [response.data find:@"msgbody/bkcardbankname" index:0];
        bkcardbanknameStr= bkcardbanknameCheck.value;
        [cardDictionary_VisaReader setValue:bkcardbanknameCheck.value forKey:@"bkcardbank"];//银行名

        //有效月
        NLProtocolData* bkcardyxmonthCheck = [response.data find:@"msgbody/bkcardyxmonth" index:0];
        bkcardyxmonthStr= bkcardyxmonthCheck.value;
        [cardDictionary_VisaReader setValue:bkcardyxmonthCheck.value forKey:@"bkcardexpireMonth"];//有效月

        //有效年
        NLProtocolData* bkcardyxyearCheck = [response.data find:@"msgbody/bkcardyxyear" index:0];
        bkcardyxyearStr= bkcardyxyearCheck.value;
        [cardDictionary_VisaReader setValue:bkcardyxyearCheck.value forKey:@"bkcardexpireYear"];//有效年

        //CVV校验
        NLProtocolData* bkcardcvvCheck = [response.data find:@"msgbody/bkcardcvv" index:0];
        bkcardcvvStr= bkcardcvvCheck.value;
        [cardDictionary_VisaReader setValue:bkcardcvvCheck.value forKey:@"bkcardcvv"];//CVV

        //身份证
        NLProtocolData* bkcardidcardCheck = [response.data find:@"msgbody/bkcardidcard" index:0];
        bkcardidcardStr= bkcardidcardCheck.value;
        [cardDictionary_VisaReader setValue:bkcardidcardCheck.value forKey:@"bkcardmanidcard"];//身份证
        
//        [cardDictionary_choose setValue:[person valueForKey:@"bkcardids"] forKey:@"paycardid"];//刷卡器ID
        
        NSLog(@"cardDictionary_VisaReader: %@",cardDictionary_VisaReader);
        
        /*填充信息 传到易宝*/
        
    }
}

#pragma mark - 选择付款卡跳转
-(void)chooseCardClick:(UIButton *)btn
{
    [self.view endEditing:YES];

    /*选择付款卡*/
    MyBankCardViewController *bank= [[MyBankCardViewController alloc] init];
    bank.agentflag= YES;
    bank.bankPayListDelegate = self;
    [bank addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self.navigationController pushViewController:bank animated:YES];
}
#pragma mark  选择付款卡回调
- (void)popWithValue:(id)person creditCard:(BOOL)flag
{
    inputView.hidden = NO;
    sureBt.frame = CGRectMake(5, 120, 286, 40);
    ((UIButton *)[self.view viewWithTag:114]).selected = NO;
    ((UIButton *)[self.view viewWithTag:115]).selected = YES;
    
    _inputTextField.text = [person valueForKey:@"bkcardnos"];
    if ([[person valueForKey:@"bkcardcardtypes"]isEqualToString:@"creditcard"]) {
        _payChannel = 1;
    }else if([[person valueForKey:@"bkcardcardtypes"]isEqualToString:@"bankcard"]){
        _payChannel = 0;
        return;
    }else{
        _payChannel = 2;
        return;
    }
    cardDictionary_choose = [NSMutableDictionary dictionaryWithCapacity:1];
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardids"] forKey:@"paycardid"];//刷卡器ID
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardbanks"] forKey:@"bkcardbank"];//银行名
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardbankmans"] forKey:@"bkcardman"];//持卡人
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardidcards"] forKey:@"bkcardmanidcard"];//身份证
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardyxyears"] forKey:@"bkcardexpireYear"];//有效年
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardyxmonths"] forKey:@"bkcardexpireMonth"];//有效月
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardbankphones"] forKey:@"bkcardPhone"];//预留手机号码
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardbankids"] forKey:@"bankid"];//银行id
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardnos"] forKey:@"bkCardno"];//银行卡号
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardcvvs"] forKey:@"bkcardcvv"];//CVV
    [cardDictionary_choose setValue:[person valueForKey:@"bkcardcardtypes"] forKey:@"bkcardcardtypes"];//银行类型
    
    NSLog(@"cardDictionary_choose: %@",cardDictionary_choose);
}



#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"] /*|| [result isEqualToString:@"cancel"] || [result isEqualToString:@"fail"]*/)
    {
        _result = result;

        NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
        double dtime = (double)curTime;
        NSDateFormatter* format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString* curTimeString = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:dtime]];
        
            //跳转成功页面
            PayMoneyOK* payOk = [[PayMoneyOK alloc] initWithNibName:@"PayMoneyOK" bundle:nil];
            payOk.title = @"支付完成";
            [payOk.navigationItem setHidesBackButton:TRUE animated:NO];
            payOk.dict = @{BUY_SUC_TITLT: @"支付成功",BUY_SUC_CONTENT: [NSString stringWithFormat: @"您已于%@预定%@张通付宝优惠卡。",curTimeString,_information[@"num"]]};
            [self.navigationController pushViewController:payOk animated:YES];
//        }];
    }
    else
    {
        return;
    }
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


#pragma mark - 信用卡易宝支付
-(void)ybagentorderPayrq:(NSMutableDictionary *)cardDictionary
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [msgDictionary setValue:_information[@"productId"] forKey:@"orderprodureid"];//购买产品id
    [msgDictionary setValue:_information[@"num"] forKey:@"ordernum"];//购买数量
    [msgDictionary setValue:_information[@"factBill"] forKey:@"orderprice"];//单个价格
    [msgDictionary setValue:_information[@"totalPay"] forKey:@"ordermoney"];//订单总额
    [msgDictionary setValue:@" " forKey:@"ordermemo"];//订单备注
    [msgDictionary setValue:@" " forKey:@"paycardid"];//刷卡器ID
    [msgDictionary setValue:cardDictionary[@"bkcardbank"] forKey:@"bkcardbank"];//银行名
    [msgDictionary setValue:cardDictionary[@"bkCardno"] forKey:@"bkCardno"];//银行卡号
    [msgDictionary setValue:cardDictionary[@"bkcardman"] forKey:@"bkcardman"];//持卡人
    [msgDictionary setValue:cardDictionary[@"bkcardexpireMonth"] forKey:@"bkcardexpireMonth"];//有效月
    [msgDictionary setValue:cardDictionary[@"bkcardmanidcard"] forKey:@"bkcardmanidcard"];//身份证
    [msgDictionary setValue:cardDictionary[@"bankid"] forKey:@"bankid"];//银行id
    [msgDictionary setValue:cardDictionary[@"bkcardexpireYear"] forKey:@"bkcardexpireYear"];//有效年
    [msgDictionary setValue:cardDictionary[@"bkcardPhone"] forKey:@"bkcardPhone"];//预留手机号码
    [msgDictionary setValue:cardDictionary[@"bkcardcvv"] forKey:@"bkcardcvv"];//CVV
    
    NSString *str=[NSString stringWithFormat:SERVER_URL];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *bodyData = [[NLpublic new] encrypt:[[NLpublic new] msgbody:msgDictionary api_name:@"ApiExpresspayInfo" api_name_func:@"ybagentorderPayrq"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSString *temp3 = [[NLpublic new] decrypt: html];
        NSMutableDictionary *msg = [[NLpublic new] xml_TO_dictionary:[temp3 dataUsingEncoding: NSUTF8StringEncoding] rolePath:@"//operation_response/msgbody" type:PublicCommon];
        
        if ([msg[@"result"]isEqualToString:@"success"]) {
            [_hud hide:YES];
            SmsVerifyData = msg;
            NSString *message = @"请输入您手机验证码";
            NSString *cancelName = @"取 消";
            UIAlertView *agentAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelName otherButtonTitles:@"确 定", nil];
            agentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            agentAlertView.tag = 2;
        
            alertText = [agentAlertView textFieldAtIndex:0];
            alertText.keyboardType = UIKeyboardTypeNumberPad;
            alertText.placeholder= @"请输入您的验证码";
            alertText.delegate = self;
             [agentAlertView show];
//            [alertText resignFirstResponder];
        }else{
            [self alert_error:@"订单提交失败！" :msg[@"message"]];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self alert_error:@"发生错误！" :[error localizedDescription]];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
        
  }

#pragma mark  易宝短信验证
-(void)ybagentorderSMSverify:(NSString *)SMSCode :(NSString *)bkordernumber :(NSString *)bkntno_yba :(NSString *)verifytoken
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [msgDictionary setValue:SMSCode forKey:@"SMSCode"];//短信验证码
    [msgDictionary setValue:bkordernumber forKey:@"bkordernumber"];//订单编号
    [msgDictionary setValue:bkntno_yba forKey:@"bkntno"];//易宝订单号
    [msgDictionary setValue:verifytoken forKey:@"verifytoken"];//返回认证
    
    [LoadDataWithASI loadDataWithMsgbody:msgDictionary apiName:@"ApiExpresspayInfo" apiNameFunc:@"ybagentorderSMSverify" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        if ([data[@"result"] isEqualToString:@"success"]) {
            [_hud hide:YES];
            NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
            double dtime = (double)curTime;
            NSDateFormatter* format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSString* curTimeString = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:dtime]];
            //跳转成功页面
            PayMoneyOK* payOk = [[PayMoneyOK alloc] initWithNibName:@"PayMoneyOK" bundle:nil];
            payOk.title = @"支付完成";
            [payOk.navigationItem setHidesBackButton:TRUE animated:NO];
            payOk.dict = @{BUY_SUC_TITLT: @"支付成功",BUY_SUC_CONTENT: [NSString stringWithFormat: @"您已于%@预定%@张通付宝优惠卡。",curTimeString,_information[@"num"]]};
            [self.navigationController pushViewController:payOk animated:YES];
        }else{
            [self alert_error:@"验证失败！" :data[@"message"]];
        }
    }];
}


#pragma mark  储蓄卡支付
-(void)payagentOrderRq:(NSString *)bknum
{
    if (bknum.length==0) {
        [NLUtils showTosatViewWithMessage:@"请刷卡或输入卡号！" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return;
    }
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    [msgDictionary setValue:_information[@"productId"] forKey:@"orderprodureid"];//购买产品id
    [msgDictionary setValue:_information[@"num"] forKey:@"ordernum"];//购买数量
    [msgDictionary setValue:_information[@"factBill"] forKey:@"orderprice"];//单个价格
    [msgDictionary setValue:_information[@"totalPay"] forKey:@"ordermoney"];//订单总额
    [msgDictionary setValue:@" " forKey:@"ordermemo"];//订单备注
    [msgDictionary setValue:bknum forKey:@"orderfucardno"];//银行卡号
    [msgDictionary setValue:@" " forKey:@"orderfucardbank"];//发卡银行
    
    [LoadDataWithASI loadDataWithMsgbody:msgDictionary apiName:@"ApiExpresspayInfo" apiNameFunc:@"payagentOrderRq" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        NSLog(@"ddd %@",data);

        if ([data[@"result"] isEqualToString:@"success"]) {
            [_hud hide:YES];
            if ([data[@"bkntno"]intValue]>0) {
                
                [self doStartPay:data[@"bkntno"]
                      sysProvide:nil
                            spId:nil
                            mode:[NLUtils get_req_bkenv]
                  viewController:self
                        delegate:self];
                NSLog(@"bkntno为：  %@", data[@"bkntno"]);
                
            }
        }else{
            [self alert_error:@"订单提交失败" :data[@"message"]];
        }
    }];
}


#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 读取用户默认信息请求
/*读取默认信用卡支付*/
-(void)ApiPaychannelInfo
{
    NSString *bkcardid= @" ";
    NSString *bkcardisdefault= @"1";
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiPaychannelInfo];
    REGISTER_NOTIFY_OBSERVER(self, ApiPaychannelInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPaychannelInfo:bkcardid bkcardisdefault:bkcardisdefault];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)ApiPaychannelInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doApiPaychannelInfoNotify:response];
    }
    else
    {
        [_hud hide:YES];
        NSString* detail = response.detail;
        if ([detail isEqualToString:@"支付失败!"])
            if (!detail || detail.length <= 0)
            {
                detail = @"服务器繁忙，请稍候再试";
            }
        
        NSRange range = [detail rangeOfString:@"没设置"];
        if (range.length > 0)/*>0 <=不正确*/
        {
            [BKcardPaymentView setFrame:CGRectMake(12, 225+IOS7HEIGHT,286,200)];
            defaultPaymentView.hidden = YES;
            inputView.hidden = NO;
            sureBt.frame = CGRectMake(5, 120, 286, 40);
            ((UIButton *)[self.view viewWithTag:115]).selected = YES;
            ((UIButton *)[self.view viewWithTag:114]).selected = NO;

        }
    }
}

#pragma mark  读取用户默认信息回调
-(void)doApiPaychannelInfoNotify:(NLProtocolResponse*)response
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
        
        cardDictionary_defualt = [NSMutableDictionary dictionaryWithCapacity:1];
        [cardDictionary_defualt setValue:@" " forKey:@"paycardid"];//刷卡器ID

        /*所属银行*/
        NLProtocolData* bank = [response.data find:@"msgbody/msgchild/bkcardbank" index:0];
        BKBankname.text= bank.value;
        if (bank.value == nil) {
            return;
        }
        [cardDictionary_defualt setValue:bank.value forKey:@"bkcardbank"];//银行名
        
        /*图片*/
        NLProtocolData* data = [response.data find:@"msgbody/msgchild/bkcardbanklogo" index:0];
        NSString* icon = data.value;
        BKIcone.image= [UIImage imageNamed:icon];
        
        /*尾号 判断才改*/
        NLProtocolData* cardNumbeData = [response.data find:@"msgbody/msgchild/bkcardno" index:0];
        NSString *cardNumbe = [cardNumbeData.value substringFromIndex:(cardNumbeData.value.length - 4)];
        BKnumber.text= cardNumbe;
        
        
        /*卡类型*/
        NLProtocolData* cardTypeData = [response.data find:@"msgbody/msgchild/bkcardcardtype" index:0];
        NSString *cardType = [cardTypeData.value isEqualToString:@"bankcard"]? @"储蓄卡" : @"信用卡";
        BKtype.text= cardType;
        
        /*持卡人*/
        NLProtocolData* bkcardbankmanData = [response.data find:@"msgbody/msgchild/bkcardbankman" index:0];
        NSString *bkcardbankman= bkcardbankmanData.value;
        BKmanname.text= bkcardbankman;
        [cardDictionary_defualt setValue:bkcardbankmanData.value forKey:@"bkcardman"];//持卡人

        
        //身份证
        NLProtocolData* bkcardidcardsData = [response.data find:@"msgbody/msgchild/bkcardidcard" index:0];
        [cardDictionary_defualt setValue:bkcardidcardsData.value forKey:@"bkcardmanidcard"];//身份证

        
        //cvv
        NLProtocolData* bkcardcvvsData = [response.data find:@"msgbody/msgchild/bkcardcvv" index:0];
        [cardDictionary_defualt setValue:bkcardcvvsData.value forKey:@"bkcardcvv"];//CVV
        
        //有效年
        NLProtocolData* bkcardyxyearsData = [response.data find:@"msgbody/msgchild/bkcardyxyear" index:0];
        [cardDictionary_defualt setValue:bkcardyxyearsData.value forKey:@"bkcardexpireYear"];//有效年
        
        //有效月
        NLProtocolData* bkcardyxmonthsData = [response.data find:@"msgbody/msgchild/bkcardyxmonth" index:0];
        [cardDictionary_defualt setValue:bkcardyxmonthsData.value forKey:@"bkcardexpireMonth"];//有效月

        
        //预留手机
        NLProtocolData* bkcardbankphonesData = [response.data find:@"msgbody/msgchild/bkcardbankphone" index:0];
        [cardDictionary_defualt setValue:bkcardbankphonesData.value forKey:@"bkcardPhone"];//预留手机号码

        
        //所属银行id
        NLProtocolData* bkcardbankidsData = [response.data find:@"msgbody/msgchild/bkcardbankid" index:0];
        [cardDictionary_defualt setValue:bkcardbankidsData.value forKey:@"bankid"];//银行id

        
        //卡号
        NLProtocolData* bkcardnosData = [response.data find:@"msgbody/msgchild/bkcardno" index:0];
        [cardDictionary_defualt setValue:bkcardnosData.value forKey:@"bkCardno"];//银行卡号

        
        //用户名
        NLProtocolData* bkcardbankmansData = [response.data find:@"msgbody/msgchild/bkcardbankman" index:0];
//        PIcardbankmansData = bkcardbankmansData.value;
    }
}

#pragma mark - checkbox事件
-(void)checkboxClick:(UIButton *)btn
{
    //银行卡支付
    if (btn.tag==115) {
        if ([btn isSelected]) {
            inputView.hidden = YES;
            sureBt.frame = CGRectMake(5, 65, 286, 40);
        }else{
            inputView.hidden = NO;
            sureBt.frame = CGRectMake(5, 120, 286, 40);
            ((UIButton *)[self.view viewWithTag:114]).selected = NO;
        }
    }
    //默认支付
    if (btn.tag==114) {
        if (![btn isSelected]) {
            ((UIButton *)[self.view viewWithTag:115]).selected = NO;
            inputView.hidden = YES;
            sureBt.frame = CGRectMake(5, 65, 286, 40);
        }
    }
    btn.selected = !btn.selected;
}



#pragma mark - 确认提交按钮事件
-(void)clickSure
{
    if (((UIButton *)[self.view viewWithTag:114]).selected) {
        NSLog(@"默认支付");
        [self ybagentorderPayrq:cardDictionary_defualt];
        
    }else if(((UIButton *)[self.view viewWithTag:115]).selected){
        NSLog(@"银行卡支付");
        
        if (_payChannel == 1) {
            [self ybagentorderPayrq:cardDictionary_choose];
            
        }else if(_payChannel == 0){
            /*银联*/
            [self payagentOrderRq:_inputTextField.text];
            
        }else if (_payChannel == 11) {
            [self ybagentorderPayrq:cardDictionary_VisaReader];
            
        }else if(_payChannel == 2){
            
            if (_inputTextField.text.length==16) {
                [self alertNotoBtn];
            }else{
                /*银联*/
                [self payagentOrderRq:_inputTextField.text];
            }
        }
    }else{
        [NLUtils showTosatViewWithMessage:@"请选择一种支付方式！" inView:self.view hideAfterDelay:1.0 beIndeter:NO];        
    }
    
}

#pragma mark - 弹窗回调
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        
        if (0 == buttonIndex)
        {
            NSLog(@"信用卡添加页面跳转");
            [self XYdefualtoPay];
        }else{
            /*银联*/
            [self payagentOrderRq:_inputTextField.text];
        }
    }else if(alertView.tag==2){
        NSLog(@"短信验证对话框");
        if (0 == buttonIndex)
        {
            return;
        }else{
            if (alertText.text.length>0) {
                [self ybagentorderSMSverify:alertText.text :
                 SmsVerifyData[@"bkordernumber"] :
                 SmsVerifyData[@"bkntno"] :
                 SmsVerifyData[@"verifytoken"]];
            }else{
                [NLUtils showTosatViewWithMessage:@"请输入验证码！" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
                
            }
        }
    }
}
#pragma mark 信用卡登记页面跳转
-(void)XYdefualtoPay
{
    planePay *pla= [[planePay alloc]initWithNibName:@"planePay" bundle:nil];
    pla.agent_Dictionary = _information;
    pla.myViewYiBaoType = YiBaoPayType_agentorderPayrq;
    pla.payCard = _cardno;
    pla.cardReaderId = _paycardid;
    pla.typePayYIBao = YES;
    [self.navigationController pushViewController:pla animated:YES];
    
}
#pragma mark 弹窗选支付通道
-(void)alertNotoBtn
{
    [NLUtils showAlertView:@"温馨提示"
                   message:@"您当前使用的卡号为信用卡，是否选择信用卡支付通道？"
                  delegate:self
                       tag:1
                 cancelBtn:@"信用卡支付"
                     other:@"借记卡支付",nil];
    
}

#pragma mark 错误/失败弹窗
-(void)alert_error:(NSString*)title :(NSString*)message
{
    [_hud hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"确认", nil];
    alertView.tag = 3;
    [alertView show];
}



#pragma mark -  键盘移动

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
//home后弹回键盘
- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self.view endEditing:YES];
}

#pragma mark - 界面初始化
-(void)UIInit
{
    //加一层 背景 防止整体向上滚的时候部分黑色
    UIView *bigV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 800)];
    bigV.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    [self.view addSubview:bigV];
    
    self.view.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    
    ctrH = [NLUtils getCtrHeight];
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
#pragma mark 账单信息区
    
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
    customerNumText.text = @"数量（张）";
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
    billNumText.text = @"单价（元）";
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
    payMoney.text = [NSString stringWithFormat:@"%@",_information[@"totalPay"]];
    [self.view addSubview:payMoney];
    
    UILabel *payCountText = [[UILabel alloc]initWithFrame:CGRectMake(15, 187+IOS7HEIGHT, 110, 15)];
    payCountText.backgroundColor = [UIColor clearColor];
    payCountText.textColor = [UIColor grayColor];
    payCountText.text = @"支付信息";
    payCountText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:payCountText];
    
    //分割线
    UIImageView *lineB = [[UIImageView alloc]initWithFrame:CGRectMake(17, 208+IOS7HEIGHT, 286,2)];
    [lineB setImage:[UIImage imageNamed:@"dashed_line"]];
    [self.view addSubview:lineB];
    
#pragma mark  默认支付区
    //默认支付
    defaultPaymentView = [[UIView alloc]init];
    [defaultPaymentView setFrame:CGRectMake(12, 225+IOS7HEIGHT,286,65)];
    UIButton *checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(0, 0,30,30);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"unSelected@2x.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"selected@2x.png"] forState:UIControlStateSelected];
    checkbox.tag = 114;
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [defaultPaymentView addSubview:checkbox];
    UILabel *defaultPaymentText = [[UILabel alloc]init];
    [defaultPaymentText setText:@"默认支付"];
    [defaultPaymentText setFrame:CGRectMake(45, 0,80,30)];
    [defaultPaymentText setFont:[UIFont systemFontOfSize:18.0]];
    [defaultPaymentView addSubview:defaultPaymentText];
    
    BKIcone = [[UIImageView alloc]init];
    [BKIcone setFrame:CGRectMake(2, 35, 25, 25)];
    [BKIcone setImage:nil];
    [defaultPaymentView addSubview:BKIcone];
    
    BKBankname = [[UILabel alloc]init];
    [BKBankname setFrame:CGRectMake(55, 35, 60, 30)];
    [BKBankname setTextColor:[UIColor blackColor]];
    [BKBankname setFont:[UIFont systemFontOfSize:14.0]];
    [BKBankname setBackgroundColor:[UIColor clearColor]];
    [defaultPaymentView addSubview:BKBankname];
    
    UILabel *weihao = [[UILabel alloc]init];
    [weihao setFrame:CGRectMake(120, 35, 28, 30)];
    [weihao setTextColor:[UIColor blackColor]];
    [weihao setFont:[UIFont systemFontOfSize:14.0]];
    [weihao setBackgroundColor:[UIColor clearColor]];
    [weihao setText:@"尾号"];
    [defaultPaymentView addSubview:weihao];
    
    BKnumber = [[UILabel alloc]init];
    [BKnumber setFrame:CGRectMake(148, 35, 56, 30)];
    [BKnumber setTextColor:[UIColor colorWithRed:0/255.0 green:194/255.0 blue:240/255.0 alpha:1]];
    [BKnumber setFont:[UIFont systemFontOfSize:14.0]];
    [BKnumber setBackgroundColor:[UIColor clearColor]];
    [defaultPaymentView addSubview:BKnumber];
    
    BKtype = [[UILabel alloc]init];
    [BKtype setFrame:CGRectMake(190, 35, 42, 30)];
    [BKtype setTextColor:[UIColor blackColor]];
    [BKtype setFont:[UIFont systemFontOfSize:14.0]];
    [BKtype setBackgroundColor:[UIColor clearColor]];
    [defaultPaymentView addSubview:BKtype];
    
    BKmanname = [[UILabel alloc]init];
    [BKmanname setFrame:CGRectMake(250, 35, 42, 30)];
    [BKmanname setTextColor:[UIColor blackColor]];
    [BKmanname setFont:[UIFont systemFontOfSize:14.0]];
    [BKmanname setBackgroundColor:[UIColor clearColor]];
    [defaultPaymentView addSubview:BKmanname];
    
    
    //分割线
    UIImageView *lineC = [[UIImageView alloc]initWithFrame:CGRectMake(5, 75, 286,2)];
    [lineC setImage:[UIImage imageNamed:@"dashed_line"]];
    [defaultPaymentView addSubview:lineC];
    
    [self.view addSubview:defaultPaymentView];
    
#pragma mark  银行卡支付区
    //银行卡支付
    BKcardPaymentView = [[UIView alloc]init];
    [BKcardPaymentView setFrame:CGRectMake(12, 315+IOS7HEIGHT,286,200)];
    UIButton *checkbox2 = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect2 = CGRectMake(0, 0,30,30);
    [checkbox2 setFrame:checkboxRect2];
    [checkbox2 setImage:[UIImage imageNamed:@"unSelected@2x.png"] forState:UIControlStateNormal];
    [checkbox2 setImage:[UIImage imageNamed:@"selected@2x.png"] forState:UIControlStateSelected];
    checkbox2.tag = 115;
    [checkbox2 addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [BKcardPaymentView addSubview:checkbox2];
    
    UILabel *BKPaymentText = [[UILabel alloc]init];
    BKPaymentText.backgroundColor = [UIColor clearColor];
    [BKPaymentText setText:@"银行卡支付"];
    [BKPaymentText setFrame:CGRectMake(45, 0,100,30)];
    [BKPaymentText setFont:[UIFont systemFontOfSize:18.0]];
    [BKcardPaymentView addSubview:BKPaymentText];
    
    
    UIButton *chooseCard = [[UIButton alloc]init];
    [chooseCard setFrame:CGRectMake(150, 0,140,38)];
    [chooseCard setBackgroundImage: [UIImage imageNamed:@"next_press.png"] forState:UIControlStateNormal];
    [chooseCard setTitle:@"选择银行卡" forState:UIControlStateNormal];
    [chooseCard addTarget:self action:@selector(chooseCardClick:) forControlEvents:UIControlEventTouchUpInside];
    [BKcardPaymentView addSubview:chooseCard];
    
    //分割线
    UIView *lineD = [[UIView alloc]initWithFrame:CGRectMake(5, 50, 286,1)];
    [lineD setBackgroundColor:[UIColor grayColor]];
    [BKcardPaymentView addSubview:lineD];
    
#pragma mark  刷卡输入区
    //刷卡
    inputView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 65, 286, 40)];
    inputView.userInteractionEnabled = YES;
    [inputView setImage:[UIImage imageNamed:@"input_field"]];
    [BKcardPaymentView addSubview:inputView];
    
    _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, 200, 30)];
    _inputTextField.delegate = self;
    _inputTextField.font = [UIFont systemFontOfSize:14];
    _inputTextField.placeholder = @"请刷卡或输入卡号";
    _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inputTextField.returnKeyType = UIReturnKeyDone;
    [_inputTextField addTarget:self action:@selector(changeTextEvent:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:_inputTextField];
    
    _inputImg = [[UIImageView alloc]initWithFrame:CGRectMake(250, 5, 30, 30)];
    [_inputImg setImage:[UIImage imageNamed:@"swipingCard"]];
    [inputView addSubview:_inputImg];
    inputView.hidden = YES;
    
#pragma mark  确认提交区
    sureBt = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBt.frame = CGRectMake(5, 65, 286, 40);
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [sureBt setTitle:@"确认支付" forState:UIControlStateNormal];
    sureBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBt setBackgroundImage:[UIImage imageNamed:@"next_press.png"] forState:UIControlStateNormal];
    
    UILabel *kindlyReminder = [[UILabel alloc]init];
    kindlyReminder.frame = CGRectMake(0, 40, 286, 30);
    kindlyReminder.text = @"温馨提示：同一信用卡请勿频繁交易";
    kindlyReminder.font = [UIFont systemFontOfSize:14];
    kindlyReminder.textAlignment = UITextAlignmentCenter;
    kindlyReminder.textColor = [UIColor blackColor];
    [sureBt addSubview:kindlyReminder];
    
    [BKcardPaymentView addSubview:sureBt];
    
    [self.view addSubview:BKcardPaymentView];
    
}
#pragma mark  -




@end
