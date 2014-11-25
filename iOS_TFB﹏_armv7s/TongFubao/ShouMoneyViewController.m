//
//  ShouMoneyViewController.m
//  TongFubao
//
//  Created by kin on 14/10/21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ShouMoneyViewController.h"
#import "TicketCustomTableViewCell.h"
#import "NLBankListViewController.h"
#import "keyView.h"

#define SWIPINGCARDIMAGESECTION 1
@interface ShouMoneyViewController ()<NLBankLisDelegate,VisaReaderDelegate,keyviewdelegate>
{
    UIImageView *_imageview;
    NSString *_shoucardbank;
    NSString *_userBank;
    NSString *_seletionBank;
    NSString *_passWroldBank;
    NSString* _shoucardno;
    NSString *_userName;


    
    VisaReader* _visaReader;
    NSString* _reshoucardno;
    NSString* _bankid;
    BOOL _enableCardImage;
    NSArray* _visaReaderArray;
    NSString* _payCardCheck;
    BOOL _enablePayCard;
    NSString* _resultPayCard;
    NLProgressHUD* _hud;
    
    UITextField *keyTextField;
    keyView *_keybord ;




}
@end

@implementation ShouMoneyViewController

@synthesize shouMoneyTableView,titleArray;


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
    [self navigation];
    // 插卡
    [self initVisaReader];
}


-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    if (_visaReader.myDelegate != self)
    {
        _visaReader = [VisaReader initWithDelegate:self];
    }
    [self startVisaReader];
    [super viewDidAppear:animated];
    if (animated)
    {
        [self.shouMoneyTableView flashScrollIndicators];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    if (_visaReader.myDelegate == self)
    {
        [self stopVisaReader];
    }
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
    //NSLog(@"event = %d,object = %@",event,object);
    if (SRS_DeviceAvailable == event && [object isEqualToString:@"0"])
    {
        [self resetCardImage:YES];
        //        [_visaReader loadWakingUp];
        //        [_visaReader wakeUp];
        //        [self startVisaReader];
    }
    else if (SRS_DeviceUnavailable == event)
    {
        [self resetCardImage:NO];
    }
    else if(SRS_Unknown == event)
    {
        [self stopVisaReader];
        [self startVisaReader];
        //        [self showErrorInfo:@"刷卡失败，请拔出刷卡器后重新操作" status:NLHUDState_Error];
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
        TicketCustomTableViewCell* cell = (TicketCustomTableViewCell*)[self.shouMoneyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:SWIPINGCARDIMAGESECTION]];
        cell.cardImageView.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        TicketCustomTableViewCell* cell = (TicketCustomTableViewCell*)[self.shouMoneyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:SWIPINGCARDIMAGESECTION]];
        cell.cardImageView.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)doSRS_OK:(NSString*)str
{
    _visaReaderArray = [str componentsSeparatedByString:@"***@@@$$$"];
    NSLog(@"++++++++_visaReaderArray++++++++++++%@",_visaReaderArray);
    
    if (_visaReaderArray.count >= 3)
    {
        NSString *str = [_visaReaderArray objectAtIndex:0];
        NSLog(@"++++++++str++++++++++++%@",str);
        if ([str isEqualToString:@""])
        {
            return;
        }
        if ([[str substringToIndex:2] intValue] >0)
        {
            _shoucardno = str;
            
            if (_shoucardno.length > 0)
            {
                _payCardCheck = [_visaReaderArray objectAtIndex:1];
                
                if (_payCardCheck.length >= 14)
                {
                    _payCardCheck = [_payCardCheck substringToIndex:14];
                    _payCardCheck = [_payCardCheck lowercaseString];
                }
                
                [self resetCardNumber:_shoucardno];
                
                [self payCardCheck];
            }
        }
        else
        {
            
        }
    }
}
-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        TicketCustomTableViewCell* cell = (TicketCustomTableViewCell*)[self.shouMoneyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.infoTextField.text = str;
    }
    [self.shouMoneyTableView reloadData];
}

-(void)payCardCheck
{
    /*刷卡器唯一码*/
    NSString *paycardkey_check= _payCardCheck;
    /*银行卡号*/
    NSString *bkcardno_check= _shoucardno;
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApipayCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApipayCardCheck:paycardkey_check bkcardno:bkcardno_check paytype:[[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0] readmode:@""];
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
            detail = @"服务器繁忙，请稍候再试";
        }
        _resultPayCard = detail;
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

#pragma mark - UITextFieldDelegate
-(void)doPayCardCheckNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
    NSString* result = data.value;
    [self showErrorInfo:result status:NLHUDState_NoError];
    
    //手机号
//    NLProtocolData *bkcardphoneData = [response.data find:@"msgbody/bkcardphone" index:0];
//    _shoucardmobile = bkcardphoneData.value;
//    
//    //姓名
//    NLProtocolData *bkcardmanData = [response.data find:@"msgbody/bkcardman" index:0];
//    _shoucardman = bkcardmanData.value;
    
    //银行
    NLProtocolData *bkcardbanknameData = [response.data find:@"msgbody/bkcardbankname" index:0];
    _shoucardbank = bkcardbanknameData.value;
    
    [self.shouMoneyTableView reloadData];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}


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
//#pragma mark --- 键盘
//-(void)oneFingerTwoTaps
//{
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    [firstResponder resignFirstResponder];
//}


-(void)navigation
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"支付人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArray = @[@"账户:",@"银行:",@"密码:",@"姓名:"];
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(10, 80, 300, 300+(ADDSIZE))];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    backView.layer.borderWidth = 2;
    backView.layer.borderColor = RGBACOLOR(3, 198, 230, 1).CGColor;
    [self.view addSubview:backView];
    
    
    self.shouMoneyTableView = [[UITableView alloc]initWithFrame:CGRectMake(-15, -100, 320,400+(ADDSIZE))style:(UITableViewStyleGrouped)];
    self.shouMoneyTableView.delegate = self;
    self.shouMoneyTableView.dataSource = self;
    [backView addSubview:self.shouMoneyTableView];
    
    UIButton *timeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    timeButton.titleLabel.text = @"确认支付";
    timeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [timeButton setTitle:timeButton.titleLabel.text forState:(UIControlStateNormal)];
    timeButton.frame = CGRectMake(10, 395+(ADDVIEWSIZE), 300, 45);
    [timeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [timeButton setBackgroundImage:[UIImage imageNamed:@"change_btn_normal.png"] forState:(UIControlStateNormal)];
    [timeButton addTarget:self action:@selector(sureButtonClik) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:timeButton];
    
    UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 445+(ADDVIEWSIZE), self.view.frame.size.width, 20)];
    infoLable.textAlignment = NSTextAlignmentCenter;
    infoLable.text = @"温馨提醒：同一信用卡当天请勿频繁交易！";
    infoLable.font = [UIFont systemFontOfSize:15];
    infoLable.textColor = RGBACOLOR(3, 198, 230, 1);
    [self.view addSubview:infoLable];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(TicketCustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indefault = @"cell";
    TicketCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefault];
    if (!cell)
    {
        cell = [[TicketCustomTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:indefault];
    }
    [cell.infoTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];

    if (indexPath.section == 0)
    {
        cell.savingNameLable.text = @"支付金额:";
        cell.infoTextField.frame =CGRectMake(120, 0, 180, 60);
        cell.infoTextField.textColor = [UIColor orangeColor];
        cell.infoTextField.enabled = NO;
        cell.infoTextField.font = [UIFont boldSystemFontOfSize:25];
        cell.infoTextField.text =[NSString stringWithFormat:@"￥%@",[self.savingPerson objectAtIndex:0]];
        cell.backgroundColor = RGBACOLOR(3, 198, 230, 0.3);
    }
    else if (indexPath.section == 1)
    {
    cell.savingNameLable.text =[self.titleArray objectAtIndex:indexPath.row];
    switch (indexPath.row)
    {
        case 0:
        {
            cell.infoTextField.placeholder = @"请您用插卡器刷卡";
            cell.infoTextField.tag = 0;
            cell.infoTextField.rightView=_imageview;
            cell.infoTextField.enabled = NO;
            cell.cardImageView.image = [UIImage imageNamed:@"swipingCard@2x.png"];
            cell.infoTextField.clearButtonMode=UITextFieldViewModeAlways;
        }
            break;
        case 1:
        {
            cell.infoTextField.placeholder = @"请选择银行";
            cell.infoTextField.enabled = NO;
            cell.infoTextField.tag = 1;
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;

        }
            break;
        case 2:
        {
            cell.infoTextField.placeholder = @"请您输入卡号密码";
            cell.infoTextField.tag = 2;
            cell.infoTextField.secureTextEntry =YES;
            cell.infoTextField.clearButtonMode=UITextFieldViewModeAlways;
//            keyTextField=[[UITextField alloc]initWithFrame:CGRectMake(80, 0, 200, 60)];
//            keyTextField.placeholder = @"请您输入卡号密码";
//            keyTextField.clearButtonMode=UITextFieldViewModeAlways;
//            keyTextField.borderStyle=UITextBorderStyleRoundedRect;
//            keyTextField.keyboardType=UIKeyboardTypeNamePhonePad;
//            keyTextField.keyboardAppearance=UIKeyboardAppearanceAlert;
//            keyTextField.tag = 2;
//            keyTextField.enabled=YES;
//            keyTextField.delegate = self;
//            _keybord.delegate = self;
//            [cell.contentView addSubview:keyTextField];

            _keybord = [[keyView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-240, 320, 240)];
            cell.infoTextField.inputView=_keybord;
            
        }
            break;
        case 3:
        {
            cell.infoTextField.placeholder = @"请您输入卡账户名";
            cell.infoTextField.tag = 3;
            cell.infoTextField.clearButtonMode=UITextFieldViewModeAlways;

        }
            break;

            
        default:
            break;
      }
    }
    
    return cell;
    
}


-(void)keybrodBack
{
    [keyTextField resignFirstResponder];
}
-(void)textFelid:(NSString *)numberText
{
    keyTextField.text = numberText;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    keyTextField.text = @"";
    [_keybord deleteNumber];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if (1 == section)
    {
        int row = indexPath.row;
        if (1 == row)
        {
            NLBankListViewController *BankListView = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
            BankListView.delegate = self;
            BankListView.payListBank = @"f";
            [self.navigationController pushViewController:BankListView animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://开户人姓名
            _userBank = textField.text;
            break;
        case 1://银行
            _seletionBank = textField.text;
        case 2://密码
            _passWroldBank = textField.text;
            break;
        case 3://用户
            _userName = textField.text;
            break;

        default:
            break;
    }
}

#pragma mark - 银行列表
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state
{
    _shoucardbank = (NSString*)aObject;
    TicketCustomTableViewCell *cell = (TicketCustomTableViewCell*)[self.shouMoneyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:SWIPINGCARDIMAGESECTION]];
    if (cell)
    {
        cell.infoTextField.text = _shoucardbank;
    }
}


-(void)sureButtonClik
{
    BOOL SELETION = [self checkCreditCardMoneyInfo];
    NSLog(@"======SELETION=====%d",SELETION);
    if (SELETION == YES) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你已交易成功！" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(BOOL)checkCreditCardMoneyInfo
{
    if (_shoucardno.length <= 15 || _shoucardbank.length >= 20)
    {
        if (![NLUtils checkBankCard:_shoucardno])
        {
            [self showErrorInfo:@"输入正确的银行卡号" status:NLHUDState_Error];
            return NO;
        }
    }
    if (_shoucardbank.length <= 0)
    {
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
    if (_passWroldBank <= 0)
    {
        [self showErrorInfo:@"请输入密码" status:NLHUDState_Error];
        return NO;
    }
    if (_userName <= 0)
    {
        [self showErrorInfo:@"请输入姓名" status:NLHUDState_Error];
        return NO;
    }

    else
    {
        return YES;
    }
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
