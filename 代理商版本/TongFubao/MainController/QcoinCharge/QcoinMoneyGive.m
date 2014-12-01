//
//  NLRechargeCreditCardSecondViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "QcoinMoneyGive.h"
#import "NLKeyboardAvoid.h"
#import "NLRechargeCreditCardThirdViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProgressHUD.h"
#import "NLProtocolRegister.h"
#import "NLUtils.h"
#import "GTMBase64.h"
#import "UPPayPlugin.h"
#import "PhoneMoneyToOK.h"
#import "NLTransferResultViewController.h"

@interface QcoinMoneyGive ()
{
    NSString* _bankname;
    NSString* _bankID;
    NSString* _cardno;
    NSString* _paymoney;
    NSString* _cardmobile;
    NSString* _cardman;
    NSString* _paycardid;
    NSString* _banktype;
    NSString* _bkntno;
    NSString* _result;
    NSString* _sendsms;
    NSString* _payCardCheck;
    NSArray* _visaReaderArray;
    NSString* _resultPayCard;
   
    int      IOS7HEIGHT;
    int      _time;
    NLProgressHUD* _hud;
    VisaReader* _visaReader;
    
    UILabel *PhoneLable;
    UILabel *AddressLable;
    UILabel *PayMoneyLable;
    UILabel *PayMoney_Lable;
    
    /*显示或不显示*/
    BOOL _enablePayCard;
    BOOL _enableCardImage;
    
    BOOL flagToPay;
    BOOL flagnot;
    BOOL flagOnePay;
    BOOL flagYZM;
    /*手输判断状态*/
    BOOL flagText;
    BOOL flagNav;
    /*错误弹框*/
    BOOL flagAlert;
    BOOL flagTY;
    /*判断*/
    NSString *typeAlert;
    
    NSString *BankType;
    NSString *orderIdStr;
    NSString *verifyCodeStr;
    NSString *_Caredtype;
    NSString *paytype_check;
    
    NSMutableArray *mainCaredPerson;
    //用户名
    NSString *bkcardbankmansStrDF;
    //卡号
    NSString *bkcardnosStrDF;
    //所属银行id
    NSString *bkcardbankidsStrDF;
    //预留电话
    NSString *bkcardbankphonesStrDF;
    //有效月
    NSString *bkcardyxmonthsStrDF;
    //有效年
    NSString *bkcardyxyearsStrDF;
    //cvv
    NSString *bkcardcvvsStrDF;
    //身份证
    NSString *bkcardidcardsStrDF;
    //订单编号
    NSString *bkordernumber;
    //易宝订单号
    NSString *bkntno;
    //认证号
    NSString *verifytoken;
    //银行卡编号
    NSString *bkcardbankno;
    
    NSString *verifytokenDa;
    NSString *bkordernumberDa;
    NSString *bkntnoDa;
    
    
    UITextField    *alertText;
    UIImageView    *imageCard;
    
    /*刷卡器对比信用卡信息*/
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
    NSString * bkcardbankids;
    
    NSString *skqhaveYes;
    
    /*成功后返回*/
    NSString *okbankname;
    NSString *okpeoplename;
    NSString *okbankCard;
}

@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingScrollView *scroller;

@property (weak, nonatomic) IBOutlet UILabel *lablephone;
@property (weak, nonatomic) IBOutlet UILabel *lableIsOn;
@property (weak, nonatomic) IBOutlet UILabel *lableQBMoney;
@property (weak, nonatomic) IBOutlet UILabel *lableXY;

@property (weak, nonatomic) IBOutlet UIButton *btnChosse;
@property (weak, nonatomic) IBOutlet UIButton *OnBtnClick;
@property (weak, nonatomic) IBOutlet UIView *imageA;
@property (weak, nonatomic) IBOutlet UIView *imageB;

@property (weak, nonatomic) IBOutlet UIImageView *BKIcone;
@property (weak, nonatomic) IBOutlet UIButton *XinYongDefualCared;
@property (weak, nonatomic) IBOutlet UIButton *XinYongCared;
@property (weak, nonatomic) IBOutlet UITextField *TextFiledCared;
@property (weak, nonatomic) IBOutlet UILabel *BKBankname;
@property (weak, nonatomic) IBOutlet UILabel *BKnumber;
@property (weak, nonatomic) IBOutlet UILabel *BKtype;
@property (weak, nonatomic) IBOutlet UILabel *BKweihao;
@property (weak, nonatomic) IBOutlet UILabel *BKmanname;
@property (weak, nonatomic) IBOutlet UIView *viewBtn;

@property(nonatomic, readwrite, retain) NSTimer *myTimer;
@end

@implementation QcoinMoneyGive

@synthesize PhoneGiveStr,PhoneGiveStr2,PhoneNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initValue
{
    _bankname = @"";
    _bankID = @"";
    _paymoney = self.myMoney;
    _sendsms = [NSString stringWithFormat:@"%d", self.myNotifySMS];
    _cardno = @"";      //付款卡号
    _cardmobile = @"";   //付款手机
    _cardman = @"";      //付款姓名
    _paycardid = @"";
    _banktype = @"creditcard";
    _bkntno = @"";
    _result = @"";
    _enableCardImage = NO;
    _enablePayCard = YES;
    _resultPayCard = @"";
    _payCardCheck = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    if ([BankType isEqualToString:@"0"]&&![typeAlert isEqualToString:@"planepay"]) {
        _XinYongCared.selected= YES;
        _XinYongDefualCared.selected= NO;
        _TextFiledCared.hidden= NO;
        if (flagnot==YES) {

        [_TextFiledCared.layer setValue:@344 forKeyPath:@"frame.origin.y"];
        
        [_viewBtn.layer setValue:@415 forKeyPath:@"frame.origin.y"];

        }
    }
    //your code
    [super viewWillAppear:YES];
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

-(void)initVisaReader
{
    //_visaReader = [[VisaReader alloc] initWithDelegate:self];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*易宝跳转*/
- (IBAction)onButtonBtnClicked:(UIButton*)sender
{
    UIButton *btn= (UIButton*)sender;
    btn.selected =! btn.selected;
    
    switch (sender.tag)
    {
        case 1:
        {
            /*默认状态*/
            BankType= @"1";
        }
            break;
        case 2:
        {
            /*非默认状态*/
            BankType= @"0";
        }
            break;
        case 3:
        {
            /*选择银行卡进行付款*/
            /*选择信用卡*/
            [self.view endEditing:YES];
            MyBankCardViewController *bank= [[MyBankCardViewController alloc] init];
            bank.bankXY= YES;
            bank.bankPayListDelegate = self;
            [self.navigationController pushViewController:bank animated:YES];
        }
            break;
        case 4:
        {
            if (_XinYongCared.selected!=YES &&_XinYongDefualCared.selected!=YES) {
                
                [self showErrorInfo:@"请选择一种支付方式并输入正确卡号" status:NLHUDState_Error];
                [_hud hide:YES afterDelay:2];
            }else{
                /*成功显示*/
//                [self viewToPayYiBaotoOK];
                [self jumpToPayType];
             
            }
        }
            break;
        default:
            break;
    }

    if (btn.tag==1||btn.tag==2)
    {
        //信用卡
        if ([BankType isEqualToString:@"0"])
        {
            if (btn.tag==2)
            {
                if (btn.selected)
                {
                    _XinYongDefualCared.selected= NO;
                    _TextFiledCared.hidden= NO;
                    
                    /*是否有默认卡号*/
                    if (flagnot==YES)
                    {
                        [_TextFiledCared.layer setValue:@344 forKeyPath:@"frame.origin.y"];
                        [_viewBtn.layer setValue:@415 forKeyPath:@"frame.origin.y"];
                    }
                    else
                    {
                        [_TextFiledCared.layer setValue:@274 forKeyPath:@"frame.origin.y"];
                    }
                    NSLog(@"_XinYongCared.selected==YES");
                }
                else
                {
                    _TextFiledCared.hidden= YES;
                    if (flagnot==YES)
                    {
                        [_viewBtn.layer setValue:@415 forKeyPath:@"frame.origin.y"];
                    }
                    NSLog(@"_XinYongCared.selected==NO");
                }
            }
        }
        else  if ([BankType isEqualToString:@"1"])
        {
            //默认选中状态
            if (btn.tag==1)
            {
                _XinYongCared.selected= NO;
                _TextFiledCared.hidden= YES;
                [_viewBtn.layer setValue:@415 forKeyPath:@"frame.origin.y"];
              
                
                if (btn.selected)
                {
                    NSLog(@"_isRememberAccount==YES");
                    
                }
                else
                {
                    NSLog(@"_isRememberAccount==NO");
                }
            }
        }
    }
}
/*
 
 <?xml version="1.0" encoding="UTF-8"?>
 <operation_request><msgbody>
 
 <expireMonth>10</expireMonth>
 <paycardid/>
 <rechargeMoney>50</rechargeMoney>
 <mobileProvince/>
 <manCardId>440883199004250347</manCardId>
 <payMoney>50</payMoney>
 <bankCardId>6222300059359706</bankCardId>
 <rechargePhone>58566666</rechargePhone>
 <manName>柯小凤</manName>
 <expireYear>2014</expireYear>
 <bankId>1</bankId>
 <payPhone>13726154947</payPhone>
 <cvv>667</cvv>
 
 <?xml version="1.0" encoding="UTF-8"?>
 <operation_request><msgbody>
 <bkcardman>柯小凤</bkcardman>
 <paycardid/>
 <paytype>qqrecharge</paytype>
 <bkcardexpireMonth>10</bkcardexpireMonth>
 <bkcardcvv>667</bkcardcvv>
 <payMoney>50</payMoney>
 <rechargePhone>50</rechargePhone>
 <bkcardmanidcard>440883199004250347</bkcardmanidcard>
 <bankid>1</bankid>
 <bkcardexpireYear>2014</bkcardexpireYear>
 <bkcardPhone>13726154947</bkcardPhone>
 <bkCardno>6222300059359706</bkCardno>
 <RechargeQQ>58566666</RechargeQQ>
 
 */

/*通道状态*/
-(void)jumpToPayType
{
    /*默认状态*/
    if ([BankType isEqualToString:@"1"])
    {
        /*默认卡号的信用卡*/
        [self YIBAOQConeTodefual];
    }
   else if (_TextFiledCared.text.length==0||_TextFiledCared.text.length<15) {
        [self showErrorInfo:@"请输入正确卡号" status:NLHUDState_Error];
        [_hud hide:YES afterDelay:1.5];
    }else{
        if ([BankType isEqualToString:@"0"])
        {
            /*选择我的银行卡读取返回来的*/
            if (flagOnePay==YES)
            {
                /*银联*/
                [self QcoinMoneyRq];
            }
            else
            {
                /*信用卡*/
                [self YIBAOQConeTopay];
            }
            
        }
        else if ([BankType isEqualToString:@"2"])
        {
            /*刷卡的
            flagToPay=YES;*/
            if (bkcardcvvStr.length==0) {
                
                /*16位的储蓄卡*/
                if ([bkcardtypeStr isEqualToString:@"bankcard"])
                {
                    
                    /*银联*/
                    [self QcoinMoneyRq];
                }else{
                    if (_TextFiledCared.text.length==16) {
                        
                        [self alertNotoBtn];
                    }
                    else
                    {
                        /*银联*/
                        [self QcoinMoneyRq];
                    }
                    
                }
                
            }
            else
            {
                /*刷卡后信用卡有数据返回则是否储蓄卡或信用卡*/
                if (_TextFiledCared.text.length==16)
                {
                    /*刷卡易宝信用卡通道*/
                    [self getApipayCardCheckStrYiBao];
                }
                else
                {
                    /*银联*/
                    [self QcoinMoneyRq];
                }
            }
            
        }
        else if ([BankType isEqualToString:@"3"])
        {
            _cardno= _TextFiledCared.text;
            /*选择信用卡之后再重新输入正确的卡号*/
             NSString *strCarno= [mainCaredPerson valueForKey:@"bkcardnos"];
            if ([strCarno isEqualToString:_cardno]) {
                
                /*选择我的银行卡读取返回来的*/
                if (flagOnePay==YES)
                {
                    /*储蓄卡*/
                     [self QcoinMoneyRq];
                }else{
                    /*信用卡*/
                     [self getApipayCardCheckStrYiBao];
                }
                
            }else{
                if (_cardno.length==0&&_TextFiledCared.text.length==0) {
                    [self showErrorInfo:@"请选择一种支付方式" status:NLHUDState_Error];
                    [_hud hide:YES afterDelay:2];
                }else
                {
                    
                    /*手写的状态*/
                    if (_TextFiledCared.text.length==16)
                    {
                        /*手输入判断类型*/
                        [self alertNotoBtn];
                    }
                    else
                    {
                        /*储蓄卡*/
                        [self QcoinMoneyRq];
                    }
                }
            }
            
        }
    }
}

/*刷卡获取后台是否有数据 信用卡通道*/
-(void)getApipayCardCheckStrYiBao
{

    /*成功后返回正确数据*/
    bkcardnosStrDF= bkcardnoCheckStr;
    _BKBankname.text= bkcardbanknameStr;
    _BKmanname.text= bkcardmanCheckStr;

    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiqqrechargeReq];
    flagTY= YES;
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiqqrechargeReq:PhoneGiveStr rechargemoney:PhoneGiveStr2 RechargeQQ:PhoneNum bkCardno:bkcardnoCheckStr bkcardman:bkcardmanCheckStr bkcardexpireMonth:bkcardyxmonthStr bkcardmanidcard:bkcardidcardStr bankid:bkcardbankids bkcardexpireYear:bkcardyxyearStr bkcardPhone:bkcardphoneStr bkcardcvv:bkcardcvvStr paytype:paytype_check paycardid:_payCardCheck];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark - BanklistpayDelegate
- (void)popWithValue:(NSMutableArray *)person creditCard:(BOOL)flag
{
    NSLog(@"card %@",person);

    /*非默认状态*/
    /*返回有数据 非刷卡*/
    BankType= @"0";
    flagOnePay= flag;
    mainCaredPerson= [NSMutableArray array];
    mainCaredPerson= person;
    
    _TextFiledCared.hidden= NO;
    _XinYongCared.selected= YES;
    _XinYongDefualCared.selected= NO;
    _TextFiledCared.text= [person valueForKey:@"bkcardnos"];
    bkcardbankids= [person valueForKey:@"bkcardbankids"];
    
    if (flag == YES)
    {
        if (flagnot == YES)
        {
            [_TextFiledCared.layer setValue:@344 forKeyPath:@"frame.origin.y"];
          
            [_viewBtn.layer setValue:@415 forKeyPath:@"frame.origin.y"];
        }
        else
        {
            [_TextFiledCared.layer setValue:@284 forKeyPath:@"frame.origin.y"];
        }
    }
    else if (flag == NO)
    {
        /*信用卡*/
        if (flagnot == YES)
        {
            [_TextFiledCared.layer setValue:@344 forKeyPath:@"frame.origin.y"];
            [_viewBtn.layer setValue:@435 forKeyPath:@"frame.origin.y"];
        }
        else
        {
            [_TextFiledCared.layer setValue:@284 forKeyPath:@"frame.origin.y"];
        }
    }

    /*成功返回数据*/
    okbankCard= [mainCaredPerson valueForKey:@"bkcardnos"];
    okbankname= [mainCaredPerson valueForKey:@"bkcardbanks"];
    okpeoplename= [mainCaredPerson valueForKey:@"bkcardbankmans"];
}

/*易宝选择卡接口*/
-(void)YIBAOQConeTopay
{
    /*易宝转账信用卡数据*/
    //身份证
    NSString *bkcardidcardsStr= [mainCaredPerson valueForKey:@"bkcardidcards"];
    //cvv
    NSString *bkcardcvvsStr= [mainCaredPerson valueForKey:@"bkcardcvvs"];
    //有效年
    NSString *bkcardyxyearsStr= [mainCaredPerson valueForKey:@"bkcardyxyears"];
    //有效月
    NSString *bkcardyxmonthsStr= [mainCaredPerson valueForKey:@"bkcardyxmonths"];
    //预留电话
    NSString *bkcardbankphonesStr= [mainCaredPerson valueForKey:@"bkcardbankphones"];
    //所属银行id
    NSString *bkcardbankidsStr= [mainCaredPerson valueForKey:@"bkcardbankids"];
    //卡号
    NSString *bkcardnosStr= [mainCaredPerson valueForKey:@"bkcardnos"];
    //用户名
    NSString *bkcardbankmansStr= [mainCaredPerson valueForKey:@"bkcardbankmans"];
   
    /*选择了默认的再选择银行卡的信息的值*/
    if (bkcardnosStr==nil) {
        /*身份证*/
        bkcardidcardsStr= bkcardidcardStr;
        /*cvv*/
        bkcardcvvsStr= bkcardcvvStr;
        /*年*/
        bkcardyxyearsStr= bkcardyxyearStr;
        /*月*/
        bkcardyxmonthsStr= bkcardyxmonthStr;
        /*电话*/
        bkcardbankphonesStr= bkcardphoneStr;
        /*银行id*/
        bkcardbankidsStr= bkcardbankidCheckStr;
        /*卡号*/
        bkcardnosStr= bkcardnoCheckStr;
        /*用户名*/
        bkcardbankmansStr= bkcardmanCheckStr;
   
    }
    flagTY= YES;
    /*记得修改 Notify_ApiYiBaoPhonePay*/
    NSString* name = [NLUtils getNameForRequest:Notify_ApiqqrechargeReq];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    if (_paycardid.length==0) {
        _paycardid= @"";
    }
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiqqrechargeReq:PhoneGiveStr rechargemoney:PhoneGiveStr2 RechargeQQ:PhoneNum bkCardno:bkcardnosStr bkcardman:bkcardbankmansStr bkcardexpireMonth:bkcardyxmonthsStr bkcardmanidcard:bkcardidcardsStr bankid:bkcardbankidsStr bkcardexpireYear:bkcardyxyearsStr bkcardPhone:bkcardbankphonesStr bkcardcvv:bkcardcvvsStr paytype:paytype_check paycardid:_payCardCheck];
    
    [self showErrorInfo:@"请稍待" status:NLHUDState_None];
}

/*默认选中卡号直接支付状态*/
-(void)YIBAOQConeTodefual
{
    /*这里写Q币默认卡信息*/
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    flagTY= YES;
    NSString* name = [NLUtils getNameForRequest:Notify_ApiqqrechargeReq];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    
    /*换个接口 把df的对应值放进去
     
     <?xml version="1.0" encoding="UTF-8"?>
     <operation_request><msgbody>
     
     <bkcardman>柯小凤</bkcardman>
     <paycardid/>
     <paytype>qqrecharge</paytype>
     <bkcardexpireMonth>10</bkcardexpireMonth>
     <bkcardcvv>667</bkcardcvv>
     <payMoney>50</payMoney>
     <rechargePhone>50</rechargePhone>
     <bkcardmanidcard>440883199004250347</bkcardmanidcard>
     <bankid>1</bankid>
     <bkcardexpireYear>2014</bkcardexpireYear>
     <bkcardPhone>13726154947</bkcardPhone>
     <bkCardno>6222300059359706</bkCardno>
     <RechargeQQ>58566666</RechargeQQ></msgbody>
     */
    
     [[[NLProtocolRequest alloc] initWithRegister:YES] getApiqqrechargeReq:strRechamoney rechargemoney:PhoneGiveStr2 RechargeQQ:PhoneNum bkCardno:bkcardnosStrDF bkcardman:bkcardbankmansStrDF bkcardexpireMonth:bkcardyxmonthsStrDF bkcardmanidcard:bkcardidcardsStrDF bankid:bkcardbankidsStrDF bkcardexpireYear:bkcardyxyearsStrDF bkcardPhone:bkcardbankphonesStrDF bkcardcvv:bkcardcvvsStrDF paytype:paytype_check paycardid:_payCardCheck];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*易宝手机充值 默认状态*/
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
            detail = @"服务器繁忙，请稍候再试";
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
        NLProtocolData* data = [response.data find:@"msgbody/orderId" index:0];
        orderIdStr = data.value;
        
        //订单编号
        NLProtocolData *bkordernumberData = [response.data find:@"msgbody/bkordernumber" index:0];
        bkordernumberDa = bkordernumberData.value;
        
        //易宝订单号
        NLProtocolData *bkntnoData = [response.data find:@"msgbody/bkntno" index:0];
        bkntnoDa = bkntnoData.value;
        
        /*verifyCode 验证码*/
        data = [response.data find:@"msgbody/verifyCode" index:0];
        verifyCodeStr = data.value;
        
        if ([verifyCodeStr intValue] == 1)
        {
            if (flagTY)
            {
                flagYZM=YES;
                typeAlert= @"typeYZM";
                flagAlert= YES;

                /*短信限制*/
                [self startTimeoutTimer];
                
                NSString *message = @"请输入您手机验证码";
                NSString *cancelName = @"取 消";
                UIAlertView *agentAlertView = [[UIAlertView alloc] initWithTitle:@"提 示" message:message delegate:self cancelButtonTitle:cancelName otherButtonTitles:@"确 定", nil];
                agentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                alertText = [agentAlertView textFieldAtIndex:0];
                alertText.keyboardType = UIKeyboardTypeNumberPad;
                alertText.placeholder= @"请输入您的验证码";
                alertText.delegate = self;
//                [alertText resignFirstResponder];
                [agentAlertView show];
                flagTY = NO;
            }
        }
        else  if ([verifyCodeStr intValue] != 1)
        {
            /*对应不同的状态 成功*/
            [self viewToPayYiBaotoOK];
           
        }
    }
}

/*信用卡提示*/
-(void)alertNotoBtn
{
    typeAlert= @"planepay";
    
    [NLUtils showAlertView:@"温馨提示"
                       message:@"您当前使用的卡号为信用卡，是否选择信用卡支付通道？"
                      delegate:self
                           tag:0
                     cancelBtn:@"信用卡支付"
                         other:@"借记卡支付",nil];

}

/*手动输入判断*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        if (flagYZM!=YES) {
            /*信用卡通道*/
            flagToPay= NO;
            [self XYdefualtoPay];
        }
        /*刷卡器的状态*/
        if (flagToPay == YES) {
            
            /*信用卡*/
            if ([typeAlert isEqualToString:@"planepay"]) {
                
                [self XYdefualtoPay];
                
            }else{
            /*取消状态*/
                
            }
        }
    }
    else
    {
        /*刷卡的*/
        if (flagYZM!=YES) {
            /*短信验证码和信用卡储蓄卡的判断*/
            flagToPay= NO;
            /*银联*/
            [self QcoinMoneyRq];
            
        }
        /*刷卡的请框况*/
        if ([BankType isEqualToString:@"2"]) {
            
            /*
            if (flagYZM!=YES) {
             
                [self QcoinMoneyRq];
                
            }else{
              */
            
            /*验证码*/
            if ([typeAlert isEqualToString:@"planepay"]) {
                /*银联*/
                [self QcoinMoneyRq];
            }else{
                if (alertText.text.length==0) {
                    
                    [self showErrorInfo:@"请输入正确的验证码" status:NLHUDState_Error];
                    [_hud hide:YES afterDelay:1.5];
                    
                }else{
                    
                    [self readRechaPayTypeinfo];
                }
            }

        }
        else{
            
            
            if (flagYZM==YES) {
                
                /*不刷卡的情况*/
                if (alertText.text.length==0) {
                    
                    [self showErrorInfo:@"请输入正确的验证码" status:NLHUDState_Error];
                    [_hud hide:YES afterDelay:1.5];
                    
                }else{
                    
                    [self readRechaPayTypeinfo];

                }
            }
        }
    }
}

/*信用卡跳转*/
-(void)XYdefualtoPay
{
    CardInfo *cardInfo = [[CardInfo alloc] init];
    //卡号
    cardInfo.bkcardno = _TextFiledCared.text;
    //金额
    cardInfo.payMoney = PhoneGiveStr;
    //Q号
    cardInfo.qNumber = PhoneNum;
    //刷卡器设备号
    cardInfo.paycardid = _payCardCheck;
    
    [self.view endEditing:YES];
    /*对应的数据填充替换*/
    planePay *pla= [[planePay alloc]init];
    pla.myViewYiBaoType= YiBaoPayType_Qcoin;
    pla.cardInfo = cardInfo;
    pla.typePayYIBao= YES;
    pla.cardReaderId= _paycardid;
    [self.navigationController pushViewController:pla animated:YES];
}

/*易宝充值验证码*/
-(void)readRechaPayTypeinfo
{
    verifytokenDa = alertText.text;
    NSString* name = [NLUtils getNameForRequest:Notify_ApiqqrechargeSMSverify];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiqqrechargeSMSverify:verifytokenDa bkordernumber:bkordernumberDa bkntno:bkntnoDa verifytoken:verifyCodeStr];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
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
         [self viewToPayYiBaotoOK];
    }
}

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
            /*当前没设置 没数据隐藏*/
            flagnot= NO;
            [_imageA setHidden:YES];
            _lableXY.text= @"银行卡支付";
            [_imageB.layer setValue:@205 forKeyPath:@"frame.origin.y"];
            _TextFiledCared.hidden= NO;
            _XinYongCared.selected= YES;
            [_TextFiledCared.layer setValue:@274 forKeyPath:@"frame.origin.y"];
        }
    }
}

-(void)doApiPaychannelInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        flagnot= NO;
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        /*hide默认 如果能读取信息 不隐藏*/
        flagnot= YES;
        BankType= @"1";
        flagNav= YES;
        _lableXY.text= @"其他卡支付";
        _imageA.hidden= NO;
        _XinYongDefualCared.selected= YES;
        [_imageB.layer setValue:@273 forKeyPath:@"frame.origin.y"];
        [_viewBtn.layer setValue:@415 forKeyPath:@"frame.origin.y"];
        
        /*所属银行*/
        NLProtocolData* bank = [response.data find:@"msgbody/msgchild/bkcardbank" index:0];
        _BKBankname.text= bank.value;
        
        /*图片*/
        NLProtocolData* data = [response.data find:@"msgbody/msgchild/bkcardbanklogo" index:0];
        NSString* icon = data.value;
        _BKIcone.image= [UIImage imageNamed:icon];
        
        /*尾号 判断才改*/
        NLProtocolData* cardNumbeData = [response.data find:@"msgbody/msgchild/bkcardno" index:0];
        NSString *cardNumbe = [cardNumbeData.value substringFromIndex:(cardNumbeData.value.length - 4)];
        _BKnumber.text= cardNumbe;
        
        /*卡类型*/
        NLProtocolData* cardTypeData = [response.data find:@"msgbody/msgchild/bkcardcardtype" index:0];
        NSString *cardType = [cardTypeData.value isEqualToString:@"bankcard"]? @"储蓄卡" : @"信用卡";
        _BKtype.text= cardType;
        
        /*持卡人*/
        NLProtocolData* bkcardbankmanData = [response.data find:@"msgbody/msgchild/bkcardbankman" index:0];
        NSString *bkcardbankman= bkcardbankmanData.value;
        _BKmanname.text= bkcardbankman;
        
        //身份证
        NLProtocolData* bkcardidcardsData = [response.data find:@"msgbody/msgchild/bkcardidcard" index:0];
        
        bkcardidcardsStrDF= bkcardidcardsData.value;
        //cvv
        NLProtocolData* bkcardcvvsData = [response.data find:@"msgbody/msgchild/bkcardcvv" index:0];
        
        bkcardcvvsStrDF= bkcardcvvsData.value;
        //有效年
        NLProtocolData* bkcardyxyearsData = [response.data find:@"msgbody/msgchild/bkcardyxyear" index:0];
        
        bkcardyxyearsStrDF= bkcardyxyearsData.value;
        //有效月
        NLProtocolData* bkcardyxmonthsData = [response.data find:@"msgbody/msgchild/bkcardyxmonth" index:0];
        
        bkcardyxmonthsStrDF= bkcardyxmonthsData.value;
        //预留电话
        NLProtocolData* bkcardbankphonesData = [response.data find:@"msgbody/msgchild/bkcardbankphone" index:0];
        
        bkcardbankphonesStrDF= bkcardbankphonesData.value;
        //所属银行id
        NLProtocolData* bkcardbankidsData = [response.data find:@"msgbody/msgchild/bkcardbankcode" index:0];
        
        bkcardbankidsStrDF= bkcardbankidsData.value;
        //卡号
        NLProtocolData* bkcardnosData = [response.data find:@"msgbody/msgchild/bkcardno" index:0];
        
        bkcardnosStrDF= bkcardnosData.value;
        //用户名
        NLProtocolData* bkcardbankmansData = [response.data find:@"msgbody/msgchild/bkcardbankman" index:0];
        
        bkcardbankmansStrDF= bkcardbankmansData.value;
        
        //订单编号
        NLProtocolData *bkordernumberData = [response.data find:@"msgbody/msgchild/bkordernumber" index:0];
        bkordernumber = bkordernumberData.value;
        
        //易宝订单号
        NLProtocolData *bkntnoData = [response.data find:@"msgbody/msgchild/bkntno" index:0];
        bkntno = bkntnoData.value;
        
        //认证号
        NLProtocolData *verifytokenData = [response.data find:@"msgbody/msgchild/verifytoken" index:0];
        verifytoken = verifytokenData.value;
        
        /*成功*/
        okbankname= _BKBankname.text;
        okpeoplename= _BKmanname.text;
        okbankCard= bkcardnosStrDF;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //加一层 背景 防止整体向上滚的时候部分黑色
    UIView *bigV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 800)];
    bigV.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    [self.view addSubview:bigV];
    [self.view sendSubviewToBack:bigV];
    
    [self.view endEditing:YES];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"付款";
    
    IOS7HEIGHT = IOS7_OR_LATER == YES? 0 : 64;
    
    [self initValue];
    
    [self initVisaReader];
    
    [self PhoneMoneyLable];
    
   
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

- (void)PhoneMoneyLable
{
    /*是否默认 易宝支付*/
    /*交易类型*/
    paytype_check= [[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0];
    
    [self ApiPaychannelInfo];
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
    self.TextFiledCared.leftView = paddingView3;
    _TextFiledCared.delegate= self;
    self.TextFiledCared.leftViewMode = UITextFieldViewModeAlways;
    [self.scroller addSubview:_TextFiledCared];
    _imageA.hidden= YES;
    [_imageB.layer setValue:@205 forKeyPath:@"frame.origin.y"];
    [_viewBtn.layer setValue:@365 forKeyPath:@"frame.origin.y"];

    UIView *rightCared = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    imageCard= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageCard.image=  [UIImage imageNamed:@"swipingCard.png"];
    [rightCared addSubview:imageCard];
    self.TextFiledCared.rightView = rightCared;
    self.TextFiledCared.rightViewMode = UITextFieldViewModeAlways;
    [self.scroller addSubview:_TextFiledCared];
    
    _TextFiledCared.hidden= YES;
    
    if (_enableCardImage)//判断bool状态
    {
        imageCard.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        imageCard.image = [UIImage imageNamed:@"swipingCard.png"];
    }
    
    self.lablephone.frame= CGRectMake(self.lablephone.frame.origin.x, self.lablephone.frame.origin.y-IOS7HEIGHT, self.lablephone.frame.size.width, self.lablephone.frame.size.height);
    
    self.lableQBMoney.frame= CGRectMake(self.lableQBMoney.frame.origin.x, self.lableQBMoney.frame.origin.y-IOS7HEIGHT, self.lableQBMoney.frame.size.width, self.lableQBMoney.frame.size.height);
    
    self.lableIsOn.frame= CGRectMake(self.lableIsOn.frame.origin.x, self.lableIsOn.frame.origin.y-IOS7HEIGHT, self.lableIsOn.frame.size.width, self.lableIsOn.frame.size.height);
    
    PhoneLable= [LableModel LableTile:PhoneNum TitleFrame:CGRectMake(118, 35-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:25];
    
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"￥" withString:@".00"];
    
    PayMoneyLable= [LableModel LableTile:[NSString stringWithFormat:@" %@",strRechamoney] TitleFrame:CGRectMake(118, 70-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:240/255.0 green:173/255.0 blue:78/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:23];
    
    PayMoney_Lable= [LableModel LableTile:[NSString stringWithFormat:@"￥%@",PhoneGiveStr2] TitleFrame:CGRectMake(118, 101-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:238/255.0 green:162/255.0 blue:54/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:23];
    
    [_scroller addSubview:PhoneLable];
    [_scroller addSubview:PayMoneyLable];
    [_scroller addSubview:PayMoney_Lable];
}

#pragma showErrorInfo
//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [self oneFingerTwoTaps];
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

#pragma 验证码超时
/*计时器*/
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


/*验证码期限*/
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
            if (_OnBtnClick.enabled)
            {
                _OnBtnClick.enabled = NO;
            }
        }
            break;
        case NLReGetBtnState_EnableTitle:
        {
            [_OnBtnClick setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0)] forState:UIControlStateNormal];
            [_OnBtnClick setTitle:@"重新提交获取" forState:UIControlStateNormal];
            
            if (!_OnBtnClick.enabled)
            {
                _OnBtnClick.enabled = YES;
            }
        }
            break;
        case NLReGetBtnState_DisableTitle:
        {
            
            [_OnBtnClick setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0)] forState:UIControlStateNormal];
            _OnBtnClick.titleLabel.text= title;
            [_OnBtnClick setTitle:_OnBtnClick.titleLabel.text forState:UIControlStateNormal];
            
            if (_OnBtnClick.enabled)
            {
                _OnBtnClick.enabled = NO;
            }
        }
            break;
        case NLReGetBtnState_Enable:
        {
            NSLog(@"NLReGetBtnState_Enable");
            
            if (!_OnBtnClick.enabled)
            {
                _OnBtnClick.enabled = YES;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - keyboard hide event
-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    [firstResponder resignFirstResponder];
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
        _enableCardImage = YES;
        
        /*刷卡器重写*/
        imageCard.image = [UIImage imageNamed:@"swipingCard2.png"];
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        
        imageCard.image = [UIImage imageNamed:@"swipingCard.png"];
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)resetCardNumber:(NSString *)str
{
    if (str.length > 0)
    {
        /*刷卡器重写*/
        _TextFiledCared.text= str;
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.myTextField.text = str;
    }
}

#pragma mark - oPayCardCheck
//验证刷卡器卡号的长度
-(BOOL)checkTransferInfo
{
    _cardno= _TextFiledCared.text;
    
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
    /*刷卡器的判断*/
    BankType= @"2";
    flagToPay= YES;
    
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
            _Caredtype= [_visaReaderArray objectAtIndex:2];
            NSString *time= [_visaReaderArray objectAtIndex:3];
            NSLog(@"type---%@  time年月 %@",_Caredtype,time);
            if (_paycardid.length >= 14)
            {
                _paycardid = [_paycardid substringToIndex:14];
                _paycardid = [_paycardid lowercaseString];
            }
            _payCardCheck = _paycardid;
            [self resetCardNumber:_cardno];
            /*刷卡器旧版*/
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
        /*写入成功*/
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* result = data.value;
        [self showErrorInfo:result status:NLHUDState_NoError];
        
        skqhaveYes= @"cardtype";
        
        //银行卡号
        NLProtocolData* bkcardnoCheck = [response.data find:@"msgbody/bkcardno" index:0];
        bkcardnoCheckStr = bkcardnoCheck.value;
        //执卡人
        NLProtocolData* bkcardmanCheck = [response.data find:@"msgbody/bkcardman" index:0];
        bkcardmanCheckStr = bkcardmanCheck.value;
        //预留手机号码
        NLProtocolData* bkcardphoneCheck = [response.data find:@"msgbody/bkcardphone" index:0];
        bkcardphoneStr= bkcardphoneCheck.value;
        //银行id
        NLProtocolData* bkcardbankidCheck = [response.data find:@"msgbody/bkcardbankid" index:0];
        bkcardbankidCheckStr= bkcardbankidCheck.value;
        //银行名
        NLProtocolData* bkcardbanknameCheck = [response.data find:@"msgbody/bkcardbankname" index:0];
        bkcardbanknameStr= bkcardbanknameCheck.value;
        //有效月
        NLProtocolData* bkcardyxmonthCheck = [response.data find:@"msgbody/bkcardyxmonth" index:0];
        bkcardyxmonthStr= bkcardyxmonthCheck.value;
        //有效年
        NLProtocolData* bkcardyxyearCheck = [response.data find:@"msgbody/bkcardyxyear" index:0];
        bkcardyxyearStr= bkcardyxyearCheck.value;
        //CVV校验
        NLProtocolData* bkcardcvvCheck = [response.data find:@"msgbody/bkcardcvv" index:0];
        bkcardcvvStr= bkcardcvvCheck.value;
        //身份证
        NLProtocolData* bkcardidcardCheck = [response.data find:@"msgbody/bkcardidcard" index:0];
        bkcardidcardStr= bkcardidcardCheck.value;
        //银行卡类型
        NLProtocolData* bkcardtypeCheck = [response.data find:@"msgbody/bkcardtype" index:0];
        bkcardtypeStr= bkcardtypeCheck.value;
        
        /*填充信息 传到易宝*/
        okbankname= bkcardbanknameStr;
        okpeoplename= bkcardmanCheckStr;
        okbankCard= bkcardnoCheckStr;
    }
}

/*刷卡器的数据*/
-(void)doPayCardCheckNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString* result = data.value;
    [self showErrorInfo:result status:NLHUDState_NoError];
    
    //银行卡号
    NLProtocolData* bkcardnoCheck = [response.data find:@"msgbody/bkcardno" index:0];
    bkcardnoCheckStr = bkcardnoCheck.value;
    //执卡人
    NLProtocolData* bkcardmanCheck = [response.data find:@"msgbody/bkcardman" index:0];
    bkcardmanCheckStr = bkcardmanCheck.value;
    //预留手机号码
    NLProtocolData* bkcardphoneCheck = [response.data find:@"msgbody/bkcardphone" index:0];
    bkcardphoneStr= bkcardphoneCheck.value;
    //银行id
    NLProtocolData* bkcardbankidCheck = [response.data find:@"msgbody/bkcardbankid" index:0];
    bkcardbankidCheckStr= bkcardbankidCheck.value;
    //银行名
    NLProtocolData* bkcardbanknameCheck = [response.data find:@"msgbody/bkcardbankname" index:0];
    bkcardbanknameStr= bkcardbanknameCheck.value;
    //有效月
    NLProtocolData* bkcardyxmonthCheck = [response.data find:@"msgbody/bkcardyxmonth" index:0];
    bkcardyxmonthStr= bkcardyxmonthCheck.value;
    //有效年
    NLProtocolData* bkcardyxyearCheck = [response.data find:@"msgbody/bkcardyxyear" index:0];
    bkcardyxyearStr= bkcardyxyearCheck.value;
    //CVV校验
    NLProtocolData* bkcardcvvCheck = [response.data find:@"msgbody/bkcardcvv" index:0];
    bkcardcvvStr= bkcardcvvCheck.value;
    //身份证
    NLProtocolData* bkcardidcardCheck = [response.data find:@"msgbody/bkcardidcard" index:0];
    bkcardidcardStr= bkcardidcardCheck.value;
    //银行卡类型
    NLProtocolData* bkcardtypeCheck = [response.data find:@"msgbody/bkcardtype" index:0];
    bkcardtypeStr= bkcardtypeCheck.value;
    
    //银行卡编号
    NLProtocolData *bkcardbanknoData = [response.data find:@"msgbody/msgchild/bkcardbankno" index:0];
    bkcardbankno = bkcardbanknoData.value;
}

-(void)payCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    NSString* detail = response.detail;
    
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
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
            detail = @"服务器繁忙，请稍候再试";
        }
        _resultPayCard = detail;
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)payCardCheck
{
    NSString* name = [NLUtils getNameForRequest:Notify_payCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payCardCheck:_payCardCheck];
    [self showErrorInfo:@"正在验证刷卡器" status:NLHUDState_None];
}

//获取流水线并跳到银联
-(void)doQcoinMoneyRqNotify:(NLProtocolResponse *)response
{
    NLProtocolData* data =  [response.data find:@"msgbody/bkntno" index:0];
    _bkntno = data.value;
    [_hud hide:YES];
    
    [self doStartPay:_bkntno
          sysProvide:nil
                spId:nil
                mode:[NLUtils get_req_bkenv]
      viewController:self
            delegate:self];
}

//刷卡后信息正确提交 银联
-(void)QcoinMoneyRq
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_RechaQQMoneyRq];
    REGISTER_NOTIFY_OBSERVER(self, QcoinMoneyRqNotify, name);
    /*手输或者刷卡的*/
    if (flagOnePay==YES) {
        _cardno= _TextFiledCared.text;
    }
    NSString* str = [_visaReaderArray objectAtIndex:2];
    NSData* data = [NLUtils stringToData:str];
    NSString* merReserved = [GTMBase64 stringByEncodingData:data];
    //参数列表 paycardid:
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    [[[NLProtocolRequest alloc] initWithRegister:YES] payQQcardIDRq:_paycardid rechapaytypeid:@"1" rechamoney:strRechamoney rechapaymoney:PhoneGiveStr2 rechaqq:PhoneNum rechabkcardno:_cardno rechabkcardid:@"1" merReserved:merReserved];
}

-(void)QcoinMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)//正确的话
    {
        [self doQcoinMoneyRqNotify:response];
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
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"cancel"] || [result isEqualToString:@"fail"])
    {
        _result = result;
        NSLog(@"_result%@",_result);
    }
    else
    {
        return;
    }
    
    if (![result isEqualToString:@"cancel"]) {
        flagNav= NO;
        [self ensureQQChargePayCardMoney];
    }
    
}

- (BOOL)doStartPay:(NSString *)payData sysProvide:(NSString*)sysProvide spId:(NSString*)spId mode:(NSString*)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate;
{
    return [UPPayPlugin startPay:payData mode:mode viewController:viewController delegate:delegate];
}

//银联返回的数据
#pragma elseShow
-(void)showMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma mark 支付返回
-(void)ensureQQChargePayCardMoney
{
    NSString* name = [NLUtils getNameForRequest:Notify_checkRechaQQMoneyStatus];
    REGISTER_NOTIFY_OBSERVER(self, checkRechaQQMoneyStatusNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkRechaQQMoneyStatus:_bkntno result:_result];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)checkRechaQQMoneyStatusNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doCheckRechaQQMoneyStatusNotify:response];
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
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//充值完成返回来的页面（这个是转账的页面）
-(void)doCheckRechaQQMoneyStatusNotify:(NLProtocolResponse*)response
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
        /*成功*/
        [self viewToPayYiBaotoOK];
        
        /*非首页冲 充值号码到本地 一会改*/
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *numArr = [userDefault objectForKey:@"chargeQQList"];
        
        if (numArr == nil)
        {
            numArr = [NSMutableArray array];
            [numArr addObject:PhoneNum];
        }
        else
        {
            if (numArr.count>1) {
                
                for (int i = 0; i < numArr.count; i++)
                {
                    if ([PhoneNum isEqualToString:numArr[i]])
                    {
                        [numArr removeObjectAtIndex:i];
                    }
                }
                
                [numArr insertObject:PhoneNum atIndex:0];
                
            
            }
            
            if (numArr.count > 3)
            {
                for (int i = 3; i < numArr.count; i++)
                {
                    [numArr removeLastObject];
                }
            }
            
        }
        
    }
}

/*成功状态*/
-(void)viewToPayYiBaotoOK
{
    NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
    [self createInforForResultView:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createInforForResultView:(NLTransferResultViewController*)vc
{
    vc.myNavigationTitle = @"Q币充值结果";
    vc.myTitle = @"Q币充值成功";
    
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    /*Q充值*/
     if (flagNav == NO)
     {
         NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", _TextFiledCared.text,@"content", nil];
         [arr addObject:dic];
         dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值QQ",@"header", PhoneNum,@"content", nil];
         [arr addObject:dic];
         dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值金额",@"header", strRechamoney,@"content", nil];
         [arr addObject:dic];
         dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", PhoneGiveStr2,@"content", nil];
         [arr addObject:dic];
     }else
     {
         /*易宝*/
         NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", okbankCard,@"content", nil];
         [arr addObject:dic];
         dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", okbankname,@"content", nil];
         [arr addObject:dic];
         dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", okpeoplename,@"content", nil];
         [arr addObject:dic];
         dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值Q 号",@"header", PhoneNum,@"content", nil];
         [arr addObject:dic];
         dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值金额",@"header", strRechamoney,@"content", nil];
         [arr addObject:dic];
         dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", PhoneGiveStr2,@"content", nil];
         [arr addObject:dic];
         
         
     }
  
    vc.myArray = [NSArray arrayWithArray:arr];
}

#pragma mark -textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_TextFiledCared==textField) {
        
        BankType= @"3";
        flagText= YES;
        flagYZM= NO;
    }
    [self performSelector:@selector(change:) withObject:nil];
}

-(void)changeTextEvent:(UITextField *)textField;
{
    _cardno = textField.text;
}

#pragma mark 键盘移动
- (void)change:(id)sender
{
    //创建一个仿射变换
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, -IOS7HEIGHT);
    
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

@end










