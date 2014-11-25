//
//  NewloginRestive.m
//  TongFubao
//
//  Created by  俊   on 14-6-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NewloginRestive.h"
#import "NLShowTextViewController.h"

@interface NewloginRestive ()
{
     int            IOS7IPHONE4;
     NLProgressHUD  * _hud;
     BOOL           _isRememberAccount;
     NSString       *_authorid;
}
@property (weak, nonatomic) IBOutlet UIButton  *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton  *rememberList;
@property (weak, nonatomic) IBOutlet UIButton  *LoginBtn;
@property (nonatomic,strong)NLProgressHUD     *myHUD;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
#pragma 键盘通知
@property (nonatomic,assign) CGRect selfFrame;

@end

@implementation NewloginRestive

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
    self.selfFrame= self.view.frame;
    [self TextTOSercetFiled];
}

#pragma 判断的
- (void)TextTOSercetFiled{
    
    IOS7IPHONE4=IOS7_OR_LATER||IOS7_OR_IPHONE4==YES?0:64;
    
    self.view.backgroundColor= RGBACOLOR(246, 250, 251, 1);
    
    __weak NewloginRestive *weakSelf = self;
    
    self.passwordField.delegate= self;
    
    self.passwordtooField.delegate = self;
    
    self.passwordtooField.textField.placeholder = @"请再次输入您的支付密码";
    
    self.passwordField.textField.placeholder= @"请输入您的支付密码";
    
    self.passwordField.textField.secureTextEntry = YES;
    
    self.passwordtooField.textField.secureTextEntry = YES;
    
    [self.passwordField setTextValidationBlock:^BOOL(NSString *text) {
        
        if (text.length<6) {
           weakSelf.passwordField.alertView.title = @"请输入6-20位的密码";
            return NO;
        }else if ([NLUtils checkPassword:text]!=YES) {
            [self showErrorInfo:@"请勿输入特殊字符做为支付密码" status:NLHUDState_Error];
            return NO;
        }
        else {
            _passwordFieldStr= text;
            return YES;
        }
        
    }];

    [self.passwordtooField setTextValidationBlock:^BOOL(NSString *text) {
        
        if (text.length<6) {
            weakSelf.passwordtooField.alertView.title = @"请重复输入您的支付密码";
            return NO;
        }else if ([NLUtils checkPassword:text]!=YES) {
            [self showErrorInfo:@"请勿输入特殊字符作为支付密码" status:NLHUDState_Error];
            return NO;
        }
        else {
            _passwordtooFieldStr= text;
            if ([_passwordFieldStr isEqualToString:_passwordtooFieldStr]) {
                 return YES;
            }
            
            return NO;
        }
        
    }];
    
    _PhoneMoble.text= self.PhoneStr;
    
    [self iphone4Or5];
    
    if (!IOS7_OR_IPHONE4) {
        [self registerForKeyboardNotifications];
    }

}

-(void)iphone4Or5{
    
    
    self.rememberList.frame= CGRectMake(self.rememberList.frame.origin.x, self.rememberList.frame.origin.y-IOS7IPHONE4*.1, self.rememberList.frame.size.width, self.rememberList.frame.size.height);
    self.rememberBtn.frame= CGRectMake(self.rememberBtn.frame.origin.x, self.rememberBtn.frame.origin.y+IOS7IPHONE4*.9, self.rememberBtn.frame.size.width, self.rememberBtn.frame.size.height);
    
    self.passwordField.frame= CGRectMake(self.passwordField.frame.origin.x, self.passwordField.frame.origin.y, self.passwordField.frame.size.width, self.passwordField.frame.size.height);
    self.passwordtooField.frame= CGRectMake(self.passwordtooField.frame.origin.x, self.passwordtooField.frame.origin.y, self.passwordtooField.frame.size.width, self.passwordtooField.frame.size.height);
    self.LoginBtn.frame= CGRectMake(self.LoginBtn.frame.origin.x, self.LoginBtn.frame.origin.y+IOS7IPHONE4*0.8, self.LoginBtn.frame.size.width, self.LoginBtn.frame.size.height);
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
     if (textField==self.passwordtooField.textField&&textField==self.passwordField.textField){
        if([[textField text] length] - range.length + string.length > 20&&[[textField text] length] - range.length + string.length <5)
        {
            retValue=NO;
        }
    }
    return retValue;
}


- (IBAction)onRememberAccounttnClicked:(id)sender
{
    
    
}

#pragma 用户登录接口
- (void)LoginViewIsGestureTextFiled{
    NSString *Mac= @"";
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorInfoV2];
    
    REGISTER_NOTIFY_OBSERVER(self, PasswordToChageNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]getTheNewLoginApiAuthorInfoV2:Mac Phone:_PhoneMoble.text Password:_passwordtooFieldStr];
    
}

- (void)PasswordToChageNotify:(NSNotification*)notify{
    
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doPasswordToChageNotify:response];
        
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
            detail = @"请求失败，请检查网络";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

- (void)doPasswordToChageNotify:(NLProtocolResponse*)response{
    
    NLProtocolData* authoridStr = [response.data find:@"msgbody/authorid" index:0];
    _authorid = authoridStr.value;
   
    [NLUtils setAuthorid:_authorid];
    [NLUtils setLogonDate];
    [NLUtils setRegisterMobile:_PhoneMoble.text];
    [NLUtils setLogonPassword:_passwordtooFieldStr];
    [NLUtils get_req_token];//加密后获取的数据
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        
        NSLog(@"value %@",value);
        
        [self showErrorInfo:value status:NLHUDState_Error];
        
    }
    else
    {
        //记录注册的信息
         NSMutableArray *array= [NSMutableArray array];
        NSString *count=@"5";
        [array addObject:@{@"passwordConfirmFieldDL": _passwordtooFieldStr,@"phonetextfiledDL":_PhoneMoble.text,@"authoridDL":_authorid,@"countNum":count}];
        
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"DLarray"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PhoneNoFlag"];
        
        //重置手势密码
        GestureToLogin *ges= [[GestureToLogin alloc]init];
    
        [self presentViewController:ges animated:YES completion:nil];
    }
    
}

#pragma mark - readKuaiDicmpList
-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [self.myHUD hide:YES];
    self.myHUD = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            self.myHUD.mode = MBProgressHUDModeCustomView;
            self.myHUD.detailsLabelText = error;
            [self.myHUD show:YES];
            [self.myHUD hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            self.myHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            self.myHUD.mode = MBProgressHUDModeCustomView;
            self.myHUD.labelText = error;
            [self.myHUD show:YES];
            [self.myHUD hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            self.myHUD.labelText = error;
            [self.myHUD show:YES];
        }
            break;
            
        default:
            break;
    }
    
    return;
}

- (IBAction)LoginBtn:(id)sender {

    if ([self checkData]) {
        if (_isRememberAccount==YES) {
            [self LoginViewIsGestureTextFiled];
        }else{
            [self showErrorInfo:@"请同意通付宝注册协议" status:NLHUDState_Error];
        }
    }
    
}

- (IBAction)IsOKtoBtn:(id)sender {
    UIButton *btn= (UIButton*)sender;
    btn.selected =! btn.selected;
    if (btn.selected) {
        _isRememberAccount = YES;
        [self.rememberBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }else{
        _isRememberAccount = NO;
        [self.rememberBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
    }
}

//协议
- (IBAction)loginlist:(id)sender {
    
    NSString* name = [NLUtils getNameForRequest:Notify_readAppruleList];
    
    REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, name);
    NSString* str = [NSString stringWithFormat:@"%d",3];
    
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAppruleList:str];
    
}

#pragma mark - http request
-(void)readAppruleListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self showTextView];
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


-(void)showTextView
{
    NLShowTextViewController* vc = [[NLShowTextViewController alloc] initWithNibName:@"NLShowTextViewController" bundle:nil];
    vc.myType = 5;
    [NLUtils presentModalViewController:self newViewController:vc];
}


//检查填入的信息是否都符合
-(BOOL)checkData
{
    BOOL check = YES;
    
    check = [_passwordtooFieldStr isEqualToString:_passwordFieldStr];
    if (!check)
    {
        [self showErrorInfo:@"请输入正确的支付密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    if (_passwordtooFieldStr.length<6) {
        [self showErrorInfo:@"请输入正确位数的支付密码" status:NLHUDState_Error];
         check = NO;
        return check;
    }if (_passwordFieldStr.length<6) {
        [self showErrorInfo:@"请输入正确位数的支付密码" status:NLHUDState_Error];
         check = NO;
        return check;
    }
    
    check = [NLUtils checkPassword:_passwordtooFieldStr];
    if (!check)
    {
         [self showErrorInfo:@"请勿输入特殊字符做为支付密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    check= [NLUtils checkPassword:_passwordFieldStr];
    if (!check)
    {
        [self showErrorInfo:@"请勿输入特殊字符做为支付密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    return check;
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
    
    //[txt resignFirstResponder];
}

#pragma 键盘通知
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginkeyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginkeyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)loginkeyboardWasShown:(NSNotification*)noti{
    
    [UIView beginAnimations:nil context:nil];
    self.view.frame= CGRectMake(0,-60, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

-(void)loginkeyboardWasHidden:(id)noti{
    
    [UIView beginAnimations:nil context:nil];
    self.view.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}



-(void)removeSelf{
    
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            CGRect frame=self.view.frame;
            
            frame.origin.y-=frame.size.height;
            
            self.view.frame=frame;
            
        } completion:^(BOOL finished) {
            
            self.view.hidden=YES;
            
            [self.view removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
