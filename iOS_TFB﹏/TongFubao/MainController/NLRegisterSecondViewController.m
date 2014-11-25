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

typedef enum
{
    NLReGetBtnState_Disable = 0,
    NLReGetBtnState_Enable,
    NLReGetBtnState_EnableTitle,
    NLReGetBtnState_DisableTitle
} NLReGetBtnState;

@interface NLRegisterSecondViewController ()
{
    int _time;
    int _codeTime;
    NLProgressHUD* _hud;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myNextBtn;
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
    self.navigationController.topViewController.title = @"提交验证码";
    [self startTimeoutTimer];
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
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
            detail = @"请求失败，请检查网络";
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
                detail = @"请求失败，请检查网络";
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

- (IBAction)onNextBtnClicked:(id)sender
{
    NSString* code = self.myVerifyCode;// [NLPlistOper readValue:TFBC_getSmsCode_smscode
                                       //path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
     NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString* theCode = cell.myTextField.text;
    if ([code isEqualToString:theCode])
    {
        if (_codeTime <= 0)
        {
            [self showErrorInfo:@"验证码已过期，请重新获取验证码" status:NLHUDState_Error];
            return;
        }
        if (self.myViewControllerType == TFBRegisterVCRegister)
        {
           /* NLInputUserInforViewController* vc = [[NLInputUserInforViewController alloc] initWithNibName:@"NLInputUserInforViewController" bundle:nil];
            vc.myMobile = self.myPhoneNumber;
            [self.navigationController pushViewController:vc animated:YES];*/
            NewloginRestive *new= [[NewloginRestive alloc]initWithNibName:@"NewloginRestive" bundle:nil];
            new.PhoneStr= self.myPhoneNumber;
            [self presentModalViewController:new animated:YES];
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
        [self showErrorInfo:@"验证码不匹配" status:NLHUDState_Error];
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
    [self startMyCodeTimeoutTimer];
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
     NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    switch (status)
    {
        case NLReGetBtnState_Disable:
        {
            if (cell.mySelectedBtn.enabled)
            {
                cell.mySelectedBtn.enabled = NO;
            }
        }
            break;
        case NLReGetBtnState_Enable:
        {
            if (!cell.mySelectedBtn.enabled)
            {
                cell.mySelectedBtn.enabled = YES;
            }
        }
            break;
        case NLReGetBtnState_EnableTitle:
        {
            [cell.mySelectedBtn setTitle:title forState:UIControlStateNormal];
            if (!cell.mySelectedBtn.enabled)
            {
                cell.mySelectedBtn.enabled = YES;
            }
        }
            break;
        case NLReGetBtnState_DisableTitle:
        {
            [cell.mySelectedBtn setTitle:title forState:UIControlStateNormal];
            if (cell.mySelectedBtn.enabled)
            {
                cell.mySelectedBtn.enabled = NO;
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
        NSString* str = [NSString stringWithFormat:@"%d秒后重新获取",_time];
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
