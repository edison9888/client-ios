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
#import "BaseButton.h"
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
    NLProgressHUD* _hud;
    VisaReader* _visaReader;
    
    UILabel *PhoneLable;
    UILabel *AddressLable;
    UILabel *PayMoneyLable;
    UILabel *PayMoney_Lable;
    
    /*显示或不显示*/
    BOOL _enablePayCard;
    BOOL _enableCardImage;
    BOOL flagnot;
    BOOL flagOnePay;
    BOOL flagYZM;
    BOOL flagText;/*手输判断状态*/
    
    NSString *BankType;
    NSString *orderIdStr;
    NSString *verifyCodeStr;
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
    
    UITextField    *alertText;
}

@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingScrollView *scroller;

@property (weak, nonatomic) IBOutlet UILabel *lablephone;
@property (weak, nonatomic) IBOutlet UILabel *lableIsOn;
@property (weak, nonatomic) IBOutlet UILabel *lableQBMoney;

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

-(void)viewDidAppear:(BOOL)animated
{
//    [NLUtils enableSliderViewController:NO];
    
    [self startVisaReader];
    
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [NLUtils enableSliderViewController:YES];
    
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
                detail = @"请求失败，请检查网络";
            }
        
        NSRange range = [detail rangeOfString:@"没设置"];
        if (range.length > 0)/*>0 <=不正确*/
        {
            /*当前没设置 没数据隐藏*/
            flagnot= NO;
            [_imageA setHidden:YES];
            [_imageB.layer setValue:@245 forKeyPath:@"frame.origin.y"];
        }
    }
}

/*易宝跳转*/
-(IBAction)onButtonBtnClicked:(UIButton*)sender
{
    UIButton *btn= (UIButton*)sender;
    btn.selected =! btn.selected;
    switch (sender.tag) {
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
            MyBankCardViewController *bank= [[MyBankCardViewController alloc] init];
            bank.bankXY= YES;
            bank.bankPayListDelegate = self;
            [self.navigationController pushViewController:bank animated:YES];
        }
            break;
        case 4:
        {
            /*确认提交*/
            if ([self checkTransferInfo])//确认提交 检查是否正确信息
            {
                [self QcoinMoneyRq];
            }

        }
            break;

        default:
            break;
    }
    if (btn.tag==1||btn.tag==2) {
        //信用卡
        if ([BankType isEqualToString:@"0"]) {
            if (btn.tag==2) {
                if (btn.selected) {
                    _XinYongDefualCared.selected= NO;
                    _TextFiledCared.hidden= NO;
                    
                    /*是否有默认卡号*/
                    if (flagnot==YES) {
                        [_TextFiledCared.layer setValue:@414 forKeyPath:@"frame.origin.y"];
                        [_OnBtnClick.layer setValue:@475 forKeyPath:@"frame.origin.y"];
                    }else{
                        [_TextFiledCared.layer setValue:@314 forKeyPath:@"frame.origin.y"];
                    }
                    NSLog(@"_XinYongCared.selected==YES");
                }else{
                    _TextFiledCared.hidden= YES;
                    if (flagnot==YES) {
                        [_OnBtnClick.layer setValue:@415 forKeyPath:@"frame.origin.y"];
                    }
                    NSLog(@"_XinYongCared.selected==NO");
                }
            }
        }else  if ([BankType isEqualToString:@"1"]){
            //默认选中状态
            if (btn.tag==1) {
                _XinYongCared.selected= NO;
                _TextFiledCared.hidden= YES;
                
                if (btn.selected) {
                    
                    NSLog(@"_isRememberAccount==YES");
                    
                }else{
                    NSLog(@"_isRememberAccount==NO");
                }
            }
        }
    }
}


#pragma mark - BanklistpayDelegate
- (void)popWithValue:(NSMutableArray *)person creditCard:(BOOL)flag{
    
    NSLog(@"card %@",person);
    /*返回有数据 非刷卡*/
    flagOnePay= flag;
    mainCaredPerson= [NSMutableArray array];
    mainCaredPerson= person;
    
    _TextFiledCared.hidden= NO;
    _XinYongCared.selected= YES;
    _XinYongDefualCared.selected= NO;
    _TextFiledCared.text= [person valueForKey:@"bkcardnos"];
    if (flag==YES) {
        
        if (flagnot==YES) {
            [_TextFiledCared.layer setValue:@414 forKeyPath:@"frame.origin.y"];
            [_OnBtnClick.layer setValue:@475 forKeyPath:@"frame.origin.y"];
        }else{
            [_TextFiledCared.layer setValue:@314 forKeyPath:@"frame.origin.y"];
        }
    }else if (flag==NO){
        /*信用卡*/
        if (flagnot==YES) {
            [_TextFiledCared.layer setValue:@414 forKeyPath:@"frame.origin.y"];
            [_OnBtnClick.layer setValue:@475 forKeyPath:@"frame.origin.y"];
        }
        else{
            [_TextFiledCared.layer setValue:@314 forKeyPath:@"frame.origin.y"];
        }
    }
}

/*默认选中卡号直接支付状态*/
-(void)YIBAOzhuanzhangTophoneTodefual
{
    /*这里写Q币默认卡信息*/
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    NSString *mobileProvince= AddressLable.text;
    NSString* name = [NLUtils getNameForRequest:Notify_ApiYiBaoPhonePay];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    /*换个接口 把df的对应值放进去*/
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApiYiBaoPhonePay:strRechamoney payMoney:PhoneGiveStr2 rechargePhone:PhoneNum bankCardId:bkcardnosStrDF bankId:bkcardbankidsStrDF manCardId:bkcardidcardsStrDF payPhone:bkcardbankphonesStrDF manName:bkcardbankmansStrDF expireYear:bkcardyxyearsStrDF expireMonth:bkcardyxmonthsStrDF cvv:bkcardcvvsStrDF mobileProvince:mobileProvince paycardid:_paycardid];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*易宝手机充值*/
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
        flagYZM=YES;
        /*orderId 通付宝订单号*/
        NLProtocolData* data = [response.data find:@"msgbody/orderId" index:0];
        orderIdStr = data.value;
        /*verifyCode 验证码*/
        data = [response.data find:@"msgbody/verifyCode" index:0];
        verifyCodeStr = data.value;
        if ([verifyCodeStr intValue]==1) {
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
            /*对应不同的状态*/
            PhoneMoneyToOK* vc = [[PhoneMoneyToOK alloc] initWithNibName:@"PhoneMoneyToOK" bundle:nil];
            vc.labletextStr= @"充值成功";
            vc.phoneNumLable= PhoneNum;
            vc.numInfo = @"您的付款卡号：";
            vc.OKPhoneStr= [NSString stringWithFormat:@"充值%@元",PhoneGiveStr];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

/*信用卡提示*/
-(void)alertNotoBtn
{
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
        /*短信验证码和信用卡储蓄卡的判断*/
        if (flagYZM==YES) {
            
        }else{
            /*信用卡通道*/
        }
        
    }else{
        if (flagYZM==YES) {
            [self readRechaPayTypeinfo];
        }else{
            /*银联信息*/
            [self QcoinMoneyRq];
        }
    }
}

/*易宝充值验证码*/
-(void)readRechaPayTypeinfo
{
 

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
        _imageA.hidden= NO;
        _XinYongDefualCared.selected= YES;
        [_imageB.layer setValue:@283 forKeyPath:@"frame.origin.y"];
        [_OnBtnClick.layer setValue:@395 forKeyPath:@"frame.origin.y"];
        
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

    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"Q币充值";
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?0:64;
    
    [self initValue];
    
    [self initVisaReader];
    
    [self PhoneMoneyLable];

    [_OnBtnClick.layer setValue:@424 forKeyPath:@"frame.origin.y"];

    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

- (void)PhoneMoneyLable
{
    /*是否默认 易宝支付*/
    [self ApiPaychannelInfo];
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
    self.TextFiledCared.leftView = paddingView3;
    _TextFiledCared.delegate= self;
    self.TextFiledCared.leftViewMode = UITextFieldViewModeAlways;
    [self.scroller addSubview:_TextFiledCared];
    _imageA.hidden= YES;
    [_imageB.layer setValue:@245 forKeyPath:@"frame.origin.y"];

    
    self.lablephone.frame= CGRectMake(self.lablephone.frame.origin.x, self.lablephone.frame.origin.y-IOS7HEIGHT, self.lablephone.frame.size.width, self.lablephone.frame.size.height);
    
    self.lableQBMoney.frame= CGRectMake(self.lableQBMoney.frame.origin.x, self.lableQBMoney.frame.origin.y-IOS7HEIGHT, self.lableQBMoney.frame.size.width, self.lableQBMoney.frame.size.height);
    
    self.lableIsOn.frame= CGRectMake(self.lableIsOn.frame.origin.x, self.lableIsOn.frame.origin.y-IOS7HEIGHT, self.lableIsOn.frame.size.width, self.lableIsOn.frame.size.height);
    
    PhoneLable= [LableModel LableTile:PhoneNum TitleFrame:CGRectMake(118, 35-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:25];
    
    PayMoneyLable= [LableModel LableTile:[NSString stringWithFormat:@"Q %@",PhoneGiveStr] TitleFrame:CGRectMake(118, 70-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:240/255.0 green:173/255.0 blue:78/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:23];
    
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
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)resetCardNumber:(NSString *)str
{
    if (str.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        cell.myTextField.text = str;
    }
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
            
            _payCardCheck = _paycardid;
            
            [self resetCardNumber:_cardno];
            
            [self payCardCheck];
        }
    }
}

-(void)doPayCardCheckNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString* result = data.value;
    
    [self showErrorInfo:result status:NLHUDState_NoError];
}

-(void)payCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    NSString* detail = response.detail;
    
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        _enablePayCard = YES;
        
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
        _enablePayCard = NO;
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
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
-(void)doQcoinMoneyRqNotify:(NLProtocolResponse*)response
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

//刷卡后信息正确提交
-(void)QcoinMoneyRq
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_RechaQQMoneyRq];
    
    REGISTER_NOTIFY_OBSERVER(self, QcoinMoneyRqNotify, name);
    
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
            detail = @"请求失败，请检查网络";
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
        [self ensureQQChargePayCardMoney];
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
        if ([detail isEqualToString:@"支付失败!"])
     
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//充值完成返回来的页面（这个是转账的页面）
-(void)doCheckRechaQQMoneyStatusNotify:(NLProtocolResponse*)response
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
        PhoneMoneyToOK* vc = [[PhoneMoneyToOK alloc] initWithNibName:@"PhoneMoneyToOK" bundle:nil];
        vc.phoneNumLable= PhoneNum;
        vc.numInfo = @"您的qq号：";
        vc.OKPhoneStr= [NSString stringWithFormat:@"充值%@元",PhoneGiveStr];
         [self.navigationController pushViewController:vc animated:YES];
        
        //号码保存到本地
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *numArr = [userDefault objectForKey:@"chargeQQList"];
        if (numArr ==nil) {
            numArr = [NSMutableArray array];
        }

        for (int i=0; i<numArr.count; i++)
        {
            if ([PhoneNum isEqualToString:[NSString stringWithFormat:@"%@",numArr[i]]])
            {
                [numArr removeObject:[NSString stringWithFormat:@"%@",numArr[i]]];
            }
        }
        
        [numArr insertObject:PhoneNum atIndex:0];
        
        if (numArr.count>3) {
            [numArr removeLastObject];
        }
        
        [userDefault setObject:numArr forKey:@"chargeQQList"];
        
        [userDefault synchronize];

    }
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










