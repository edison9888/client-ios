//
//  NLBalanceQueryViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLBalanceQueryViewController.h"
#import "NLUtils.h"
#import "NLKeyboardAvoid.h"
#import "NLUserInforSettingsCell.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"

@interface NLBalanceQueryViewController ()
{
    BOOL _enableCardImage;
    NLProgressHUD* _hud;
    VisaReader* _visaReader;
    NSArray* _visaReaderArray;
    NSString* _payCardCheck;
    
    BOOL _enablePayCard;
    NSString* _resultPayCard;
    NSString* _bankcardno;
    NSString* _bankid;
    NSString* _bankname;
    NSString* _paycardid;
    NSString* _smsmsg;
    NSString* _smsphone;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UIView* myView;
@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingScrollView* myScrolView;
@property(nonatomic,retain) IBOutlet UIButton* myGetBtn;
@property(nonatomic,retain) IBOutlet UIButton* mySendBtn;
@property(nonatomic,retain) IBOutlet UITextField* myTextField;

- (IBAction)onGetBtnClicked:(id)sender;
- (IBAction)onSendBtnClicked:(id)sender;

@end

@implementation NLBalanceQueryViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"余额查询";
    [self initValue];
    [self initVisaReader];
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

-(void)initValue
{
    _bankcardno = @"";
    _bankid = @"";
    _bankname = @"";
    _paycardid = @"";
    _smsmsg = @"";
    _smsphone = @"";
    _enableCardImage = NO;
    _enablePayCard = YES;
    _resultPayCard = @"";
    _payCardCheck = @"";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)checkInfor
{
    if (_bankname.length <= 0)
    {
        [self showErrorInfo:@"输入选择银行" status:NLHUDState_Error];
        return NO;
    }
    if (![NLUtils checkBankCard:_bankcardno])
    {
        [self showErrorInfo:@"输入正确银行卡号" status:NLHUDState_Error];
        return NO;
    }
    return YES;
}

- (IBAction)onGetBtnClicked:(id)sender
{
    if (!_enablePayCard)
    {
        [self showErrorInfo:_resultPayCard status:NLHUDState_Error];
        return;
    }
    if ([self checkInfor])
    {
        [self readQueryCardMoney];
    }
}

- (IBAction)onSendBtnClicked:(id)sender
{
    [NLUtils sendSms:_smsmsg
           telephone:[NSArray arrayWithObjects:_smsphone, nil]
          controller:self
            delegate:self];
}

-(void)showView
{
    if (_smsphone.length > 0 && _smsmsg.length > 0)
    {
        self.myView.hidden = NO;
        self.myTextField.text = _smsmsg;
    }
    else
    {
        self.myView.hidden = YES;
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://银行卡号
        {
            _bankcardno = textField.text;
        }
            break;
        default:
            break;
    }
}

#pragma mark http request
-(void)doPayCardCheckNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString* result = data.value;
    [self showErrorInfo:result status:NLHUDState_NoError];
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
    NSString* name = [NLUtils getNameForRequest:Notify_payCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payCardCheck:_payCardCheck];
    [self showErrorInfo:@"正在验证刷卡器" status:NLHUDState_None];
}

-(void)doReadQueryCardMoneyNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/smsmsg" index:0];
    _smsmsg = data.value;
    data = [response.data find:@"msgbody/smsphone" index:0];
    _smsphone = data.value;
    [self showView];
}

-(void)readQueryCardMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadQueryCardMoneyNotify:response];
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

-(void)readQueryCardMoney
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_readQueryCardMoney];
    REGISTER_NOTIFY_OBSERVER(self, readQueryCardMoneyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readQueryCardMoney:_bankcardno
                                                                  bankid:_bankid
                                                                bankname:_bankname];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    //    [controller dismissModalViewControllerAnimated:YES];
    //    [[controller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    //    [self.navigationController popToViewController:controller animated:YES];
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
            _bankcardno = [_visaReaderArray objectAtIndex:0];
            _paycardid = [_visaReaderArray objectAtIndex:1];
            if (_paycardid.length >= 14)
            {
                _paycardid = [_paycardid substringToIndex:14];
                _paycardid = [_paycardid lowercaseString];
            }
            _payCardCheck = _paycardid;
            [self resetCardNumber:_bankcardno];
            [self payCardCheck];
        }
    }
}

-(void)resetCardImage:(BOOL)enable
{
    if (enable == YES)
    {
        _enableCardImage = YES;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)resetCardNumber:(NSString*)str
{
    if (str.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.myTextField.text = str;
    }
}

#pragma mark - DataSearchDelegate

- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(int)state
{
    _bankname = (NSString*)aObject;
    _bankid = [NSString stringWithFormat:@"%d",state];
    
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell)
    {
        cell.myContentLabel.text = _bankname;
    }
}

- (void)dataSearchDidCanceled:(NLBankListViewController *)controller
                    withState:(int)state
{
    //[controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
            cell.myHeaderLabel.text = @"选择银行";
            cell.myTextField.hidden = YES;
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            if ([_bankname length] <= 0)
            {
                cell.myContentLabel.text = @"点击选择";
            }
            else
            {
                cell.myContentLabel.text = _bankname;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"收款账户";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 0;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
            if ([_bankcardno length] <= 0)
            {
                cell.myTextField.placeholder = @"可手动输入卡号";
            }
            else
            {
                cell.myTextField.text = _bankcardno;
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
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    if (0 == section)
    {
        int row = indexPath.row;
        if (0 == row)
        {
            NLBankListViewController *vc = [[NLBankListViewController alloc] initWithNibName:@"NLBankListViewController" bundle:nil];
            vc.delegate = self;
            vc.myActivemobilesms = @"1";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ProgressHUD
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

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
