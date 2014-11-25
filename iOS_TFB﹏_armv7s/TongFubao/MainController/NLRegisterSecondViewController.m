//
//  NLRegisterSecondViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-23.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLRegisterSecondViewController.h"
#import "NLRegisterViewController.h"
#import "NLInputUserInforViewController.h"
#import "NLPassWordManagerViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProtocolRequest.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLPlistOper.h"
#import "NLUtils.h"
#import "NewloginRestive.h"

#define MaxPhoneNum 8

@interface NLRegisterSecondViewController ()
{
    int _time;
    int _codeTime;
    NLProgressHUD* _hud;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myNextBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property(nonatomic, readwrite, retain) NSTimer *myTimer;
@property(nonatomic, readwrite, retain) NSTimer *myCodeTimer;


- (IBAction)onNextBtnClicked:(id)sender;

@end

@implementation NLRegisterSecondViewController

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
    self.navigationController.topViewController.title = @"填写验证码";
    [self addleftButtonItemWithTitle:@"取消" useEnabled:YES];
    [self startTimeoutTimer];
    _yzmTF.delegate= self;
//    _Laphone.text= _myPhoneNumber;
    
    /*随便吧 急着用 没封装*/
    NSString *phoneq1 = [_myPhoneNumber substringWithRange:NSMakeRange(0, 3)];
    NSString *phoneq2 = [_myPhoneNumber substringWithRange:NSMakeRange(3, 4)];
    NSString *phoneq3 = [_myPhoneNumber substringWithRange:NSMakeRange(7, 4)];
    NSString *phone= [NSString stringWithFormat:@"%@ %@ %@",phoneq1,phoneq2,phoneq3];
    _Laphone.text= phone;
    
    /*
    while (_myPhoneNumber.length > 0) {
        
        NSString *subString = [_myPhoneNumber substringToIndex:MIN(_myPhoneNumber.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4||subString.length == 9) {
            newString = [newString stringByAppendingString:@" "];
            NSLog(@"phoneStr 2 %@",newString);
        }
        _myPhoneNumber = [_myPhoneNumber substringFromIndex:MIN(_myPhoneNumber.length, 4)];
    }
   */

    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [self oneFingerTwoTaps];
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

-(void)getSmsCodeInfoNotify:(NSNotification*)notify
{
    [_hud hide:YES];
    NSString* name = [NLUtils getNameForRequest:Notify_getSmsCodeInfo];
    REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, name);
    
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        NLProtocolData* data = [response.data find:@"msgbody/smscode" index:0];
        self.myVerifyCode = data.value;
        
        [self showErrorInfo:@"验证码已经发出,注意查收短信" status:NLHUDState_NoError];
        [self startTimeoutTimer];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        self.myVerifyCode = @"*&^%$#@";//maybe no need
        
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)getSmsCodeNotify:(NSNotification*)notify
{
    {
        [_hud hide:YES];
        NSString* name = [NLUtils getNameForRequest:Notify_getSmsCode];
        REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, name);
        
        NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
        int error = response.errcode;
        
        if (RSP_NO_ERROR == error)
        {
            NLProtocolData* data = [response.data find:@"msgbody/smscode" index:0];
            self.myVerifyCode = data.value;
            
            [self showErrorInfo:@"验证码已经发出,注意查收短信" status:NLHUDState_NoError];
            [self startTimeoutTimer];
        }
        else if (error == RSP_TIMEOUT)
        {
            [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
            [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
            return;
        }
        else
        {
            self.myVerifyCode = @"*&^%$#@";//maybe no need
            
            NSString* detail = response.detail;
            if (!detail || detail.length <= 0)
            {
                detail = @"服务器繁忙，请稍候再试";
            }
            [self showErrorInfo:detail status:NLHUDState_Error];
        }
    }
}

-(void)getSmsCodeInfo
{
    if (self.myViewControllerType == TFBRegisterVCRegister)
    {
        NSString* name = [NLUtils getNameForRequest:Notify_getSmsCode];
        REGISTER_NOTIFY_OBSERVER(self, getSmsCodeNotify, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getSmsCode:self.myPhoneNumber];
    }
    else
    {
        NSString* name = [NLUtils getNameForRequest:Notify_getSmsCodeInfo];
        REGISTER_NOTIFY_OBSERVER(self, getSmsCodeInfoNotify, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getSmsCodeInfo:self.myPhoneNumber];
    }
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

- (IBAction)lostList:(id)sender {
    [self.view endEditing:YES];
    [_btnLost setTitleColor:RGBACOLOR(28, 179, 241, 1.0) forState:UIControlStateNormal];
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: nil
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"重新获取验证码", nil];
    
    menu.actionSheetStyle = UIActionSheetStyleDefault;
    [menu showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)leftItemClick:(id)sender
{
    [NLUtils showAlertView:nil
                   message:@"验证码短信可能略有延迟，确定返回并重新开始?"
                  delegate:self
                       tag:1
                 cancelBtn:@"等待"
                     other:@"返回",nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if (actionSheet.tag == 0) //Downright
    
    if (0 == buttonIndex)
    {
        [self startTimeoutTimer];
        NSString* name = [NLUtils getNameForRequest:Notify_getSmsCode];
        REGISTER_NOTIFY_OBSERVER(self, getSmsCodeNotify, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getSmsCode:self.myPhoneNumber];
    }
}

- (IBAction)onNextBtnClicked:(id)sender
{
    NSString* code = self.myVerifyCode;// [NLPlistOper readValue:TFBC_getSmsCode_smscode
                                       //path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
     /*
      NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    */
    NSString* theCode = _yzmTF.text;
    if ([code isEqualToString:theCode])
    {
        if (self.myViewControllerType == TFBRegisterVCRegister)
        {
           /* NLInputUserInforViewController* vc = [[NLInputUserInforViewController alloc] initWithNibName:@"NLInputUserInforViewController" bundle:nil];
            vc.myMobile = self.myPhoneNumber;
            [self.navigationController pushViewController:vc animated:YES];*/
            
            NewloginRestive *new= [[NewloginRestive alloc]initWithNibName:@"NewloginRestive" bundle:nil];
            new.PhoneStr= self.myPhoneNumber;
            [NLUtils presentModalViewController:self newViewController:new];
        }
        else
        {
            //忘记密码的
            NLPassWordManagerViewController* vc = [[NLPassWordManagerViewController alloc] initWithNibName:@"NLPassWordManagerViewController" bundle:nil];
            vc.myBackToLogon = YES;
            vc.myMobile = self.myPhoneNumber;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
       if ( ![_yzmTF.text isEqualToString: self.myVerifyCode] )
        {
            if (_yzmTF.text.length < self.myVerifyCode.length)
            {
                 [self showErrorInfo:@"请输入正确验证码" status:NLHUDState_Error];
            }
            else
            {
                 [self showErrorInfo:@"验证码不匹配" status:NLHUDState_Error];
            }
        }
    }
}

- (void)onReGetBtnClicked:(id)sender
{
    [self oneFingerTwoTaps];
    [self getSmsCodeInfo];
}

-(void)startMyCodeTimeoutTimer
{
	[self stopMyCodeTimeoutTimer];
    _codeTime = 300;
	self.myCodeTimer = [NSTimer scheduledTimerWithTimeInterval: 1//kTimeoutSeconds
                                                    target: self
                                                  selector: @selector(doAnimationForCode:)
                                                  userInfo: nil
                                                   repeats: YES];
}

#pragma timerOut
-(void)startTimeoutTimer
{
    [self stopTimeoutTimer];
    _time = 60;
	self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 1//kTimeoutSeconds
                                                    target: self
                                                  selector: @selector(doAnimationForCommand:)
                                                  userInfo: nil
                                                   repeats: YES];
}

-(void)stopMyCodeTimeoutTimer
{
	if (self.myCodeTimer != nil && [self.myCodeTimer isValid])
	{
		[self.myCodeTimer invalidate];
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
            if (_myNextBtn.enabled)
            {
                _myNextBtn.enabled = NO;
                _btnLost.enabled= NO;
            }
        }
            break;
        case NLReGetBtnState_EnableTitle:
        {
            [_btnLost setTitle:@"收不到验证码？" forState:UIControlStateNormal];
            
            if (!_btnLost.enabled)
            {
                _btnLost.enabled= YES;
                _btnLost.titleLabel.textColor= RGBACOLOR(28, 179, 241, 1.0);
            }
        }
            break;
        case NLReGetBtnState_DisableTitle:
        {
            _btnLost.titleLabel.text= title;
            [_btnLost setTitle:_btnLost.titleLabel.text forState:UIControlStateNormal];
            _btnLost.titleLabel.textColor= SACOLOR(219, 1.0);
            if (_btnLost.enabled)
            {
                _btnLost.enabled= NO;
            }
        }
            break;
        case NLReGetBtnState_Enable:
        {
            NSLog(@"NLReGetBtnState_Enable");
            
            if (!_btnLost.enabled)
            {
                _btnLost.enabled= YES;
               
            }
        }
            break;
        default:
            break;
    }
}

-(void)doAnimationForCode:(NSTimer *)timer
{
    _codeTime--;
    if (_codeTime <= 0)
    {
        [self stopMyCodeTimeoutTimer];
    }
}

-(void)doAnimationForCommand:(NSTimer *)timer
{
    _time--;
    if (_time <= 0)
    {
        [self stopTimeoutTimer];
        [self modifyReGetBtnStatus:NLReGetBtnState_EnableTitle title:@"重新获取"];
    }
    else
    {
        NSString* str = [NSString stringWithFormat:@"接收短信大约需要%d秒",_time];
        [self modifyReGetBtnStatus:NLReGetBtnState_DisableTitle title:str];
    }
}

#pragma mark - UITableViewDataSource

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
    cell.myTextField.hidden = NO;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"手机号码";
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            cell.myContentLabel.text = self.myPhoneNumber;
            cell.myTextField.hidden = YES;
            cell.mySelectedBtn.hidden = YES;
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.hidden = YES;
            cell.myContentLabel.hidden = YES;
            cell.myTextField.placeholder = @"输入验证码";
            cell.myTextField.font= [UIFont systemFontOfSize:17];
            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.myTextField setFrame:CGRectMake(10, cell.myTextField.frame.origin.y, 150, cell.myTextField.frame.size.height)];
            cell.myTextField.textAlignment = NSTextAlignmentCenter;
            cell.mySelectedBtn.hidden = NO;
            cell.mySelectedBtn.enabled = NO;
            [cell.mySelectedBtn addTarget:self action:@selector(onReGetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.mySelectedBtn setFrame:CGRectMake(160, 2, 130, 40)];
            [cell.mySelectedBtn setTitle:@"60秒后重新获取" forState:UIControlStateNormal];
            [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"otherButtonDefaultBack.png"] forState:UIControlStateNormal];
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
    rect.size.width = 270;
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.adjustsFontSizeToFitWidth = NO;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor blackColor];
    label.text = @"手机号码及验证码";
    [view addSubview:label];
    
    return view;
}

#pragma mark - keyboard hide event

/*长度控制*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if([[textField text] length] - range.length + string.length > MaxPhoneNum)
    {
        retValue=NO;
    }
    return retValue;
}

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self oneFingerTwoTaps];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
