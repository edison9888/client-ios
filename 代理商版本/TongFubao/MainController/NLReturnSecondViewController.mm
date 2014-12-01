//
//  NLReturnSecondViewController.m
//  TongFubao
//
//  Created by MD313 on 13-10-10.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLReturnSecondViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "NLKeyboardAvoid.h"
#import "GTMBase64.h"
#import "UPPayPlugin.h"
#import "NLTransferResultViewController.h"

@interface NLReturnSecondViewController ()
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
    
    BOOL _enablePayCard;
    NSString* _resultPayCard;
    BOOL _enableCardImage;
    NLProgressHUD* _hud;
    VisaReader* _visaReader;
    NSArray* _visaReaderArray;
}

@end

@implementation NLReturnSecondViewController

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
    self.navigationController.topViewController.title = @"刷卡";
    [self initValue];
    [self initVisaReader];
    
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

-(IBAction)onButtonBtnClicked:(id)sender
{
    if ([self checkInfo])
    {
        [self RepayMoneyRq];
    }
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
            cell.myHeaderLabel.text = @"收款账户";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 0;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
            if ([_fucardno length] <= 0)
            {
                cell.myTextField.placeholder = @"可手动输入卡号";
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
            cell.myHeaderLabel.text = @"选择银行";
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
            cell.myHeaderLabel.text = @"开户人姓名";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 1;
            if ([_fucardman length] > 0)
            {
                cell.myTextField.text = _fucardman;
            }
            else
            {
                cell.myTextField.placeholder = @"输入开户人姓名_second";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case 3:
        {
            cell.myContentLabel.hidden = YES;
            cell.myHeaderLabel.text = @"手机号码";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 2;
            cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
            if ([_fucardmobile length] > 0)
            {
                cell.myTextField.text = _fucardmobile;
            }
            else
            {
                cell.myTextField.placeholder = @"输入手机号码_second";
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
    rect.size.height = 20;
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.adjustsFontSizeToFitWidth = NO;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor blackColor];
    if (0 == section)
    {
        label.text = @"付款银行账号信息";
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
         withState:(int)state
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
    }
}

-(void)showErrorInfo:(NSString *)detail status:(NLHUDState)status
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
        _fucardno = [_visaReaderArray objectAtIndex:0];
        _paycardid = [_visaReaderArray objectAtIndex:1];
        if (_paycardid.length >= 14)
        {
            _paycardid = [_paycardid substringToIndex:14];
            _paycardid = [_paycardid lowercaseString];
        }
        _payCardCheck = _paycardid;
        [self resetCardNumber:_fucardno];
        [self payCardCheck];
        }
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
    [self showErrorInfo:nil status:NLHUDState_None];
}

-(void)doRepayMoneyRqNotify:(NLProtocolResponse*)response
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

-(void)RepayMoneyRqNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;

    if (RSP_NO_ERROR == error)
    {
        [self doRepayMoneyRqNotify:response];
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

-(void)RepayMoneyRq
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_RepayMoneyRq];
    REGISTER_NOTIFY_OBSERVER(self, RepayMoneyRqNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] RepayMoneyRq:_paycardid
                                                          fucardno:_fucardno
                                                      fucardmobile:_fucardmobile
                                                         fucardman:_fucardman
                                                        fucardbank:_fucardbank
                                                        shoucardno:[self.myDictionary objectForKey:@"shoucardno"]
                                                    shoucardmobile:[self.myDictionary objectForKey:@"shoucardmobile"]
                                                       shoucardman:[self.myDictionary objectForKey:@"shoucardman"]
                                                      shoucardbank:[self.myDictionary objectForKey:@"shoucardbank"]
                                                           current:_current
                                                          paymoney:[self.myDictionary objectForKey:@"paymoney"]
                                                            payfee:[self.myDictionary objectForKey:@"payfee"]
                                                             money:[self.myDictionary objectForKey:@"money"]];
}

-(void)doInsertRepayMoneyNotify:(NLProtocolResponse*)response
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

-(void)insertRepayMoneyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;

    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doInsertRepayMoneyNotify:response];
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
//        if ([detail isEqualToString:@"支付失败!"])
//        {
//            [self performSelector:@selector(showMainView) withObject:nil afterDelay:2.0f];
//            
//        }
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)insertRepayMoney
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_insertRepayMoney];
    REGISTER_NOTIFY_OBSERVER(self, insertRepayMoneyNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] insertRepayMoney:_bkntno result:_result];
}


-(BOOL)checkInfo
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
    [self insertRepayMoney];
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
    vc.myNavigationTitle = @"还贷款结果";
    vc.myTitle = @"还贷款成功";
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
//    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"信用卡银行",@"header", _fucardbank,@"content", nil];
//    [arr addObject:dic];
    
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
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [self.myDictionary objectForKey:@"paymoney"],@"content", nil];
    [arr addObject:dic];
    vc.myArray = [NSArray arrayWithArray:arr];
    
}

-(void)showMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
