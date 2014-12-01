//
//  SavingsCardViewController.m
//  TongFubao
//
//  Created by kin on 14/10/21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SavingsCardViewController.h"
#import "TicketCustomTableViewCell.h"
#import "NLHistoricalAccountViewController.h"
#import "ShouMoneyViewController.h"
#import "NLCashArriveHistoryViewController.h"
#import "VisaReader.h"

#define SWIPINGCARDIMAGESECTION 0

@interface SavingsCardViewController ()<NLBankLisDelegate,NLHistoricalAccountViewdelegate>
{
    NLProgressHUD* _hud;
    NSString* _paymoney;
    NSString* _shoucardno;
    NSString* _shoucardmobile;
    NSString* _shoucardman;
    UIImageView *_imageview;
    NSString* _shoucardbank;

    NSString* _reshoucardno;
    NSString* _bankid;
    VisaReader* _visaReader;
    BOOL _enableCardImage;
    NSArray* _visaReaderArray;
    NSString* _payCardCheck;
    BOOL _enablePayCard;
    NSString* _resultPayCard;


//    NSString* _paycardid;
//    NSString* _paytype;
//    NSString* _payCardCheck;
}

@end

@implementation SavingsCardViewController

@synthesize SavingsCardTableView,titleArray;


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
    [self allController];
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
        [self.SavingsCardTableView flashScrollIndicators];
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
         TicketCustomTableViewCell* cell = (TicketCustomTableViewCell*)[self.SavingsCardTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardNunberRowType inSection:SWIPINGCARDIMAGESECTION]];
        cell.cardImageView.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        TicketCustomTableViewCell* cell = (TicketCustomTableViewCell*)[self.SavingsCardTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardNunberRowType inSection:SWIPINGCARDIMAGESECTION]];
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
        TicketCustomTableViewCell* cell = (TicketCustomTableViewCell*)[self.SavingsCardTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardNunberRowType inSection:SWIPINGCARDIMAGESECTION]];
        cell.infoTextField.text = str;
    }
    [self.SavingsCardTableView reloadData];
}

-(void)payCardCheck
{
    /*刷卡器唯一码*/
    NSString *paycardkey_check= _payCardCheck;
    /*银行卡号*/
    NSString *bkcardno_check= _shoucardno;
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApipayCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApipayCardCheck:paycardkey_check bkcardno:bkcardno_check paytype:[[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0] readmode:@"s"];
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
    NLProtocolData *bkcardphoneData = [response.data find:@"msgbody/bkcardphone" index:0];
    _shoucardmobile = bkcardphoneData.value;
    
    //姓名
    NLProtocolData *bkcardmanData = [response.data find:@"msgbody/bkcardman" index:0];
    _shoucardman = bkcardmanData.value;
    
    //银行
    NLProtocolData *bkcardbanknameData = [response.data find:@"msgbody/bkcardbankname" index:0];
    _shoucardbank = bkcardbanknameData.value;
    
    [self.SavingsCardTableView reloadData];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}



-(void)navigation
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"收款人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRightButtonItemWithTitle:@"交易记录"];
}
// 右边导航
-(void)rightItemClick:(id)sender
{
    NLCashArriveHistoryViewController* CashArriveHistoryView = [[NLCashArriveHistoryViewController alloc] initWithNibName:@"NLCashArriveHistoryViewController" bundle:nil] ;
    CashArriveHistoryView.myHistoryRecordType = NLHistoryRecordType_CreditCardPayments;
    [self.navigationController pushViewController:CashArriveHistoryView animated:YES];
}

-(void)allController
{
    
    self.titleArray = @[@"您可以点击选择历史帐户",@"账户:",@"银行:",@"姓名:",@"手机:",@"金额:"];
    UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 68, self.view.frame.size.width, 30)];
    infoLable.textAlignment = NSTextAlignmentCenter;
    infoLable.text = @"注:此交易支付只支持信用卡!";
    infoLable.font = [UIFont systemFontOfSize:15];
//    infoLable.textColor = RGBACOLOR(3, 198, 230, 1);
    infoLable.textColor = [UIColor orangeColor];
    [self.view addSubview:infoLable];
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(10, 100, 300, 300+(ADDSIZE))];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    backView.layer.borderWidth = 2;
    backView.layer.borderColor = RGBACOLOR(3, 198, 230, 1).CGColor;
    [self.view addSubview:backView];
    
    self.SavingsCardTableView = [[UITableView alloc]initWithFrame:CGRectMake(-15, 0, 320,300+(ADDSIZE))];
    self.SavingsCardTableView.delegate = self;
    self.SavingsCardTableView.dataSource = self;
    [backView addSubview:self.SavingsCardTableView];
    
    
    UIButton *timeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    timeButton.titleLabel.text = @"下一步";
    timeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [timeButton setTitle:timeButton.titleLabel.text forState:(UIControlStateNormal)];
    timeButton.frame = CGRectMake(10, 415+(ADDVIEWSIZE), 300, 45);
    [timeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [timeButton setBackgroundImage:[UIImage imageNamed:@"change_btn_normal.png"] forState:(UIControlStateNormal)];
    [timeButton addTarget:self action:@selector(nextButtonClik) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:timeButton];    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
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
    switch (indexPath.row)
    {
        case TableViewHistoricalAccountRowType:
        {
            cell.savingNameLable.text =[self.titleArray objectAtIndex:0];
            cell.savingNameLable.frame = CGRectMake(0, 0, cell.frame.size.width, 60);
            cell.savingNameLable.textAlignment = NSTextAlignmentCenter;
//            cell.infoTextField.placeholder = @"您可以选择历史银行卡";
//            cell.infoTextField.frame =CGRectMake(120, 0, 180, 60);
            cell.infoTextField.hidden = YES;
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = RGBACOLOR(3, 198, 230, 0.3);
        }
            break;
        case TableViewCardNunberRowType:
        {
            cell.savingNameLable.text =[self.titleArray objectAtIndex:1];
            cell.infoTextField.placeholder = @"请您输入卡号/刷卡";
            cell.infoTextField.text = _shoucardno;
            cell.infoTextField.tag = 0;
            if (_enableCardImage)
            {
                cell.cardImageView.image = [UIImage imageNamed:@"swipingCard2.png"];
            }
            else
            {
                cell.cardImageView.image = [UIImage imageNamed:@"swipingCard.png"];
            }
            cell.infoTextField.clearButtonMode=UITextFieldViewModeAlways;
        }
            break;
        case TableViewCardBankRowType:
        {
            cell.savingNameLable.text =[self.titleArray objectAtIndex:2];
            cell.infoTextField.placeholder = @"请您点击选择银行";
            cell.infoTextField.enabled = NO;
            cell.infoTextField.text = _shoucardbank;
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case TableViewCardNameRowType:
        {
            cell.savingNameLable.text =[self.titleArray objectAtIndex:3];
            cell.infoTextField.placeholder = @"请您输入账户姓名";
            cell.infoTextField.text = _shoucardman;
            cell.infoTextField.tag = 1;
            cell.infoTextField.clearButtonMode=UITextFieldViewModeAlways;
        }
            break;
        case TableViewCardMobileRowType:
        {
            cell.savingNameLable.text =[self.titleArray objectAtIndex:4];
            cell.infoTextField.placeholder = @"请您输入手机号码";
            cell.infoTextField.text = _shoucardmobile;
            cell.infoTextField.tag = 2;
            cell.infoTextField.delegate = self;
            cell.infoTextField.clearButtonMode=UITextFieldViewModeAlways;
        }
            break;
        case TableViewPayMoneyRowType:
        {
            cell.savingNameLable.text =[self.titleArray objectAtIndex:5];
            cell.infoTextField.placeholder = @"请您输入还款金额";
            cell.infoTextField.tag = 3;
            cell.infoTextField.delegate = self;
            cell.infoTextField.clearButtonMode=UITextFieldViewModeAlways;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://收款卡号
            _shoucardno = textField.text;
            break;
        case 1://开户人姓名
            _shoucardman = textField.text;
            break;
        case 2://手机号码
            _shoucardmobile = textField.text;
            break;
        case 3://还款金额
            _paymoney = textField.text;
            break;
        default:
            break;
    }
}
#pragma mark ====== 推送到下一页面
-(void)nextButtonClik
{
//    if (!_enablePayCard)
//    {
//        [self showErrorInfo:_resultPayCard status:NLHUDState_Error];
//        return;
//    }
    if (_visaReader.myDelegate == self)
    {
        [self stopVisaReader];
    }
    BOOL SELETION = [self checkCreditCardMoneyInfo];
    if (SELETION == YES)
    {
        ShouMoneyViewController *shouMoneyView = [[ShouMoneyViewController alloc]init];
        //金额
        NSArray *shouPersonArray = [[NSArray alloc]initWithObjects:_paymoney,_shoucardno,_shoucardbank,_shoucardman,_shoucardmobile,nil];
        shouMoneyView.savingPerson  = shouPersonArray;
//        [NLUtils presentModalViewController:self newViewController:shouMoneyView];
        [self.navigationController pushViewController:shouMoneyView animated:YES];
    }
}

-(BOOL)checkCreditCardMoneyInfo
{

    if (_shoucardno.length <= 15|| _shoucardbank.length >= 20)
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
    if (![NLUtils checkName:_shoucardman])
    {
        [self showErrorInfo:@"输入正确的姓名" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkMobilePhone:_shoucardmobile])
    {
        [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
        return NO;
    }
    if (_paymoney.length <= 0)
    {
        [self showErrorInfo:@"输入还款金额" status:NLHUDState_Error];
        return NO;
    }
    else if ([_paymoney floatValue] <= 0)
    {
        [self showErrorInfo:@"还款金额必须大于0元" status:NLHUDState_Error];
        return NO;
    }
    else
    {
        return YES;
    }
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
#pragma mark - keyboard hide event

//-(void)oneFingerTwoTaps
//{
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    [firstResponder resignFirstResponder];
//}
#pragma mark - 选择历史帐户和银行列表
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int section = indexPath.section;
//    if (0 == section)
//    {
        int row = indexPath.row;
        if (TableViewHistoricalAccountRowType == row)
        {
            [self.view endEditing:YES];
            NLHistoricalAccountViewController *HistoricalAccountView = [[NLHistoricalAccountViewController alloc]initWithNibName:@"NLHistoricalAccountViewController" bundle:nil];
            HistoricalAccountView.myHistoryPayType = NLHistoryPayType_Creditcard;
            HistoricalAccountView.delegate = self;
            HistoricalAccountView.otherPage = @"Saving";
            [self.navigationController pushViewController:HistoricalAccountView animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else if (TableViewCardBankRowType == row)
        {
            [self.view endEditing:YES];
            NLBankListViewController *BankListView = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
            BankListView.delegate = self;
            BankListView.payListBank = @"s";
            [self.navigationController pushViewController:BankListView animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

        }
    
//    }
    
}

#pragma mark - 银行列表

- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state
{
    _shoucardbank = (NSString*)aObject;
    TicketCustomTableViewCell *cell = (TicketCustomTableViewCell*)[self.SavingsCardTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardBankRowType inSection:SWIPINGCARDIMAGESECTION]];
    if (cell)
    {
        cell.infoTextField.text = _shoucardbank;
    }
}


-(void)HistoriupdateValue:(NSString*)shoucardno Historishoucardbank:(NSString*)shoucardbank Historishoucardman:(NSString*)shoucardman Historishoucardmobile:(NSString*)shoucardmobile  Historibankid:(NSString*)bankid
{
    _shoucardbank = shoucardbank;
    _shoucardno = shoucardno;
    _reshoucardno = shoucardno;
    _shoucardmobile = shoucardmobile;
    _shoucardman = shoucardman;
    _bankid = bankid;
    [self.SavingsCardTableView reloadData];
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
