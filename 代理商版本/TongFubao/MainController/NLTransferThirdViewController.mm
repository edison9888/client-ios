//
//  NLTransferThirdViewController.m
//  TongFubao
//
//  Created by MD313 on 13-10-10.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLTransferThirdViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "NLKeyboardAvoid.h"
#import "GTMBase64.h"
#import "UPPayPlugin.h"
#import "NLTransferResultViewController.h"

@interface NLTransferThirdViewController ()
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
    NSString*_Caredtype;/*卡类型*/
    NSString* _resultPayCard;
    
    //银行卡ID
    NSString *bankID;
    
    BOOL _enablePayCard;
    BOOL _enableCardImage;
   
    /*转账超时*/
    int             _time;
    NLProgressHUD  * _hud;
    VisaReader     * _visaReader;
    NSArray        * _visaReaderArray;
    
    /*获取信用卡验证码*/
    NSString       *orderIdStr;
    NSString       *verifyCodeStr;
    UITextField    *alertText;
    BOOL             flagYZM;
    BOOL             flagTY;
    BOOL             flagSKQ;
    BOOL             flagAlert;
    /*交易类型*/
    NSString *paytype_check;
    
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
    
    //我的银行卡
    BOOL myBankCard;
}

@property (weak, nonatomic) IBOutlet UIButton *btnOnclick;
@property (weak, nonatomic) IBOutlet UILabel *textLable;
/*验证码超时期限*/
@property(nonatomic, readwrite, retain) NSTimer *myTimer;

@end

@implementation NLTransferThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
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
    _result = @"";
    _current = @"RMB";
    _enableCardImage = NO;
    _enablePayCard = YES;
    _resultPayCard = @"";
    _payCardCheck = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"付款";
    
    [self initValue];
    [self initVisaReader];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
     NSString *num =[NSString stringWithFormat:@"%f",_btnOnclick.frame.origin.y+60];
      [_textLable.layer setValue:num forKeyPath:@"frame.origin.y"];
   
//    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*通道选择 先刷卡器区分*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        if (flagSKQ == NO)
        {
            planePay *pla= [[planePay alloc]init];
            pla.myViewYiBaoType= YiBaoPayType_ZhuanZhang;
            pla.myDictionary= self.myDictionary;
            pla.cardReaderId= _paycardid;
            pla.sendBankCardId= _fucardno;
            pla.fucardmobile= _fucardmobile;
            pla.fucardbank = _fucardbank;
            pla.bankID = bankID;
            pla.fucardman= _fucardman;
            
            [self.navigationController pushViewController:pla animated:YES];
        }
    }
    else
    {
        if ([[self.myDictionary objectForKey:@"transferType"] isEqualToString:@"0"])
        {
           
            if (flagYZM==YES)
            {
                if (flagSKQ==NO)
                {
                    /*信用卡还款 银联*/
                    [self transferMoneyRq];
                }
                else
                {
                    if (alertText.text.length==0)
                    {
                        
                        [self showErrorInfo:@"请输入正确的验证码" status:NLHUDState_Error];
                        [_hud hide:YES afterDelay:1.5];
                        
                    }
                    else
                    {
                        /*信用卡还款验证码*/
                        [self ApicreditCardMoneyRq_YiBao];
                    }
                }
            }
            else
            {
                /*信用卡还款 银联*/
                [self transferMoneyRq];
            }
        }
        else if ([[self.myDictionary objectForKey:@"transferType"] isEqualToString:@"1"])
        {
            if (flagYZM==YES)
            {
                    /*信用卡还款验证码*/
                    if (flagSKQ==NO)
                    {
                        /*信用卡还款 银联*/
                        [self SuptransferMoneyRq];
                    }else{
                        if (alertText.text.length==0) {
                            
                            [self showErrorInfo:@"请输入正确的验证码" status:NLHUDState_Error];
                            [_hud hide:YES afterDelay:1.5];
                            
                        }else{
                            
                         [self ApicreditCardMoneyRq_YiBao];
                        }
                }
            }else{
                /*信用卡还款 银联*/
                [self SuptransferMoneyRq];
                
            }
        }
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

/*转账汇款*/
-(IBAction)onButtonBtnClicked:(id)sender
{
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (cell.myTextField.text.length == 0 || [cell.myTextField.text isEqualToString:@""])
    {
        [self showError:@"请输入卡号"];
        
        return;
    }
    
    if ([self checkTransferInfo])
    {
        /*转账类型 转账类型0 超级转账是1 区分转账类型 传不同的参数即可 */
        if ([[self.myDictionary objectForKey:@"transferType"] isEqualToString:@"0"])
        {
            /*刷卡判断 后台有数据则选择卡号*/
            if (bkcardcvvStr.length == 0)
            {
                /*16位的储蓄卡*/
                if ([bkcardtypeStr isEqualToString:@"bankcard"])
                {
                    /*转账汇款 银联*/
                    [self transferMoneyRq];
                }
                else
                {
                    /*后台判断数据*/
                    if (_fucardno.length == 16)
                    {
                        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
                        
                        //数据筛选
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bankname == %@", _fucardbank];
                        
                        //请求参数
                        NSDictionary *dic = @{ @"activemobilesms" : @"0",
                                               @"msgstart" : @"0",
                                               @"msgdisplay" : @"50",
                                               @"querywhere" : @"",
                                               @"banktype" : @"yibao" };
                        
                        //数据请求
                        [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiAppInfo" apiNameFunc:@"readBankList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
                            
                            if (data)
                            {
                                NSArray *banknames = [data filteredArrayUsingPredicate:predicate];
                                
                                if (banknames.count > 0)
                                {
                                    /*弹框*/
                                    [self alertNotoBtn];
                                }
                            }
                        }];
                    }
                    else
                    {
                        /*转账汇款 银联*/
                        [self transferMoneyRq];
                    }
                }
            }
            else
            {
                /*刷卡后信用卡有数据返回则是否储蓄卡或信用卡*/
                if (_fucardno.length == 16)
                {
                    flagTY = YES;
                    /*易宝信用卡通道*/
                    [self ApiTransferWithtfm_yiBao];
                    
                }
                else
                {
                    /*转账汇款 银联*/
                    [self transferMoneyRq];
                }
            }
            
        }
        else if ([[self.myDictionary objectForKey:@"transferType"] isEqualToString:@"1"])
        {
            /*刷卡判断 后台有数据则选择卡号*/
            if (bkcardcvvStr.length==0)
            {
                /*16位的储蓄卡*/
                if ([bkcardtypeStr isEqualToString:@"bankcard"])
                {
                    /*转账汇款 银联*/
                    [self SuptransferMoneyRq];
                }
                else
                {
                    /*后台判断数据*/
                    if (_fucardno.length==16)
                    {
                        //数据筛选
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bankname == %@", _fucardbank];
                        
                        //请求参数
                        NSDictionary *dic = @{ @"activemobilesms" : @"0",
                                               @"msgstart" : @"0",
                                               @"msgdisplay" : @"50",
                                               @"querywhere" : @"",
                                               @"banktype" : @"yibao" };
                        
                        //数据请求
                        [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiAppInfo" apiNameFunc:@"readBankList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
                            
                            if (data)
                            {
                                NSArray *banknames = [data filteredArrayUsingPredicate:predicate];
                                
                                if (banknames.count > 0)
                                {
                                    /*弹框*/
                                    [self alertNotoBtn];
                                }
                            }
                        }];
                    }
                    else
                    {
                        /*转账汇款 银联*/
                        [self SuptransferMoneyRq];
                    }
                }
                
            }
            else
            {
                /*刷卡后信用卡有数据返回则是否储蓄卡或信用卡*/
                if (_fucardno.length==16)
                {
                    flagTY = YES;
                    /*易宝信用卡通道*/
                    [self ApiTransferWithtfm_yiBao];
                    /*测试成功效果*/
                }else
                {
                    /*转账汇款 银联*/
                    [self SuptransferMoneyRq];
                }
            }
            
        }

    }
}

/*转账汇款 区分参数类型的通道
 转账类型 转账类型0 超级转账是1*/
/*刷卡的信用卡数据*/
-(void)ApiTransferWithtfm_yiBao
{
    
    /*转账类型 转账类型0 超级转账是1 */
     NSString *transferTypeStr= [_myDictionary valueForKey:@"transferType"];
    NSString *patyType = [transferTypeStr isEqualToString:@"0"]? @"tfmg" : @"suptfmg";
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiTransferWithCreditCard];
    REGISTER_NOTIFY_OBSERVER(self, ApiTransferNotify, name);
     /*银行卡号 receiveBankCardId*/
     [[[NLProtocolRequest alloc] initWithRegister:YES]ApiTransferWithCreditCard:[self.myDictionary objectForKey:@"money"] transferMoney:[self.myDictionary objectForKey:@"paymoney"] receiveBankCardId:[self.myDictionary objectForKey:@"shoucardno"] receiveBankName:[self.myDictionary objectForKey:@"shoucardbank"] receivePhone:[self.myDictionary objectForKey:@"shoucardmobile"] receivePersonName:[self.myDictionary objectForKey:@"shoucardman"] cardReaderId:_paycardid sendBankCardId:bkcardnoCheckStr sendBankCode:bkcardbankidCheckStr personCardId:bkcardidcardStr sendPhone:bkcardphoneStr sendPersonName:bkcardmanCheckStr expireYear:bkcardyxyearStr expireMonth:bkcardyxmonthStr cvv:bkcardcvvStr transferType:transferTypeStr arriveid:[self.myDictionary objectForKey:@"arriveid"] sendBankName:bkcardbanknameStr payType:patyType paycardid:_paycardid];
    
    /*写数据 写参数*/
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

/*易宝信用卡还款*/
-(void)ApiTransferNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
         [_hud hide:YES];

        [self doApiTransferNotify:response];
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
-(void)doApiTransferNotify:(NLProtocolResponse*)response
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
       
        if ([verifyCodeStr intValue]==1)
        {
            if (flagTY)
            {
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
            [self viewtoYiBaoToOK];

            NSLog(@"成功支付");
        }
        
    }
}


-(void)viewtoYiBaoToOK
{
    //成功转账显示的页面
    NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
    
    [self createInforForResultView:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

/*易宝转账验证码*/
-(void)ApicreditCardMoneyRq_YiBao
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApiPayWithVerifyCode];
    REGISTER_NOTIFY_OBSERVER(self, ApiYiBaoMoreNotify, name);
    /*修改*/
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiPayWithVerifyCode:orderIdStr verifyCode:alertText.text];
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
          [self viewtoYiBaoToOK];
    }
}

#pragma 短信验证码超时
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
            if (_btnOnclick.enabled)
            {
                _btnOnclick.enabled = NO;
            }
        }
            break;
        case NLReGetBtnState_EnableTitle:
        {
            [_btnOnclick setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0)] forState:UIControlStateNormal];
            [_btnOnclick setTitle:@"重新提交获取" forState:UIControlStateNormal];
            
            if (!_btnOnclick.enabled)
            {
                _btnOnclick.enabled = YES;
            }
        }
            break;
        case NLReGetBtnState_DisableTitle:
        {
            
            [_btnOnclick setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0)] forState:UIControlStateNormal];
            _btnOnclick.titleLabel.text= title;
            [_btnOnclick setTitle:_btnOnclick.titleLabel.text forState:UIControlStateNormal];
            
            if (_btnOnclick.enabled)
            {
                _btnOnclick.enabled = NO;
            }
        }
            break;
        case NLReGetBtnState_Enable:
        {
            NSLog(@"NLReGetBtnState_Enable");
            
            if (!_btnOnclick.enabled)
            {
                _btnOnclick.enabled = YES;
            }
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
                NSLog(@"测试易宝卡号长度 Cow _fucardno%d %@",_fucardno.length,_fucardno);
            }
            cell.myUprightImage.hidden = NO;
            [cell.myUprightImage setFrame:CGRectMake(260, 7, 30, 30)];
            if (_enableCardImage) //判断bool类型
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
            if ([_fucardbank length] <= 0)
            {
                cell.myContentLabel.text = @"点击选择";
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
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 1;
            cell.myTextField.enabled = myBankCard? NO : YES;
            if ([_fucardman length] > 0)
            {
                cell.myTextField.text = _fucardman;
            }
            else
            {
                cell.myTextField.placeholder = @"输入开户人姓名";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case 3:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"手机";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 2;
            cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
            cell.myTextField.enabled = myBankCard? NO : YES;
            if ([_fucardmobile length] > 0)
            {
                cell.myTextField.text = _fucardmobile;
            }
            else
            {
                cell.myTextField.placeholder = @"输入手机号码";
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
    bankID = state;
    
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

#pragma showErrorInfo
- (void)showError:(NSString *)detail
{
    if (detail)
    {
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
    else
    {
        [self showErrorInfo:@"服务器繁忙，请稍候再试" status:NLHUDState_Error];
    }
}

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
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]];
            
            _hud.mode = MBProgressHUDModeCustomView;
            
            [_hud show:YES];
            
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
            
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
            break;
    }
    
    return ;
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

/*刷卡获取信息*/
-(void)doSRS_OK:(NSString*)str
{
    _visaReaderArray = [str componentsSeparatedByString:@"***@@@$$$"];
    NSLog(@"_visaReaderArray %@",_visaReaderArray);
    if (_visaReaderArray.count >= 5)
    {
        NSString *str = [_visaReaderArray objectAtIndex:0];
        if ([str isEqualToString:@""])
        {
            return;
        }
        
        if ([[str substringToIndex:2] intValue] >0)
        {
            _fucardno = [_visaReaderArray objectAtIndex:0];
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
            
            [self resetCardNumber:_fucardno];
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
    NSString *bkcardno_check= _fucardno;
    /*交易类型*/
    paytype_check= [[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0];
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApipayCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, ApipayCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApipayCardCheck:paycardkey_check bkcardno:bkcardno_check paytype:paytype_check readmode:@""];
}

/*信用卡刷卡信息对比*/
-(void)ApipayCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self doApiPayCardCheckNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"获取数据为空，请重试" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
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
        bkcardbanknameStr = bkcardbanknameCheck.value;
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
        _fucardbank = bkcardbanknameStr;
        _fucardman = bkcardmanCheckStr;
        _fucardmobile = bkcardphoneStr;
        
        myBankCard = _fucardman? YES : NO;
        
        [self.myTableView reloadData];
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

-(void)doInsertTransferMoneyNotify:(NLProtocolResponse*)response
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
        NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
        
        [self createInforForResultView:vc];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)insertTransferMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doInsertTransferMoneyNotify:response];
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

-(void)insertTransferMoney
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_insertTransferMoney];
    REGISTER_NOTIFY_OBSERVER(self, insertTransferMoneyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] insertTransferMoney:_bkntno result:_result];
}

-(void)doTransferMoneyRqNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/bkntno" index:0];
    _bkntno = data.value;
    [_hud hide:YES];
    [self doStartPay:_bkntno
          sysProvide:nil
                spId:nil
                mode:[NLUtils get_req_bkenv]
      viewController:self
            delegate:self];
}

-(void)transferMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doTransferMoneyRqNotify:response];
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

/*myDictionary 银联通道*/
-(void)transferMoneyRq
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_transferMoneyRq];
    REGISTER_NOTIFY_OBSERVER(self, transferMoneyRqNotify, name);
    NSString* str = [_visaReaderArray objectAtIndex:2];
    NSData* data = [NLUtils stringToData:str];
    NSString* merReserved = [GTMBase64 stringByEncodingData:data];
    [[[NLProtocolRequest alloc] initWithRegister:YES] transferMoneyRq:_paycardid
                                                             fucardno:_fucardno
                                                           fucardbank:_fucardbank
                                                            fucardman:_fucardman
                                                         fucardmobile:_fucardmobile
                                                           shoucardno:[self.myDictionary objectForKey:@"shoucardno"]
                                                         shoucardbank:[self.myDictionary objectForKey:@"shoucardbank"]
                                                              current:_current
                                                             paymoney:[self.myDictionary objectForKey:@"paymoney"]
                                                               payfee:[self.myDictionary objectForKey:@"payfee"]
                                                                money:[self.myDictionary objectForKey:@"money"]
                                                       shoucardmobile:[self.myDictionary objectForKey:@"shoucardmobile"]
                                                          shoucardman:[self.myDictionary objectForKey:@"shoucardman"]
                                                             arriveid:[self.myDictionary objectForKey:@"arriveid"]
                                                         shoucardmemo:[self.myDictionary objectForKey:@"shoucardmemo"]
                                                              sendsms:[self.myDictionary objectForKey:@"sendsms"]
                                                          merReserved:merReserved];
}

-(void)doInsertSupTransferMoneyNotify:(NLProtocolResponse*)response
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
        //成功转账显示的页面
        NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
        
        [self createInforForResultView:vc];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)insertSupTransferMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doInsertSupTransferMoneyNotify:response];
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
            detail = @"请求失败，请重新尝试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)insertSupTransferMoney
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_insertSupTransferMoney];
    REGISTER_NOTIFY_OBSERVER(self, insertSupTransferMoneyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] insertSupTransferMoney:_bkntno result:_result];
}

//2doSuptransferMoneyRqNotify
-(void)doSuptransferMoneyRqNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/bkntno" index:0];
    _bkntno = data.value;
    [_hud hide:YES];
    /*银联流水号转账*/
    [self doStartPay:_bkntno
          sysProvide:nil
                spId:nil
                mode:[NLUtils get_req_bkenv]
      viewController:self
            delegate:self];
}

/*超级转账 银联*/
-(void)SuptransferMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doSuptransferMoneyRqNotify:response];
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

/*超级转账 银联接口的*/
-(void)SuptransferMoneyRq
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_SuptransferMoneyRq];
    REGISTER_NOTIFY_OBSERVER(self, SuptransferMoneyRqNotify, name);
    NSString* str = [_visaReaderArray objectAtIndex:2];
    NSData* data = [NLUtils stringToData:str];
    NSString* merReserved = [GTMBase64 stringByEncodingData:data];
    [[[NLProtocolRequest alloc] initWithRegister:YES] SuptransferMoneyRq:_paycardid
                                                                fucardno:_fucardno
                                                              fucardbank:_fucardbank
                                                               fucardman:_fucardman
                                                            fucardmobile:_fucardmobile
                                                              shoucardno:[self.myDictionary objectForKey:@"shoucardno"]
                                                            shoucardbank:[self.myDictionary objectForKey:@"shoucardbank"]
                                                                 current:_current
                                                                paymoney:[self.myDictionary objectForKey:@"paymoney"]
                                                                  payfee:[self.myDictionary objectForKey:@"payfee"]
                                                                   money:[self.myDictionary objectForKey:@"money"]
                                                          shoucardmobile:[self.myDictionary objectForKey:@"shoucardmobile"]
                                                             shoucardman:[self.myDictionary objectForKey:@"shoucardman"]
                                                                arriveid:[self.myDictionary objectForKey:@"arriveid"]
                                                            shoucardmemo:[self.myDictionary objectForKey:@"shoucardmemo"]
                                                                 sendsms:[self.myDictionary objectForKey:@"sendsms"]
                                                             merReserved:merReserved];
}

-(BOOL)checkTransferInfo
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
        _result  = @"";
        return;
    }
    
    if (![result isEqualToString:@"cancel"]) {
       
        if ([[self.myDictionary objectForKey:@"transferType"] isEqualToString:@"0"])
        {
            [self insertTransferMoney];
        }
        else if ([[self.myDictionary objectForKey:@"transferType"] isEqualToString:@"1"])
        {
            [self insertSupTransferMoney];
        }
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

-(void)createInforForResultView:(NLTransferResultViewController*)vc
{
    vc.myNavigationTitle = @"转账结果";
    vc.myTitle = @"转账成功";
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款卡号",@"header", [self.myDictionary objectForKey:@"shoucardno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款银行",@"header", [self.myDictionary objectForKey:@"shoucardbank"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款人",@"header", [self.myDictionary objectForKey:@"shoucardman"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", _fucardno,@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", _fucardbank,@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款人",@"header", _fucardman,@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [self.myDictionary objectForKey:@"paymoney"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手续费",@"header", [self.myDictionary objectForKey:@"payfee"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"支付金额",@"header", [self.myDictionary objectForKey:@"money"],@"content", nil];
    [arr addObject:dic];
   
    vc.myArray = [NSArray arrayWithArray:arr];
}

-(void)showMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end









