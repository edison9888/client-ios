//
//  NLRechargeCreditCardSecondViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "PhoneMoneyGive.h"
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
#import "planePay.h"
#import "MyBankCardViewController.h"
#import "CardInfo.h"

@interface PhoneMoneyGive ()
{
    /*银行卡*/
    BOOL  _isRememberAccount;
    BOOL  isremomberSayCard;
    BOOL  isremomberDefualCard;
    BOOL  _enablePayCard;
    BOOL  _enableCardImage;
    BOOL flagnot;
    BOOL creditCard;
    BOOL flagToPay;
    BOOL flagText;
    BOOL flagOnePay;
    BOOL flagYZM;
    BOOL flagNav;
    BOOL flagTY;
    /*错误弹框 多次验证码*/
    BOOL flagAlert;
    //当前卡类型
    int  IOS7HEIGHT;
    int _time;
    int _codeTime;
    
    NSString *currentCard;
    
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
    NSString* _payCardCheck;
    NSString* _resultPayCard;
    NSString* BankType;
    NSString* defualType;
    NSString*_Caredtype;
    NSString* paytype_check;
    
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
    
    /*选择卡再删除判断*/
    NSString *bkcardnosStr;
    
    /*获取信用卡验证码*/
    NSString *orderIdStr;
    NSString *verifyCodeStr;
    /*判断*/
    NSString *typeAlert;
    
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
    //银行卡编号
    NSString *bkcardbankno;
    NSString *bkcardbankids;
    
    NLProgressHUD* _hud;
    VisaReader   * _visaReader;
    
    NSMutableArray *mainCaredPerson;
    NSArray        * _visaReaderArray;
    UIImageView    *imageCard;
    UITextField    *alertText;
    
    UILabel *PhoneLable;
    UILabel *AddressLable;
    UILabel *PayMoneyLable;
    UILabel *PayMoney_Lable;
    
    /*成功后返回*/
    NSString *okbankname;
    NSString *okpeoplename;
    NSString *okbankCard;
    
    /*输入卡号的新功能跳转*/
    NSString *bankTypeStr;
}

@property (weak, nonatomic) IBOutlet UIButton *OnBtnClick;
@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingTableView *tableViewFrame;
@property (weak, nonatomic) IBOutlet UILabel *lablephone;
@property (weak, nonatomic) IBOutlet UILabel *lableAddress;
@property (weak, nonatomic) IBOutlet UILabel *lableMoney;
@property (weak, nonatomic) IBOutlet UILabel *LableIsOnMoney;
@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingScrollView *Scroller;

@property (weak, nonatomic) IBOutlet UIButton *XinYongDefualCared;
@property (weak, nonatomic) IBOutlet UIButton *XinYongCared;
@property (weak, nonatomic) IBOutlet UIButton *DefualCared;

@property (weak, nonatomic) IBOutlet UIImageView *BKIcone;

@property (weak, nonatomic) IBOutlet UILabel *lineviewXY;
@property (weak, nonatomic) IBOutlet UILabel *BKBankname;
@property (weak, nonatomic) IBOutlet UILabel *BKnumber;
@property (weak, nonatomic) IBOutlet UILabel *BKtype;
@property (weak, nonatomic) IBOutlet UILabel *BKweihao;
@property (weak, nonatomic) IBOutlet UILabel *BKmanname;
@property (weak, nonatomic) IBOutlet UILabel *lablemoren;
@property (weak, nonatomic) IBOutlet UILabel *lableXY;

@property (weak, nonatomic) IBOutlet UIImageView *lineViewMore;
@property (weak, nonatomic) IBOutlet UITextField *TextFiledCared;
@property (weak, nonatomic) IBOutlet UIButton *btnXY;

@property (weak, nonatomic) IBOutlet UIView *imageA;
@property (weak, nonatomic) IBOutlet UIView *imageB;
@property (weak, nonatomic) IBOutlet UIView *viewBtn;
/*验证码超时期限*/
@property(nonatomic, readwrite, retain) NSTimer *myTimer;
@property(nonatomic, readwrite, retain) NSTimer *myCodeTimer;

@end

@implementation PhoneMoneyGive

@synthesize PhoneGiveStr,PhoneGiveStr2,PhoneAddress,PhoneNum;

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
    _bankname = @"";;
    _bankID = @"";
    _paymoney = self.myMoney;
    _cardno = @"";      //付款卡号
    _cardmobile = @"";   //付款手机
    _cardman = @"";      //付款姓名
    _paycardid = @"";
    _banktype = @"creditcard";
    _bkntno = @"";
    _paycardid = @"";
    _result = @"";
    _enableCardImage = NO;
    _enablePayCard = YES;
    _resultPayCard = @"";
    _payCardCheck = @"";
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

/*需支付信用信息*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view endEditing:YES];
    
    [self initVisaReader];
    
    //加一层 背景 防止整体向上滚的时候部分黑色
    UIView *bigV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 800)];
    bigV.backgroundColor = RGBACOLOR(239, 244, 245, 1.0);
    [self.view addSubview:bigV];
    [self.view sendSubviewToBack:bigV];
   
    [self initValue];
    
    [self PhoneMoneyLable];
    
    /*读取默认信用卡支付*/
    [self ApiPaychannelInfo];
    
    [self.view endEditing:YES];
}

-(void)text
{
    CardInfo *card= [[CardInfo alloc]init];
    NSLog(@" bkcardcardtype %@  %@",card.bkcardcardtype,card.bkcardbank);
}

-(void)leftItemClick:(id)sender
{
    //返回dismiss 和push的 cow
    if ([self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)PhoneMoneyLable
{
    //返回样式类型
    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?0:64;
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"付款";

    /*scrollerview*/
    _Scroller.contentSize = CGSizeMake( 320, 510/*550*/);
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:oneFingerTwoTaps];

    
    /*刷卡*/
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 30)];
    self.TextFiledCared.leftView = paddingView3;
    _TextFiledCared.delegate= self;
    self.TextFiledCared.leftViewMode = UITextFieldViewModeAlways;
    [self.Scroller addSubview:_TextFiledCared];
    _imageA.hidden= YES;
    
    [_imageB.layer setValue:@265 forKeyPath:@"frame.origin.y"];
    
    [_viewBtn.layer setValue:@415 forKeyPath:@"frame.origin.y"];

    UIView *rightCared = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    imageCard= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageCard.image=  [UIImage imageNamed:@"swipingCard.png"];
    [rightCared addSubview:imageCard];
    self.TextFiledCared.rightView = rightCared;
    self.TextFiledCared.rightViewMode = UITextFieldViewModeAlways;
    [self.Scroller addSubview:_TextFiledCared];
    
    _TextFiledCared.hidden= YES;
    
    if (_enableCardImage)//判断bool状态
    {
        imageCard.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        imageCard.image = [UIImage imageNamed:@"swipingCard.png"];
    }

    self.lableAddress.frame= CGRectMake(self.lableAddress.frame.origin.x, self.lableAddress.frame.origin.y-IOS7HEIGHT, self.lableAddress.frame.size.width, self.lableAddress.frame.size.height);
     self.LableIsOnMoney.frame= CGRectMake(self.LableIsOnMoney.frame.origin.x, self.LableIsOnMoney.frame.origin.y-IOS7HEIGHT, self.LableIsOnMoney.frame.size.width, self.LableIsOnMoney.frame.size.height);
     self.lableMoney.frame= CGRectMake(self.lableMoney.frame.origin.x, self.lableMoney.frame.origin.y-IOS7HEIGHT, self.lableMoney.frame.size.width, self.lableMoney.frame.size.height);
     self.lablephone.frame= CGRectMake(self.lablephone.frame.origin.x, self.lablephone.frame.origin.y-IOS7HEIGHT, self.lablephone.frame.size.width, self.lablephone.frame.size.height);
    
    PhoneLable= [LableModel LableTile:PhoneNum TitleFrame:CGRectMake(118, 85-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:25];
    
    AddressLable= [LableModel LableTile:PhoneAddress TitleFrame:CGRectMake(118, 116-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:19];

    PayMoneyLable= [LableModel LableTile:[NSString stringWithFormat:@"%@元",[PhoneGiveStr stringByReplacingOccurrencesOfString:@"￥" withString:@""]] TitleFrame:CGRectMake(118, 147-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:240/255.0 green:173/255.0 blue:78/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:23];
   
    PayMoney_Lable= [LableModel LableTile:[NSString stringWithFormat:@"%@元",PhoneGiveStr2] TitleFrame:CGRectMake(118, 179-IOS7HEIGHT, 280, 30) TitleNum:1 titleColor:[UIColor colorWithRed:238/255.0 green:162/255.0 blue:54/255.0 alpha:1] BGColor:[UIColor clearColor] fontSize:17 boldSize:23];
    
    [self.Scroller addSubview:PhoneLable];
    [self.Scroller addSubview:AddressLable];
    [self.Scroller addSubview:PayMoneyLable];
    [self.Scroller addSubview:PayMoney_Lable];
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
            [_imageB.layer setValue:@255 forKeyPath:@"frame.origin.y"];
            _TextFiledCared.hidden= NO;
            _XinYongCared.selected= YES;
             [_TextFiledCared.layer setValue:@334 forKeyPath:@"frame.origin.y"];
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
        _imageA.hidden= NO;
        _lableXY.text= @"其他卡支付";
        _XinYongDefualCared.selected= YES;
        [_imageB.layer setValue:@333 forKeyPath:@"frame.origin.y"];
        [_viewBtn.layer setValue:@465 forKeyPath:@"frame.origin.y"];

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
         NLProtocolData* bkcardbankidsData = [response.data find:@"msgbody/msgchild/bkcardbankid" index:0];
        bkcardbankidsStrDF= bkcardbankidsData.value;
        
        //卡号
         NLProtocolData* bkcardnosData = [response.data find:@"msgbody/msgchild/bkcardno" index:0];
        
        bkcardnosStrDF= bkcardnosData.value;
        //用户名
         NLProtocolData* bkcardbankmansData = [response.data find:@"msgbody/msgchild/bkcardbankman" index:0];
        bkcardbankmansStrDF= bkcardbankmansData.value;
        
        /*成功*/
        okbankname= _BKBankname.text;
        okpeoplename= _BKmanname.text;
        okbankCard= bkcardnosStrDF;
    }
}

/*支付各种通道状态*/
-(void)jumpToPayType
{
    /*默认状态*/
    if ([BankType isEqualToString:@"1"])
    {
        /*默认卡号的信用卡*/
        [self YIBAOzhuanzhangTophoneTodefual];
        
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
                /*储蓄卡*/
                [self PhoneMoneyRq];
            }else{
                /*信用卡*/
                [self YIBAOzhuanzhangTophone];
            }
            
        }else if ([BankType isEqualToString:@"2"])
        {
            /*刷卡的*/
            flagToPay=YES;
            
            if (bkcardcvvStr.length==0) {
                
                /*16位的储蓄卡 修改新增字段*/
                if ([bkcardtypeStr isEqualToString:@"bankcard"]) {
                    
                    /*银联*/
                    [self PhoneMoneyRq];
                }else{
                    
                    if (![bankTypeStr isEqualToString:@"bankcard"]) {
//                        [self alertNotoBtn];
                        if (_TextFiledCared.text.length >16) {
                            /*储蓄卡*/
                            [self PhoneMoneyRq];
                        }else{
                            /*刷卡易宝信用卡通道*/
                            [self XYdefualtoPay];
                        }
                       
                    }else{
                        /*银联*/
                        [self PhoneMoneyRq];
                    }
                }
                
            }else{
                /*刷卡后信用卡有数据返回则是否储蓄卡或信用卡*/
                if (![bkcardtypeStr isEqualToString:@"bankcard"]) {
                    
                    /*刷卡易宝信用卡通道*/
                    [self getApipayCardCheckStrYiBao];
                }else{
                    
                    /*转账汇款 银联*/
                    [self PhoneMoneyRq];
                }
            }
            
        }else if ([BankType isEqualToString:@"3"])
        {
            _cardno= _TextFiledCared.text;
             /*选择信用卡之后再重新输入正确的卡号*/
            NSString *strCarno= [mainCaredPerson valueForKey:@"bkcardnos"];
            
            if ([strCarno isEqualToString:_cardno]) {
                
                /*选择我的银行卡读取返回来的*/
                if (flagOnePay==YES)
                {
                    /*储蓄卡*/
                    [self PhoneMoneyRq];
                }else{
                    /*信用卡*/
                    [self YIBAOzhuanzhangTophone];
                }
                
            }else{
                /*手写的状态*/
                if (![bankTypeStr isEqualToString:@"bankcard"])
                {
                    if (_TextFiledCared.text.length >16) {
                        /*储蓄卡*/
                        [self PhoneMoneyRq];
                    }else if(bankTypeStr!=nil) {
                        [self XYdefualtoPay];
                    }
                 
                    /*手输入
                    [self alertNotoBtn];*/
                }else
                {
                    /*储蓄卡*/
                    [self PhoneMoneyRq];
                }
            }
        }
    }
}


/*刷卡获取后台是否有数据 信用卡通道*/
-(void)getApipayCardCheckStrYiBao
{
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    NSString *mobileProvince= AddressLable.text;
    NSString* name = [NLUtils getNameForRequest:Notify_ApiYiBaoPhonePay];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    flagTY= YES;
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApiYiBaoPhonePay:strRechamoney payMoney:PhoneGiveStr2  rechargePhone:PhoneNum bankCardId:bkcardnoCheckStr bankId:bkcardbankidCheckStr manCardId:bkcardidcardStr payPhone:bkcardphoneStr manName:bkcardmanCheckStr expireYear:bkcardyxyearStr expireMonth:bkcardyxmonthStr cvv:bkcardcvvStr mobileProvince:mobileProvince paycardid:_paycardid];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}


/*转向银联支付*/
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
            /*一条通道*/
            BankType= @"0";
        }
            break;
        case 3:
        {
            /*选择信用卡*/
            [self.view endEditing:YES];
            MyBankCardViewController *bank= [[MyBankCardViewController alloc] init];
            bank.bankXY= YES;
            bank.righthidden= YES;
            bank.bankPayListDelegate = self;
            [self.navigationController pushViewController:bank animated:YES];
        }
            break;
        case 4:
        {
            if (_XinYongCared.selected!=YES &&_XinYongDefualCared.selected!=YES)
            {
                
                [self showErrorInfo:@"请选择一种支付方式并输入正确卡号" status:NLHUDState_Error];
                [_hud hide:YES afterDelay:2];
                
            }else{
                /*成功显示*/
//                [self viewtoYiBaotoOK];
                [self.view endEditing:YES];
                if (bankTypeStr==nil && [BankType isEqualToString: @"3"])
                {
                    [self bankcardtype];
                }else
                {
                    [self jumpToPayType];
                }
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
                if (btn.selected)
                {
                    _XinYongDefualCared.selected= NO;
                    _TextFiledCared.hidden= NO;

                    /*是否有默认卡号*/
                    if (flagnot==YES)
                    {
                        [_TextFiledCared.layer setValue:@414 forKeyPath:@"frame.origin.y"];
                         [_viewBtn.layer setValue:@465 forKeyPath:@"frame.origin.y"];
                    }else
                    {
                        [_TextFiledCared.layer setValue:@344 forKeyPath:@"frame.origin.y"];
                    }
                    NSLog(@"_XinYongCared.selected==YES");
                }else{
                   _TextFiledCared.hidden= YES;
                     if (flagnot==YES)
                     {
                           [_viewBtn.layer setValue:@465 forKeyPath:@"frame.origin.y"];
                     }
                    NSLog(@"_XinYongCared.selected==NO");
                }
            }
        }else  if ([BankType isEqualToString:@"1"])
        {
        //默认选中状态
            if (btn.tag==1)
            {
                _XinYongCared.selected= NO;
                _TextFiledCared.hidden= YES;
            
                if (btn.selected)
                {
                  
                NSLog(@"_isRememberAccount==YES");
           
                }else{
                NSLog(@"_isRememberAccount==NO");
                }
            }
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    if ([BankType isEqualToString:@"0"]&&![typeAlert isEqualToString:@"planepay"]) {
        _XinYongCared.selected= YES;
        _XinYongDefualCared.selected= NO;
        _TextFiledCared.hidden= NO;
        if (flagnot==YES) {
            [_TextFiledCared.layer setValue:@414 forKeyPath:@"frame.origin.y"];
            [_viewBtn.layer setValue:@465 forKeyPath:@"frame.origin.y"];
        }
    }
    //your code
    [super viewWillAppear:YES];
}


#pragma mark - BanklistpayDelegate
- (void)popWithValue:(NSMutableArray *)person creditCard:(BOOL)flag{
    
    NSLog(@"card %@",person);
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
    if (flag==YES) {
        /*储蓄卡
        [_btnXY setTitle:@"当前为储蓄卡" forState:UIControlStateNormal];
        [_btnXY setTitle:@"当前为储蓄卡" forState:UIControlStateSelected];
         */
        
        if (flagnot==YES) {
            [_TextFiledCared.layer setValue:@414 forKeyPath:@"frame.origin.y"];
             [_viewBtn.layer setValue:@465 forKeyPath:@"frame.origin.y"];
        }else{
            [_TextFiledCared.layer setValue:@344 forKeyPath:@"frame.origin.y"];
        }
    }else if (flag==NO){
        /*重新刷新*/
        /*区分通道接口 读取或填写
        [_btnXY setTitle:@"当前为信用卡" forState:UIControlStateNormal];
        [_btnXY setTitle:@"当前为信用卡" forState:UIControlStateSelected];
         */
        /*信用卡*/
        if (flagnot==YES) {
            [_TextFiledCared.layer setValue:@414 forKeyPath:@"frame.origin.y"];
            [_viewBtn.layer setValue:@465 forKeyPath:@"frame.origin.y"];
        }
        else{
            [_TextFiledCared.layer setValue:@344 forKeyPath:@"frame.origin.y"];
        }
    }
    
    /*成功返回数据*/
    okbankCard= [mainCaredPerson valueForKey:@"bkcardnos"];
    okbankname= [mainCaredPerson valueForKey:@"bkcardbanks"];
    okpeoplename= [mainCaredPerson valueForKey:@"bkcardbankmans"];

}

/*默认选中卡号直接支付状态*/
-(void)YIBAOzhuanzhangTophoneTodefual
{
    flagTY= YES;
    /*话费信息 PhoneGiveStr2优惠*/
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    NSString *mobileProvince= AddressLable.text;
    NSString* name = [NLUtils getNameForRequest:Notify_ApiYiBaoPhonePay];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApiYiBaoPhonePay:strRechamoney payMoney:PhoneGiveStr2 rechargePhone:PhoneNum bankCardId:bkcardnosStrDF bankId:bkcardbankidsStrDF manCardId:bkcardidcardsStrDF payPhone:bkcardbankphonesStrDF manName:bkcardbankmansStrDF expireYear:bkcardyxyearsStrDF expireMonth:bkcardyxmonthsStrDF cvv:bkcardcvvsStrDF mobileProvince:mobileProvince paycardid:_paycardid];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];

}


/*易宝选择卡接口*/
-(void)YIBAOzhuanzhangTophone
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
    NSString *bkcardbankidsStr= [mainCaredPerson valueForKey:@"bkcardids"];
    /*bkcardbankids银行卡id*/
    //卡号
    bkcardnosStr= [mainCaredPerson valueForKey:@"bkcardnos"];
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
    /*
    //银行卡id（修改的）
    NSString *bkcardidsStr= [mainCaredPerson valueForKey:@"bkcardids"];
    //银行logo
    NSString *bkcardbanklogosStr= [mainCaredPerson valueForKey:@"Bkcardbanklogos"];
    //银行卡名
    NSString *bkcardbanksStr= [mainCaredPerson valueForKey:@"bkcardbanks"];
    //卡类型
    NSString *bkcardcardtypesStr= [mainCaredPerson valueForKey:@"bkcardcardtypes"];
    //默认
    NSString *bkcardisdefaultsStr= [mainCaredPerson valueForKey:@"bkcardisdefaults"];
    */
    
    /*话费信息*/
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    NSString *mobileProvince= AddressLable.text;
    NSString* name = [NLUtils getNameForRequest:Notify_ApiYiBaoPhonePay];
    REGISTER_NOTIFY_OBSERVER(self, YIBAOMorePayNotify, name);
    if (_paycardid.length==0) {
        _paycardid= @"";
    }
   
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApiYiBaoPhonePay:strRechamoney payMoney:PhoneGiveStr2  rechargePhone:PhoneNum bankCardId:bkcardnosStr bankId:bkcardbankidsStr manCardId:bkcardidcardsStr payPhone:bkcardbankphonesStr manName:bkcardbankmansStr expireYear:bkcardyxyearsStr expireMonth:bkcardyxmonthsStr cvv:bkcardcvvsStr mobileProvince:mobileProvince paycardid:_paycardid];
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
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

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

/*300秒限制请求超时*/
-(void)startMyCodeTimeoutTimer
{
	[self stopMyCodeTimeoutTimer];
    _codeTime = 300;
	self.myCodeTimer = [NSTimer scheduledTimerWithTimeInterval: 1//kTimeoutSeconds
                                                        target: self
                                                      selector: @selector(doAnimationForCodePhone:)
                                                      userInfo: nil
                                                       repeats: YES];
}

-(void)stopMyCodeTimeoutTimer
{
	if (self.myCodeTimer != nil && [self.myCodeTimer isValid])
	{
		[self.myCodeTimer invalidate];
	}
}

-(void)doAnimationForCodePhone:(NSTimer *)timer
{
    _codeTime--;
    if (_codeTime <= 0)
    {
        [self stopMyCodeTimeoutTimer];
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
        
        /*verifyCode 验证码*/
        data = [response.data find:@"msgbody/verifyCode" index:0];
        verifyCodeStr = data.value;
        if ([verifyCodeStr intValue] == 1) {
            if (flagTY)
            {
                flagYZM=YES;
                typeAlert= @"typeYZM";
                flagAlert= YES;
                /*短信限制*/
                [self startTimeoutTimer];
                
                NSString *message = @"请输入您手机验证码";
                NSString *cancelName = @"取 消";
                UIAlertView *agentAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelName otherButtonTitles:@"确 定", nil];
                agentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertText = [agentAlertView textFieldAtIndex:0];
                alertText.delegate = self;
                alertText.keyboardType = UIKeyboardTypeNumberPad;
                alertText.placeholder= @"请输入您的验证码";
                [agentAlertView show];
//                [alertText resignFirstResponder];
                flagTY = NO;
            }
        }else if ([verifyCodeStr intValue] != 1){
             /*对比正确*/
            [self viewtoYiBaotoOK];
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
                       tag:1
                 cancelBtn:@"信用卡支付"
                     other:@"借记卡支付",nil];
    
}

/*信用卡跳转*/
-(void)XYdefualtoPay
{
    [self.view endEditing:YES];
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    planePay *pla= [[planePay alloc]initWithNibName:@"planePay" bundle:nil];
    pla.AddressStr= AddressLable.text;
    pla.paymoneyStr=  PhoneGiveStr2;
    pla.payphoneNumber= PhoneNum;
    pla.myViewYiBaoType= YiBaoPayType_phone;
    pla.payCard= _cardno;
    pla.cardReaderId= _paycardid;
    pla.payRechamoneyStr= strRechamoney;
    pla.typePayYIBao= YES;
    [self.navigationController pushViewController:pla animated:YES];

}

/*手动输入判断*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        if (flagYZM!=YES) {
            /*短信验证码和信用卡储蓄卡的判断*/
            flagToPay= NO;
            [self XYdefualtoPay];
        }
        if (flagToPay == YES) {
            /*信用卡*/
            if ([typeAlert isEqualToString:@"planepay"]) {
                
                [self XYdefualtoPay];
                
            }else{
                /*取消状态*/
                
            }
        }
    }else{
        /*刷卡的*/
        if (flagYZM!=YES) {
            /*短信验证码和信用卡储蓄卡的判断*/
            flagToPay= NO;
            /*银联*/
            [self PhoneMoneyRq];

        }
         /*刷卡的请框况*/
        if ([BankType isEqualToString:@"2"]) {
     
            /*
            if (flagYZM!=YES) {
             
                [self PhoneMoneyRq];
                
            }else{
              */
                /*验证码*/
            if ([typeAlert isEqualToString:@"planepay"]) {
                /*银联*/
                [self PhoneMoneyRq];
                
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

/*易宝充值验证码*/
-(void)readRechaPayTypeinfo
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiYiBaoVerifyCode];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiYiBaoVerifyCode:orderIdStr verifyCode:alertText.text];
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
        /*对比正确*/
        [self viewtoYiBaotoOK];
    }
}


#pragma mark - UITableViewDataSource
/*易宝暂不用table类型刷卡 重写了*/
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell *cell =nil;
    static NSString *kCellID = @"NLUsersInforSettingsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    cell.myHeaderLabel.hidden = NO;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.myContainer = self;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"支付账户";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 0;
            cell.myTextField.delegate = self;
            [cell.myTextField addTarget:self action:@selector(changeTextEvent:) forControlEvents:UIControlEventEditingChanged];
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            cell.myTextField.returnKeyType = UIReturnKeyDone;
            [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
            if ([_cardno length] <= 0)
            {
                cell.myTextField.placeholder = @"刷卡或手动输入卡号";
            }
            else
            {
                cell.myTextField.text = _cardno;
            }
            cell.myUprightImage.hidden = NO;
            
            [cell.myUprightImage setFrame:CGRectMake(260, 7, 30, 30)];
            if (_enableCardImage)//判断bool状态
            {
                cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
            }
            else
            {
                cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
              default:
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma showErrorInfo
//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
//    [self oneFingerTwoTaps];
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

-(void)resetCardNumber:(NSString*)str
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
    if (![NLUtils matchRegularExpressionPsy:_cardno match:mach]) {
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
            /*验证刷卡器*/
//            [self payCardCheck];
            /*刷卡验证是否有此默认信用卡*/
            [self ApipayCardCheck];
            /*卡号类型判断*/
            [self bankcardtype];
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
        
//        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
//        NSString* result = data.value;
//        [self showErrorInfo:result status:NLHUDState_NoError];
        
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
        _enablePayCard = YES;
        [self doPayCardCheckNotify:response];
    }
    else
    {
        _enablePayCard = NO;
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
-(void)doPhoneMoneyRqNotify:(NLProtocolResponse*)response
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
-(void)PhoneMoneyRq
{
    /*卡号数据不够长 获取不了数据跳不过去
    [self showErrorInfo:@"请稍候 （跳过银联了 正在屏蔽）" status:NLHUDState_None];
    [_hud hide:YES afterDelay:2];*/

    NSString* name = [NLUtils getNameForRequest:Notify_RechaMoneyRq];
    REGISTER_NOTIFY_OBSERVER(self, PhoneMoneyRqNotify, name);
    NSString* str = [_visaReaderArray objectAtIndex:2];
    NSData* data = [NLUtils stringToData:str];
    NSString* merReserved = [GTMBase64 stringByEncodingData:data];
    NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    if (flagOnePay==YES) {
        _cardno= _TextFiledCared.text;
    }
    [[[NLProtocolRequest alloc] initWithRegister:YES] paycardIDRq:_paycardid rechapaytypeid:@"1" rechamoney:strRechamoney  rechapaymoney:PhoneGiveStr2 rechamobile:PhoneNum rechamobileprov:AddressLable.text rechabkcardno:_cardno rechabkcardid:@"1" merReserved:merReserved];
     [self showErrorInfo:@"请稍候" status:NLHUDState_None];

}

-(void)PhoneMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (error ==  RSP_NO_ERROR )//正确的话
    {
        [self doPhoneMoneyRqNotify:response];
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
        [self ensurePhoneChargePayCardMoney];
    }
}

- (BOOL)doStartPay:(NSString *)payData sysProvide:(NSString*)sysProvide spId:(NSString*)spId mode:(NSString*)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate;
{
    return [UPPayPlugin startPay:payData mode:mode viewController:viewController delegate:delegate];
}

#pragma elseShow
-(void)showMainView
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma mark 支付返回
-(void)ensurePhoneChargePayCardMoney
{
        NSString* name = [NLUtils getNameForRequest:Notify_checkRechaMoneyStatus];
        
        REGISTER_NOTIFY_OBSERVER(self, checkRechaMoneyStatusNotify, name);
    
        [[[NLProtocolRequest alloc] initWithRegister:YES] checkRechaMoneyStatus:_bkntno result:_result];
            
        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)checkRechaMoneyStatusNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doCheckRechaMoneyStatusNotify:response];
    }
    else
    {
        NSString* detail = response.detail;
        if ([detail isEqualToString:@"支付失败!"])
     
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//充值完成返回来的页面（这个是转账的页面）
-(void)doCheckRechaMoneyStatusNotify:(NLProtocolResponse*)response
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
        [self viewtoYiBaotoOK];
        
        /*非首页冲 充值号码到本地 一会改
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *numArr = [userDefault objectForKey:@"chargeNumList"];
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
        
        [userDefault setValue:numArr forKey:@"chargeNumList"];
        [userDefault synchronize];
         */
    }
}

/*成功状态*/
-(void)viewtoYiBaotoOK
{
    NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
    [self createInforForResultView:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createInforForResultView:(NLTransferResultViewController*)vc
{
    vc.myNavigationTitle = @"充值结果";
    vc.myTitle = @"交易成功";
    
     NSString *strRechamoney= [PhoneGiveStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    /*话费充值*/
    if (flagNav == NO)
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", _TextFiledCared.text,@"content", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值号码",@"header", PhoneNum,@"content", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值金额",@"header", [NSString stringWithFormat:@"%@元",strRechamoney],@"content", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", [NSString stringWithFormat:@"%@元",PhoneGiveStr2],@"content", nil];
        [arr addObject:dic];
    }else{
        /*易宝*/
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", okbankCard,@"content", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", okbankname,@"content", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", okpeoplename,@"content", nil];
        [arr addObject:dic];
    
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值号码",@"header", PhoneNum,@"content", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值金额",@"header", [NSString stringWithFormat:@"%@元",strRechamoney],@"content", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", [NSString stringWithFormat:@"%@元",PhoneGiveStr2],@"content", nil];
        [arr addObject:dic];
    }
    vc.myArray = [NSArray arrayWithArray:arr];
}

#pragma mark -textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_TextFiledCared==textField)
    {
        BankType= @"3";
        flagText= YES;
        flagYZM= NO;
    }
  
    [self performSelector:@selector(change:) withObject:nil];
}

/*识别银行卡所属银行以及类型*/
-(void)bankcardtype
{
    NSDictionary *dataDictionary = @{ @"bkcardno" : _TextFiledCared.text, };
    
    /**/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiAppInfo" apiNameFunc:@"checkBanckCardType" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error) {
        NSLog(@"bkcardno %@",data);
        
        if ([BankType isEqualToString: @"3"]) {
            [self jumpToPayType];
        }
        
        NSRange range = [data[@"result"] rangeOfString:@"succ"];
        if (range.length <= 0)
        {
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }else
        {
            /*卡的类型*/
            bankTypeStr = [[data valueForKey:@"bkcardtype"]length] > 2 ?[data valueForKey:@"bkcardtype"] : @" " ;
        }
        
    }];
    
}

-(void)changeTextEvent:(UITextField *)textField;
{
    _cardno = textField.text;
}

#pragma mark 键盘移动
- (void)change:(id)sender
{
    /*创建一个仿射变换*/
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

//弹回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
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
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*输入判断的*/
    if (_TextFiledCared.text.length >= 15) {
        
        [self bankcardtype];
    }
    
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

/*长度限制*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    if (textField == _TextFiledCared) {
        
        if([[textField text] length] - range.length + string.length > 20)
        {
            retValue=NO;
        }
        
       
    }
    return retValue;
}


//弹回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
