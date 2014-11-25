//
//  NLMyBankCardEditViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLMyBankCardEditViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "NLUtils.h"
#import "NLProtocolRegister.h"
#import "NLCashArriveHistoryViewController.h"
#import "NLReturnSecondViewController.h"

@interface NLMyBankCardEditViewController ()
{
    NLProgressHUD* _hud;
    
    NSString* _shoucardbank;
    NSString* _shoucardno;
    NSString* _shoucardman;
    NSString* _shoucardmobile;
    
//    NSString* _payCardCheck;
//    BOOL _enablePayCard;
//    NSString* _resultPayCard;
//    BOOL _enableCardImage;
//    VisaReader* _visaReader;
//    NSArray* _visaReaderArray;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;

- (IBAction)onNextBtnClicked:(id)sender;

@end

@implementation NLMyBankCardEditViewController
@synthesize delegate;

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
//    if (_visaReader.myDelegate != self)
//    {
//        _visaReader = [VisaReader initWithDelegate:self];
//    }
//    [self startVisaReader];
    [super viewDidAppear:animated];
    if (animated)
    {
        [self.myTableView flashScrollIndicators];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
//    if (_visaReader.myDelegate == self)
//    {
//        [self stopVisaReader];
//    }
    [super viewWillDisappear:animated];
}

-(void)initValue
{
//    _shoucardbank = @"";
//    _shoucardno = @"";
//    _shoucardman = @"";
//    _shoucardmobile = @"";
//    _enableCardImage = NO;
//    _payCardCheck = @"";
//    _enablePayCard = YES;
//    _resultPayCard = @"";
}

-(void)setInitValue:(NSString*)bank no:(NSString*)no man:(NSString*)man mobile:(NSString*)mobile
{
    _shoucardbank = bank;
    _shoucardno = no;
    _shoucardman = man;
    _shoucardmobile = mobile;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"编辑我的银行卡";
//    [self initValue];
//    [self initVisaReader];

    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

//-(void)initVisaReader
//{
//    //_visaReader = [[VisaReader alloc] initWithDelegate:self];
//    _visaReader = [VisaReader initWithDelegate:self];
//    [_visaReader createVisaReader];
//}
//
//-(void)startVisaReader
//{
//    if (_visaReader)
//    {
//        [_visaReader resetVisaReader:YES];
//    }
//}
//
//-(void)stopVisaReader
//{
//    if (_visaReader)
//    {
//        [_visaReader resetVisaReader:NO];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self showErrorInfo:@"请输入正确的银行卡号" status:NLHUDState_Error];
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
    
    return YES;
}

- (IBAction)onNextBtnClicked:(id)sender
{
    if ([self checkReturnLoanInfo])
    {
//        if (_visaReader.myDelegate == self)
//        {
//            [self stopVisaReader];
//        }
        [self modifyAuBkCardInfo];
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1://银行卡号
        {
            _shoucardno = textField.text;
        }
            break;
            
        case 2://开户人
        {
            _shoucardman = textField.text;
        }
            break;
            
        case 3://手机号码
        {
            _shoucardmobile = textField.text;
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
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"开户银行";
            cell.myContentLabel.hidden = NO;
            [cell.myContentLabel setFrame:CGRectMake(100, cell.myContentLabel.frame.origin.y, 185, cell.myContentLabel.frame.size.height)];
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
            
        case 1:
        {
            cell.myHeaderLabel.text = @"银行卡号";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            if (_shoucardno && _shoucardno.length > 0)
            {
                cell.myTextField.text = _shoucardno;
            }
            else
            {
                cell.myTextField.placeholder = @"可手动输入银行卡号";
            }
            cell.myTextField.tag = 1;
//            cell.myUprightImage.hidden = NO;
//            [cell.myUprightImage setFrame:CGRectMake(260, 7, 30, 30)];
//            if (_enableCardImage)
//            {
//                cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
//            }
//            else
//            {
//                cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
//            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case 2:
        {
            cell.myHeaderLabel.text = @"开户人";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            if (_shoucardman && _shoucardman.length > 0)
            {
                cell.myTextField.text = _shoucardman;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入开户人姓名";
            }
            cell.myTextField.tag = 2;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case 3:
        {
            cell.myHeaderLabel.text = @"手机号码";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            if (_shoucardmobile && _shoucardmobile.length > 0)
            {
                cell.myTextField.text = _shoucardmobile;
            }
            else
            {
                cell.myTextField.placeholder = @"请输入银行预留手机号码";
            }
            cell.myTextField.tag = 3;
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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the root controller
    
    int row = indexPath.row;
    if (0 == row)
    {
        NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



//#pragma mark - VisaReaderDelegate
//
//-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString*)object
//{
//    //NSLog(@"event = %d,object = %@",event,object);
//    if (SRS_DeviceAvailable == event && [object isEqualToString:@"0"])
//    {
//        [self resetCardImage:YES];
////        [_visaReader loadWakingUp];
////        [_visaReader wakeUp];
////        [self startVisaReader];
//    }
//    else if (SRS_DeviceUnavailable == event)
//    {
//        [self resetCardImage:NO];
//    }
//    else if(SRS_Unknown == event)
//    {
//        [self stopVisaReader];
//        [self startVisaReader];
////        [self showErrorInfo:@"刷卡失败，请拔出刷卡器后重新操作" status:NLHUDState_Error];
//    }
//    else if (SRS_OK == event)
//    {
//        [self doSRS_OK:object];
//    }
//}
//
//-(void)doSRS_OK:(NSString*)str
//{
//    _visaReaderArray = [str componentsSeparatedByString:@"***@@@$$$"];
//    if (_visaReaderArray.count >= 3)
//    {
//        NSString *str = [_visaReaderArray objectAtIndex:0];
//        if ([str isEqualToString:@""])
//        {
//            return;
//        }
//        if ([[str substringToIndex:2] intValue] >0)
//        {
//            _shoucardno = str;
//            if (_shoucardno.length > 0)
//            {
//                _payCardCheck = [_visaReaderArray objectAtIndex:1];
//                if (_payCardCheck.length >= 14)
//                {
//                    _payCardCheck = [_payCardCheck substringToIndex:14];
//                    _payCardCheck = [_payCardCheck lowercaseString];
//                }
//                [self resetCardNumber:_shoucardno];
//                [self payCardCheck];
//            }
//        }
//        else
//        {
//            
//        }
//    }
//}
//
//-(void)resetCardImage:(BOOL)enable
//{
//    if (enable == YES)
//    {
//        _enableCardImage = YES;
//        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
//    }
//    else
//    {
//        _enableCardImage = NO;
//        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
//    }
//}
//
//-(void)resetCardNumber:(NSString*)str
//{
//    if (str.length > 0)
//    {
//        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//        cell.myTextField.text = str;
//    }
//}

#pragma mark NLBankLisDelegate

- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(int)state
{
    _shoucardbank = (NSString*)aObject;
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell)
    {
        cell.myContentLabel.text = _shoucardbank;
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

#pragma mark - http request

-(void)doModifyAuBkCardInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
    NSString* message = data.value;
    [self showErrorInfo:message status:NLHUDState_NoError];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0f];
    self.delegate.isChanged = YES;
}

-(void)modifyAuBkCardInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doModifyAuBkCardInfoNotify:response];
//        [_hud hide:YES];
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
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)modifyAuBkCardInfo
{
    [self showErrorInfo:@"正在提交信息" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_modifyAuBkCardInfo];
    REGISTER_NOTIFY_OBSERVER(self, modifyAuBkCardInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] modifyAuBkCardInfo:_shoucardman aushoucardphone:_shoucardmobile aushoucardno:_shoucardno aushoucardbank:_shoucardbank];
}

-(void)doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

//判断数字输入错误的集合
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

//-(void)doPayCardCheckNotify:(NLProtocolResponse*)response
//{
//    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
//    NSString* result = data.value;
//    [self showErrorInfo:result status:NLHUDState_NoError];
//}
//
//-(void)payCardCheckNotify:(NSNotification*)notify
//{
//    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
//    NSString* detail = response.detail;
//    int error = response.errcode;
//    if (error == RSP_NO_ERROR)
//    {
//        _enablePayCard = YES;
//        [self doPayCardCheckNotify:response];
//    }
//    else if (error == RSP_TIMEOUT)
//    {
//        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
//        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
//        return;
//    }
//    else
//    {
//        _enablePayCard = NO;
//        _resultPayCard = detail;
//        [self showErrorInfo:detail status:NLHUDState_Error];
//    }
//}
//
//-(void)payCardCheck
//{
//    NSString* name = [NLUtils getNameForRequest:Notify_payCardCheck];
//    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
//    [[[NLProtocolRequest alloc] initWithRegister:YES] payCardCheck:_payCardCheck];
//    [self showErrorInfo:@"正在验证刷卡器" status:NLHUDState_None];
//}

@end
