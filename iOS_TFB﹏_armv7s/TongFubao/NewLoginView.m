//
//  NewLogin.m
//  TongFubao
//
//  Created by  俊   on 14-5-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NewLoginView.h"
//#import "BaseButton.h"
#import "NLUserInforSettingsCell.h"
#import "NLRegisterViewController.h"
#import "NLMoreViewController.h"
#import "NLToast.h"
#import "NLProtocolRequest.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLPlistOper.h"
#import "NewLoginView.h"
#import "SvUDIDTools.h"
#import "NewPhoneIsOn.h"
#import "GestureToLogin.h"
#import "TFBXY.h"
#import "SecretText.h"
#import "NLInputUserInforViewController.h"
#import "SecretText.h"
#import "NewloginRestive.h"

#define PHONENUM 11

typedef enum
{
    NLLogOnInfoType_Logon = 0,
    NLLogOnInfoType_Mobile,
    NLLogOnInfoType_Password,
    NLLogOnInfoType_ProtocolFailure,
    NLLogOnInfoType_ProtocolSuccess
}NLLogOnInfoType;

@interface NewLoginView ()
{
    BOOL _isRememberAccount;
    NLProgressHUD* _hud;
    UIButton*select;
    NSString* _mpmodel;
    NSString* _auloginmethod;
    NSString* _ispaypwd;
    CGRect  Lableframe;
    NSString *PhoneUIID;
    BOOL _test;
    BOOL flagPhone;
    
    UIButton *btn;
}

@property(nonatomic,retain)NSString *passwordConfirmFieldStr;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordConfirmField;
@property (nonatomic,strong)NLProgressHUD* myHUD;
@property (weak, nonatomic) IBOutlet UIView *ViewBg;

@property (weak, nonatomic) IBOutlet UITextField *phonetextfiled;
@property (weak, nonatomic) IBOutlet UIImageView *Uimage2;
@property (weak, nonatomic) IBOutlet UIImageView *Uimage1;
@property (weak, nonatomic) IBOutlet UIImageView *LoginLogo;
@property (weak, nonatomic) IBOutlet UIImageView *PhoneIcon;

@property (weak, nonatomic) IBOutlet UIView *viewA;
@property (weak, nonatomic) IBOutlet UIView *BGimageView;

@property (weak, nonatomic) IBOutlet UILabel *LableRZ;

@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property(nonatomic,retain) IBOutlet UIButton* myLogonBtn;

- (IBAction)onLogonBtnClicked:(id)sender;

-(void)oneFingerTwoTaps;

-(void)checkAuthorLoginNotify:(NSNotification*)notify;

@end

@implementation NewLoginView

@synthesize myLogonBtn,passwordConfirmFieldStr,LoginMobile;
@synthesize myNextTypeBool;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.navigationController removeFromParentViewController];
    }
    return self;
}

-(void)loadView{
    
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif

    [self viewTableIsOn];
    
    [self initValue];
    
    [self TextTOSercetFiled];
 
}

#pragma 判断的
- (void)TextTOSercetFiled{
    
    //更多里面修改密码的判断
    if (myNextTypeBool==YES) {
        
        self.title= @"修改手势密码";
        
    }

    /*是否第一次进入通付宝*/
    NSString * num =[NSString stringWithFormat:@"%d", _firstOpen ? 44 : 0 ];
    [_ViewBg.layer setValue:num forKeyPath:@"frame.origin.y"];
    num =[NSString stringWithFormat:@"%d", _firstOpen ? 322 : 264];
    [_viewA.layer  setValue:num forKeyPath:@"frame.origin.y"];
    _LoginBtn.hidden= !_firstOpen;
    
    
    //判断字符是否包含某字符串；
    __weak NewLoginView *weakSelf = self;

    self.phonetextfiled.delegate= self;
    
    self.phonetextfiled.text= LoginMobile;
    
    self.passwordConfirmField.delegate = self;
    
    self.passwordConfirmField.textField.placeholder = @"请输入登录密码";
    
    self.passwordConfirmField.textField.secureTextEntry = YES;

    [self.passwordConfirmField setTextValidationBlock:^BOOL(NSString *text) {
        if (text.length<6) {
            weakSelf.passwordConfirmField.alertView.title = @"请输入6-20位的密码";
            return NO;
        }
        else if ([NLUtils checkPassword:text]!=YES) {
            [self showErrorInfo:@"请勿输入特殊字符作为登陆密码" status:NLHUDState_Error];
            return NO;
        }
        else {
            passwordConfirmFieldStr= text;
            return YES;
        }
    }];
}


#pragma 键盘通知
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginkeyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginkeyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)loginkeyboardWasShown:(NSNotification*)noti{
    
    [UIView beginAnimations:nil context:nil];
    self.view.frame= CGRectMake(0,-40, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

-(void)loginkeyboardWasHidden:(id)noti{
    
    [UIView beginAnimations:nil context:nil];
    self.view.frame= CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if (textField== self.phonetextfiled) {
       
        if([[textField text] length] - range.length + string.length > PHONENUM)
        {
            retValue=NO;
        }
    }else  if (textField==self.passwordConfirmField.textField){
        if([[textField text] length] - range.length + string.length > 20)
        {
            retValue=NO;
        }
    }
       return retValue;
}


#pragma mark - BZGFormFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


- (void)viewTableIsOn{

    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
     */
}

-(void)initValue
{
    _mpmodel = [NLUtils simplePlatformString];
    _auloginmethod = @"0";
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    
    [super viewDidAppear:animated];
    
//    [self checkAppVersion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取对应的case跳转前注册页面 代理商
- (void) doPush: (id) nc
{
    UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:self.myNextType];
    
    if (vc)
    {
        [nc pushViewController:vc animated:YES];
    }
}

- (void)myProgressTask
{
	// This just increases the progress indicator in a loop
    _test = NO;
	float progress = 0.0f;
	while (progress < 1.0f)
    {
        //NLLogNoLocation(@"_test = %d",_test);
        if (_test)
        {
            break;
        }
        
		progress += 0.01f;
		_hud.progress = progress;
		usleep(50000);
	}
    //_test = NO;
}


//新用户注册
- (IBAction)LoginNewPeople:(id)sender {
   
    NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
    
    vl.myViewControllerType = TFBRegisterVCRegister;
    
    [NLUtils presentModalViewController:self newViewController:vl];
 
}


//忘记支付密码
- (IBAction)MissPasswd:(id)sender {
    
    NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
    vl.myViewControllerType = TFBRegisterVCFind;
    [NLUtils presentModalViewController:self newViewController:vl];
    
}

//登陆
- (IBAction)onLogonBtnClicked:(id)sender
{
    if ([self checkData]) {
        
        [self loginUrl];
    }
   
}

-(void)loginUrl{
  
    NSString *gestureStr= @"";
    NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorInfoV2Gesture];
    REGISTER_NOTIFY_OBSERVER(self, checkAuthorLoginNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorInfoV2gesturepasswd:gestureStr paypasswd:passwordConfirmFieldStr mobile:_phonetextfiled.text];
    [self showErrorInfo:NLLogOnInfoType_Logon detail:nil];

}

-(void)checkAuthorLoginNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self docheckAuthorLoginNotify:response];
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:NLLogOnInfoType_ProtocolFailure detail:detail];
       
        [self performSelector:@selector(todomain) withObject:response afterDelay:2.2f];
    }
}

//用户忘记登陆密码 使用手势密码登陆的状态
-(void)todomain{
    
    if (btn==nil) {
        
        btn= [[UIButton alloc]init];
        btn.frame= CGRectMake(16, 55, 288, 40);
        NSString *num =[NSString stringWithFormat:@"%d", _firstOpen ? 322 : 264];
        [_viewA.layer  setValue:num forKeyPath:@"frame.origin.y"];
        num =[NSString stringWithFormat:@"%d", 102];
        [_forgetBtn.layer setValue:num forKeyPath:@"frame.origin.y"];
        [_LoginBtn.layer setValue:num forKeyPath:@"frame.origin.y"];
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:@"change_btn_press"] forState:UIControlStateNormal];
    
    [btn setTitle:@"尝试手势密码登录" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [_viewA addSubview:btn];
  
}

-(void)btn{
    
    Gesture *ges= [[Gesture alloc]init];
    ges.loginMobile= _phonetextfiled.text;
    ges.loginFlage=YES;
    [self presentModalViewController:ges animated:YES];
}

-(void)docheckAuthorLoginNotify:(NLProtocolResponse*)response
{
    /*** havegesture 0没设置 1已设置 手势密码的 ***/
    NLProtocolData* gesturepasswdStr = [response.data find:@"msgbody/gesturepasswd" index:0];
    [NLUtils setGesturepasswd:gesturepasswdStr.value];
    
    [NLUtils setAuthorid:[response.data find:@"msgbody/authorid" index:0].value];
    
    /*** madfrog add 6.20***/
    NLProtocolData* agentidStr = [response.data find:@"msgbody/agentid" index:0];
    NSString  *agentid = agentidStr.value;
    [NLUtils setAgentid:agentid];
   
     /*** madfrog add 6.20***/
    /*relateAgent字段*/
    [NLUtils setRelateAgent:[response.data find:@"msgbody/relateAgent" index:0].value];

    /*Agenttypeid字段 0/1/2 */
    [NLUtils setAgenttypeid:[response.data find:@"msgbody/agenttypeid" index:0].value];
    /*Agenttypeid*/
    
    [NLUtils setLogonDate];
    [NLUtils setLogonPassword:passwordConfirmFieldStr];
    [NLUtils get_req_token];//加密后获取的数据
    [NLUtils setRegisterMobile:_phonetextfiled.text];
    
    NLProtocolData* ispaypwdStr;
    ispaypwdStr = [response.data find:@"msgbody/ispaypwd" index:0];
    _ispaypwd = ispaypwdStr.value;
    [NLUtils setIspaypwd:_ispaypwd];
    [self showErrorInfo:NLLogOnInfoType_ProtocolSuccess detail:@"登录成功"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PhoneNoFlag"];
   
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
        //本地储存数据 用于手势密码数据
       
        
        /*用于第一次进入手势密码直接跳过的操作*/
        if ( [NLUtils getleader] == nil) {
           
            /*引导页面话费的*/
            id thisClass = [[NSClassFromString(@"FirstLeadView") alloc] initWithNibName:@"FirstLeadView" bundle:nil];
            [self presentViewController:thisClass animated:YES completion:nil];
        }else{
            if ([[response.data find:@"msgbody/gesturepasswd" index:0].value isEqualToString:@"0"])
            {
                GestureToLogin *new= [[GestureToLogin alloc]init];
                new.mobile= _phonetextfiled.text;
                [NLUtils presentModalViewController:self newViewController:new];
            }else
            {
                [self usedefuallistGesture];
                
                NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                
                /*** 代理商 or 普通 ***/
                if ([[NLUtils getAgenttypeid] isEqualToString:@"0"])
                {
                    [delegate backToMain];
                }else
                {
                    [delegate backToTFAgent];
                }
                
            }
           
        }
      
    }
}

-(void)usedefuallistGesture
{
    NSMutableArray *array= [NSMutableArray array];
    NSString *count= @"5";
    [array addObject:@{@"passwordConfirmFieldDL": passwordConfirmFieldStr,@"phonetextfiledDL":_phonetextfiled.text,@"countNum":count/**@"authoridDL":[response.data find:@"msgbody/authorid" index:0].value, **/}];
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"DLarray"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //手势判断次数 存本地
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",5] forKey:KEY_RECORD_GESTURE_NUM];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//检查版本号
-(void)checkAppVersion
{
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
}

-(BOOL)checkData
{
    BOOL check = YES;
    check = [NLUtils checkMobilePhone:_phonetextfiled.text];
    if (!check)
    {
        [self showErrorInfo:@"请填入正确的手机号码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    if (_passwordConfirmField.textField.text.length<6) {
        [self showErrorInfo:@"请输入正确位数的密码密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }if ([NLUtils checkPassword:_passwordConfirmField.textField.text]!=YES) {
        [self showErrorInfo:@"请勿输入特殊字符作为密码密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    return check;
}

-(void)doSetRememberAccount:(NSString*)mobile
{
    if (_isRememberAccount)
    {
        [NLUtils setRememberAccount:mobile];
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


//登陆的进入页面
-(void)showErrorInfo:(NLLogOnInfoType)error detail:(NSString*)detail
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (error)
    {
        case NLLogOnInfoType_Logon:
        {
            _hud.labelText = @"正在登录";
            [_hud show:YES];
        }
            break;
        case NLLogOnInfoType_Mobile:
        {
            _hud.labelText = @"请输入正确的手机号码";
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
        case NLLogOnInfoType_Password:
        {
            _hud.labelText = @"请输入6-20位密码";
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLLogOnInfoType_ProtocolFailure:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLLogOnInfoType_ProtocolSuccess:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        default:
            break;
    }
    return;
}


-(void)hideKeyboard
{
    [self oneFingerTwoTaps];
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


#pragma mark - NLProgressHUDDelegate
- (void)hudWasHidden:(NLProgressHUD *)hud
{
    if (NLProgressHUDCloseBtnMode_Clicked == hud.isClose)
    {
        _test = YES;
    }
}

- (void)onClickedCloseBtn:(NLProgressHUD *)hud
{

    if (NLProgressHUDCloseBtnMode_Clicked == hud.isClose)
    {
        _test = YES;
    }
}

-(void)keyboardWasShown:(NSNotification*)noti{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame=self.view.frame;
        frame.size.height-=80;
        self.view.frame=frame;
    } completion:^(BOOL finished) {
    }];
}

-(void)keyboardWasHidden:(id)noti{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        CGRect frame=self.view.frame;
        frame.size.height+=80;
        self.view.frame=frame;
    } completion:^(BOOL finished) {
    }];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( textField ==  self.passwordConfirmField.textField ) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (!iPhone5) {
                CGRect frame=self.view.frame;
                frame.origin.y-=80;
                self.view.frame=frame;
            }
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( textField ==  self.passwordConfirmField.textField ) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (!iPhone5) {
                CGRect frame=self.view.frame;
                frame.origin.y+=80;
                self.view.frame=frame;
            }
        } completion:^(BOOL finished) {
        }];
    }
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

@end
