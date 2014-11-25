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

@interface planePay ()<planeaddtableDelegate>
{
    BOOL  _isRememberAccount;
    BOOL  isremomberSayCard;
    
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
    
    /*信用卡持有基本信息*/
    NSString *payPhone;
    NSString *manCardId;
    NSString *manName;
    NSString *cvv;
    NSString *expireYear;
    NSString *expireMonth;
    NSString *expireYearStr;
    NSString *expireMonthStr;

}
@property (nonatomic,strong)NLProgressHUD     *myHUD;
@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingScrollView *scroller;

@property (weak, nonatomic) IBOutlet UILabel     *listview;

@property (weak, nonatomic) IBOutlet UIButton    *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton    *bankList;
@property (weak, nonatomic) IBOutlet UIButton    *month;
@property (weak, nonatomic) IBOutlet UIButton    *year;
@property (weak, nonatomic) IBOutlet UIButton    *peopleid;
@property (weak, nonatomic) IBOutlet UIButton    *btnSayBankCard;
@property (weak, nonatomic) IBOutlet UIButton    *btnSayBankList;
@property (weak, nonatomic) IBOutlet UIButton    *btnOnClick;
@property (weak, nonatomic) IBOutlet UIButton *btnToYB;



@end

@implementation planePay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*信用卡持卡人信息*/
-(void)bankCardId{
    
    /*付款方预留手机号*/
    payPhone   = _payPhone.text;
    /*付款方证件号码*/
    manCardId  = _payId.text;
    /*付款方持有者姓名*/
    manName    =  _payName.text;
    
    /*信用卡持有者基本信息*/
    expireYear = _year.titleLabel.text;
    expireMonth= _month.titleLabel.text;
    cvv        = _payYZM.text;
    expireYearStr= [NSString stringWithFormat:@"20%@",expireYear];
    expireMonthStr= [expireMonth stringByReplacingOccurrencesOfString:@"0" withString:@""];

    /*银行编号信息*/
    for (int i=0; i<arraytext.count; i++) {
        NSString *str= [[arraytext valueForKey:@"text"]objectAtIndex:i];
        if ([str isEqualToString:_bankList.titleLabel.text]) {
            /*银行编号*/
            bankId= [[arraytext valueForKey:@"bianhao"]objectAtIndex:i];
        }
    }
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
    if (area.length==0) {
        area = @"";
    }
    NSString *server = _myDictionary[@"server"];
    if (server.length==0) {
        server = @"";
    }
   
     [self bankCardId];
    
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
    
     [[[NLProtocolRequest alloc] initWithRegister:YES]getApiYiBaoPhonePay:_payRechamoneyStr payMoney:_paymoneyStr rechargePhone:_payphoneNumber bankCardId:_payCard bankId:bankId manCardId:manCardId payPhone:payPhone manName:manName expireYear:expireYearStr expireMonth:expireMonthStr cvv:cvv mobileProvince:mobileProvince paycardid:_cardReaderId];
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
        
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
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
        
        /*verifyCode 验证码*/
        data = [response.data find:@"msgbody/verifyCode" index:0];
        NSString* CodeStr = data.value;
       
        if ([CodeStr intValue]==1) {
            NSString *message = @"请输入您手机验证码";
            NSString *cancelName = @"取 消";
            UIAlertView *agentAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelName otherButtonTitles:@"立即前往", nil];
            agentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [agentAlertView show];
            alertText = [agentAlertView textFieldAtIndex:0];
            alertText.keyboardType = UIKeyboardTypeNumberPad;
            alertText.placeholder= @"请输入您的验证码";
            alertText.delegate = self;
            [alertText resignFirstResponder];
            
        }else{
            /*新增银行卡*/
             [self ApiAuthorKuaibkcardInfoAdd];
            
            /*对应不同的状态*/
            PhoneMoneyToOK* vc = [[PhoneMoneyToOK alloc] initWithNibName:@"PhoneMoneyToOK" bundle:nil];
            switch (self.myViewYiBaoType) {
                case YiBaoPayType_phone:
                {
                    vc.labletextStr= @"充值成功";
                    vc.phoneNumLable= _payCard;
                    vc.numInfo = @"您的付款卡号：";
                    vc.OKPhoneStr= [NSString stringWithFormat:@"充值%@元",_paymoneyStr];
                }
                    break;
                case YiBaoPayType_ZhuanZhang:
                {
                    if ([[_myDictionary valueForKey:@"transferType"] isEqualToString:@"1"]) {
                        vc.labletextStr= @"超级转账成功";
                    }else{
                        vc.labletextStr= @"普通转账成功";
                    }
                    vc.phoneNumLable= _sendBankCardId;
                    vc.numInfo = @"您的付款卡号：";
                    vc.OKPhoneStr= [NSString stringWithFormat:@"操作%@元",[_myDictionary valueForKey:@"money"]];
                }
                    break;
                case YiBaoPayType_Game:
                {
                    vc.labletextStr= @"充值成功";
                    vc.phoneNumLable= _sendBankCardId;
                    vc.numInfo = @"您的付款卡号：";
                    vc.OKPhoneStr= [NSString stringWithFormat:@"操作%@元",[NSString stringWithFormat:@"￥%.02f",piceCount]];
                }
                    break;
                case YiBaoPayType_CreditCardPayments:
                {     /*信用卡还款*/
                    
                }
                    break;
                case YiBaoPayType_Qcoin:
                {
                    
                }
                    break;
                case YiBaoPayType_Merchantsgathering:
                {    /*商户收款*/
                    
                }
                    break;
                default:
                    break;
            }
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

/*验证类型 跳转类型 加载类型*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [_hud hide:YES];
    
    verifyCodeStr= alertText.text;

    if (1 == buttonIndex)
    {
        /*当前判断验证码信息是否正确*/
        switch (self.myViewYiBaoType) {
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
               
            }
             break;
            case YiBaoPayType_Qcoin:
            {    
                
            }
            break;
            case YiBaoPayType_Merchantsgathering:
            {    /*商户收款*/
                
            }
                break;
                default:
                break;
        }
    }else{
        
       
    }
}

/*end*/

/*易宝充值验证码*/
-(void)readRechaPayTypeinfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiYiBaoVerifyCode];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiYiBaoVerifyCode:orderIdStr verifyCode:verifyCodeStr];
  
}

/*易宝游戏验证码*/
-(void)ApiGamePayWithVerifyCode
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiGamePayWithVerifyCode];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPayWithVerifyCode:orderIdStr verifyCode:verifyCodeStr];
}

/*易宝转账验证码*/
-(void)ApiPayWithVerifyCode
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiPayWithVerifyCode];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPayWithVerifyCode:orderIdStr verifyCode:verifyCodeStr];
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
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            [_hud hide:YES];
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
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
        [self showErrorInfo:@"操作成功" status:NLHUDState_NoError];
        [self performSelector:@selector(hideAction)withObject:nil afterDelay:1.5f];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self mainView];
}

-(void)mainView
{
    /*易宝转账类型*/
    switch (self.myViewYiBaoType) {
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
            
        }
            break;
        case YiBaoPayType_Merchantsgathering:
        {    /*商户收款*/
            
        }
            break;
        default:
            break;
    }
    [self ScrollerViewInType];
}

/*易宝游戏*/
-(void)typeYiBaoGame
{
    /*数量×单价成本*/
    costCount= [_myDictionary[@"cost"]floatValue]*[_myDictionary[@"quantity"]intValue];
    /*数量×单价*/
    piceCount= [_myDictionary[@"price"]floatValue]*[_myDictionary[@"quantity"]intValue];

    /*支付金额*/
    _paymoney.text= [NSString stringWithFormat:@"￥%.02f",piceCount];
    /*付款卡号*/
    _paycard.text= _sendBankCardId;
}

/*易宝信用卡还款*/
-(void)typeYiBaoCreditCardPayments
{
    /*支付金额*/
    _paymoney.text= self.myDictionary[@"paymoney"];
    /*付款卡号*/
    _paycard.text= _sendBankCardId;
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
}


/*易宝充值*/
-(void)typeYiBaoPhonePay
{
    /*支付金额*/
    _paymoney.text= [NSString stringWithFormat:@"￥%@",_paymoneyStr];
    /*付款卡号*/
    _paycard.text= [NSString stringWithFormat:@"%@",_payCard];
}

/*加载页面*/
-(void)ScrollerViewInType{
    
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
    
    self.rememberBtn.frame= CGRectMake(self.rememberBtn.frame.origin.x, self.rememberBtn.frame.origin.y, self.rememberBtn.frame.size.width, self.rememberBtn.frame.size.height);
    
    _payId.delegate= self;
    _payName.delegate= self;
    _payPhone.delegate= self;
    _payYZM.delegate= self;
    _payYZM.keyboardType= UIKeyboardTypeNumberPad;
    _payPhone.keyboardType= UIKeyboardTypeNumberPad;
    
    _scroller.frame = CGRectMake(0, 44, 320, _scroller.frame.size.height);
    _scroller.delegate = self;
    _scroller.contentSize = CGSizeMake(320, 670/*550*/);
}

/*对应类型的数据*/
-(void)yibaoTypeTopayMoney
{
    switch (self.myViewYiBaoType) {
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
        {     /*信用卡还款*/
            
        }
            break;
        case YiBaoPayType_Qcoin:
        {
            
        }
            break;
        case YiBaoPayType_Merchantsgathering:
        {    /*商户收款*/
            
        }
            break;
        default:
            break;
    }
}

/*提交及同意*/
- (IBAction)touchMore:(UIButton*)sender
{
    UIButton *btn= (UIButton*)sender;
    btn.selected =! btn.selected;
    switch (sender.tag) {
        case 5:
        {
            if (btn.selected) {
                _isRememberAccount = YES;
                _btnSayBankCard.selected= YES;
   
            }else{
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
            /*确定提交的*/
            if ([self checkData]) {
               
                if (_isRememberAccount==YES) {
                    
                    /*信用卡支付*/
                    [self yibaoTypeTopayMoney];

                }
                /*如果保存了银行卡信息*/
               else if (isremomberSayCard==YES)
                {
                 _btnSayBankCard.selected=YES;
                    
                }else{
                    
                    /*信用卡支付*/
                    [self yibaoTypeTopayMoney];
                }
            }
        }
            break;
        case 8:
        {
            if (btn.selected) {
                isremomberSayCard = YES;
               
            }else{
                isremomberSayCard = NO;
                if (_isRememberAccount==YES) {
                    _rememberBtn.selected= NO;
                }
            }
        }
            break;
        case 9:
        {
            if (btn.selected) {
                isremomberSayCard = YES;
                [self.btnSayBankCard setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            }else{
                isremomberSayCard = NO;
                [self.btnSayBankCard setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
            }
        }
            break;
        case 10:
        {
            /*协议*/
            [self xieyilist];
        }
            break;
        default:
            break;
    }

}

/*设为默认卡*/
-(void)isRememberBtnAction
{
    /*信用卡id*/
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }

}

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

/*保存此卡为信用卡*/
-(void)ApiAuthorKuaibkcardInfoAdd
{
    [self bankCardId];
//    NSString *bkcardisdefaultStr= _isRememberAccount?@"1":@"0";
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoDefault];
    REGISTER_NOTIFY_OBSERVER(self, ApiAuthorKuaibkcardInfoAdd, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoAdd:bankId bkcardbank:_bankList.titleLabel.text bkcardno:_payCard bkcardbankman:manName bkcardbankphone:payPhone bkcardyxmonth:expireMonthStr bkcardyxyear:expireYearStr bkcardcvv:cvv bkcardidcard:manCardId bkcardcardtype:@"creditcard" bkcardisdefault:@"1"];
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
    else
    {
        [_hud hide:YES];
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
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

/*同意协议*/
-(void)xieyilist{
    
    NSString* name = [NLUtils getNameForRequest:Notify_readAppruleList];
    
    REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, name);
    NSString* str;
    if (_btnToYB.tag==10) {
        str  = [NSString stringWithFormat:@"%d",7];
    }else{
        str = [NSString stringWithFormat:@"%d",6];
    }
 
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAppruleList:str];
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
            detail = @"请求失败，请检查网络";
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

-(void)hideAction{
    [_hud hide:YES];
}

//检查填入的信息是否都符合
-(BOOL)checkData
{
    BOOL check = YES;
    if (!check)
    {
        [self showErrorInfo:@"请填写正确的信息" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    if (_payYZM.text.length<3) {
        [self showErrorInfo:@"请输入正确位数的验证码" status:NLHUDState_Error];
        check = NO;
        return check;
    }if (_payPhone.text.length<10) {
        [self showErrorInfo:@"请输入正确的电话号码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    if (_payName.text.length<2) {
        [self showErrorInfo:@"请输入持卡人姓名" status:NLHUDState_Error];
        check = NO;
        return check;
    }if (_payId.text.length<16) {
        [self showErrorInfo:@"请输入正确的身份证号码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    
       return check;
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

/*获取列表数据的*/
- (IBAction)btnInScroller:(UIButton*)sender
{
    currentButton= sender;
    
    switch (sender.tag)
    {
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
-(void)backPlane{
    
    if ([self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
