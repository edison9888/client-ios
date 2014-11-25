//
//  NLCreditCardSecondViewController.m
//  TongFubao
//
//  Created by MD313 on 13-10-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLCreditCardSecondViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "NLKeyboardAvoid.h"
#import "GTMBase64.h"
#import "UPPayPlugin.h"
#import "NLTransferResultViewController.h"
#import "NLCreditCardVerifyViewController.h"

@interface NLCreditCardSecondViewController ()
{
    
    NSString* _fucardno;
    NSString* _fucardbank;
    NSString* _fucardmobile;
    NSString* _fucardman;
    NSString* _bkntno;
    NSString* _current;
    NSString* _paycardid;
    NSString* _result;
    NSString* _payCardCheck;
    NSString* _resultPayCard;
    
    BOOL         flagSKQ;
    BOOL         flagTY;
    BOOL _enablePayCard;
    BOOL _enableCardImage;
    NLProgressHUD   * _hud;
    VisaReader      * _visaReader;
    NSArray         * _visaReaderArray;
    NSMutableArray  *MainArray;
    
    NSString* merReserved;
    
    /*转账手续费*/
    NSString        *allmoney;
    NSString        *feemoney;
    /*获取信用卡验证码*/
    NSString *orderIdStr;
    NSString *verifyCodeStr;
    UITextField    *alertText;
    BOOL             flagYZM;
    /*错误弹框 多次验证码*/
    BOOL flagAlert;
    /*转账超时*/
    int _time;
    
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
    //银行卡编号
    NSString *bkcardbankno;
    
    //短信认证码
    NSString *verifytokenStr;
    //订单编号
    NSString *bkordernumber;
    //易宝订单号
    NSString *bkntnoYB;
    //认证码
    NSString *verifytoken;
    
    /*交易类型*/
    NSString *paytype_check;
    
    //我的银行卡
    BOOL myBankCard;
}

@property(nonatomic,strong)IBOutlet UITableView* myTableView;
@property(nonatomic,strong)IBOutlet UIButton* myButton;

-(IBAction)onButtonBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *imageA;
@property (weak, nonatomic) IBOutlet UITextField *textfiledmoney;
@property (weak, nonatomic) IBOutlet UILabel *textLable;
/*验证码超时期限*/
@property(nonatomic, readwrite, retain) NSTimer *myTimer;
@end

@implementation NLCreditCardSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

-(void)initValue
{
    _fucardno = @"";
    _fucardbank = @"";
    _fucardmobile = @"";
    _fucardman = @"";
    _bkntno = @"";
    _paycardid = @"";
    _current = @"RMB";
    _result = @"";
    _enableCardImage = NO;
    _enablePayCard = YES;
    _resultPayCard = @"";
    _payCardCheck = @"";
}


- (void)viewDidLoad
{
 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*信用卡还款*/
    [self initValue];
    [self initVisaReader];
    
    self.navigationController.topViewController.title = @"付款";
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    /*信用卡还款 手续费*/
    [self bankPoundage];
    NSString *num =[NSString stringWithFormat:@"%f",_myButton.frame.origin.y+60];
    [_textLable.layer setValue:num forKeyPath:@"frame.origin.y"];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
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

/*信用卡手续费*/
-(void)bankPoundage
{
    _textfiledmoney.userInteractionEnabled = NO;
    _myTableView.tableHeaderView = _imageA;
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApigetcreditCardMoneyPayfee];
    REGISTER_NOTIFY_OBSERVER(self, ApigetcreditCardMoneyPayfeeNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApigetcreditCardMoneyPayfee:@" " money:[self.myDictionary objectForKey:@"paymoney"]];

}

-(void)ApigetcreditCardMoneyPayfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doApigetcreditCardMoneyPayfeeNotify:response];
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

-(void)doApigetcreditCardMoneyPayfeeNotify:(NLProtocolResponse*)response
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
        NLProtocolData* data = [response.data find:@"msgbody/allmoney" index:0];
        allmoney = data.value;
        _textfiledmoney.text= [NSString stringWithFormat:@"%@元",allmoney];
        
        data = [response.data find:@"msgbody/feemoney" index:0];
        feemoney = data.value;
    }
}

/*跳转 信用卡还款*/
-(IBAction)onButtonBtnClicked:(id)sender
{
    if ([self checkCreditCardMoneyInfo])
    {
        /*刷卡判断 后台有数据则选择卡号*/
        if (bkcardcvvStr.length==0) {
            /*16位的储蓄卡*/
            if ([bkcardtypeStr isEqualToString:@"bankcard"]) {
                /*信用卡还款 银联*/
                [self creditCardMoneyRq];
            }else
            {
                /*后台判断数据*/
                if (_fucardno.length==16) {
                    /*弹框*/
                    [self alertNotoBtn];
                }else{
                    /*信用卡还款 银联*/
                    [self creditCardMoneyRq];
                }
            }
           
        }else{
            /*刷卡后信用卡有数据返回则是否储蓄卡或信用卡*/
            if (_fucardno.length==16) {
              
                /*易宝信用卡通道 信用卡*/
                flagTY = YES;
                [self getApicreditCardMoneyRq];
               
            }else{
                
                /*信用卡还款 银联*/
                [self creditCardMoneyRq];
            }
        }
    }
}

/*信用卡还款 提交时候的 信用卡易宝接口 如果已经有这个数据的话 则用信用卡通道接口传参*/
-(void)getApicreditCardMoneyRq
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApicreditCardMoneyRq];
    REGISTER_NOTIFY_OBSERVER(self, ApicreditCardMoneyRqNotify, name);
    
    NSString* str = [_visaReaderArray objectAtIndex:2];
    NSData* data = [NLUtils stringToData:str];
    merReserved = [GTMBase64 stringByEncodingData:data];
    
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApicreditCardMoneyRq:paytype_check paymoney:[self.myDictionary objectForKey:@"paymoney"] shoucardno:[self.myDictionary objectForKey:@"shoucardno"] shoucardmobile:[self.myDictionary objectForKey:@"shoucardmobile"] shoucardman:[self.myDictionary objectForKey:@"shoucardman"] shoucardbank:[self.myDictionary objectForKey:@"shoucardbank"] current:_current paycardid:_paycardid merReserved:merReserved bkcardbank:_fucardbank bkCardno:_fucardno bkcardman:_fucardman bkcardexpireMonth:bkcardyxmonthStr bkcardmanidcard:bkcardidcardStr bankid:bkcardbankidCheckStr bkcardexpireYear:bkcardyxyearStr bkcardPhone:_fucardmobile bkcardcvv:bkcardcvvStr allmoney:allmoney feemoney:feemoney];
    
    /*写数据 写参数*/
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*易宝信用卡还款*/
-(void)ApicreditCardMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doApicreditCardMoneyRqNotify:response];
    }
    else
    {
        [_hud hide:YES];
        NSString *detailA = response.detail;
        if (!detailA || detailA.length <= 0)
        {
            detailA = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detailA status:NLHUDState_Error];
    }
}

/*信用卡信息对比*/
-(void)doApicreditCardMoneyRqNotify:(NLProtocolResponse*)response
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
        
        //订单编号
        NLProtocolData *bkordernumberData = [response.data find:@"msgbody/bkordernumber" index:0];
        bkordernumber = bkordernumberData.value;
        
        //易宝订单号
        NLProtocolData *bkntnoData = [response.data find:@"msgbody/bkntno" index:0];
        bkntnoYB = bkntnoData.value;
        
        /*verifyCode 认证码*/
        data = [response.data find:@"msgbody/verifyCode" index:0];
        verifyCodeStr = data.value;
        
        if ([verifyCodeStr intValue]==1)
        {
            if (flagTY)
            {
                /*刷卡获取保存后再刷入未保存的银行卡*/
                flagSKQ= YES;
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
                [agentAlertView show];
          
                flagTY = NO;
            }
        }
        else if ([verifyCodeStr intValue]==0)
        {
            /*或者成功显示数据*/
            [self viewtoOKYiBao];
        }
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
            
            [_myButton setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0)] forState:UIControlStateNormal];
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

/*信用卡提示*/
-(void)alertNotoBtn
{
    flagSKQ = NO;

    [NLUtils showAlertView:@"温馨提示"
                   message:@"您当前使用的卡号为信用卡，是否选择信用卡支付通道？"
                  delegate:self
                       tag:0
                 cancelBtn:@"信用卡支付"
                     other:@"借记卡支付",nil];
}


/*手动输入*/
-(void)viewinPayYiBao
{
    NSString* str = [_visaReaderArray objectAtIndex:2];
    NSData* data = [NLUtils stringToData:str];
    merReserved = [GTMBase64 stringByEncodingData:data];
    
    MainArray= [NSMutableArray array];
    [MainArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_fucardno,@"fucardno",_fucardman,@"fucardman",_fucardmobile,@"fucardmobile",_fucardbank,@"fucardbank",feemoney,@"feemoney",allmoney,@"allmoney",bkcardbankidCheckStr,@"bankid",merReserved,@"merReserved",nil]];
    
    planePay *pla= [[planePay alloc]init];
    pla.myViewYiBaoType= YiBaoPayType_CreditCardPayments;
    pla.sendBankCardId= _fucardno;
    pla.cardReaderId= _paycardid;
    pla.merReserved= merReserved;
    pla.paytype_check= paytype_check;
    pla.payRechamoneyStr= allmoney;
    pla.myDictionary= self.myDictionary;
    pla.arraydic= MainArray;
    pla.payPhone.text=_fucardmobile;
    pla.payName.text= _fucardman;
    pla.bankList.titleLabel.text= _fucardbank;
    
    [self.navigationController pushViewController:pla animated:YES];
}

/*通道选择 先判断当前的卡号后台是否有数据 再刷卡器区分 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (0 == buttonIndex)
    {
        NSLog(@"验证码是否正确 %hhd",flagYZM);
   
            /*信用卡还款*/
            if (flagSKQ == NO) {
                
                [self viewinPayYiBao];
            }
      
    }
    else
    {
        if (flagYZM==YES) {
            
            if (flagSKQ==NO) {
                /*信用卡还款 银联*/
                [self creditCardMoneyRq];
            }else{
                if (alertText.text.length==0) {
                    
                    [self showErrorInfo:@"请输入正确的验证码" status:NLHUDState_Error];
                    [_hud hide:YES afterDelay:1.5];
                    
                }else{
                    
                    /*信用卡还款验证码*/
                    [self ApicreditCardMoneyRq];
                }
            }
        }
        else
        {
            /*信用卡还款 银联*/
            [self creditCardMoneyRq];
        }

    }
}

/*易宝充值验证码*/
-(void)ApicreditCardMoneyRq
{
    verifytokenStr = alertText.text;
    NSString* name = [NLUtils getNameForRequest:Notify_ApicreditCardMoneySMSverify];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreCardNotify, name);
    
    /*修改*/
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApicreditCardMoneySMSverify:verifytokenStr bkordernumber:bkordernumber bkntno:bkntnoYB verifytoken:verifyCodeStr];
    //    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*判断特别情况或超时*/
-(void)ApiYiBaoMoreCardNotify:(NSNotification*)notify
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
        /*或者成功显示数据*/
        [self viewtoOKYiBao];
    }
}

-(void)viewtoOKYiBao
{
    NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
    
    [self createInforForResultView:vc];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"账户";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 0;
            cell.myTextField.enabled = NO;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
            if ([_fucardno length] <= 0)
            {
                cell.myTextField.placeholder = @"请刷卡";
            }
            else
            {
                cell.myTextField.text = _fucardno;
            }
            cell.myUprightImage.hidden = NO;
            [cell.myUprightImage setFrame:CGRectMake(260, 7, 30, 30)];
            if (_enableCardImage)
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
        case 1:
        {
            cell.myHeaderLabel.text = @"银行";
            cell.myTextField.hidden = YES;
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            [cell.myContentLabel setFrame:CGRectMake(100, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
            if ([_fucardbank length] <= 0)
            {
                cell.myContentLabel.text = @"请选择银行";
            }
            else
            {
                cell.myContentLabel.text = _fucardbank;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"姓名";
            cell.myTextField.enabled = myBankCard? NO : YES;
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 1;
            if ([_fucardman length] > 0)
            {
                cell.myTextField.text = _fucardman;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入姓名";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case 3:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"手机";
            cell.myTextField.enabled = myBankCard? NO : YES;
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 2;
            cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
            if ([_fucardmobile length] > 0)
            {
                cell.myTextField.text = _fucardmobile;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入手机";
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
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    UIView* view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    rect.origin.x = 10;
    rect.origin.y = 5;
    rect.size.width = 300;
    rect.size.height = 25;
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.adjustsFontSizeToFitWidth = NO;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor blackColor];
    if (0 == section)
    {
        label.text = @"付款账户信息";
    }
    [view addSubview:label];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if (0 == section)
    {
        int row = indexPath.row;
        if (1 == row)
        {
            NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
            vc.delegate = self;
            vc.payListBank = @"f";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NLBankLisDelegate
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state
{
    _fucardbank = (NSString*)aObject;
    
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (cell)
    {
        cell.myContentLabel.text = _fucardbank;
    }
}

- (void)dataSearchDidCanceled:(NLBankListViewController *)controller
                    withState:(int)state
{
    //[controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://付款卡号
            _fucardno = textField.text;
            break;
        case 1://付款姓名
            _fucardman = textField.text;
            break;
        case 2://付款手机号码
            _fucardmobile = textField.text;
            break;
            default:
            break;
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
        [self.CreditCardDelgate resetCardImage:YES];
        [self resetCardImage:YES];
    }
    else if (SRS_DeviceUnavailable == event)
    {
        [self.CreditCardDelgate resetCardImage:NO];
        [self resetCardImage:NO];
    }
    else if (SRS_OK == event)
    {
        [self doSRS_OK:object];
    }
}

-(void)doSRS_OK:(NSString*)str
{
    _visaReaderArray = [str componentsSeparatedByString:@"***@@@$$$"];
    if (_visaReaderArray.count >= 3)
    {        NSString *str = [_visaReaderArray objectAtIndex:0];
        if ([str isEqualToString:@""])
        {
            return;
        }
        if ([[str substringToIndex:2] intValue] >0)
        {
        _fucardno = [_visaReaderArray objectAtIndex:0];
        _paycardid = [_visaReaderArray objectAtIndex:1];
        if (_paycardid.length >= 14)
        {
            _paycardid = [_paycardid substringToIndex:14];
            _paycardid = [_paycardid lowercaseString];
        }
      
            _payCardCheck = _paycardid;
            [self resetCardNumber:_fucardno];
            
            /*验证刷卡器*/
            [self payCardCheck];
            /*刷卡验证是否有此默认信用卡*/
            [self ApipayCardCheck];
        }
    }
}

-(void)doPayCardCheckNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
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
    
    /*填充信息*/
    /*若有CVV数据则直接存信用卡通道*/
    _fucardbank= bkcardbanknameStr;
    _fucardman= bkcardmanCheckStr;
    _fucardmobile= bkcardphoneStr;
    
    [self.myTableView reloadData];
}

-(void)payCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
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
         NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
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


/*刷卡验证*/
-(void)ApipayCardCheck
{
    /*刷卡器唯一码*/
    NSString *paycardkey_check= _payCardCheck;
    /*银行卡号*/
    NSString *bkcardno_check= _fucardno;
    /*交易类型*/
    paytype_check= [[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0];
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApipayCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, ApipayCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApipayCardCheck:paycardkey_check bkcardno:bkcardno_check paytype:paytype_check readmode:@"f"];
}

/*信用卡刷卡信息对比*/
-(void)ApipayCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
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
        
        /*失败清空*/
        _fucardbank= @"";
        _fucardman= @"";
        _fucardmobile= @"";
        [self.myTableView reloadData];
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
        
        /*填充信息*/
        _fucardbank= bkcardbanknameStr;
        _fucardman= bkcardmanCheckStr;
        _fucardmobile= bkcardphoneStr;
        
        myBankCard = _fucardman? YES : NO;
        
        [self.myTableView reloadData];
        
   
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

-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.myTextField.text = str;
    }
}

#pragma mark - http request
-(void)createInforForResultView:(NLTransferResultViewController*)vc
{
    vc.myNavigationTitle = @"还款结果";
    vc.myTitle = @"交易成功";
    
     NSMutableArray  * arr = [NSMutableArray arrayWithCapacity:1];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款卡号",@"header", [self.myDictionary objectForKey:@"shoucardno"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款人姓名",@"header", [self.myDictionary objectForKey:@"shoucardman"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款银行",@"header", [self.myDictionary objectForKey:@"shoucardbank"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", _fucardno,@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人姓名",@"header", _fucardman,@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", _fucardbank,@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [NSString stringWithFormat:@"%@元",[self.myDictionary objectForKey:@"paymoney"]],@"content", nil];
    [arr addObject:dic];
    vc.myArray = [NSArray arrayWithArray:arr];
}

-(void)doInsertcreditCardMoneyNotify:(NLProtocolResponse*)response
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
        NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
        
        [self createInforForResultView:vc];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)insertcreditCardMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doInsertcreditCardMoneyNotify:response];
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

-(void)insertcreditCardMoney
{
    NSString* name = [NLUtils getNameForRequest:Notify_insertcreditCardMoney];
    REGISTER_NOTIFY_OBSERVER(self, insertcreditCardMoneyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] insertcreditCardMoney:_bkntno result:_result];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)createVerifyInfo:(NLCreditCardVerifyViewController*)vc
{
    vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"paymoney", nil];
}

-(void)doCreditCardMoneyRqNotify:(NLProtocolResponse*)response
{
    [_hud hide:YES];
    NLProtocolData* data = [response.data find:@"msgbody/bkntno" index:0];
    _bkntno = data.value;
    data = [response.data find:@"msgbody/paymoney" index:0];
    NSString* paymoney = data.value;
    data = [response.data find:@"msgbody/feemoney" index:0];
    NSString* feemoneyStr = data.value;
    data = [response.data find:@"msgbody/allmoney" index:0];
    NSString* allmoneyStr = data.value;
    NLCreditCardVerifyViewController* vc = [[NLCreditCardVerifyViewController alloc] initWithNibName:@"NLCreditCardVerifyViewController"
                                                                                              bundle:nil];
    
   
    vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:_bkntno,@"bkntno",paymoney,@"paymoney",feemoneyStr,@"feemoney",allmoneyStr,@"allmoney",[self.myDictionary objectForKey:@"shoucardno"],@"shoucardno",_fucardno,@"fucardno", nil];
    [self.navigationController pushViewController:vc animated:YES];
     
//    [_hud hide:YES];
//    [self doStartPay:_bkntno
//          sysProvide:nil
//                spId:nil
//                mode:[NLUtils get_req_bkenv]
//      viewController:self
//            delegate:self];
}

-(void)creditCardMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doCreditCardMoneyRqNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
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

/*信用卡还款 银联*/
-(void)creditCardMoneyRq
{
    NSString* name = [NLUtils getNameForRequest:Notify_creditCardMoneyRq];
    REGISTER_NOTIFY_OBSERVER(self, creditCardMoneyRqNotify, name);
    NSString* str = [_visaReaderArray objectAtIndex:2];
    NSData* data = [NLUtils stringToData:str];
    merReserved = [GTMBase64 stringByEncodingData:data];
    
    [[[NLProtocolRequest alloc] initWithRegister:YES] creditCardMoneyRq:[self.myDictionary objectForKey:@"paytype"]
                                                               paymoney:[self.myDictionary objectForKey:@"paymoney"]
                                                             shoucardno:[self.myDictionary objectForKey:@"shoucardno"]
                                                         shoucardmobile:[self.myDictionary objectForKey:@"shoucardmobile"]
                                                            shoucardman:[self.myDictionary objectForKey:@"shoucardman"]
                                                           shoucardbank:[self.myDictionary objectForKey:@"shoucardbank"]
                                                               fucardno:_fucardno
                                                             fucardbank:_fucardbank
                                                           fucardmobile:_fucardmobile
                                                              fucardman:_fucardman
                                                                current:_current
                                                              paycardid:_paycardid
                                                            merReserved:merReserved];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(BOOL)checkCreditCardMoneyInfo
{
    if (![NLUtils checkBankCard:_fucardno])
    {
        [self showErrorInfo:@"输入正确的银行卡号" status:NLHUDState_Error];
        return NO;
    }
    if (_fucardbank.length <= 0)
    {
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkMobilePhone:_fucardmobile])
    {
        [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkName:_fucardman])
    {
        [self showErrorInfo:@"输入正确的姓名" status:NLHUDState_Error];
        return NO;
    }
    return YES;
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
    if (![result isEqualToString:@"cancel"]) {
       
        [self insertcreditCardMoney];
    }
    
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

-(void)showMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
