//
//  NLCreditCardPaymentsViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLCreditCardPaymentsViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "NLCashArriveHistoryViewController.h"
#import "NLCreditCardSecondViewController.h"
#import "NLHistoricalAccountViewController.h"
typedef enum
{
    TableViewHistoricalAccountRowType = 0,
    TableViewCardNunberRowType,
    TableViewCardBankRowType,
    TableViewCardNameRowType,
    TableViewCardMobileRowType,
    TableViewPayMoneyRowType
} CreditCardTableViewRowType;

#define SWIPINGCARDIMAGESECTION 0

@interface NLCreditCardPaymentsViewController ()
{
    NLProgressHUD* _hud;
    NSString* _paycardid;
    NSString* _shoucardbank;
    NSString* _paymoney;
    NSString* _shoucardno;
    NSString* _shoucardmobile;
    NSString* _shoucardman;
    NSString* _paytype;
    NSString* _payCardCheck;
    
    BOOL _enablePayCard;
    NSString* _resultPayCard;
    BOOL _enableCardImage;
    VisaReader* _visaReader;
    NSArray* _visaReaderArray;
    
    //我的银行卡
    BOOL myBankCard;
}

@property(nonatomic,retain) IBOutlet UIButton* myNextBtn;
@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;

- (IBAction)onNextBtnClicked:(id)sender;

@end

@implementation NLCreditCardPaymentsViewController

@synthesize myTableView;
@synthesize myNextBtn;

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
    
    if (_visaReader.myDelegate != self)
    {
        _visaReader = [VisaReader initWithDelegate:self];
    }
    
    [self startVisaReader];
    [super viewDidAppear:animated];
    
    if (animated)
    {
        [self.myTableView flashScrollIndicators];
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

-(void)initValue
{
    _paycardid = nil;
    _shoucardbank = nil;
    _paymoney = nil;
    _shoucardno = nil;
    _shoucardmobile = nil;
    _shoucardman = nil;
    _paytype = @"pay";
    _enableCardImage = NO;
    _payCardCheck = @"";
    _enablePayCard = YES;
    _resultPayCard = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"还信用卡";
    [self initValue];
    [self initVisaReader];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"还款历史"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(historyRecord)];
    self.navigationItem.rightBarButtonItem = anotherButton;
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

/*信用卡还款*/
- (IBAction)onNextBtnClicked:(id)sender
{
    if (![self checkCreditCardMoneyInfo])
    {
        return;
    }
    
    if (!_enablePayCard)
    {
        [self showErrorInfo:_resultPayCard status:NLHUDState_Error];
        return;
    }
    
    if (_visaReader.myDelegate == self)
    {
        [self stopVisaReader];
    }
    
    /*信用卡还款下一步界面*/
    [self.view endEditing:YES];
    
    NLCreditCardSecondViewController* vc = [[NLCreditCardSecondViewController alloc] initWithNibName:@"NLCreditCardSecondViewController"
                                                                                              bundle:nil];
    
    vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                       _paytype, @"paytype",
                       _paymoney, @"paymoney",
                       _shoucardno, @"shoucardno",
                       _shoucardmobile, @"shoucardmobile",
                       _shoucardman, @"shoucardman",
                       _shoucardbank, @"shoucardbank", nil];
    
    vc.CreditCardDelgate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
        case TableViewHistoricalAccountRowType:
        {
            cell.myHeaderLabel.text = @"选择历史账户";
            cell.myTextField.hidden = YES;
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            cell.myContentLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case TableViewCardNunberRowType:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"账户";
            cell.myTextField.hidden = NO;
            cell.myTextField.enabled = YES;
            cell.myTextField.tag = 0;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
            if ([_shoucardno length] <= 0)
            {
                cell.myTextField.placeholder = @"请刷卡或输入卡号";
            }
            else
            {
                cell.myTextField.text = _shoucardno;
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
        case TableViewCardBankRowType:
        {
            cell.myHeaderLabel.text = @"银行";
            cell.myTextField.hidden = YES;
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            [cell.myContentLabel setFrame:CGRectMake(100, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
            if ([_shoucardbank length] <= 0)
            {
                cell.myContentLabel.text = @"请选择银行";
            }
            else
            {
                cell.myContentLabel.text = _shoucardbank;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case TableViewCardNameRowType:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"姓名";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 1;
            if ([_shoucardman length] > 0)
            {
                cell.myTextField.text = _shoucardman;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入姓名";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case TableViewCardMobileRowType:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"手机";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 2;
            cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
            if ([_shoucardmobile length] > 0)
            {
                cell.myTextField.text = _shoucardmobile;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入手机";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case TableViewPayMoneyRowType:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"金额";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 3;
            cell.myTextField.delegate = self;
            cell.myTextField.keyboardType = UIKeyboardTypeDecimalPad;
            
            if ([_paymoney length] > 0)
            {
                cell.myTextField.text = _paymoney;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入金额";
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
        label.text = @"还款账户信息";
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
        if (TableViewHistoricalAccountRowType == row)
        {
              [self.view endEditing:YES];
            NLHistoricalAccountViewController *con = [[NLHistoricalAccountViewController alloc]initWithNibName:@"NLHistoricalAccountViewController" bundle:nil];
            con.myHistoryPayType = NLHistoryPayType_Creditcard;
            con.creditcardDelegate = self;
            [self.navigationController pushViewController:con animated:YES];
        }
        else if (TableViewCardBankRowType == row)
        {
              [self.view endEditing:YES];
            NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
            vc.payListBank = @"s";
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

-(void)doSelectedBtnClicked:(id)sender
{
//    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)sender;
//    _notifyReceiver = !_notifyReceiver;
//    if (_notifyReceiver)
//    {
//        [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"]
//                                      forState:UIControlStateNormal];
//    }
//    else
//    {
//        [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"]
//                                      forState:UIControlStateNormal];
//    }
    
    return;
}

#pragma mark - NLBankListDelegate
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state
{
    _shoucardbank = (NSString*)aObject;
    
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardBankRowType inSection:SWIPINGCARDIMAGESECTION]];
    
    if (cell)
    {
        cell.myContentLabel.text = _shoucardbank;
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

-(void)historyRecord
{
      [self.view endEditing:YES];
    NLCashArriveHistoryViewController* vc = [[NLCashArriveHistoryViewController alloc] initWithNibName:@"NLCashArriveHistoryViewController" bundle:nil] ;
    vc.myHistoryRecordType = NLHistoryRecordType_CreditCardPayments;
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)checkCreditCardMoneyInfo
{
    if (![NLUtils checkBankCard:_shoucardno])
    {
        [self showErrorInfo:@"输入正确的银行卡号" status:NLHUDState_Error];
        return NO;
    }
    if (_shoucardbank.length <= 0)
    {
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkMobilePhone:_shoucardmobile])
    {
        [self showErrorInfo:@"输入正确的手机号码" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkName:_shoucardman])
    {
        [self showErrorInfo:@"输入正确的姓名" status:NLHUDState_Error];
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
    return YES;
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

-(void)resetCardImage:(BOOL)enable
{
    if (enable == YES)
    {
        _enableCardImage = YES;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardNunberRowType inSection:SWIPINGCARDIMAGESECTION]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardNunberRowType inSection:SWIPINGCARDIMAGESECTION]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardNunberRowType inSection:SWIPINGCARDIMAGESECTION]];
        cell.myTextField.text = str;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL input = YES;
    int result = [NLUtils doTextFieldDelegate:textField
                shouldChangeCharactersInRange:range
                            replacementString:string];
    switch (result)
    {
        case 0:
        {
            input = YES;
        }
            break;
        case 1:
        {
            input = NO;
            [self showErrorInfo:@"只能保留二位小数" status:NLHUDState_Error];
        }
            break;
        case 2:
        {
            input = NO;
            [self showErrorInfo:@"第一位不能输入小数点" status:NLHUDState_Error];
        }
            break;
        case 3:
        {
            input = NO;
            [self showErrorInfo:@"不能大于八位数" status:NLHUDState_Error];
        }
            break;
        case 5:
        {
            input = NO;
            [self showErrorInfo:@"第一位不能为0" status:NLHUDState_Error];
        }
            break;
        case 6:
        {
            input = NO;
            [self showErrorInfo:@"粘贴数目第一位为0,请手动输入" status:NLHUDState_Error];
        }
            break;
        default:
            break;
    }
    
    return input;
}

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    return str;
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
    
    [self.myTableView reloadData];
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

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

-(void)updateValue:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank shoucardman:(NSString*)shoucardman shoucardmobile:(NSString*)shoucardmobile
{
    _shoucardbank = shoucardbank;
    _shoucardno = shoucardno;
    _shoucardmobile = shoucardmobile;
    _shoucardman = shoucardman;
    
    [self.myTableView reloadData];
}

@end
