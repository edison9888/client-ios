//
//  PaymentDf.m
//  TongFubao
//
//  Created by  俊   on 14-6-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PaymentDf.h"
#import "NLUtils.h"
#import "NLUserInforSettingsCell.h"
#import "BlockText.h"

@interface PaymentDf ()
{
    NSString    * _cardno;
    BOOL _enableCardImage;
    BOOL _enablePayCard;
    NLProgressHUD* _hud;
    NSString* _result;
    NSString* _fucardno;
    NSString* _fucardman;
    NSArray* _visaReaderArray;
    NSString* _payCardCheck;
    NSString* _paycardid;
    NSString* _resultPayCard;
    NSString* _fucardmobile;
    VisaReader* _visaReader;
    NSString *namestr;
    NSString *phonestr;
    
}
@end

@implementation PaymentDf

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    
    [self stopVisaReader];
    
    [super viewWillDisappear:animated];
}

/*
-(void)readAuthorInfoPeople
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAuthorInfo];
    REGISTER_NOTIFY_OBSERVER(self, readAuthorInfoPeopleNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAuthorInfo];
}

-(void)readAuthorInfoPeopleNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doreadAuthorInfoPeopleNotify:response];
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
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doreadAuthorInfoPeopleNotify:(NLProtocolResponse*)response
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
        
    }
}

*/

//初始化刷卡
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
-(void)initValue
{
    _cardno = @"";      //付款卡号
    _paycardid = @"";
    _paycardid = @"";
    _result = @"";
    _enablePayCard = YES;
    _enableCardImage = NO;
    _payCardCheck = @"";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVisaReader];
    [self initValue];
    [self phoneInTheMain];
}

- (void)phoneInTheMain{
    
    self.navigationController.topViewController.title = @"付款账户设定";
    
    self.view.backgroundColor= RGBACOLOR(241, 241, 241, 1);
    
    self.myTableView.scrollEnabled= NO;
    
    self.myTableView.userInteractionEnabled= YES;
    
    [self.view addSubview:self.myTableView];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
            cell.myTextField.enabled = NO;
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.myTextField setFrame:CGRectMake(cell.myTextField.frame.origin.x, cell.myTextField.frame.origin.y, 155, cell.myTextField.frame.size.height)];
            if ([_fucardno length] <= 0)
            {
                cell.myTextField.placeholder = @"刷卡获取卡号";
                NSLog(@"Cow _fucardno lenth %d",_fucardno.length);
            }
            else
            {
                cell.myTextField.text = _fucardno;
                NSLog(@"Cow _fucardno%@",_fucardno);
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
                cell.myTextField.placeholder = @"输入开户人姓名";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case 2:
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
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    rect.origin.x = 5;
    
    rect.origin.y = 5;
    
    rect.size.width = 300;
    
    rect.size.height = 20;
    
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    
    label.adjustsFontSizeToFitWidth = NO;
    
    label.backgroundColor=[UIColor clearColor];
    
    label.font=[UIFont systemFontOfSize:17];
    
    label.textColor = [UIColor lightGrayColor];
    
    if (0 == section)
    {
        label.text = @"默认收款银行账号信息绑定";
    }
    [view addSubview:label];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


//提示错误的
-(void)showErrorInfo:(NSString*)detail
{
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    if (detail)
    {
        _hud.detailsLabelText = detail;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
        _hud.mode = MBProgressHUDModeCustomView;
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
    }
    else
    {
        [_hud show:YES];
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

-(void)showMainView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
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

#pragma mark - oPayCardCheck
//验证刷卡器卡号的长度
-(BOOL)checkTransferInfo
{
    if (_cardno.length<=0)
    {
        [self showErrorInfo:@"亲，请插入通付宝刷卡器并刷卡" status:NLHUDState_Error];
        return NO;
    }
    return YES;
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
            _cardno = [_visaReaderArray objectAtIndex:0];
            _paycardid = [_visaReaderArray objectAtIndex:1];
            if (_paycardid.length >= 14)
            {
                _paycardid = [_paycardid substringToIndex:14];
                _paycardid = [_paycardid lowercaseString];
            }
            _payCardCheck = _paycardid;
            
            [self resetCardNumber:_cardno];
            
            [self payCardCheck];
        }
    }
}

-(void)payCardCheck
{
    NSString* name = [NLUtils getNameForRequest:Notify_payCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, payCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payCardCheck:_payCardCheck];
    [self showErrorInfo:@"正在验证刷卡器" status:NLHUDState_None];
}


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

-(BOOL)checkData
{
    BOOL check = YES;
    
    check = [NLUtils checkMobilePhone:phonestr];
    if (!check)
    {
        [self showErrorInfo:@"请输入正确的手机号码"];
        return check;
    }
    
    if (namestr.length<1)
    {
        [self showErrorInfo:@"请填写正确的收货人"];
        check = NO;
        return check;
    }
    return check;
}

- (IBAction)NextBtn:(id)sender {
    if ([self checkData]==YES) {
        NSLog(@"跳转");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end