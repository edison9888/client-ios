//
//  NLReturnLoanViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLReturnLoanViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "NLUtils.h"
#import "NLProtocolRegister.h"
#import "NLCashArriveHistoryViewController.h"
#import "NLReturnSecondViewController.h"
#import "NLHistoricalAccountViewController.h"

typedef enum
{
    TableViewHistoricalAccountRowType = 0,
    TableViewCardBankRowType,
    TableViewCardNunberRowType,
    TableViewReCardNumberRowType,
    TableViewCardNameRowType,
    TableViewCardMobileRowType,
    TableViewPayMoneyRowType,
    TableViewPayFeeRowType
} ReturnLoanTableViewRowType;

@interface NLReturnLoanViewController ()
{
    NLProgressHUD* _hud;
    
    NSString* _bankid;
    NSString* _paycardid;
    NSString* _shoucardno;
    NSString* _shoucardmobile;
    NSString* _shoucardman;
    NSString* _shoucardbank;
    NSString* _current;
    NSString* _paymoney;
    NSString* _payfee;
    NSString* _money;
    NSString* _reshoucardno;
    NSString* _bkntno;
    NSString* _message;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;

- (IBAction)onNextBtnClicked:(id)sender;

@end

@implementation NLReturnLoanViewController

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
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

-(void)initValue
{
    _bankid = @"";
    _paycardid = @"";
    _shoucardno = @"";
    _shoucardmobile = @"";
    _shoucardman = @"";
    _shoucardbank = @"";
    _current = @"RMB";
    _paymoney = @"";
    _payfee = @"";
    _money = @"";
    _reshoucardno = @"";
    _bkntno = @"";
    _message = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"还贷款";
    [self initValue];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"历史记录"
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)historyRecord
{
    NLCashArriveHistoryViewController* vc = [[NLCashArriveHistoryViewController alloc] initWithNibName:@"NLCashArriveHistoryViewController" bundle:nil] ;
    vc.myHistoryRecordType = NLHistoryRecordType_ReturnLoan;
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)checkReturnLoanInfo
{
    if (_shoucardbank.length <= 0)
    {
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkBankCard:_shoucardno])
    {
        [self showErrorInfo:@"请正确的银行卡号" status:NLHUDState_Error];
        return NO;
    }
    if (![_shoucardno isEqualToString:_reshoucardno])
    {
        [self showErrorInfo:@"二次输入的卡号不同" status:NLHUDState_Error];
        return NO;
    }
    
    if (![NLUtils checkName:_shoucardman])
    {
        [self showErrorInfo:@"输入正确姓名" status:NLHUDState_Error];
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
    
    if (_payfee.length <= 0)
    {
        [self showErrorInfo:@"请点击获取手续费" status:NLHUDState_Error];
        return NO;
    }
    if (![_money isEqualToString:[NSString stringWithFormat:@"%.2f",(float)([_payfee floatValue]+[_paymoney floatValue])]])
    {
        [self showErrorInfo:@"已修改还款金额，请重新计算手续费" status:NLHUDState_Error];
        return NO;
    }
    
    return YES;
}

- (IBAction)onNextBtnClicked:(id)sender
{
    if ([self checkReturnLoanInfo])
    {
        NLReturnSecondViewController *vc = [[NLReturnSecondViewController alloc] initWithNibName:@"NLReturnSecondViewController" bundle:nil];
        vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:_shoucardman,@"shoucardman",_shoucardmobile,@"shoucardmobile",_money,@"money",_payfee,@"payfee",_paymoney,@"paymoney",_shoucardbank,@"shoucardbank",_shoucardno,@"shoucardno", nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://银行卡号
        {
            _shoucardno = textField.text;
        }
            break;
        case 1://再次输入银行卡号
        {
            _reshoucardno = textField.text;
        }
            break;
        case 2://开户人姓名
        {
            _shoucardman = textField.text;
        }
            break;
            
        case 3://手机号码
        {
            _shoucardmobile = textField.text;
        }
            break;
            
        case 4://还款金额
        {
            _paymoney = textField.text;
        }
            break;

        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

#ifdef IOS_7

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}

#endif

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
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
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    switch (indexPath.row)
    {
        case TableViewHistoricalAccountRowType:
        {
            cell.myHeaderLabel.text = @"选择历史账户";
            cell.myContentLabel.hidden = NO;
            [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 185, cell.myContentLabel.frame.size.height)];
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            cell.myContentLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case TableViewCardBankRowType:
        {
            cell.myHeaderLabel.text = @"选择收款银行";
            cell.myContentLabel.hidden = NO;
            [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 185, cell.myContentLabel.frame.size.height)];
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            if (_shoucardbank.length <= 0)
            {
                cell.myContentLabel.text = @"点击选择银行";
            }
            else
            {
                cell.myContentLabel.text = _shoucardbank;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case TableViewCardNunberRowType:
        {
            cell.myHeaderLabel.text = @"还贷银行卡号";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(110, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            cell.myTextField.tag = 0;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            if (_shoucardno.length > 0)
            {
                cell.myTextField.text = _shoucardno;
            }
            else
            {
                cell.myTextField.placeholder = @"输入银行卡号";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case TableViewReCardNumberRowType:
        {
            cell.myHeaderLabel.text = @"再次输入卡号";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(110, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            cell.myTextField.tag = 1;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            if (_reshoucardno.length > 0)
            {
                cell.myTextField.text = _reshoucardno;
            }
            else
            {
                cell.myTextField.placeholder = @"再次输入银行卡号";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case TableViewCardNameRowType:
        {
            cell.myHeaderLabel.text = @"开户人姓名";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(110, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            cell.myTextField.tag = 2;
            if (_shoucardman.length > 0)
            {
                cell.myTextField.text = _shoucardman;
            }
            else
            {
                cell.myTextField.placeholder = @"输入开户人姓名";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case TableViewCardMobileRowType:
        {
            cell.myHeaderLabel.text = @"手机号码";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(110, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            cell.myTextField.tag = 3;
            cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
            if (_shoucardmobile.length > 0)
            {
                cell.myTextField.text = _shoucardmobile;
            }
            else
            {
                cell.myTextField.placeholder = @"输入手机号码";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case TableViewPayMoneyRowType:
        {
            cell.myHeaderLabel.text = @"还款金额";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(110, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            cell.myTextField.tag = 4;
            cell.myTextField.delegate = self;
            cell.myTextField.keyboardType = UIKeyboardTypeDecimalPad;
            if (_paymoney.length > 0)
            {
                cell.myTextField.text = _paymoney;
            }
            else
            {
                cell.myTextField.placeholder = @"输入还款金额";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case TableViewPayFeeRowType:
        {
            cell.myHeaderLabel.text = @"手续费";
            [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 185, cell.myContentLabel.frame.size.height)];
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            if (_payfee.length > 0)
            {
                cell.myContentLabel.text = _payfee;
            }
            else
            {
                cell.myContentLabel.text = @"点击获取手续费";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the root controller
    
    int row = indexPath.row;
    if (TableViewHistoricalAccountRowType == row)
    {
        NLHistoricalAccountViewController *con = [[NLHistoricalAccountViewController alloc]initWithNibName:@"NLHistoricalAccountViewController" bundle:nil];
        con.myHistoryPayType = NLHistoryPayType_Repay;
        con.repayDelegate = self;
        [self.navigationController pushViewController:con animated:YES];
    }
    else if (TableViewCardBankRowType  == row)
    {
        NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (TableViewPayFeeRowType == row)
    {
        if ([self isGetTransferPayfee])
        {
            [self getRepayMoneyPayfee];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark NLBankLisDelegate

- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(int)state
{
    _shoucardbank = (NSString*)aObject;
    _bankid = [NSString stringWithFormat:@"%d",state];
    
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCardBankRowType inSection:0]];
    if (cell)
    {
        cell.myContentLabel.text = _shoucardbank;
    }
    if ([self isGetTransferPayfee])
    {
        [self getRepayMoneyPayfee];
    }
}

- (void)dataSearchDidCanceled:(NLBankListViewController *)controller
                    withState:(int)state
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
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

-(void)resetPayfeeCell:(NSString*)str
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewPayMoneyRowType inSection:0]];
    cell.myTextField.text = str;
}

-(BOOL)isGetTransferPayfee
{
    if (_paymoney.length <= 0)
    {
        [self resetPayfeeCell:@""];
        return NO;
    }
    if (_bankid.length <= 0)
    {
        [self showErrorInfo:@"请选择银行" status:NLHUDState_Error];
        return NO;
    }
    return YES;
}

#pragma mark - http request

-(void)doGetRepayMoneyPayfeeNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/payfee" index:0];
    _payfee = data.value;
    _money = [NSString stringWithFormat:@"%.2f",(float)([_payfee floatValue]+[_paymoney floatValue])];
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewPayFeeRowType inSection:0]];
    cell.myContentLabel.text = _payfee;
}

-(void)getRepayMoneyPayfeeNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doGetRepayMoneyPayfeeNotify:response];
        [_hud hide:YES];
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)getRepayMoneyPayfee
{
    [self showErrorInfo:@"正在获取手续费" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_getRepayMoneyPayfee];
    REGISTER_NOTIFY_OBSERVER(self, getRepayMoneyPayfeeNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getRepayMoneyPayfee:_bankid money:_paymoney];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
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
        default:
            break;
    }
    
    return input;
}

-(void)updateValue:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank shoucardman:(NSString*)shoucardman shoucardmobile:(NSString*)shoucardmobile bankid:(NSString*)bankid
{
    _shoucardbank = shoucardbank;
    _shoucardno = shoucardno;
    _reshoucardno = shoucardno;
    _shoucardmobile = shoucardmobile;
    _shoucardman = shoucardman;
    _bankid = bankid;
    [self.myTableView reloadData];
}

@end
