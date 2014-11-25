//
//  QCoinPayController.m
//  TongFubao
//
//  Created by Delpan on 14-8-13.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "QCoinPayController.h"
#import "CardInfo.h"
#import "ButtonLabel.h"

@interface QCoinPayController ()
{
    NLProgressHUD *_hud;
    
    NSInteger currentHeight;
    //默认信用卡信息底图
    UIView *defaultCardView;
    //银行卡信息底图
    UIView *bankCardView;
    //银行卡号输入
    UITextField *bankNumText;
    //默认卡按钮
    ButtonLabel *defaultBtn;
    //银行卡按钮
    ButtonLabel *bankCardBtn;
    //选择银行卡按钮
    UIButton *selectCardBtn;
    //信用卡信息
    CardInfo *cardInfo;
    //选择银行卡信息
    CardInfo *selectInfo;
    //刷卡器
    VisaReader *visaReader;
}

@end

@implementation QCoinPayController

@synthesize infos = _infos;
@synthesize particulars = _particulars;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (visaReader)
    {
        [visaReader resetVisaReader:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (visaReader)
    {
        [visaReader resetVisaReader:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Q币充值";
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    //生成刷卡器
    [self initVisaReader];
    
    //读取默认银行卡
    [self loadDataForBankCard];
    
    //初始化视图
    [self initView];
}

#pragma mark - 生成刷卡器
- (void)initVisaReader
{
    visaReader = [VisaReader initWithDelegate:self];
    [visaReader createVisaReader];
}

#pragma mark - 初始化视图
- (void)initView
{
    //基本信息
    for (int i = 0; i < 2; i++)
    {
        for (int k = 0; k < 3; k++)
        {
            NSString *info = nil;
            UIColor *infoColor = nil;
            UIFont *infoFont = i == 0? [UIFont systemFontOfSize:20.0] : [UIFont systemFontOfSize:22.0];
            
            if (i == 0)
            {
                info = _infos[k];
                infoColor = [UIColor blackColor];
            }
            else
            {
                info = _particulars[k];
                infoColor = k == 0? RGBACOLOR(91, 192, 222, 1.0) : RGBACOLOR(240, 173, 78, 1.0);
            }
            
            UILabel *infoLabel = [UILabel labelWithFrame:CGRectMake(20 + 100 * i, currentHeight * (20.0 / 480.0) + 30 * k, 200, 22) backgroundColor:[UIColor clearColor] textColor:infoColor text:info font:infoFont];
            [self.view addSubview:infoLabel];
        }
    }
    
    NSString *payInfo = @"支付账户信息";
    
    //支付账户信息
    UILabel *payInfoLabel = [UILabel labelWithFrame:CGRectMake(10, currentHeight * (130.0 / 480.0), 200, 22) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] text:payInfo font:[UIFont systemFontOfSize:17.0]];
    [self.view addSubview:payInfoLabel];
    
    //虚线
    UIImageView *dottedLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, currentHeight * (160.0 / 480.0), 300, 2)];
    dottedLine.opaque = YES;
    dottedLine.image = imageName(@"dashed_line@2x", @"png");
    [self.view addSubview:dottedLine];
}

- (void)initPayViewWithDefault:(BOOL)default_
{
    //判断当前是否有默认信用卡
    if (default_)
    {
        NSString *defaultBtnTitle = @"默认支付";
        
        //选择当前信用卡按钮
        defaultBtn = [[ButtonLabel alloc] initWithTitle:defaultBtnTitle frame:CGRectMake(10, currentHeight * (170.0 / 480.0), 300, 30) tag:2801];
        defaultBtn.selectBtn.selected = YES;
        [defaultBtn.selectBtn addTarget:self action:@selector(bankCardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:defaultBtn];
        
        //默认底图
        if (!defaultCardView)
        {
            defaultCardView = [UIView viewWithFrame:CGRectMake(10, currentHeight * (210.0 / 480.0), 300, 27)];
            [self.view addSubview:defaultCardView];
        }
        
        //银行商标
        UIImageView *brandView = [UIImageView viewWithFrame:CGRectMake(0, 0, 20, 20) image:[UIImage imageNamed:cardInfo.bkcardbanklogo]];
        [defaultCardView addSubview:brandView];
        
        NSString *bankInfo = [NSString stringWithFirst:cardInfo.bkcardbank second:cardInfo.bkcardno third:@"信用卡" fourth:cardInfo.bkcardbankman];
        
        //银行卡信息
        UILabel *bankInfoLabel = [UILabel labelWithFrame:CGRectMake(35, 0, 290, 20) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] text:bankInfo font:[UIFont systemFontOfSize:15.0]];
        [defaultCardView addSubview:bankInfoLabel];
        
        //虚线
        UIImageView *dottedLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 300, 2)];
        dottedLine.opaque = YES;
        dottedLine.image = imageName(@"dashed_line@2x", @"png");
        [defaultCardView addSubview:dottedLine];
    }
    
    CGRect viewRect = default_? CGRectMake(10, currentHeight * (247.0 / 480.0), 300, 160) : CGRectMake(10, currentHeight * (170.0 / 480.0), 300, 160);
    
    //银行卡信息底图
    if (!bankCardView)
    {
        bankCardView = [UIView viewWithFrame:viewRect];
        [self.view addSubview:bankCardView];
    }
    
    NSString *bankCardBtnTitle = @"银行卡支付";
    
    //选择银行卡支付按钮
    bankCardBtn = [[ButtonLabel alloc] initWithTitle:bankCardBtnTitle frame:CGRectMake(0, 0, 300, 30) tag:2802];
    [bankCardBtn.selectBtn addTarget:self action:@selector(bankCardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bankCardView addSubview:bankCardBtn];
    
    //选择付款卡
    selectCardBtn = [UIButton buttonWithFrame:CGRectMake(160, 0, 100, 35) unSelectImage:imageName(@"next_press@2x", @"png") selectImage:nil tag:100000 titleColor:[UIColor whiteColor] title:@"选择付款卡"];
    selectCardBtn.hidden = YES;
    [selectCardBtn addTarget:self action:@selector(selectCardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bankCardView addSubview:selectCardBtn];
    
    //银行卡输入
    bankNumText = [UITextField textWithFrame:CGRectMake(0, 47, 300, 40) placeholder:@"刷卡或手动输入卡号"];
    bankNumText.background = imageName(@"input_field@2x", @"png");
    bankNumText.delegate = self;
    bankNumText.returnKeyType = UIReturnKeyDone;
    bankNumText.hidden = YES;
    [bankCardView addSubview:bankNumText];
    
    //提交按钮
    UIButton *enterBtn = [UIButton buttonWithFrame:CGRectMake(0, 95, 300, 40) unSelectImage:[NLUtils createImageWithColor:RGBACOLOR(21, 99, 181, 1.0) rect:CGRectMake(0, 0, 300, 40)] selectImage:nil tag:100000 titleColor:[UIColor whiteColor] title:@"确定提交"];
    [enterBtn addTarget:self action:@selector(enterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bankCardView addSubview:enterBtn];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, -150, SelfWidth, SelfHeight);
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, 0, SelfWidth, SelfHeight);
    }];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0, 0, SelfWidth, SelfHeight);
    }];
}

#pragma mark - 卡按钮触发
- (void)bankCardBtnAction:(UIButton *)sender
{
    if (!sender.selected)
    {
        defaultBtn.selectBtn.selected = !defaultBtn.selectBtn.selected;
        bankCardBtn.selectBtn.selected = !bankCardBtn.selectBtn.selected;
    }
    
    bankNumText.hidden = bankCardBtn.selectBtn.selected? NO : YES;
    selectCardBtn.hidden = bankCardBtn.selectBtn.selected? NO : YES;
}

#pragma mark - 选择付款卡
- (void)selectCardBtnAction:(UIButton *)sender
{
    MyBankCardViewController *bankView = [[MyBankCardViewController alloc] init];
    bankView.QCoin = YES;
    bankView.bankPayListDelegate = self;
    [self.navigationController pushViewController:bankView animated:YES];
}

#pragma mark - 确定提交触发
- (void)enterBtnAction:(UIButton *)sender
{
    
}

#pragma mark - BankPayListDelegate
- (void)popWithValue:(id)person creditCard:(BOOL)flag
{
    selectInfo = (CardInfo *)person;
    
    bankNumText.text = selectInfo.bkcardno;
}

#pragma mark - VisaReaderDelegate
-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString*)object
{
    //NSLog(@"event = %d,object = %@",event,object);
    if (SRS_DeviceAvailable == event && [object isEqualToString:@"0"])
    {
        
    }
    else if (SRS_DeviceUnavailable == event)
    {
        
    }
    else if (SRS_OK == event)
    {
        
    }
}

#pragma mark - 读取默认银行卡
-(void)loadDataForBankCard
{
    NSString *bkcardid= @" ";
    NSString *bkcardisdefault= @"1";
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiPaychannelInfo];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForBankCardNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPaychannelInfo:bkcardid bkcardisdefault:bkcardisdefault];
}

-(void)checkDataForBankCardNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self getDataWithBankCard:response];
    }
    else
    {
        NSString* detail = response.detail;
        NSLog(@"detail = %@",detail);
        
        [self initPayViewWithDefault:NO];
    }
}

- (void)getDataWithBankCard:(NLProtocolResponse*)response
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
        //银行卡id
        NLProtocolData *bkcardid = [response.data find:@"msgbody/msgchild/bkcardid" index:0];
        //银行卡号
        NLProtocolData *bkcardno = [response.data find:@"msgbody/msgchild/bkcardno" index:0];
        //所属银行id
        NLProtocolData *bkcardbankid = [response.data find:@"msgbody/msgchild/bkcardbankcode" index:0];
        //所属银行名
        NLProtocolData *bkcardbank = [response.data find:@"msgbody/msgchild/bkcardbank" index:0];
        //所属银行LOGO
        NLProtocolData *Bkcardbanklogo = [response.data find:@"msgbody/msgchild/Bkcardbanklogo" index:0];
        //开户人
        NLProtocolData *bkcardbankman = [response.data find:@"msgbody/msgchild/bkcardbankman" index:0];
        //预留电话号码
        NLProtocolData *bkcardbankphone = [response.data find:@"msgbody/msgchild/bkcardbankphone" index:0];
        //有效月
        NLProtocolData *bkcardyxmonth = [response.data find:@"msgbody/msgchild/bkcardyxmonth" index:0];
        //有效年
        NLProtocolData *bkcardyxyear = [response.data find:@"msgbody/msgchild/bkcardyxyear" index:0];
        //CVV校验
        NLProtocolData *bkcardcvv = [response.data find:@"msgbody/msgchild/bkcardcvv" index:0];
        //身份证
        NLProtocolData *bkcardidcard = [response.data find:@"msgbody/msgchild/bkcardidcard" index:0];
        //是否默认
        NLProtocolData *bkcardisdefault = [response.data find:@"msgbody/msgchild/bkcardisdefault" index:0];
        //银行卡类型
        NLProtocolData *bkcardcardtype = [response.data find:@"msgbody/msgchild/bkcardcardtype" index:0];
        //通道名
        NLProtocolData *paychalname = [response.data find:@"msgbody/msgchild/paychalname" index:0];
        
        cardInfo = [CardInfo infoWithBkcardno:bkcardno.value bkcardbankid:bkcardbankid.value bkcardbank:bkcardbank.value bkcardbanklogo:Bkcardbanklogo.value bkcardbankman:bkcardbankman.value bkcardbankphone:bkcardbankphone.value bkcardyxmonth:bkcardyxmonth.value bkcardyxyear:bkcardyxyear.value bkcardcvv:bkcardcvv.value bkcardidcard:bkcardidcard.value bkcardisdefault:bkcardisdefault.value bkcardcardtype:bkcardcardtype.value bkcardid:bkcardid.value];
        cardInfo.paychalname = paychalname.value;
        
        [self initPayViewWithDefault:YES];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end












