//
//  planePay.m
//  TongFubao
//
//  Created by  俊   on 14-7-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "planePay.h"
#import "NLProgressHUD.h"
#import "planeaddtable.h"
#import "NLShowTextViewController.h"
#import "NLKeyboardAvoid.h"
#import "PhoneMoneyToOK.h"

#import "PayMoneyOK.h"

@interface planePay ()<planeaddtableDelegate>
{
    BOOL  _isRememberAccount;
    BOOL  isremomberSayCard;
    
    /*错误弹框 多次验证码*/
    BOOL flagAlert;
    BOOL flagTF;
    
    CGFloat IOS7HEIGHT;
    double costCount;
    double piceCount;
    
    planeaddtable  *areaView;
    NLProgressHUD  * _hud;
    
    UITextField    *alertText;
    UIButton       *currentButton;
    NSMutableArray *arraytext;
    
    NSString *orderIdStr;
    NSString *verifyCodeStr;
    NSString *bankId;//银行id
    NSString *banName;
    
    /*信用卡持有基本信息*/
    NSString *payPhone;
    NSString *manCardId;
    NSString *manName;
    NSString *cvv;
    NSString *expireYear;
    NSString *expireMonth;
    NSString *expireYearStr;
    NSString *expireMonthStr;
    
    //订单编号
    NSString *bkordernumber;
    //易宝订单号
    NSString *bkntno;
    //认证码
    NSString *verifytoken;
    /*验证码*/
    NSString* CodeStr;
//    UIAlertView* _AlertView ;
    
    BOOL flagTY;
    /*转账超时*/
    int _time;
    
    /*短信验证数据*/
    NSMutableDictionary * SmsVerifyData;
}

@property (nonatomic,strong)NLProgressHUD     *myHUD;
@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingScrollView *scroller;

@property (weak, nonatomic) IBOutlet UIImageView *thirdViewBG;
@property (weak, nonatomic) IBOutlet UILabel     *listIsOnDefualLB;
@property (weak, nonatomic) IBOutlet UIButton    *listIsOnDefualBtn;

@property (weak, nonatomic) IBOutlet UIButton    *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton    *btnSayBankCard;
@property (weak, nonatomic) IBOutlet UIButton    *btnSayBankList;

@property (weak, nonatomic) IBOutlet UIButton *btnToYB;
/*验证码超时期限*/
@property(nonatomic, readwrite, retain) NSTimer *myTimer;

@end

@implementation planePay


@synthesize cardInfo = _cardInfo;
@synthesize couponid = _couponid;

@synthesize PayperSonIdArray,PayContactIdArray,PayTicketBillId,playBackTicketId,PayCarTextString,PayPriceOilTax,OrderId,verify,playStyGoBack;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*信用卡持卡人信息*/
-(void)bankCardId
{
    /*付款方预留手机号*/
    payPhone   = _payPhone.text;
    /*付款方证件号码*/
    manCardId  = _payId.text;
    /*付款方持有者姓名*/
    manName    =  _payName.text;
    /*信用卡持有者基本信息*/
    expireYear     = _yearTF.text;
    expireMonth    = _monthTF.text;
    cvv            = _payYZM.text;
    expireYearStr  = [NSString stringWithFormat:@"20%@",expireYear];
    expireMonthStr = [expireMonth stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
    /*银行编号信息*/
//    for (int i=0; i<arraytext.count; i++)
//    {
//        NSString *str= [[arraytext valueForKey:@"text"]objectAtIndex:i];
//        
//        if ([str isEqualToString:_bankList.titleLabel.text])
//        {
//            /*银行编号*/
//            bankId= [[arraytext valueForKey:@"bianhao"]objectAtIndex:i];
//        }
//    }
}

//易宝Q币充值
- (void)YiBaoQCoin
{
    [self bankCardId];
    flagTY = YES;
    NSString *name = [NLUtils getNameForRequest:Notify_ApiqqrechargeReq];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiqqrechargeReq:_cardInfo.payMoney rechargemoney:_cardInfo.payMoney RechargeQQ:_cardInfo.qNumber bkCardno:_cardInfo.bkcardno bkcardman:manName bkcardexpireMonth:expireMonthStr bkcardmanidcard:manCardId bankid:bankId bkcardexpireYear:expireYearStr bkcardPhone:payPhone bkcardcvv:cvv paytype:@"qqrecharge" paycardid:_cardInfo.paycardid];
}

/*易宝游戏接口*/
-(void)YIBAOgame
{
     NSString *gameId= _myDictionary[@"gameId"];
     NSString *gameName= _myDictionary[@"gameName"];
     NSString *quantity= _myDictionary[@"quantity"];
     NSString *userCount= _myDictionary[@"userCount"];
     NSString *pice= [NSString stringWithFormat:@"%f",piceCount];
     NSString *cost= [NSString stringWithFormat:@"%f",costCount];
    
    _fucardmobile= _payPhone.text;
    _fucardman= _payName.text;
    
    NSString *area = _myDictionary[@"area"];
    
    if (area.length==0)
    {
        area = @"";
    }
    
    NSString *server = _myDictionary[@"server"];
    
    if (server.length==0)
    {
        server = @"";
    }
    
    [self bankCardId];
    flagTY= YES;
    NSString* name = [NLUtils getNameForRequest:Notify_ApiGamePayWithCreditCard];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]ApiGamePayWithCreditCard:gameId gameName:gameName area:area server:server quantity:quantity price:pice cost:cost userCount:userCount paycardid:_cardReaderId bankCardId:_sendBankCardId bankId:bankId manCardId:manCardId payPhone:_fucardmobile manName:_fucardman expireYear:expireYearStr expireMonth:expireMonthStr cvv:cvv];

    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*易宝转账接口*/
-(void)YIBAOzhuanzhang
{
    /*收款方信息类型*/
    NSString *payMoney= [_myDictionary valueForKey:@"money"];
    NSString *transferMoney= [_myDictionary valueForKey:@"paymoney"];
    NSString *receiveBankCardId= [_myDictionary valueForKey:@"shoucardno"];
    NSString *receiveBankName= [_myDictionary valueForKey:@"shoucardbank"];
    NSString *receivePhone= [_myDictionary valueForKey:@"shoucardmobile"];
    NSString *receivePersonName= [_myDictionary valueForKey:@"shoucardman"];
    NSString *arriveid= [_myDictionary valueForKey:@"arriveid"];
    NSString *sendBankName= _bankList.titleLabel.text;
    
    flagTY = YES;
    /*转账类型*/
    NSString *transferType= [_myDictionary valueForKey:@"transferType"];
    /*转账类型 转账类型0 超级转账是1 */
     NSString *patyType = [transferType isEqualToString:@"0"]? @"tfmg" : @"suptfmg";
    
    [self bankCardId];
    NSString* name = [NLUtils getNameForRequest:Notify_ApiTransferWithCreditCard];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]ApiTransferWithCreditCard:payMoney transferMoney:transferMoney receiveBankCardId:receiveBankCardId receiveBankName:receiveBankName receivePhone:receivePhone receivePersonName:receivePersonName cardReaderId:_cardReaderId sendBankCardId:_sendBankCardId sendBankCode:bankId personCardId:manCardId sendPhone:_fucardmobile sendPersonName:_fucardman expireYear:expireYearStr expireMonth:expireMonthStr cvv:cvv transferType:transferType arriveid:arriveid sendBankName:sendBankName payType:patyType paycardid:_cardReaderId];
     [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*易宝手机充值接口*/
-(void)YIBAOPhoneMoney
{
    [self bankCardId];
     NSString *mobileProvince= _AddressStr;
     NSString* name = [NLUtils getNameForRequest:Notify_ApiYiBaoPhonePay];
     REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
     flagTY = YES;
     [[[NLProtocolRequest alloc] initWithRegister:YES]getApiYiBaoPhonePay:_payRechamoneyStr payMoney:_paymoneyStr rechargePhone:_payphoneNumber bankCardId:_payCard bankId:bankId manCardId:manCardId payPhone:payPhone manName:manName expireYear:expireYearStr expireMonth:expireMonthStr cvv:cvv mobileProvince:mobileProvince paycardid:_cardReaderId];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*信用卡还款*/
-(void)YIBAOCreditCardPayments
{
    [self bankCardId];
    flagTY = YES;
    NSString* name = [NLUtils getNameForRequest:Notify_ApicreditCardMoneyRq];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);

    [[[NLProtocolRequest alloc] initWithRegister:YES]getApicreditCardMoneyRq:_paytype_check paymoney:self.myDictionary[@"paymoney"] shoucardno:self.myDictionary[@"shoucardno"] shoucardmobile:self.myDictionary[@"shoucardmobile"] shoucardman:self.myDictionary[@"shoucardman"] shoucardbank:self.myDictionary[@"shoucardbank"] current:@"RMB" paycardid:_cardReaderId merReserved:_merReserved bkcardbank:[[self.arraydic valueForKey:@"fucardbank"]objectAtIndex:0] bkCardno:[[self.arraydic valueForKey:@"fucardno"]objectAtIndex:0] bkcardman:manName bkcardexpireMonth:expireMonthStr bkcardmanidcard:manCardId bankid:bankId bkcardexpireYear:expireYearStr bkcardPhone:payPhone bkcardcvv:cvv allmoney:[[self.arraydic valueForKey:@"allmoney"] objectAtIndex:0] feemoney:[[self.arraydic valueForKey:@"feemoney"] objectAtIndex:0]];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark - /*发工资*/
- (void)YIBAOpayMonyPeople
{
    [self bankCardId];
 
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];

    NSDictionary *dataDictionaryBnak =
    @{ @"wagepaymoney" : self.myDictionary[@"wagepaymoney"] , @"wagemonth" : self.myDictionary[@"wagemonth"] , @"wagemoney" : self.myDictionary[@"wagemoney"] , @"paycardid" : _cardReaderId , @"bkcardbank" : _bankList.titleLabel.text , @"bkCardno": self.myDictionary[@"fucardno"] , @"bkcardman" : manName , @"bkcardexpireMonth" : _monthTF.text , @"bkcardexpireYear" : expireYearStr, @"bkcardmanidcard" : manCardId , @"bankid" : [[_bankNameArr valueForKey:@"bankid"] objectAtIndex:0] ,  @"bkcardPhone" : payPhone , @"bkcardcvv" : cvv , @"wagelistid" : self.myDictionary[@"wagelistid"] };
    
    NSLog(@"myDictionary %@",dataDictionaryBnak);
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryBnak apiName:@"ApiWageInfo" apiNameFunc:@"ybwagePayrq" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        NSLog(@"请求成功%@",data);
        [_hud hide:YES];
        SmsVerifyData = data;
        if (![data[@"result"] isEqualToString:@"success"])
        {
            [NLUtils showAlertView:@"提示"
                           message:data[@"message"]
                          delegate:self
                               tag:8
                         cancelBtn:@"确定"
                             other:nil];
        }
        else
        {
            if ([data[@"verifyCode"] intValue]==1)
            {
                NSString *message = @"请输入您手机验证码";
                NSString *cancelName = @"取 消";
                UIAlertView *agentAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelName otherButtonTitles:@"确 定", nil];
                agentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertText = [agentAlertView textFieldAtIndex:0];
                agentAlertView.tag= 2;
                alertText.keyboardType = UIKeyboardTypeNumberPad;
                alertText.placeholder= @"请输入您的验证码";
                alertText.delegate = self;
                [agentAlertView show];
            }
            else {
                /*新增银行卡*/
                if (_btnSayBankCard.selected==YES)
                {
                    [self ApiAuthorKuaibkcardInfoAdd];
                }
                [self yibaotoOKpayMoneyPeople];
            }
        }
    }];
}

//商户收款
- (void)YIBAOMerchantsgathering
{
    [self bankCardId];
    flagTY = YES;
    _couponid = _couponid? _couponid : @" ";
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApicouponPayReq];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApicouponPayReq:_couponid couponmoney:_payRechamoneyStr paycardid:_cardReaderId bkcardbank:_bankList.titleLabel.text bkCardno:self.myDictionary[@"fucardno"] bkcardman:manName bkcardexpireMonth:expireMonthStr bkcardmanidcard:manCardId bankid:bankId bkcardexpireYear:expireYearStr bkcardPhone:payPhone bkcardcvv:cvv paytype:@"coupon"];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*对特殊数据情况处理*/
-(void)YIBAOMorePayNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)//正确的话
    {
        [_hud hide:YES];
        [self doYIBAOMorePayNotify:response];
    }
    else
    {
        [_hud hide:YES];
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            [_hud hide:YES];
            detail = @"服务器繁忙，请稍候再试";
            [self showErrorInfo:detail status:NLHUDState_Error];
        }else{
            if (flagAlert==YES) {
                
                [NLUtils showAlertView:@"提示"
                               message:detail
                              delegate:self
                                   tag:8
                             cancelBtn:@"确定"
                                 other:nil];
                flagAlert= NO;
            }
        }
    }
}

/*返回成功数据*/
-(void)doYIBAOMorePayNotify:(NLProtocolResponse*)response
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
        /*orderId 通付宝订单号*/
        NLProtocolData* moreorder = [response.data find:@"msgbody/orderId" index:0];
        orderIdStr = moreorder.value;
        
        //订单编号
        NLProtocolData *bkordernumberData = [response.data find:@"msgbody/bkordernumber" index:0];
        bkordernumber = bkordernumberData.value;
        
        //易宝订单号
        NLProtocolData *bkntnoData =  [response.data find:@"msgbody/bkntno" index:0];
        bkntno = bkntnoData.value;
        
        //认证码
        NLProtocolData *verifytokenData = [response.data find:@"msgbody/verifytoken" index:0];
        verifytoken = verifytokenData.value;
        
        /*verifyCode 验证码*/
        data = [response.data find:@"msgbody/verifyCode" index:0];
        
        NSString *CodeSt = data.value;
        CodeSt = data.value;
       
        if ([CodeSt intValue] == 1)
        {
            if (flagTY)
            {
                flagAlert= YES;
                /*短信限制*/
                [self startTimeoutTimer];
                NSString *message = @"请输入您手机验证码";
                NSString *cancelName = @"取 消";
                UIAlertView *agentAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelName otherButtonTitles:@"确 定", nil];
                agentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                alertText = [agentAlertView textFieldAtIndex:0];
                alertText.keyboardType = UIKeyboardTypeNumberPad;
                alertText.placeholder= @"请输入您的验证码";
                alertText.delegate = self;
                flagTY = NO;
                [agentAlertView show];
            }
        }
        else
        {
            /*新增银行卡*/
            if (_btnSayBankCard.selected==YES)
            {
                [self ApiAuthorKuaibkcardInfoAdd];
            }
            [self yibaotoOKpay];
        }
    }
}

#pragma mark====== 飞机票提示框/*验证类型 跳转类型 加载类型*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [_hud hide:YES];
    
//    [self yibaotoOKpay];
    
    verifyCodeStr = alertText.text;
    
    if ((1 == buttonIndex) && (alertView.tag != 2))
    {
        if (alertText.text.length==0)
        {
            [self showErrorInfo:@"请输入正确的验证码" status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }
        else
        {
             [self.view endEditing:YES];
            /*当前判断验证码信息是否正确 转账和手机充值旧接口*/
            switch (self.myViewYiBaoType)
            {
                case YiBaoPayType_phone:
                {
                    [self readRechaPayTypeinfo];
                }
                    break;
                case YiBaoPayType_ZhuanZhang:
                {
                    [self ApiPayWithVerifyCode];
                }
                    break;
                case YiBaoPayType_Game:
                {
                    [self ApiGamePayWithVerifyCode];
                }
                    break;
                case YiBaoPayType_CreditCardPayments:
                {     /*信用卡还款*/
                    [self ApicreditCardMoneyRq];
                }
                    break;
                case YiBaoPayType_Qcoin:
                {
                    [self ApiQcoinWithVerifyCode];
                }
                    break;
                case YiBaoPayType_Merchantsgathering:
                {    /*商户收款*/
                    [self ApiCreditCardPaymentsWithVerifyCode];
                }
                    break;
                    /*飞机票*/
                case YibaoPlayTicket:
                {
//                    UITextField *alertViewText=[alertView textFieldAtIndex:0];
                    NSLog(@"=====alertViewText=====%@",verifyCodeStr);
                    if ([verifyCodeStr isEqualToString:self.verify])
                       {
                         [self playTicketURL];
                       }
                    else
                    {
                        UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码不正确交易不成功！" delegate:nil cancelButtonTitle:@"请重新确认提交" otherButtonTitles:nil, nil];
                        AlertView.tag = 22;
                        [AlertView show];
                    }
                }
                    break;
                default:
                    break;
            }
    
        }
    }
    
    if(alertView.tag==2){
        NSLog(@"短信验证对话框");
        if (0 == buttonIndex)
        {
            return;
        }else{
            if (alertText.text.length>0) {
                /*data[@"verifyCode"]*/
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

/*end*/
/*易宝充值验证码*/
-(void)readRechaPayTypeinfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiYiBaoVerifyCode];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiYiBaoVerifyCode:orderIdStr verifyCode:alertText.text];
}

/*易宝游戏验证码*/
-(void)ApiGamePayWithVerifyCode
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiGamePayWithVerifyCode];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPayWithVerifyCode:orderIdStr verifyCode:alertText.text];
}

/*信用卡验证码*/
-(void)ApicreditCardMoneyRq
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApicreditCardMoneySMSverify];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApicreditCardMoneySMSverify:verifyCodeStr bkordernumber:bkordernumber bkntno:bkntno verifytoken:alertText.text];
}

/*易宝转账验证码*/
-(void)ApiPayWithVerifyCode
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiPayWithVerifyCode];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPayWithVerifyCode:orderIdStr verifyCode:alertText.text];
}

//Q币验证码
- (void)ApiQcoinWithVerifyCode
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiqqrechargeSMSverify];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiqqrechargeSMSverify:verifyCodeStr bkordernumber:bkordernumber bkntno:bkntno verifytoken:alertText.text];
}

//商户收款
- (void)ApiCreditCardPaymentsWithVerifyCode
{
    bkntno = bkntno? bkntno : @" ";
    NSString *name = [NLUtils getNameForRequest:Notify_ApicouponPaySMSverify];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApicouponPaySMSverify:verifyCodeStr bkordernumber:bkordernumber bkntno:bkntno verifytoken:alertText.text];
}

/*判断特别情况或超时*/
-(void)ApiYiBaoMoreNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doApiYiBaoMoreNotifyNotify:response];
    }
    else
    {
        [_hud hide:YES];
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            [_hud hide:YES];
            detail = @"支付失败，如有疑问请联系客服";
            [self showErrorInfo:detail status:NLHUDState_Error];
        }else{
            if (flagAlert==YES) {
            
                [NLUtils showAlertView:@"提示"
                           message:detail
                          delegate:self
                               tag:8
                         cancelBtn:@"确定"
                             other:nil];
                flagAlert= NO;
            }
        }
    }
}

/*成功返回页面的状态*/
-(void)yibaotoOKpay
{
    NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
    [self createInforForResultView:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

/*发工资完成再次支付*/
-(void)yibaotoOKpayMoneyPeople
{
    payMoneyToPay *pay= [[payMoneyToPay alloc]init];
    pay.pushFlag= YES;
    pay.timerStr= self.myDictionary[@"wagemonth"];
    [self.navigationController pushViewController:pay animated:YES];
}

-(void)createInforForResultView:(NLTransferResultViewController*)vc
{
    vc.myNavigationTitle = @"商户收款结果";
    vc.myTitle = @"收款成功";
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
    switch (self.myViewYiBaoType)
    {
        case YiBaoPayType_phone:
        {
            vc.myNavigationTitle = @"话费充值结果";
            vc.myTitle = @"话费充值成功";
            
            /*话费充值*/
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", _paycard.text,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", _bankList.titleLabel.text,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", _payName.text,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值号码",@"header", _payphoneNumber,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值金额",@"header", _payRechamoneyStr,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", _paymoneyStr,@"content", nil];
            [arr addObject:dic];
        }
            break;
        case YiBaoPayType_Qcoin:
        {
            vc.myNavigationTitle = @"Q币充值结果";
            vc.myTitle = @"Q币充值成功";
            
            /*Q币充值*/
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", _cardInfo.bkcardno,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", _bankList.titleLabel.text,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", _payName.text,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值Q号",@"header", _cardInfo.qNumber
                   ,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值金额",@"header", _cardInfo.payMoney,@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", _cardInfo.payMoney,@"content", nil];
            [arr addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手机号码",@"header", _payPhone.text,@"content", nil];
//            [arr addObject:dic];
//            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"刷卡器id",@"header", _cardReaderId,@"content", nil];
//            [arr addObject:dic];
            
        }
            break;
        case YiBaoPayType_ZhuanZhang:
        {
            vc.myNavigationTitle = @"转账结果";
            vc.myTitle = @"转账成功";
            
            /*信用卡充值*/
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款卡号",@"header", [self.myDictionary objectForKey:@"shoucardno"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款银行",@"header", [self.myDictionary objectForKey:@"shoucardbank"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款人",@"header", [self.myDictionary objectForKey:@"shoucardman"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", _paycard.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", _bankList.titleLabel.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", _payName.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手机号码",@"header", _payPhone.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [self.myDictionary objectForKey:@"paymoney"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手续费",@"header", [self.myDictionary objectForKey:@"payfee"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", [self.myDictionary objectForKey:@"money"],@"content", nil];
            [arr addObject:dic];
        }
            break;
            
        case YiBaoPayType_Game:
        {
            vc.myNavigationTitle = @"游戏充值结果";
            vc.myTitle = @"游戏充值成功";
        }
            break;
            
        case YiBaoPayType_CreditCardPayments:
        {
            vc.myNavigationTitle = @"还款结果";
            vc.myTitle = @"还款成功";
            
            /*信用卡充值*/
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", _paycard.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", _bankList.titleLabel.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", _payName.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手机号码",@"header", _payPhone.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", _paymoney.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"刷卡器id",@"header", _cardReaderId,@"content", nil];
            [arr addObject:dic];
        }
            break;
            
        case YiBaoPayType_Merchantsgathering:
        {
            vc.myNavigationTitle = @"商户收款结果";
            vc.myTitle = @"收款成功";
            
            /*商户收款*/
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", self.myDictionary[@"fucardno"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", self.myDictionary[@"bankName"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", self.myDictionary[@"bankManName"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手机号码",@"header", self.myDictionary[@"bankManPhone"],@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款金额",@"header", _payRechamoneyStr,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"刷卡器id",@"header", _cardReaderId,@"content", nil];
            [arr addObject:dic];
        }
            break;
            
        case YiBaoPayType_payMonyPeople:
        {
            vc.myNavigationTitle = @"发工资结果";
            vc.myTitle = @"发工资成功";
            
            /*商户收款*/
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", self.myDictionary[@"fucardno"],@"content", nil];
            [arr addObject:dic];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", _bankList.titleLabel.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", _payName.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手机号码",@"header", _payPhone.text,@"content", nil];
            [arr addObject:dic];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", _paymoney.text,@"content", nil];
            [arr addObject:dic];
        }
            break;
            
        default:
            break;
    }
    
    vc.myArray = [NSArray arrayWithArray:arr];
}

/*成功读取数据*/
-(void)doApiYiBaoMoreNotifyNotify:(NLProtocolResponse*)response
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
        /*新增银行卡*/
        if (_btnSayBankCard.selected==YES)
        {
            [self ApiAuthorKuaibkcardInfoAdd];
        }

        [self yibaotoOKpay];
    }
}
#pragma mark --- 飞机信息
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    [self mainView];
     /*测试成功状态*/
//    [self yibaotoOKpay];

}
-(void)playTicket
{
    self.paymoney.text =[NSString stringWithFormat:@"%d",PayPriceOilTax];
    self.paycard.text = PayCarTextString;

}
-(void)mainView
{
    /*易宝转账类型*/
    switch (self.myViewYiBaoType)
    {
        case YiBaoPayType_phone:
        {
            [self typeYiBaoPhonePay];
        }
            break;
        case YiBaoPayType_ZhuanZhang:
        {
            /*转账类型*/
            [self typeYiBaoZhuangZhangPay];
        }
            break;
        case YiBaoPayType_Game:
        {
            [self typeYiBaoGame];
        }
            break;
        case YiBaoPayType_CreditCardPayments:
        {
            /*信用卡还款*/
            [self typeYiBaoCreditCardPayments];
        }
            break;
        case YiBaoPayType_Qcoin:
        {
            [self typeYiBaoQcoin];
        }
            break;
        case YiBaoPayType_Merchantsgathering:
        {
            /*商户收款*/
            [self typeYIBaoMerchantsgathering];
        }
            break;
            /*飞机票*/
        case YibaoPlayTicket:
        {
            [self playTicket];
        }
            break;
            #pragma mark   case: 发工资
        case YiBaoPayType_payMonyPeople:
        {
            [self typepayMonyPeople];
        }
            break;
        case YiBaoPayType_agentorderPayrq:
        {
            /*汇通卡*/
            [self typeagentorderPayrq];
        }
            break;
        default:
            break;
    }
    [self ScrollerViewInType];
}

#pragma viewInSroller
/*易宝游戏*/
-(void)typeYiBaoGame
{
    /*数量×单价成本*/
    costCount= [_myDictionary[@"cost"] floatValue]*[_myDictionary[@"quantity"] intValue];
    /*数量×单价*/
    piceCount= [_myDictionary[@"price"] floatValue]*[_myDictionary[@"quantity"] intValue];
    /*支付金额*/
    _paymoney.text= [NSString stringWithFormat:@"￥%.02f",piceCount];
    /*付款卡号*/
    _paycard.text= _sendBankCardId;
}

/*易宝信用卡还款*/
-(void)typeYiBaoCreditCardPayments
{
    /*支付金额*/
    _paymoney.text= [NSString stringWithFormat:@"%@元",_payRechamoneyStr];
    /*付款卡号*/
    _paycard.text= _sendBankCardId;
    _payPhone.text= [_arraydic valueForKey:@"fucardmobile"][0];
    _payName.text= [_arraydic valueForKey:@"fucardman"][0];
    _bankList.titleLabel.text= [_arraydic valueForKey:@"fucardbank"][0];
}

/*易宝转账*/
-(void)typeYiBaoZhuangZhangPay
{
    /*转账银联需要填 传值过来*/
    self.payPhone.text= _fucardmobile;
    self.payName.text= _fucardman;
     /*支付金额*/
    _paymoney.text= [NSString stringWithFormat:@"￥%@",[_myDictionary valueForKey:@"money"]];
    /*付款卡号*/
    _paycard.text= _sendBankCardId;
    //所属银行
    _bankList.titleLabel.text = _fucardbank;
    //所属银行ID
    bankId = _bankID;
}

/*易宝Q币*/
- (void)typeYiBaoQcoin
{
    self.paymoney.text = _cardInfo.payMoney;
    self.paycard.text = _cardInfo.bkcardno;
}

/*易宝充值*/
-(void)typeYiBaoPhonePay
{
    /*支付金额*/
    _paymoney.text= [NSString stringWithFormat:@"￥%@",_paymoneyStr];
    /*付款卡号*/
    _paycard.text= [NSString stringWithFormat:@"%@",_payCard];
}

/*发工资*/
-(void)typepayMonyPeople
{
    /*支付金额*/
    _paymoney.text= [NSString stringWithFormat:@"￥%@",_paymoneyStr];
    /*付款卡号*/
    NSLog(@"%@",_myDictionary);
    _paycard.text= [NSString stringWithFormat:@"%@",_payCard];
    _bankAcces.hidden= YES;
    _bankList.titleLabel.text= _bankname;
    _bankList.userInteractionEnabled= NO;
}

-(void)typeagentorderPayrq
{
    /*支付金额*/
    _paymoney.text= [NSString stringWithFormat:@"￥%@",_agent_Dictionary[@"totalPay"]];
    /*付款卡号*/
    NSLog(@"%@",_myDictionary);
    _paycard.text= [NSString stringWithFormat:@"%@",_payCard];
}


/*商户收款*/
- (void)typeYIBaoMerchantsgathering
{
    //支付金额
    _paymoney.text = _payRechamoneyStr;
    //支付卡号
    _paycard.text = self.myDictionary[@"fucardno"];
    //银行名
    _bankList.titleLabel.text = self.myDictionary[@"bankName"];
    //执卡人
    _payName.text = self.myDictionary[@"bankManName"];
    //执卡人电话
    _payPhone.text = self.myDictionary[@"bankManPhone"];
    
    bankId = self.myDictionary[@"bankID"];
}

/*加载页面*/
-(void)ScrollerViewInType
{
    IOS7HEIGHT = IOS7_OR_LATER == YES? 64 : 0;
    self.title= @"信用卡支付";
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPlane) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
    /*银行帮助图*/
    [_thirdViewBank.layer setValue:@"224" forKeyPath:@"frame.origin.y"];
    
    _monthTF.delegate= self;
    _yearTF.delegate= self;
    _payId.delegate= self;
    _payName.delegate= self;
    _payPhone.delegate= self;
    _payYZM.delegate= self;
    
    _scroller.delegate = self;
    _scroller.contentSize = CGSizeMake(320, 770/*550*/);
    _btnSayBankCard.selected= YES;
    
    /*非便民服务状态选择*/
    if (_typePayYIBao != YES)
    {
        _rememberBtn.hidden= YES;
        _listIsOnDefualBtn.hidden= YES;
        _listIsOnDefualLB.hidden= YES;
        
        NSString *str= [NSString stringWithFormat:@"%f",_thirdViewBG.frame.origin.y+153];
        NSString *str2= [NSString stringWithFormat:@"%f",_thirdViewBG.frame.origin.y+145];
        
        _isRememberAccount = YES;
        [_btnSayBankCard.layer setValue:str forKeyPath:@"frame.origin.y"];
        [_btnSayBankList.layer setValue:str2 forKeyPath:@"frame.origin.y"];
    }
}

/*对应类型的数据 易宝信用卡类型*/
#pragma mark - 易宝信用卡类型 switch
-(void)yibaoTypeTopayMoney
{
    switch (self.myViewYiBaoType)
    {
        case YiBaoPayType_phone:
        {
            [self YIBAOPhoneMoney];
        }
            break;
        case YiBaoPayType_ZhuanZhang:
        {
            [self YIBAOzhuanzhang];
        }
            break;
        case YiBaoPayType_Game:
        {
            [self YIBAOgame];
        }
            break;
        case YiBaoPayType_CreditCardPayments:
        {
#pragma mark   case:信用卡还款
            [self YIBAOCreditCardPayments];
        }
            break;
        case YiBaoPayType_Qcoin:
        {
            [self YiBaoQCoin];
        }
            break;
        case YiBaoPayType_Merchantsgathering:
        {
#pragma mark   case: 商户收款
            [self YIBAOMerchantsgathering];
        }
            break;
            // 飞机票
        case YibaoPlayTicket:
        {
            [self orderNumberVerificationCode];
        }
            break;
        case YiBaoPayType_payMonyPeople:
        {
#pragma mark   case: 发工资
            [self YIBAOpayMonyPeople];
        }
             break;
        case YiBaoPayType_agentorderPayrq:
        {
#pragma mark   case: 汇通卡
            [self ybagentorderPayrq];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 汇通卡支付
-(void)ybagentorderPayrq
{
    [self bankCardId];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [msgDictionary setValue:_agent_Dictionary[@"productId"] forKey:@"orderprodureid"];//购买产品id
    [msgDictionary setValue:_agent_Dictionary[@"num"] forKey:@"ordernum"];//购买数量
    [msgDictionary setValue:_agent_Dictionary[@"factBill"] forKey:@"orderprice"];//单个价格
    [msgDictionary setValue:_agent_Dictionary[@"totalPay"] forKey:@"ordermoney"];//订单总额
    [msgDictionary setValue:@" " forKey:@"ordermemo"];//订单备注
    [msgDictionary setValue:_cardReaderId forKey:@"paycardid"];//刷卡器ID
    [msgDictionary setValue:banName forKey:@"bkcardbank"];//银行名
    [msgDictionary setValue:_payCard forKey:@"bkCardno"];//银行卡号
    [msgDictionary setValue:manName forKey:@"bkcardman"];//持卡人
    [msgDictionary setValue:expireMonthStr forKey:@"bkcardexpireMonth"];//有效月
    [msgDictionary setValue:manCardId forKey:@"bkcardmanidcard"];//身份证
    [msgDictionary setValue:bankId forKey:@"bankid"];//银行id
    [msgDictionary setValue:expireYearStr forKey:@"bkcardexpireYear"];//有效年
    [msgDictionary setValue:payPhone forKey:@"bkcardPhone"];//预留手机号码
    [msgDictionary setValue:cvv forKey:@"bkcardcvv"];//CVV
    
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
-(void)ybagentorderSMSverify:(NSString *)_SMSCode :(NSString *)_bkordernumber :(NSString *)_bkntno_yba :(NSString *)_verifytoken
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [msgDictionary setValue:_SMSCode forKey:@"SMSCode"];//短信验证码
    [msgDictionary setValue:_bkordernumber forKey:@"bkordernumber"];//订单编号
    [msgDictionary setValue:_bkntno_yba forKey:@"bkntno"];//易宝订单号
    [msgDictionary setValue:_verifytoken forKey:@"verifytoken"];//返回认证
    
    NSString *apiname;
    NSString *apifunc;
    if (YiBaoPayType_payMonyPeople == self.myViewYiBaoType) {
       /*发工资*/
        apiname= @"ApiWageInfo";
        apifunc= @"ybwagepaySMSverify";
        
    }else if (YiBaoPayType_agentorderPayrq == self.myViewYiBaoType)
    {
        /*汇通卡*/
        apiname= @"ApiExpresspayInfo";
        apifunc= @"ybagentorderSMSverify";
    }
    
    [LoadDataWithASI loadDataWithMsgbody:msgDictionary apiName:apiname apiNameFunc:apifunc rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        if ([data[@"result"] isEqualToString:@"success"]) {
            [_hud hide:YES];
            NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
            double dtime = (double)curTime;
            NSDateFormatter* format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSString* curTimeString = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:dtime]];

            /*新增银行卡*/
            if (_btnSayBankCard.selected==YES)
            {
                [self ApiAuthorKuaibkcardInfoAdd];
            }
            if (YiBaoPayType_payMonyPeople == self.myViewYiBaoType) {
                 [self yibaotoOKpayMoneyPeople];
            }else{
                //跳转成功页面
                PayMoneyOK* payOk = [[PayMoneyOK alloc] initWithNibName:@"PayMoneyOK" bundle:nil];
                payOk.title = @"支付完成";
                [payOk.navigationItem setHidesBackButton:TRUE animated:NO];
                payOk.dict = @{BUY_SUC_TITLT: @"支付成功",BUY_SUC_CONTENT: [NSString stringWithFormat: @"您已于%@预定%@张通付宝优惠卡。",curTimeString,_agent_Dictionary[@"num"]]};
                [self.navigationController pushViewController:payOk animated:YES];
            }
        }else{
            [self alert_error:@"验证失败！" :data[@"message"]];
        }
    }];
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

#pragma mark - /*按钮回调*/
- (IBAction)touchMore:(UIButton*)sender
{
    UIButton *btn= (UIButton*)sender;
    btn.selected =! btn.selected;

    
    switch (sender.tag)
    {
        case 1:
        {
            [self.view endEditing:YES];

            NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
            vc.delegate = self;
            vc.banKtype= YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5:
        {
            if (btn.selected)
            {
                _isRememberAccount = YES;
                _btnSayBankCard.selected= YES;
            }
            else
            {
                _isRememberAccount = NO;
            }
        }
            break;
        case 6:
        {
             /*协议*/
            [self xieyilist];
        }
            break;
        case 7:
        {
//            [self yibaotoOKpayMoneyPeople];
            /*text
             [self yibaotoOKpay];
            if (_btnSayBankCard.selected==YES)
            {
                [self ApiAuthorKuaibkcardInfoAdd];
            }*/
        
            #pragma mark /*提交及同意*/
            if (_typePayYIBao != YES)
            {
                /*确定提交的*/
                if ([self checkData])
                {
                    /*信用卡支付*/
                    [self yibaoTypeTopayMoney];
                }
            }
            else
            {
                /*确定提交的*/
                if ([self checkData])
                {
                    if (_isRememberAccount==YES)
                    {
                        /*信用卡支付*/
                        [self yibaoTypeTopayMoney];
                    }
                    /*如果保存了银行卡信息*/
                    else if (isremomberSayCard==YES)
                    {
                        _btnSayBankCard.selected=YES;
                        /*信用卡支付*/
                        [self yibaoTypeTopayMoney];
                    }
                    else
                    {
                        /*信用卡支付*/
                        [self yibaoTypeTopayMoney];
                    }
                }
            }
        }
            break;
        case 8:
        {
            if (btn.selected)
            {
                isremomberSayCard = YES;
            }
            else
            {
                isremomberSayCard = NO;
                
                if (_isRememberAccount == YES)
                {
                    _rememberBtn.selected = NO;
                   
                }
            }
        }
            break;
        case 9:
        {
            if (btn.selected)
            {
                isremomberSayCard = YES;
                [self.btnSayBankCard setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            }
            else
            {
                isremomberSayCard = NO;
                [self.btnSayBankCard setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
            }
        }
            break;
        case 10:
        {
            /*协议*/
            [self banklist];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark === 飞机票生成订单号
-(void)orderNumberVerificationCode
{
    
    NSLog(@"===%@===%@===%@==%@==%d", PayperSonIdArray,PayContactIdArray,PayTicketBillId,PayCarTextString,PayPriceOilTax);
    NSString *yearMonth =[NSString stringWithFormat:@"%@-%@",_yearTF.text,_monthTF.text];
    NSMutableArray *sureInfoArray = [[NSMutableArray alloc]initWithObjects:self.paycard.text,yearMonth, self.payYZM.text,self.payName.text,@"1",self.payId.text ,nil];
    NSLog(@"=====sureInfoArray======%@",sureInfoArray);

    NSString *name = [NLUtils getNameForRequest:Notify_createOrder];
    REGISTER_NOTIFY_OBSERVER(self, GetcreateOrder, name);
    // 票,乘机人,联系人,卡
//    [[[NLProtocolRequest alloc]initWithRegister:YES] TicketBillId:self.PayTicketBillId perSonIdArray:self.PayperSonIdArray ContactIdArray:self.PayContactIdArray   payinfoCardInfoArray:sureInfoArray];
    
    [[[NLProtocolRequest alloc]initWithRegister:YES] TicketBillId:self.PayTicketBillId  backTicketId:self.playBackTicketId  styGoBack:self.playStyGoBack perSonIdArray:self.PayperSonIdArray ContactIdArray:self.PayContactIdArray   payinfoCardInfoArray:sureInfoArray];
    
}


-(void)GetcreateOrder:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getGetcreateOrderAirline:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"===string====%@",string);
    }
}
- (void)getGetcreateOrderAirline:(NLProtocolResponse *)response
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
        // 机票实际价格
        NSArray *OrderIdArray = [response.data find:@"msgbody/orderId"];
        NLProtocolData *OrderIdCode = [OrderIdArray objectAtIndex:0];
        self.OrderId  = OrderIdCode.value;
        NSLog(@"=====verifyCode=====%@",self.OrderId);
        
        NSArray *verifyArray = [response.data find:@"msgbody/verifyCode"];
        NLProtocolData *verifyCode = [verifyArray objectAtIndex:0];
        self.verify  = verifyCode.value;
        NSLog(@"=====verifyCode=====%@",self.verify);
        
//       _AlertView = [[UIAlertView alloc]initWithTitle:@"请输入验证码" message:self.verify delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"支付", nil];
////        _AlertView.tag = 10;
//        [_AlertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
//        [_AlertView show];
        
        UIAlertView *agentAlertView = [[UIAlertView alloc] initWithTitle:@"请输入验证码"  message:self.verify delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"支付", nil];
        agentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [agentAlertView show];
        alertText = [agentAlertView textFieldAtIndex:0];
        alertText.keyboardType = UIKeyboardTypeNumberPad;
        alertText.placeholder= @"请输入您的验证码";
        alertText.delegate = self;

    }
}
#pragma mark====== 飞机票确认支付
-(void)playTicketURL
{
    NSString* name = [NLUtils getNameForRequest:Notify_getpayWithCreditCard];
    REGISTER_NOTIFY_OBSERVER(self, ApipayValidationCreditCardNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPayverify:self.OrderId OrderId:verifyCodeStr];
}

-(void)ApipayValidationCreditCardNotify:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getpayValidationWithCreditCard:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"===string====%@",string);
        UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"交易不成功！" delegate:nil cancelButtonTitle:@"请退出" otherButtonTitles:nil, nil];
        AlertView.tag = 21;
        [AlertView show];
        
    }
}
- (void)getpayValidationWithCreditCard:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    NSLog(@"===result====%@",result);
    if ([result isEqualToString:@"success"])
    {
        UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"交易成功！" delegate:nil cancelButtonTitle:@"请退出" otherButtonTitles:nil, nil];
        AlertView.tag = 20;
        [AlertView show];
    }
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        //        NSArray *msgchildArray = [response.data find:@"msgbody/msgchild/msgchild"];
        //        for (NLProtocolData *bkcardnoCheck in msgchildArray) {
        //            NSLog(@"=====bkcardnoCheck==%@",bkcardnoCheck.value);
        //        }
        //        NSArray *departCityArray = [response.data find:@"msgbody/msgchild/departCity"];
        //        for (NLProtocolData *bkcardnoCheck in departCityArray) {
        //            NSLog(@"=====bkcardnoCheck==%@",bkcardnoCheck.value);
        //        }
    }
}

/*
 <?xml version="1.0" encoding="UTF-8"?><operation_request><msgbody><bkcardman>破色</bkcardman><wagemoney>3.00</wagemoney><paycardid>00000000000000</paycardid><wagemonth>2015-04</wagemonth><bkcardbank>平安银行</bkcardbank><wagelistid>57</wagelistid><bkcardexpireMonth>05</bkcardexpireMonth><bkcardcvv>898</bkcardcvv><bkcardexpireYear>55</bkcardexpireYear><bkcardmanidcard>341125198705133929</bkcardmanidcard><bankid>14</bankid><bkcardPhone>13531614882</bkcardPhone><bkCardno>6221550891102901</bkCardno><wagepaymoney>3.00</wagepaymoney></msgbody><msgheader version="3.0.0"><req_bkenv>00</req_bkenv><au_token>yyISVsHJraTJlA7g9b5+2mcF</au_token><req_time>20141013145814</req_time><channelinfo><api_name>ApiWageInfo</api_name><api_name_func>ybwagePayrq</api_name_func><agentid>688</agentid><authorid>3575</authorid></channelinfo><req_token></req_token><req_version>3.0.0</req_version><req_appenv>3</req_appenv></msgheader></operation_request>
 */

/*设为默认卡
-(void)isRememberBtnAction
{
    NSString *bkcardid= @"";
    NSString *bkcardisdefault= @"";
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoDefault];
    REGISTER_NOTIFY_OBSERVER(self, ApiAuthorKuaibkcardInfoDefaultNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoDefault:bkcardid bkcardisdefault:bkcardisdefault];
}

-(void)ApiAuthorKuaibkcardInfoDefaultNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)//正确的话
    {
        [_hud hide:YES];
        [self doApiAuthorKuaibkcardInfoDefaultNotify:response];
    }
    else
    {
        [_hud hide:YES];
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}
*/
/*返回数据默认*/
-(void)doApiAuthorKuaibkcardInfoDefaultNotify:(NLProtocolResponse*)response
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
}

/*保存此卡为信用卡 */
-(void)ApiAuthorKuaibkcardInfoAdd
{
    [self bankCardId];
    
    NSString *bkcardisdefaultStr;
    
    if (_btnSayBankCard.selected==YES) {
        
         bkcardisdefaultStr= @"0";
    }
   
    if (_rememberBtn.selected == YES)
    {
         bkcardisdefaultStr= @"1";
    }
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoDefault];
    REGISTER_NOTIFY_OBSERVER(self, ApiAuthorKuaibkcardInfoAddNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoAdd:bankId bkcardbank:_bankList.titleLabel.text bkcardno:_paycard.text bkcardbankman:manName bkcardbankphone:payPhone bkcardyxmonth:expireMonthStr bkcardyxyear:expireYearStr bkcardcvv:cvv bkcardidcard:manCardId bkcardcardtype:@"creditcard" bkcardisdefault:bkcardisdefaultStr];
}

/*默认*/
-(void)ApiAuthorKuaibkcardInfoAddNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)//正确的话
    {
        [_hud hide:YES];
        [self doApiAuthorKuaibkcardInfoAdd:response];
    }
}

/*新增*/
-(void)doApiAuthorKuaibkcardInfoAdd:(NLProtocolResponse*)response
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
}

/*清单*/
-(void)banklist{
    NSString* name = [NLUtils getNameForRequest:Notify_readAppruleList];
    REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAppruleList:@"7"];
}

/*同意协议*/
-(void)xieyilist{
    
    NSString* name = [NLUtils getNameForRequest:Notify_readAppruleList];
    REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAppruleList:@"6"];
}

#pragma mark - http request
-(void)readAppruleListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self showTextView];
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

/*协议*/
-(void)showTextView
{
    NLShowTextViewController* vc = [[NLShowTextViewController alloc] initWithNibName:@"NLShowTextViewController" bundle:nil];
    vc.myType = 6;
    [NLUtils presentModalViewController:self newViewController:vc];
}

-(void)hideAction
{
    [_hud hide:YES];
}

#pragma 验证码期限
-(void)startTimeoutTimer
{
	[self stopTimeoutTimer];
    _time = 30;
	self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 1//kTimeoutSeconds
                                                    target: self
                                                  selector: @selector(doAnimationForCommandYiBao:)
                                                  userInfo: nil
                                                   repeats: YES];
}

-(void)doAnimationForCommandYiBao:(NSTimer *)timer
{
    _time--;
    if (_time <= 0)
    {
        [self stopTimeoutTimer];
        [self modifyReGetBtnStatus:NLReGetBtnState_EnableTitle title:@"获取提交"];
    }
    else
    {
        NSString* str = [NSString stringWithFormat:@"%d秒后重新获取",_time];
        
        [self modifyReGetBtnStatus:NLReGetBtnState_DisableTitle title:str];
    }
}

-(void)stopTimeoutTimer
{
	if (self.myTimer != nil && [self.myTimer isValid])
	{
		[self.myTimer invalidate];
	}
}

-(void)modifyReGetBtnStatus:(NLReGetBtnState)status title:(NSString*)title
{
    switch (status)
    {
        case NLReGetBtnState_Disable:
        {
            NSLog(@"NLReGetBtnState_Disable");
            if (_myButton.enabled)
            {
                _myButton.enabled = NO;
            }
        }
            break;
        case NLReGetBtnState_EnableTitle:
        {
            [_myButton setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0)] forState:UIControlStateNormal];
            [_myButton setTitle:@"重新提交获取" forState:UIControlStateNormal];
            
            if (!_myButton.enabled)
            {
                _myButton.enabled = YES;
            }
        }
            break;
        case NLReGetBtnState_DisableTitle:
        {
            
            [_myButton setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(174, 1.0)] forState:UIControlStateNormal];
            _myButton.titleLabel.text= title;
            [_myButton setTitle:_myButton.titleLabel.text forState:UIControlStateNormal];
            
            if (_myButton.enabled)
            {
                _myButton.enabled = NO;
            }
        }
            break;
        case NLReGetBtnState_Enable:
        {
            NSLog(@"NLReGetBtnState_Enable");
            
            if (!_myButton.enabled)
            {
                _myButton.enabled = YES;
            }
        }
            break;
        default:
            break;
    }
}

/*选择框*/
-(void)viewinTable{
    
    if (!areaView)
    {
        areaView = [[planeaddtable alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
        areaView.alpha = 0.0;
        areaView.planeaddtableDelegate = self;
        areaView.backgroundColor = [UIColor clearColor];
       
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            
            areaView.alpha = 1.0;
        }];
        
        [_scroller addSubview:areaView];
    }
}

#pragma mark - readKuaiDicmpList
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
            //_hud.labelText = error;
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

#pragma mark - NLBankLisDelegate
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state
{
    bankId = state;
    banName= (NSString *)aObject;
    
    [_bankList setTitle:banName forState:UIControlStateNormal];
    _bankList.titleLabel.frame= CGRectMake(self.bankList.frame.origin.x, self.bankList.frame.origin.y, self.bankList.frame.size.width, 120);
}

- (void)dataSearchDidCanceled:(NLBankListViewController *)controller
                    withState:(int)state
{
    //[controller dismissViewControllerAnimated:YES completion:NULL];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.payYZM resignFirstResponder];
    [self.payPhone resignFirstResponder];
    [self.payName resignFirstResponder];
    [self.payId resignFirstResponder];
}
/*获取列表数据的*/
- (IBAction)btnInScroller:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    currentButton= sender;
    
    switch (sender.tag)
    {
            /*
        case 1:
        {
            arraytext= [NSMutableArray array];
            [arraytext addObject:@{@"text": @"邮政储蓄银行",@"bianhao":@"PSBCCREDIT",}];
            [arraytext addObject:@{@"text": @"深圳发展银行",@"bianhao":@"SDBCREDIT",}];
            [arraytext addObject:@{@"text": @"民生银行",@"bianhao":@"CMBCCREDIT",}];
            [arraytext addObject:@{@"text": @"包商银行",@"bianhao":@"BSBCREDIT",}];
            [arraytext addObject:@{@"text": @"北京银行",@"bianhao":@"BCCBCREDIT",}];
            [arraytext addObject:@{@"text": @"上海银行",@"bianhao":@"BOSHCREDIT",}];
            [arraytext addObject:@{@"text": @"招商银行",@"bianhao":@"CMBCHINACREDIT",}];
            [arraytext addObject:@{@"text": @"中信银行",@"bianhao":@"ECITICCREDIT",}];
            [arraytext addObject:@{@"text": @"浦东发展银行",@"bianhao":@"SPDBCREDIT",}];
            [arraytext addObject:@{@"text": @"兴业银行",@"bianhao":@"CIBCREDIT",}];
            [arraytext addObject:@{@"text": @"华夏银行",@"bianhao":@"HXBCREDIT",}];
            [arraytext addObject:@{@"text": @"农业银行",@"bianhao":@"ABCCREDIT",}];
            [arraytext addObject:@{@"text": @"广东发展银行",@"bianhao":@"GDBCREDIT",}];
            [arraytext addObject:@{@"text": @"工商银行",@"bianhao":@"ICBCCREDIT",}];
            [arraytext addObject:@{@"text": @"中国银行",@"bianhao":@"BOCCREDIT",}];
            [arraytext addObject:@{@"text": @"交通银行",@"bianhao":@"BOCOCREDIT",}];
            [arraytext addObject:@{@"text": @"建设银行",@"bianhao":@"CCBCREDIT",}];
            [arraytext addObject:@{@"text": @"平安银行",@"bianhao":@"PINGANCREDIT",}];
            [arraytext addObject:@{@"text": @"光大银行",@"bianhao":@"EVERBRIGHTCREDIT",}];
            
            [areaView loadDataWith:[arraytext valueForKey:@"text"] button:currentButton];
        }
            break;
             */
        case 2:
        {
            [areaView loadDataWith:@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"] button:currentButton];
            
        }
            break;
        case 3:
        {
            [areaView loadDataWith:@[@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"] button:currentButton];
        }
            break;
        default:
            break;
    }
    
    [self viewinTable];
}

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

/*返回跳转*/
-(void)backPlane
{
    if ([self.navigationController.viewControllers count] > 1)
    {
        if (YiBaoPayType_payMonyPeople == self.myViewYiBaoType){
               [TFData getTempData][ADD_SKQ_ADDRESS_FLAG]=ADD_SKQ_ADDRESS_FLAG;
        }
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*检查填入的信息是否都符合*/
-(BOOL)checkData
{
    BOOL check = YES;
    
    if (!check)
    {
        [self showErrorInfo:@"请填写正确的信息" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    
    if (_payYZM.text.length < 3)
    {
        [self showErrorInfo:@"请输入正确位数的验证码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    
    if (![NLUtils checkMobilePhone:_payPhone.text])
    {
        [self showErrorInfo:@"请输入正确的电话号码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    if (![NLUtils checkName:_payName.text])
    {
        [self showErrorInfo:@"请输入持卡人姓名" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    
    if (![NLUtils checkIdentity:_payId.text])
    {
        [self showErrorInfo:@"请输入正确的身份证号码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    
    if (_monthTF.text.length <= 0 )
    {
        [self showErrorInfo:@"请输入正确的月份" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    
    if (_yearTF.text.length <= 0)
    {
        [self showErrorInfo:@"请输入正确的年份" status:NLHUDState_Error];
        check = NO;
        return check;
    }

    return check;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //使视图回到原来的位置
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, 0);
    //使视图使用这个变换
    [UIView
     transitionWithView:self.view
     duration:0.2
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^(void) {
         self.view.transform = pTransform;
     }
     completion:nil];
    /*月份*/
    if (textField==_monthTF) {
        
        NSString* monthStr;
        if ( [_monthTF.text intValue]<10 && _monthTF.text.length<2 ) {
            monthStr= [NSString stringWithFormat:@"0%@",_monthTF.text];
        }else{
            monthStr= [NSString stringWithFormat:@"%@",_monthTF.text];
        }
        _monthTF.text= monthStr;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _monthTF) {

        flagTF = YES;
        [self textFiledMonthYear];
        
    }else if (textField == _yearTF){
        
        flagTF = NO;
        [self textFiledMonthYear];
    }
    /* */
    else if (textField == _payYZM )
    {
        [self textfiledYZM];
    }
    else if (textField != _payYZM || textField != _monthTF || textField != _yearTF) {
        
        [self othertextfiled];
    }
    
}

/*textTF frame and Image hidden*/
-(void)textFiledMonthYear
{
   
    _bankCvvHelp.hidden= YES;
    
    /*年 月*/
    CGRect _Firstframe = CGRectMake(_FirstImage.frame.origin.x, _FirstImage.frame.origin.y, _FirstImage.frame.size.width, 170);
    CGRect _secondframe = CGRectMake(_SecondImage.frame.origin.x, _SecondImage.frame.origin.y, _SecondImage.frame.size.width, 45);
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_FirstImage setFrame:_Firstframe];
        [_SecondImage setFrame:_secondframe];
        
    } completion:^(BOOL finished) {
        
          _bankhelpView.hidden= NO;
    }];

    [_secondTFView.layer setValue:@"175" forKeyPath:@"frame.origin.y"];
    [_thirdViewBank.layer setValue:@"350" forKeyPath:@"frame.origin.y"];
}

-(void)textfiledYZM
{
    _bankhelpView.hidden= YES;
  
    CGRect _Firstframe = CGRectMake(_FirstImage.frame.origin.x, _FirstImage.frame.origin.y, _FirstImage.frame.size.width, 45);
    CGRect _secondframe = CGRectMake(_SecondImage.frame.origin.x, _SecondImage.frame.origin.y, _SecondImage.frame.size.width, 170);
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_FirstImage setFrame:_Firstframe];
        [_SecondImage setFrame:_secondframe];
        
    } completion:^(BOOL finished) {
        
         _bankCvvHelp.hidden= NO;
    }];
    
    [_secondTFView.layer setValue:@"50" forKeyPath:@"frame.origin.y"];
    [_thirdViewBank.layer setValue:@"350" forKeyPath:@"frame.origin.y"];
}

-(void)othertextfiled
{
    _bankhelpView.hidden= YES;
    _bankCvvHelp.hidden= YES;
    
    [_secondTFView.layer setValue:@"50" forKeyPath:@"frame.origin.y"];
    [_thirdViewBank.layer setValue:@"224" forKeyPath:@"frame.origin.y"];
    [_FirstImage setFrame:CGRectMake(_FirstImage.frame.origin.x, _FirstImage.frame.origin.y, _FirstImage.frame.size.width, 45)];
    [_SecondImage setFrame:CGRectMake(_SecondImage.frame.origin.x, _SecondImage.frame.origin.y, _SecondImage.frame.size.width, 45)];
}


/*长度限制*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    if (textField == _payPhone) {
        
        if([[textField text] length] - range.length + string.length > 11)
        {
            retValue=NO;
        }
    }
    if (textField == _payYZM) {
        
        if([[textField text] length] - range.length + string.length > 3)
        {
            retValue=NO;
        }
    }
    if (textField == _payId) {
        
        if([[textField text] length] - range.length + string.length > 19)
        {
            retValue=NO;
        }
    }
    
    if (textField == _yearTF) {
        
        if([[textField text] length] - range.length + string.length > 2)
        {
            retValue=NO;
        }
    }
    if (textField == _monthTF) {
        
        if([[textField text] length] - range.length + string.length > 2)
        {
            retValue=NO;
        }
        
        NSString  *str = [NSString stringWithFormat:@"%@%@",_monthTF.text,string];
        
        if (_monthTF.text > 0 &&  [str doubleValue] > 12)
        {
            [self showErrorInfo:@"请输入正确的月份" status:NLHUDState_Error];
            
            retValue=NO;
        }

    }
 
    return retValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    /*
     NSInteger number = flagTF ? 100 : 100;
     [UIView
     transitionWithView:self.scroller
     duration:0.2
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^(void) {
     self.view.transform = CGAffineTransformMakeTranslation(0, - number);
     }
     completion:nil];
     */
}


/*
 转账接口
 <?xml version="1.0" encoding="UTF-8"?>
 <operation_request><msgbody><arriveid>8</arriveid><sendPersonName>ÊüØÂ∞èÂá§</sendPersonName><transferType>1</transferType><sendBankName>Âπø‰∏úÂèëÂ±ïÈì∂Ë°å</sendBankName><sendBankCardId>5201521214336027</sendBankCardId><sendPhone>13726732782</sendPhone><transferMoney>1</transferMoney><payType>suptfmg</payType><payMoney>3.00</payMoney><sendBankCode>13</sendBankCode><expireMonth>9</expireMonth><receiveBankCardId>5218990783286031</receiveBankCardId><cardReaderId>fff16301024522</cardReaderId><paycardid>fff16301024522</paycardid><receiveBankName>‰∫§ÈÄöÈì∂Ë°å</receiveBankName><receivePhone/><receivePersonName>ÊüØÂ∞èÂá§</receivePersonName><expireYear>2019</expireYear><cvv>159</cvv><personCardId>440883199004250347</personCardId></msgbody><msgheader version="2.1.0"><req_bkenv>00</req_bkenv><au_token>miFEXJXJraHJlA7i97F60GAD</au_token><req_time>20140922170646</req_time><channelinfo><api_name>ApiTransferMoney</api_name><api_name_func>TransferWithCreditCard</api_name_func><agentid>417</agentid><authorid>1692</authorid></channelinfo><req_token/><req_version>2.1.0</req_version><req_appenv>3</req_appenv></msgheader></operation_request>
 
 保存卡为信用卡
 <?xml version="1.0" encoding="UTF-8"?>
 <operation_request><msgbody><bkcardbank>Âπø‰∏úÂèëÂ±ïÈì∂Ë°å</bkcardbank><bkcardidcard>440883199004250347</bkcardidcard><bkcardno/><bkcardyxmonth>9</bkcardyxmonth><bkcardyxyear>2019</bkcardyxyear><bkcardcvv>159</bkcardcvv><bkcardbankman>ÊüØÂ∞èÂá§</bkcardbankman><bkcardbankphone>13726732782</bkcardbankphone><bkcardbankid>13</bkcardbankid><bkcardisdefault>0</bkcardisdefault><bkcardcardtype>creditcard</bkcardcardtype></msgbody><msgheader version="2.1.0"><req_bkenv>00</req_bkenv><au_token>ySIWVceTpfLJlA7i97F612sB</au_token><req_time>20140922170736</req_time><channelinfo><api_name>ApiAuthorKuaibkcardInfo</api_name><api_name_func>AddKuaibkcard</api_name_func><agentid>417</agentid><authorid>1692</authorid></channelinfo><req_token/><req_version>2.1.0</req_version><req_appenv>3</req_appenv></msgheader></operation_request>
 */

/*
 <?xml version="1.0" encoding="UTF-8"?><operation_request><msgbody>
 <bkcardman>你的</bkcardman>
 <wagemoney>3.00</wagemoney>
 <paycardid>00000000000000</paycardid>
 <wagemonth>2015-04</wagemonth>
 <bkcardbank>平安银行</bkcardbank>
 <wagelistid>57</wagelistid>
 <bkcardexpireMonth>8</bkcardexpireMonth>
 <bkcardcvv>683</bkcardcvv>
 <bkcardexpireYear>18</bkcardexpireYear>
 <bkcardmanidcard>341125198705133929</bkcardmanidcard>
 <bankid>14</bankid>
 <bkcardPhone>13531614882</bkcardPhone>
 <bkCardno>6221550891102901</bkCardno>
 <wagepaymoney>3.00</wagepaymoney>
 </msgbody>
 <msgheader version="3.0.0"><req_bkenv>00</req_bkenv><au_token>nCdDBZDIrqHJlA7g9b5+0msA</au_token><req_time>20141013144534</req_time><channelinfo><api_name>ApiWageInfo</api_name><api_name_func>ybwagePayrq</api_name_func><agentid>688</agentid><authorid>3575</authorid></channelinfo><req_token></req_token><req_version>3.0.0</req_version><req_appenv>3</req_appenv></msgheader></operation_request>
 
 */

@end
