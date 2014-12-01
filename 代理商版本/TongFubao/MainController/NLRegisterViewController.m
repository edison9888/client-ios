//
//  NLRegisterViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLRegisterViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLRegisterSecondViewController.h"
#import "NLProtocolRequest.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"
#import "SecretText.h"

#define MaxPhoneNum 11

@interface NLRegisterViewController ()
{
    NSString     * _mobile;
    NLProgressHUD* _hud;
    NSString     *phoneStr;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UITextField* myPhoneNumberTextField;
@property(nonatomic,retain) IBOutlet UITextField* myVerifyTextField;
@property(nonatomic,retain) IBOutlet UILabel* myVerifyLable1;
@property(nonatomic,retain) IBOutlet UILabel* myVerifyLable2;
@property(nonatomic,retain) IBOutlet UILabel* myVerifyLable3;
@property(nonatomic,retain) IBOutlet UILabel* myVerifyLable4;
@property(nonatomic,retain) IBOutlet UIButton* myGetVerifyBtn;
@property(nonatomic,retain) IBOutlet UIButton* myRandomBtn;
@property(nonatomic,retain) IBOutlet UIView* myVerifyView;

- (IBAction)onGetVerifyBtnClicked:(id)sender;
- (IBAction)onRandomBtnClicked:(id)sender;

-(void)oneFingerTwoTaps;
-(BOOL)verificationCheck:(NSString*)verification;
-(void)updateVerification;
-(float)huDuFromdu:(float)du;
-(void)tiltUI:(UILabel*)UI;
-(int)getRotation;

@end

@implementation NLRegisterViewController
/*外包的注册 就懒得吐槽了*/
@synthesize myTableView;
@synthesize myGetVerifyBtn;
@synthesize myRandomBtn;
@synthesize myPhoneNumberTextField;
@synthesize myVerifyLable1;
@synthesize myVerifyLable2;
@synthesize myVerifyLable3;
@synthesize myVerifyLable4;
@synthesize myVerifyTextField;
@synthesize myVerifyView;
@synthesize myViewControllerType;

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
    [self setMain];
}

-(void)setMain{
    
    self.UserBool = YES;
    phoneStr= @"";
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
 
    if (TFBRegisterVCRegister == self.myViewControllerType)
    {
        self.navigationController.topViewController.title = @"注册";
        self.myVerifyView.hidden = YES;
        [self.myGetVerifyBtn setFrame:CGRectMake(self.myGetVerifyBtn.frame.origin.x, self.myGetVerifyBtn.frame.origin.y-90, self.myGetVerifyBtn.frame.size.width, self.myGetVerifyBtn.frame.size.height)];
    }
    else
    {
        self.navigationController.topViewController.title = @"找回密码";
        [self updateVerification];
    }
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    //[txt resignFirstResponder];
}

-(void)showErrorInfo:(NSString*)detail
{
    [self oneFingerTwoTaps];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    if (detail)
    {
        _hud.detailsLabelText = detail;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
        _hud.mode = MBProgressHUDModeCustomView;
        [_hud show:YES];
        [_hud hide:YES afterDelay:2];
    }
    else
    {
        [_hud show:YES];
    }
    return;
}

//密保找回密码
-(void)getGuardUserNotifity:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self dogetGuardUserNotify:response];
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

-(void)dogetGuardUserNotify:(NLProtocolResponse*)response
{
    
    NLProtocolResponse * pushResponse= response;
    
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
        [NLUtils setRegisterMobile:phoneStr];
        //密保问题找回
        SecretText *sec= [[SecretText alloc]init];
        sec.pushResponse= pushResponse;
        sec.UserBool = YES;
        [self.navigationController pushViewController:sec animated:YES];
    }
}

//判断注册还是找回密码的
-(void)getSmsCode
{
    //找回密码的
    if (TFBRegisterVCFind == self.myViewControllerType)
    {
        NSString* name = [NLUtils getNameForRequest:Notify_ApiSafeGuardLoginUp];
        REGISTER_NOTIFY_OBSERVER(self, getGuardUserNotifity, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getApiSafeGuardLoginUp:_mobile];
    }
    else
    {
        [NLUtils showAlertView:@"确认手机号码"
                       message:[NSString stringWithFormat:@"我们将发送验证码短信到这个号码：%@", _mobile]
                      delegate:self
                           tag:1
                     cancelBtn:@"取消"
                         other:@"好",nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [_hud hide:YES];
    if (1 == buttonIndex)
    {
        /*注册的 发送验证码*/
        NSString* name = [NLUtils getNameForRequest:Notify_getSmsCode];
        REGISTER_NOTIFY_OBSERVER(self, getSmsCodeInfoNotify, name);
        [[[NLProtocolRequest alloc] initWithRegister:YES] getSmsCode:_mobile];
        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    }else{
        
    }
}


//注册的
-(void)getSmsCodeInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
   
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self dogetSmsCodeInfoNotify:response];
        
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

-(void)dogetSmsCodeInfoNotify:(NLProtocolResponse*)response
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
        [NLUtils setRegisterMobile:phoneStr];
        NLProtocolData* data = [response.data find:@"msgbody/smscode" index:0];
        NSString* smscode = data.value;
        NLRegisterSecondViewController *vl = [[NLRegisterSecondViewController alloc] initWithNibName:@"NLRegisterSecondViewController" bundle:nil];
        vl.myPhoneNumber = _mobile;
        vl.myVerifyCode = smscode;
        vl.myViewControllerType = self.myViewControllerType;
        [NLUtils presentModalViewController:self newViewController:vl];
    }
}

/*注册和忘记密码的界面*/
- (IBAction)onGetVerifyBtnClicked:(id)sender
{
    NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _mobile = cell.myTextField.text;
    BOOL result = [NLUtils checkMobilePhone:_mobile];
    if (!result)
    {
        [self showErrorInfo:@"请输入正确的手机号码"];
    }
    /*忘记密码*/
    else if (self.myViewControllerType == TFBRegisterVCFind)
    {
        /*验证码的问题*/
//        if (![self verificationCheck:self.myVerifyTextField.text])
//        {
//            [self showErrorInfo:@"请输入正确的检验码"];
//            [self updateVerification];
//        }
//        else
//        {
            [self showErrorInfo:nil];
            [self getSmsCode];

//        }
    }
    else if(self.myViewControllerType == TFBRegisterVCRegister)
    {
        /*新用户注册*/
        [self showErrorInfo:nil];
        [self getSmsCode];
    }
}

//验证码随机的
- (IBAction)onRandomBtnClicked:(id)sender
{
    [self updateVerification];
}

#pragma mark - verify code

/*随机生成的验证码*/
-(int)getRotation
{
    int a=(arc4random() % (30 -(-30))) + (-30);
    return a;
}

/*验证码显示样式*/
-(void)tiltUI:(UILabel*)UI
{
    CGAffineTransform rotation4 = CGAffineTransformMakeRotation([self huDuFromdu:[self getRotation]]);
    [UI setTransform:rotation4];
}

-(float)huDuFromdu:(float)du
{
    return M_PI/(180/du);
}

-(NSString*)getRandomNumber
{
    return [NSString stringWithFormat:@"%d",arc4random()%10];
}

-(void)updateVerification
{
    self.myVerifyLable1.text=[self getRandomNumber];
    [self tiltUI:self.myVerifyLable1];
    self.myVerifyLable2.text=[self getRandomNumber];
    [self tiltUI:self.myVerifyLable2];
    self.myVerifyLable3.text=[self getRandomNumber];
    [self tiltUI:self.myVerifyLable3];
    self.myVerifyLable4.text=[self getRandomNumber];
    [self tiltUI:self.myVerifyLable4];
}

//判断信息是否正确
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


-(BOOL)verificationCheck:(NSString*)verification
{
    NSString*ver=[NSString stringWithFormat:@"%@%@%@%@",self.myVerifyLable1.text,self.myVerifyLable2.text,self.myVerifyLable3.text,self.myVerifyLable4.text];
    if ([ver isEqualToString:verification])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    [cell.myTextField addTarget:self action:@selector(textFieldWithSectre:) forControlEvents:UIControlEventEditingChanged];
    
    cell.myHeaderLabel.hidden = NO;
    cell.myTextField.hidden = NO;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.myContentLabel.hidden = YES;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"注册手机";
            cell.myTextField.delegate= self;
            cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.myTextField.placeholder = @"请填写注册手机号";
            cell.myTextField.text= phoneStr;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)textFieldWithSectre:(UITextField *)textField
{
     phoneStr= textField.text;
}

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
    label.text = @"请输入注册手机号";
    [view addSubview:label];
    return view;
}

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the root controller
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
