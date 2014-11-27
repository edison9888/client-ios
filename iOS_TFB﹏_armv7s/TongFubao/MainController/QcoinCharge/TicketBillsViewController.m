//
//  TicketBillsViewController.m
//  TongFubao
//
//  Created by kin on 14-9-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TicketBillsViewController.h"
#import "CreditCardPaymentTicketViewController.h"
#import "ticketPriceObject.h"
#import "MyBankCardViewController.h"
#import "planePay.h"
#import "PlayCustomActivityView.h"
@interface TicketBillsViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_buttonArray;
    UITextField *_carText;
    int STY;
    NSString *_bankString;
    NSString *_cardNumbe;
    NSString *_cardType;
    NSString *_bkcardbankman;
    NSString *_bkcardid;
    NSString *_bkcardcvv;
    NSString *_bkcardyxyears;
    NSString *_bkcardyxmonths;
    NSString *_bkcardbankphones;
    NSString *_bkcardbankids;
    NSString *_bkcardnos;
    NSString *_bkcardbankmans;
    NSString *_bkcardbankcct;
    NSString *bkcardtypeCCTStr;

    

    UIImageView *_imageview1;
    VisaReader   * _visaReader;
    UIScrollView *_scrollView ;
    BOOL PushState;
    NSInteger priceOilTax ;
    BOOL BUTTONSTATE;
    
    PlayCustomActivityView *_activityView;
    
    
    
    BOOL  _enableCardImage;
    NSArray        * _visaReaderArray;
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
    NSString*paytype_check;
    
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
    
    NLProgressHUD* _hud;
    // 价格
    NSArray *_moneyArray;
    
}

@end

@implementation TicketBillsViewController

@synthesize TicketBillsArray,allPriceBillsArray,textString,TicketBillFlightInformation,sureInfoArray,TicketBillId,TicketContactArray,perSonIdArray,ContactIdArray,OrderId,verify,styGoBack,carYearMonth;


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
    _enableCardImage = NO;
    _buttonArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *passengersId = [[NSMutableArray alloc]init];
    NSMutableArray *contactId = [[NSMutableArray alloc]init];
    
    // 添加乘机人
    for (int i = 0; i < [self.TicketBillsArray count]; i++)
    {
        [passengersId addObject:[[self.TicketBillsArray objectAtIndex:i] objectAtIndex:3]];
    }
    self.perSonIdArray = passengersId;
    // 添加联系人
    for (int j = 0; j < [self.TicketContactArray count]; j++)
    {
        [contactId addObject:[[self.TicketContactArray objectAtIndex:j] objectAtIndex:0]];
    }
    
    self.ContactIdArray = contactId;
    
    NSLog(@"========perSonIdArray=========%@",self.perSonIdArray);
    NSLog(@"========ContactIdArray=========%@",self.ContactIdArray);
    // 插卡
    [self initVisaReader];

    // 默认读取信用卡
    [self ApiPaychannelInfo];
    // 导航
    [self navigationView];
}

/*刷卡*/
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

#pragma mark - VisaReaderDelegate
-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString*)object
{
    NSLog(@"event = %d,object = %@",event,object);
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
        _imageview1.image = [UIImage imageNamed:@"swipingCard2@2x.png"];
    }
    else
    {
        _enableCardImage = NO;
        _imageview1.image = [UIImage imageNamed:@"swipingCard@2x.png"];
    }
}
-(void)doSRS_OK:(NSString*)str
{
    /*刷卡器的判断*/
    //    BankType= @"2";
    //    flagToPay= YES;
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
        }
    }
}
-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        /*刷卡器重写*/
        _carText.text= str;
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
    paytype_check= @"airplane";
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

#pragma showErrorInfo
//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
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

#pragma mark-----刷卡
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
        //银行卡号
        NLProtocolData* bkcardnoCheck = [response.data find:@"msgbody/bkcardno" index:0];
        bkcardnoCheckStr = bkcardnoCheck.value;
        NSLog(@"=======bkcardnoCheckStr=======%@",bkcardnoCheckStr);

        //执卡人
        NLProtocolData* bkcardmanCheck = [response.data find:@"msgbody/bkcardman" index:0];
        bkcardmanCheckStr = bkcardmanCheck.value;
        NSLog(@"=======bkcardmanCheckStr=======%@",bkcardmanCheckStr);

        
        //预留手机号码
        NLProtocolData* bkcardphoneCheck = [response.data find:@"msgbody/bkcardphone" index:0];
        bkcardphoneStr = bkcardphoneCheck.value;
        NSLog(@"=======bkcardphoneStr=======%@",bkcardphoneStr);

        
        //银行id
        NLProtocolData* bkcardbankidCheck = [response.data find:@"msgbody/bkcardbankid" index:0];
        bkcardbankidCheckStr = bkcardbankidCheck.value;
        NSLog(@"=======bkcardbankidCheckStr=======%@",bkcardbankidCheckStr);

        
        //银行名
        NLProtocolData* bkcardbanknameCheck = [response.data find:@"msgbody/bkcardbankname" index:0];
        bkcardbanknameStr = bkcardbanknameCheck.value;
        NSLog(@"=======bkcardbanknameStr=======%@",bkcardbanknameStr);

        //有效月
        NLProtocolData* bkcardyxmonthCheck = [response.data find:@"msgbody/bkcardyxmonth" index:0];
        bkcardyxmonthStr = bkcardyxmonthCheck.value;
        NSLog(@"=======bkcardyxmonthStr=======%@",bkcardyxmonthStr);

        if ([bkcardyxmonthCheck.value length]==1)
        {
            bkcardyxmonthStr = [NSString stringWithFormat:@"0%@",bkcardyxmonthCheck.value];
        }
        else
        {
            bkcardyxmonthStr = bkcardyxmonthCheck.value;
        }
        
        //有效年
        NLProtocolData* bkcardyxyearCheck = [response.data find:@"msgbody/bkcardyxyear" index:0];
        bkcardyxyearStr = bkcardyxyearCheck.value;
        NSLog(@"=======bkcardyxyearStr=======%@",bkcardyxyearStr);

        
        NSString *validityStr = [bkcardyxyearStr stringByAppendingString:bkcardyxmonthStr];
        self.carYearMonth = validityStr;
        NSLog(@"=======self.carYearMonth111=======%@",self.carYearMonth);
        
        
        //CVV校验
        NLProtocolData* bkcardcvvCheck = [response.data find:@"msgbody/bkcardcvv" index:0];
        bkcardcvvStr = bkcardcvvCheck.value;
        NSLog(@"=======bkcardcvvStr=======%@",bkcardcvvStr);

        //身份证
        NLProtocolData* bkcardidcardCheck = [response.data find:@"msgbody/bkcardidcard" index:0];
        bkcardidcardStr = bkcardidcardCheck.value;
        NSLog(@"=======bkcardidcardStr=======%@",bkcardidcardStr);

        //银行卡类型
        NLProtocolData* bkcardtypeCheck = [response.data find:@"msgbody/bkcardtype" index:0];
        bkcardtypeStr = bkcardtypeCheck.value;
        NSLog(@"=======bkcardtypeStr=======%@",bkcardtypeStr);

        //银行卡类型
        NLProtocolData* bkcardtypeCCT = [response.data find:@"msgbody/ctripbankctt" index:0];
        bkcardtypeCCTStr = bkcardtypeCCT.value;
        NSLog(@"=======bkcardtypeCCTStr=======%@",bkcardtypeCCTStr);
        //刷卡状态
        SHUAKA = YES;

        self.carYearMonth = [bkcardyxyearStr stringByAppendingString:bkcardyxmonthStr];
        NSMutableArray *personArray = [[NSMutableArray alloc]initWithObjects:bkcardnoCheckStr,self.carYearMonth,bkcardcvvStr,bkcardmanCheckStr,@"1", bkcardidcardStr,bkcardphoneStr, bkcardbanknameStr,bkcardtypeCCTStr,nil];
        NSLog(@"=======personArray=======%@",personArray);

        for (NSString *STRING in personArray)
        {
            NSLog(@"====STRING===%@",STRING);
        }
        if ([personArray count] == 9) {
            self.sureInfoArray =personArray;
        }

        
    }
}

/*读取默认信用卡支付*/
-(void)ApiPaychannelInfo
{
    // 一开始默认刷卡状态为no
    SHUAKA = NO;

    NSString *bkcardid= @" ";
    NSString *bkcardisdefault= @"1";
    
    _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    _activityView.center = self.view.center;
    [_activityView setTipsText:@"正在加载数据..."];
    [_activityView starActivity];
    [self.view addSubview:_activityView];
    
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiPaychannelInfo];
    REGISTER_NOTIFY_OBSERVER(self, ApiPaychannelInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPaychannelInfo:bkcardid bkcardisdefault:bkcardisdefault];
}

-(void)ApiPaychannelInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doApiPaychannelInfoNotify:response];
    }
    else
    {
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
        }
        // 判断0是没有默认卡
        STY = 0;
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        [self allControllerView];
    }
}
#pragma mark-----默认
-(void)doApiPaychannelInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        NSLog(@"======value====%@",value);
    }
    else
    {
        
        /*所属银行*/
        NLProtocolData* bank = [response.data find:@"msgbody/msgchild/bkcardbank" index:0];
        _bankString = bank.value;
        /*图片*/
        //        NLProtocolData* data = [response.data find:@"msgbody/msgchild/bkcardbanklogo" index:0];
        //        NSString* icon = data.value;
        //        _BKIcone.image= [UIImage imageNamed:icon];
        
        /*尾号 判断才改*/
        NLProtocolData* cardNumbeData = [response.data find:@"msgbody/msgchild/bkcardno" index:0];
        _cardNumbe = [cardNumbeData.value substringFromIndex:(cardNumbeData.value.length - 4)];
        
        /*卡类型*/
        NLProtocolData* cardTypeData = [response.data find:@"msgbody/msgchild/bkcardcardtype" index:0];
        _cardType = [cardTypeData.value isEqualToString:@"bankcard"]? @"储蓄卡" : @"信用卡";
        
        /*持卡人*/
        NLProtocolData* bkcardbankmanData = [response.data find:@"msgbody/msgchild/bkcardbankman" index:0];
        _bkcardbankman= bkcardbankmanData.value;
        
        
        //身份证
        NLProtocolData* bkcardidcardsData = [response.data find:@"msgbody/msgchild/bkcardidcard" index:0];
        _bkcardid= bkcardidcardsData.value;
        
        
        //cvv
        NLProtocolData* bkcardcvvsData = [response.data find:@"msgbody/msgchild/bkcardcvv" index:0];
        _bkcardcvv = bkcardcvvsData.value;
        
        
        //有效年
        NLProtocolData* bkcardyxyearsData = [response.data find:@"msgbody/msgchild/bkcardyxyear" index:0];
        _bkcardyxyears = bkcardyxyearsData.value;
        
        
        //有效月
        NLProtocolData* bkcardyxmonthsData = [response.data find:@"msgbody/msgchild/bkcardyxmonth" index:0];
        if ([bkcardyxmonthsData.value length]==1) {
            _bkcardyxmonths = [NSString stringWithFormat:@"0%@",bkcardyxmonthsData.value];
        }
        else
        {
            _bkcardyxmonths = bkcardyxmonthsData.value;
            
        }
        NSString *validityStr = [_bkcardyxyears stringByAppendingString:_bkcardyxmonths];
        self.carYearMonth = validityStr;
        NSLog(@"=======self.carYearMonth000=======%@",self.carYearMonth);
        
        
        
        //预留电话
        NLProtocolData* bkcardbankphonesData = [response.data find:@"msgbody/msgchild/bkcardbankphone" index:0];
        _bkcardbankphones = bkcardbankphonesData.value;
        NSLog(@"=======_bkcardbankphones=======%@",_bkcardbankphones);

        
        
        //所属银行id
        NLProtocolData* bkcardbankidsData = [response.data find:@"msgbody/msgchild/bkcardbankid" index:0];
        _bkcardbankids = bkcardbankidsData.value;
        
        
        //卡号
        NLProtocolData* bkcardnosData = [response.data find:@"msgbody/msgchild/bkcardno" index:0];
        _bkcardnos= bkcardnosData.value;
        
        
        //用户名
        NLProtocolData* bkcardbankmansData = [response.data find:@"msgbody/msgchild/bkcardbankman" index:0];
        _bkcardbankmans = bkcardbankmansData.value;
        
        //cct
        NLProtocolData* bkcardbankcctData = [response.data find:@"msgbody/msgchild/ctripbankctt" index:0];
        _bkcardbankcct = bkcardbankcctData.value;
        NSLog(@"=======_bkcardbankcct=======%@",_bkcardbankcct);
        
        
        //        NSLog(@"==%@===%@===%@==%@===%@==%@===%@===%@====%@====%@====%@===%@=",_bankString,
        //              _cardNumbe,
        //              _cardType,
        //              _bkcardbankman,
        //              _bkcardid,
        //              _bkcardcvv,
        //              _bkcardyxyears,
        //              _bkcardbankphones,
        //              _bkcardbankids,
        //              _bkcardnos,
        //              _bkcardbankmans,_bkcardyxmonths);
        NSString *bankYm = [NSString stringWithFormat:@"%@－%@",_bkcardyxyears,_bkcardyxmonths];
        NSMutableArray *bankInfoArray = [[NSMutableArray alloc]initWithObjects:_bkcardnos,bankYm,_bkcardcvv,_bkcardbankman,@"1",_bkcardnos,_bkcardbankphones,_bankString, _bkcardbankcct,nil];
        NSLog(@"======bankInfoArray=====%@",bankInfoArray);
        self.sureInfoArray =bankInfoArray;
        // 判断1是有默认卡
        STY = 1;
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        
        [self allControllerView];
    }
}



-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"机票账单";
}

#pragma mark-------所有控件
-(void)allControllerView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
    [self.view addSubview:_scrollView];
    
    NSArray *infoArray = @[@"账单信息",@"总票价(元)",@"总基建(元)",@"总油费(元)",@"总票数(张)",@"总金额(元)"];
    ticketPriceObject *ticketObject = [[ticketPriceObject alloc]init];
    int ADULT = 0,CHILDREN = 0,BABY = 0;
    NSLog(@"===========TicketBillsArray=======%d",[self.TicketBillsArray count]);
    for (int i = 0; i < [self.TicketBillsArray count]; i++)
    {
        if ([[[self.TicketBillsArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"1" ])
        {
            ADULT++;
        }
        else if ([[[self.TicketBillsArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"2" ])
        {
            CHILDREN++;
        }
        else if ([[[self.TicketBillsArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"3" ])
        {
            BABY++;
        }
    }
    //  每张票价信息
//    NSLog(@"=========asdfasdf========%d",[self.TicketBillsArray count]);
    
    
    
    //    NSLog(@"========self.TicketBillsArray======%@",self.TicketBillsArray);
    //    NSLog(@"========allPriceBillsArray======%@",allPriceBillsArray);
    
    
    if ([styGoBack isEqualToString:@"S"])
    {
        // 所有票价总和
        NSInteger priceInteger = [ticketObject adultPrice:[self.allPriceBillsArray objectAtIndex:0] childrenPrice:[self.allPriceBillsArray  objectAtIndex:3] babyPrice:[self.allPriceBillsArray  objectAtIndex:6] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        // 所有燃油费
        NSInteger OilInteger = [ticketObject adultOil:[self.allPriceBillsArray  objectAtIndex:1] childrenOil:[self.allPriceBillsArray  objectAtIndex:4] babyOil:[self.allPriceBillsArray  objectAtIndex:7] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        // 所有税费
        NSInteger TaxInteger = [ticketObject adultTax:[self.allPriceBillsArray  objectAtIndex:2] childrenTax:[self.allPriceBillsArray  objectAtIndex:5] babyTax:[self.allPriceBillsArray  objectAtIndex:8] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        
        // 所有费用
        priceOilTax = priceInteger + OilInteger + TaxInteger;
        
        _moneyArray = @[[NSString stringWithFormat:@"￥%d",priceInteger],[NSString stringWithFormat:@"￥%d",OilInteger],[NSString stringWithFormat:@"￥%d",TaxInteger],[NSString stringWithFormat:@"%d张", [self.TicketBillsArray count]]];
    }
    else
    {
        
        // 所有票价总和
        NSInteger priceInteger = [ticketObject adultPrice:[self.goTicketArray objectAtIndex:0] childrenPrice:[self.goTicketArray  objectAtIndex:3] babyPrice:[self.goTicketArray  objectAtIndex:6] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        // 所有燃油费
        NSInteger OilInteger = [ticketObject adultOil:[self.goTicketArray  objectAtIndex:1] childrenOil:[self.goTicketArray  objectAtIndex:4] babyOil:[self.goTicketArray  objectAtIndex:7] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        // 所有税费
        NSInteger TaxInteger = [ticketObject adultTax:[self.goTicketArray  objectAtIndex:2] childrenTax:[self.goTicketArray  objectAtIndex:5] babyTax:[self.goTicketArray  objectAtIndex:8] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        
        NSInteger  gopriceOilTax = priceInteger + OilInteger + TaxInteger;
        
        
        
        // 所有票价总和
        NSInteger backpriceInteger = [ticketObject adultPrice:[self.backTicketArray objectAtIndex:0] childrenPrice:[self.backTicketArray  objectAtIndex:3] babyPrice:[self.backTicketArray  objectAtIndex:6] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        // 所有燃油费
        NSInteger backOilInteger = [ticketObject adultOil:[self.backTicketArray  objectAtIndex:1] childrenOil:[self.backTicketArray  objectAtIndex:4] babyOil:[self.backTicketArray  objectAtIndex:7] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        // 所有税费
        NSInteger backTaxInteger = [ticketObject adultTax:[self.backTicketArray  objectAtIndex:2] childrenTax:[self.backTicketArray  objectAtIndex:5] babyTax:[self.backTicketArray  objectAtIndex:8] adultNumber:ADULT childrenNumber:CHILDREN babyNumber:BABY];
        
        // 所有费用
        NSInteger  backpriceOilTax  = backpriceInteger + backOilInteger + backTaxInteger;
        
        priceOilTax = gopriceOilTax + backpriceOilTax;
        
        _moneyArray = @[[NSString stringWithFormat:@"￥%d",priceInteger + backpriceInteger],[NSString stringWithFormat:@"￥%d",OilInteger + backOilInteger],[NSString stringWithFormat:@"￥%d",TaxInteger + backTaxInteger],[NSString stringWithFormat:@"%d张", [self.TicketBillsArray count]*2]];
    }
    
    
    
    for (int i = 0; i < 6; i++)
    {
        UILabel *contactLabel = [[UILabel alloc]init];
        contactLabel.tag = i;
        contactLabel.backgroundColor = [UIColor clearColor];
        contactLabel.textColor = [UIColor grayColor];
        contactLabel.text = [infoArray objectAtIndex:i];
        contactLabel.frame = CGRectMake(10, 70+40*i, 150, 40);
        if (contactLabel.tag == 0)
        {
            contactLabel.font = [UIFont boldSystemFontOfSize:20];
            contactLabel.textColor = RGBACOLOR(19, 193, 245, 1);
        }
        [_scrollView addSubview:contactLabel];
    }
    UIImageView *lineAccorIamge = [[UIImageView alloc]initWithFrame:CGRectMake(10, 113, 300, 1)];
    lineAccorIamge.image = [UIImage imageNamed:@"line@2x.png"];
    [_scrollView addSubview:lineAccorIamge];
    
    
    for (int i = 0; i < 4; i++)
    {
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.tag = i;
        moneyLabel.backgroundColor = [UIColor clearColor];
        moneyLabel.textColor = [UIColor grayColor];
        moneyLabel.text = [_moneyArray objectAtIndex:i];
        moneyLabel.font = [UIFont systemFontOfSize:20];
        moneyLabel.frame = CGRectMake(210, 110+40*i, 100, 40);
        moneyLabel.textAlignment = UITextAlignmentRight;
        [_scrollView addSubview:moneyLabel];
    }
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textColor = [UIColor orangeColor];
    moneyLabel.font = [UIFont boldSystemFontOfSize:30];
    moneyLabel.text =  [NSString stringWithFormat:@"￥%d",priceOilTax];
    moneyLabel.textAlignment = UITextAlignmentRight;
    moneyLabel.frame = CGRectMake(180, 270, 130, 40);
    [_scrollView addSubview:moneyLabel];
    
    
    UILabel *zhifuLabel = [[UILabel alloc]init];
    zhifuLabel.frame = CGRectMake(10,STY == 0 ? 380 : 330, 300, 20);
    zhifuLabel.backgroundColor = [UIColor clearColor];
    zhifuLabel.textColor = RGBACOLOR(19, 193, 245, 1);
    zhifuLabel.font = [UIFont boldSystemFontOfSize:20];
    zhifuLabel.text =  @"账户信息";
    [_scrollView addSubview:zhifuLabel];
    
    
    UIImageView *lineAIamge = [[UIImageView alloc]initWithFrame:CGRectMake(10, 360, 300, 1)];
    lineAIamge.image = [UIImage imageNamed:@"line@2x.png"];
    if (STY == 0)
    {
        lineAIamge.hidden = YES;
    }
    else
    {
        lineAIamge.hidden = NO;
    }
    [_scrollView addSubview:lineAIamge];
    
    if (_bkcardbankcct > 0) {
    // 默认支付按钮
    if (STY == 1)
    {
        //  按钮状态
        BUTTONSTATE = NO;
        PushState = NO;
        for (int i = 0; i < 2; i++)
        {
            UIButton * _moreiButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            _moreiButton.tag = i;
            if (_moreiButton.tag == 0)
            {
                _moreiButton.frame = CGRectMake(10, 372, 30, 30);
                [_moreiButton setImage:[UIImage imageNamed:@"9@2x.png"] forState:(UIControlStateNormal)];
            }
            else if (_moreiButton.tag == 1)
            {
                _moreiButton.frame = CGRectMake(10, 430, 30, 30);
                [_moreiButton setImage:[UIImage imageNamed:@"91@2x.png"] forState:(UIControlStateNormal)];
            }
            [_moreiButton addTarget:self action:@selector(moreiSelection:) forControlEvents:(UIControlEventTouchUpInside)];
            [_buttonArray addObject:_moreiButton];
            [_scrollView addSubview:_moreiButton];
        }
    }
    }
    else
    {
        // 按钮状态
        BUTTONSTATE = YES;
        UIButton * _moreiButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _moreiButton.frame = CGRectMake(10, 430, 30, 30);
        _moreiButton.selected = YES;
        [_moreiButton setImage:[UIImage imageNamed:@"9@2x.png"] forState:(UIControlStateNormal)];
        [_moreiButton addTarget:self action:@selector(twoSelection:) forControlEvents:(UIControlEventTouchUpInside)];
        [_scrollView addSubview:_moreiButton];
    }
    
    
    UILabel *moreiLabel = [[UILabel alloc]init];
    moreiLabel.frame = CGRectMake(60, 360, 150, 25);
    moreiLabel.backgroundColor = [UIColor clearColor];
    moreiLabel.textColor = [UIColor grayColor];
    moreiLabel.font = [UIFont boldSystemFontOfSize:15];
    if (STY == 0)
    {
        moreiLabel.hidden = YES;
    }
    else
    {
        moreiLabel.hidden = NO;
    }
    
    moreiLabel.text =  @"默认支付";
    [_scrollView addSubview:moreiLabel];
    
    
    for (int i = 0; i < 5; i++)
    {
        UILabel *moreiLabel = [[UILabel alloc]init];
        moreiLabel.tag = i;
        moreiLabel.textColor = [UIColor grayColor];
        if (moreiLabel.tag == 0)
        {
            moreiLabel.frame = CGRectMake(60, 385, 80, 25);
            moreiLabel.text = _bankString;
        }
        else if (moreiLabel.tag == 1)
        {
            moreiLabel.frame = CGRectMake(135, 385, 35, 25);
            moreiLabel.text = @"尾号";
        }
        else if (moreiLabel.tag == 2)
        {
            moreiLabel.text = _cardNumbe;
            moreiLabel.frame = CGRectMake(165, 385, 35, 25);
            moreiLabel.textColor = [UIColor orangeColor];
        }
        else
        {
            if (moreiLabel.tag == 3)
            {
                moreiLabel.text = _cardType;
            }
            else if (moreiLabel.tag == 4)
            {
                moreiLabel.text = _bkcardbankmans;
            }
            
            moreiLabel.frame = CGRectMake(55+i*52, 385, 55, 25);
        }
        if (STY == 0)
        {
            moreiLabel.hidden = YES;
        }
        else
        {
            moreiLabel.hidden = NO;
        }
        moreiLabel.backgroundColor = [UIColor clearColor];
        moreiLabel.font = [UIFont systemFontOfSize:15];
        [_scrollView addSubview:moreiLabel];
    }
    
    UIImageView *linAIamge = [[UIImageView alloc]initWithFrame:CGRectMake(10, 415, 300, 1)];
    linAIamge.image = [UIImage imageNamed:@"line@2x.png"];
    [_scrollView addSubview:linAIamge];
    
    
    UILabel *yhLabel = [[UILabel alloc]init];
    yhLabel.frame = CGRectMake(60, 425, 150, 40);
    yhLabel.backgroundColor = [UIColor clearColor];
    yhLabel.textColor = [UIColor grayColor];
    yhLabel.font = [UIFont boldSystemFontOfSize:20];
    yhLabel.text =  @"银行卡支付";
    [_scrollView addSubview:yhLabel];
    
    
    UIButton *selecButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    selecButton.frame = CGRectMake(190, 425, 120, 40);
    selecButton.backgroundColor = RGBACOLOR(19, 195, 245, 1);
    selecButton.layer.masksToBounds = YES;
    selecButton.layer.cornerRadius = 2;
    [selecButton setTitle:@"选择付款卡" forState:(UIControlStateNormal)];
    [selecButton addTarget:self action:@selector(SeleButton) forControlEvents:(UIControlEventTouchUpInside)];
    [_scrollView addSubview:selecButton];
    
    UIImageView *lineIamge = [[UIImageView alloc]initWithFrame:CGRectMake(10, 475, 300, 1)];
    lineIamge.image = [UIImage imageNamed:@"line@2x.png"];
    [_scrollView addSubview:lineIamge];
    
    _carText = [[UITextField alloc]initWithFrame:CGRectMake(10, 490, 300, 40)];
    _carText.borderStyle = UITextBorderStyleRoundedRect;
    if (BUTTONSTATE == YES)
    {
        _carText.enabled = YES;
    }
    else
    {
        _carText.enabled = NO;
    }
    _carText.delegate = self;
    _imageview1=[[UIImageView alloc]init];
    if (_enableCardImage)//判断bool状态
    {
        _imageview1.image = [UIImage imageNamed:@"swipingCard2@2x.png"];
    }
    else
    {
        _imageview1.image = [UIImage imageNamed:@"swipingCard@2x.png"];
        
    }
    _imageview1.frame=CGRectMake(250, 0, 60, 40);
    _carText.rightView=_imageview1;
    _carText.rightViewMode=UITextFieldViewModeAlways;
    _carText.placeholder = @"请输入卡号";
    _carText.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_carText];
    
    UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureButton.frame = CGRectMake(10, 545, 300, 45);
    sureButton.titleLabel.text = @"确认提交";
    sureButton.layer.masksToBounds = YES;
    sureButton.layer.cornerRadius = 5;
    sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [sureButton setTitle:sureButton.titleLabel.text forState:(UIControlStateNormal)];
    sureButton.backgroundColor = [UIColor orangeColor];
    [sureButton addTarget:self action:@selector(suerPayMoney) forControlEvents:(UIControlEventTouchUpInside)];
    [_scrollView addSubview:sureButton];
    
    UILabel *tishiLabel = [[UILabel alloc]init];
    tishiLabel.frame = CGRectMake(20, 600, 300, 20);
    tishiLabel.backgroundColor = [UIColor clearColor];
    tishiLabel.textColor = [UIColor grayColor];
    tishiLabel.font = [UIFont systemFontOfSize:15];
    tishiLabel.text =  @"温馨提醒：同一信用卡当天请勿频繁交易";
    [_scrollView addSubview:tishiLabel];
    
}

-(void)moreiSelection:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0)
    {
        // 刷卡
        SHUAKA = NO;
        PushState = NO;
        BUTTONSTATE = NO;
        _carText.enabled = NO;
        _carText.text = nil;
        _carText.hidden = YES;
        
        NSString *bankYm = [NSString stringWithFormat:@"%@－%@",_bkcardyxyears,_bkcardyxmonths];
        NSMutableArray *bankInfoArray = [[NSMutableArray alloc]initWithObjects:_bkcardnos,bankYm,_bkcardcvv,_bkcardbankman,@"1",_bkcardnos,_bkcardbankphones,_bankString, _bkcardbankcct,nil];
        NSLog(@"======bankInfoArray=====%@",bankInfoArray);
        NSString *validityStr = [_bkcardyxyears stringByAppendingString:_bkcardyxmonths];
        self.carYearMonth = validityStr;
        self.sureInfoArray =bankInfoArray;

    }
    if(button.tag == 1)
    {
        BUTTONSTATE = YES;
        _carText.enabled = YES;
        _carText.hidden = NO;

    }
    for (int i = 0 ; i < 2; i++)
    {
        if (button != [_buttonArray objectAtIndex:i])
        {
            [[_buttonArray objectAtIndex:i] setImage:[UIImage imageNamed:@"91@2x.png"] forState:(UIControlStateNormal)];
        }
        else
        {
            [[_buttonArray objectAtIndex:i] setImage:[UIImage imageNamed:@"9@2x.png"] forState:(UIControlStateNormal)];
        }
    }
}

-(void)twoSelection:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    _carText.hidden = NO;
    
    if (button.selected == YES)
    {
        [button setImage:[UIImage imageNamed:@"91@2x.png"] forState:(UIControlStateNormal)];
        button.selected = NO;
        BUTTONSTATE = YES;
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"9@2x.png"] forState:(UIControlStateNormal)];
        button.selected = YES;
        BUTTONSTATE = NO;
    }
}

#pragma mark -- 选银行卡
-(void)SeleButton
{

    if (BUTTONSTATE == YES)
    {
        // 刷卡为no
        SHUAKA = NO;
        MyBankCardViewController *myBankCardView = [[MyBankCardViewController alloc]init];
        myBankCardView.planeFlag = YES;
        myBankCardView.bankPayListDelegate = self;
        [self.navigationController pushViewController:myBankCardView animated:YES];
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！请您选择银行卡支付按钮！" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark--- 选银行卡代理
- (void)popWithValue:(NSMutableArray *)person creditCard:(BOOL)flag
{
    // 选卡状态
    PushState = YES;
    NSLog(@"====flag===%d",flag);
    self.carYearMonth = [[person valueForKey:@"bkcardyxyears"]stringByAppendingString:[person valueForKey:@"bkcardyxmonths"]];
    NSLog(@"=======self.carYearMonth=======%@",self.carYearMonth);
    
    
    NSString *cardYM = [NSString stringWithFormat:@"%@-%@",[person valueForKey:@"bkcardyxyears"],[person valueForKey:@"bkcardyxmonths"]];
    NSMutableArray *personArray = [[NSMutableArray alloc]initWithObjects:[person valueForKey:@"bkcardnos"],cardYM,[person valueForKey:@"bkcardcvvs"],[person valueForKey:@"bkcardbankmans"],@"1", [person valueForKey:@"bkcardidcards"],[person valueForKey:@"bkcardbankphones"], [person valueForKey:@"bkcardbanks"],[person valueForKey:@"bkcardbankcctp"],nil];

    for (NSString *STRING in personArray)
    {
        NSLog(@"====STRING===%@",STRING);
    }
    if ([person valueForKey:@"bkcardbankcctp"] > 0) {
        self.sureInfoArray = personArray;
    }
    self.textString = [personArray objectAtIndex:0];
    _carText.text =self.textString;
    _scrollView.frame = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height+64);
}
#pragma mark -- 输入框
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [UIView animateWithDuration:0.3 animations:^{
//        [_scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
//    }];
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    PushState = NO;
//    return YES;
//}
//#pragma mark -- 滚动视图
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_carText resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_carText resignFirstResponder];
}
#pragma mark -- 确定支付生成订单号
-(void)suerPayMoney
{
    [_carText resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (BUTTONSTATE == YES && ![self.textString isEqualToString:_carText.text] && [_carText.text length] == 16)
    {
        _scrollView.frame = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height+64);
        planePay *planePayView = [[planePay alloc]init];
        // 乘机人和联系人的id
        planePayView.PayperSonIdArray = self.perSonIdArray;
        planePayView.PayContactIdArray = self.ContactIdArray;
        // 票的id
        planePayView.PayTicketBillId = self.TicketBillId;
        planePayView.playBackTicketId  = self.backTicketId;
        // 单往返类型
        planePayView.playStyGoBack = self.styGoBack;
        // 账号
        planePayView.PayCarTextString = _carText.text;
        // 总票价
        planePayView.PayPriceOilTax = priceOilTax;
        // 票识
        //        planePayView.TICKETSTY = YES;
        planePayView.myViewYiBaoType = YibaoPlayTicket;
        // ctt
//        planePayView.planePayCTT = 10;
        
        [self.navigationController pushViewController:planePayView animated:YES];
    }
    else if(BUTTONSTATE == NO && PushState == NO && STY == 1 &&([_bkcardnos length] == 16 ||[bkcardnoCheckStr length] == 16))
    {
        [self orderNumberVerificationCode];
    }
    else if (BUTTONSTATE == YES && PushState == YES && [self.textString isEqualToString:_carText.text]  && [_carText.text length] == 16 && self.sureInfoArray != nil && [self.sureInfoArray count] > 0)
    {
        [self orderNumberVerificationCode];
    }
    else if (SHUAKA == YES && [self.sureInfoArray count] == 9)
    {
        [self orderNumberVerificationCode];
    }
    else if ([_carText.text length] != 16)
    {
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"温馨提示" message:@"请您正确使用卡号进行交易！" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
#pragma mark === 生成订单号
-(void)orderNumberVerificationCode
{
    _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    _activityView.center = self.view.center;
    [_activityView setTipsText:@"正在提交信息..."];
    [_activityView starActivity];
    [self.view addSubview:_activityView];
    
    NSString *name = [NLUtils getNameForRequest:Notify_createOrder];
    REGISTER_NOTIFY_OBSERVER(self, GetcreateOrder, name);
    NSLog(@"=====sureInfoArray=====%@",self.sureInfoArray);
    
    //    NSLog(@"========perSonIdArray=========%@",self.perSonIdArray);
    //    NSLog(@"========ContactIdArray=========%@",self.ContactIdArray);
    //    self.TicketBillId
    //    _bkcardyxmonths = bkcardyxmonthsData.value;
    
    
    NSLog(@"=======self.carYearMonth=======%@",self.carYearMonth);
    // 票,乘机人,联系人,卡
    [[[NLProtocolRequest alloc]initWithRegister:YES] TicketBillId:self.TicketBillId  backTicketId:self.backTicketId  styGoBack:self.styGoBack perSonIdArray:self.perSonIdArray ContactIdArray:self.ContactIdArray   payinfoCardInfoArray:self.sureInfoArray validity:self.carYearMonth amount:[NSString stringWithFormat:@"%d",priceOilTax]];
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
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
    
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"===string====%@",string);
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
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
        NSLog(@"=====OrderId=====%@",self.OrderId);
        
//        NSArray *verifyArray = [response.data find:@"msgbody/verifyCode"];
//        NLProtocolData *verifyCode = [verifyArray objectAtIndex:0];
//        self.verify  = verifyCode.value;
//        NSLog(@"=====verifyCode=====%@",self.verify);
        
        UIAlertView *_AlertView = [[UIAlertView alloc]initWithTitle:@"请输入验证码" message:nil delegate:self cancelButtonTitle:@"支付" otherButtonTitles:@"退出", nil];
        _AlertView.tag = 10;
        [_AlertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        [_AlertView show];
        
    }
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];
    
}
#pragma mark-----支付
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {


        UITextField *alertViewText=[alertView textFieldAtIndex:0];
        NSLog(@"=====alertViewText=====%@",alertViewText.text);
        if ([alertView textFieldAtIndex:0] > 0)
        {
            if (buttonIndex == 0)
            {
                _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
                _activityView.center = self.view.center;
                [_activityView setTipsText:@"正在提交信息..."];
                [_activityView starActivity];
                [self.view addSubview:_activityView];

                NSString* name = [NLUtils getNameForRequest:Notify_getpayWithCreditCard];
                REGISTER_NOTIFY_OBSERVER(self, ApipayValidationCreditCardNotify, name);
                [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPayverify:self.OrderId OrderId:self.verify];
            }
        }
        else
        {
            
            UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码不正确交易不成功！" delegate:nil cancelButtonTitle:@"请重新确认提交" otherButtonTitles:nil, nil];
            AlertView.tag = 22;
            [AlertView show];
        }
    }
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
        UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示!" message:@"交易不成功!" delegate:nil cancelButtonTitle:@"请退出" otherButtonTitles:nil, nil];
        AlertView.tag = 21;
        [AlertView show];
        
    }
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];

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
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

