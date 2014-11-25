//
//  NewLogin.m
//  TongFubao
//
//  Created by  俊   on 14-5-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "NewLoginView.h"
#import "BaseButton.h"
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
    int        IOS7HEIGHT;
    BOOL _isRememberAccount;
    NLProgressHUD* _hud;
    UIButton*select;
    NSString* _mpmodel;
    NSString* _auloginmethod;
    NSString* _ispaypwd;
    NSString* _authorid;
    CGRect  Lableframe;
    NSString *PhoneUIID;
    BOOL _test;
    BOOL flagPhone;
    
    UIButton *btn;
}

@property(nonatomic,retain)NSString *passwordConfirmFieldStr;

@property(nonatomic,retain) IBOutlet UIButton* myLogonBtn;

@property (strong, nonatomic) IBOutlet UIView *BGimageView;
@property (weak, nonatomic) IBOutlet UITextField *phonetextfiled;
@property (weak, nonatomic) IBOutlet UIImageView *Uimage2;
@property (weak, nonatomic) IBOutlet UIImageView *Uimage1;
@property (weak, nonatomic) IBOutlet UIImageView *LoginLogo;
@property (weak, nonatomic) IBOutlet UILabel *LableRZ;
@property (weak, nonatomic) IBOutlet UIImageView *PhoneIcon;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (nonatomic,strong)NLProgressHUD* myHUD;
@property(nonatomic,retain) IBOutlet UIButton* myRememberAccountBtn;

@property (weak, nonatomic) IBOutlet UILabel *LbleeText;

- (IBAction)onLogonBtnClicked:(id)sender;


-(void)oneFingerTwoTaps;

-(void)checkAuthorLoginNotify:(NSNotification*)notify;

@end

@implementation NewLoginView

@synthesize myLogonBtn,passwordConfirmFieldStr,LoginMobile;
@synthesize myRememberAccountBtn;
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

- (void)iphone4Oriphone5{
    
     //更多里面修改密码的判断
    if (myNextTypeBool==YES) {
        
        self.title= @"修改手势密码";
        
        self.BGimageView.frame= CGRectMake(0, 40, 320, 430);
        
        self.BGimageView.backgroundColor= [UIColor redColor];
        
        [self.view addSubview:self.BGimageView];
        
    }else{
        
        self.BGimageView.frame= CGRectMake(0, 0, 320, self.view.frame.size.height);
        
        self.BGimageView.backgroundColor= RGBACOLOR(246, 250, 251, 1);
        
        [self.view addSubview:self.BGimageView];
        
        _forgetBtn.frame= CGRectMake(self.forgetBtn.frame.origin.x, self.forgetBtn.frame.origin.y, self.forgetBtn.frame.size.width, self.forgetBtn.frame.size.height);
        
        [self.BGimageView addSubview:_forgetBtn];
        
        _LoginBtn.frame= CGRectMake(self.LoginBtn.frame.origin.x, self.LoginBtn.frame.origin.y, self.LoginBtn.frame.size.width, self.LoginBtn.frame.size.height);
        
        [self.BGimageView addSubview:_LoginBtn];
    }
    
    _LoginLogo.frame = CGRectMake(self.LoginLogo.frame.origin.x, self.LoginLogo.frame.origin.y-IOS7HEIGHT/4, self.LoginLogo.frame.size.width, self.LoginLogo.frame.size.height);
    
    [self.BGimageView addSubview:_LoginLogo];
    
    _LableRZ.frame=  CGRectMake(self.LableRZ.frame.origin.x, self.LableRZ.frame.origin.y-IOS7HEIGHT/4, self.LableRZ.frame.size.width, self.LableRZ.frame.size.height);
    
    [self.BGimageView addSubview:_LableRZ];
    
    _Uimage1.frame= CGRectMake(self.Uimage1.frame.origin.x, self.Uimage1.frame.origin.y-IOS7HEIGHT*0.16, self.Uimage1.frame.size.width, self.Uimage1.frame.size.height);
    
     [self.BGimageView addSubview:_Uimage1];
    
    _Uimage2.frame= CGRectMake(self.Uimage2.frame.origin.x, self.Uimage2.frame.origin.y-IOS7HEIGHT*0.19, self.Uimage2.frame.size.width, self.Uimage2.frame.size.height);
    
    [self.BGimageView addSubview:_Uimage2];
    
    _phonetextfiled.frame= CGRectMake(self.phonetextfiled.frame.origin.x, self.phonetextfiled.frame.origin.y+IOS7HEIGHT*0.6, self.phonetextfiled.frame.size.width, self.phonetextfiled.frame.size.height);
    
    [self.BGimageView addSubview:_phonetextfiled];
    
     _PhoneIcon.frame= CGRectMake(self.PhoneIcon.frame.origin.x, self.PhoneIcon.frame.origin.y+IOS7HEIGHT*0.6, self.PhoneIcon.frame.size.width, self.PhoneIcon.frame.size.height);
    
     [self.BGimageView addSubview:_PhoneIcon];
    
   _passwordConfirmField.frame=CGRectMake(self.passwordConfirmField.frame.origin.x, self.passwordConfirmField.frame.origin.y-IOS7HEIGHT*0.16, self.passwordConfirmField.frame.size.width, self.passwordConfirmField.frame.size.height);
    
    [self.BGimageView addSubview:_passwordConfirmField];
    
    _LbleeText.frame= CGRectMake(self.LbleeText.frame.origin.x, self.LbleeText.frame.origin.y-IOS7HEIGHT, self.LbleeText.frame.size.width, self.LbleeText.frame.size.height);
    
     [self.BGimageView addSubview:_LbleeText];
    
    myLogonBtn.frame= CGRectMake(self.myLogonBtn.frame.origin.x, self.myLogonBtn.frame.origin.y+IOS7HEIGHT/2, self.myLogonBtn.frame.size.width, self.myLogonBtn.frame.size.height);
    
     [self.BGimageView addSubview:myLogonBtn];
    
    //如果当前用户手机号码错误的话 则手势密码登陆
    
    
    
}

-(void)loadView{
    
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IOS7HEIGHT=IOS7_OR_LATER==YES?0:64;
    
    [self viewTableIsOn];
    
    [self initValue];
    
    [self iphone4Oriphone5];
    
    [self TextTOSercetFiled];
    
     if (!IOS7_OR_IPHONE4) {
         
        [self registerForKeyboardNotifications];
    }

}

#pragma 判断的
- (void)TextTOSercetFiled{
    
       //判断字符是否包含某字符串；
    __weak NewLoginView *weakSelf = self;

    self.phonetextfiled.delegate= self;
    
    self.phonetextfiled.text= LoginMobile;
    
    self.passwordConfirmField.delegate = self;
    
    self.passwordConfirmField.textField.placeholder = @"请输入您账户的支付密码";
    
    self.passwordConfirmField.textField.secureTextEntry = YES;

    [self.passwordConfirmField setTextValidationBlock:^BOOL(NSString *text) {
        
        if (text.length<6) {
            weakSelf.passwordConfirmField.alertView.title = @"请输入6-20位的密码";
            return NO;
        }
        else if ([NLUtils checkPassword:text]!=YES) {
            [self showErrorInfo:@"请勿输入特殊字符作为支付密码" status:NLHUDState_Error];
            return NO;
        }
        else {
            passwordConfirmFieldStr= text;
            return YES;
        }
        
    }];
    
    self.PhoneIcon.frame= CGRectMake(self.PhoneIcon.frame.origin.x, self.PhoneIcon.frame.origin.y-IOS7HEIGHT/1.25, self.PhoneIcon.frame.size.width, self.PhoneIcon.frame.size.height);
    self.phonetextfiled.frame= CGRectMake(self.phonetextfiled.frame.origin.x, self.phonetextfiled.frame.origin.y-IOS7HEIGHT/1.25, self.phonetextfiled.frame.size.width, self.phonetextfiled.frame.size.height);

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
    self.view.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
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
            detail = @"网络异常，请检查网络";
        }
        
        [self showErrorInfo:NLLogOnInfoType_ProtocolFailure detail:detail];
       
        [self performSelector:@selector(todomain) withObject:response afterDelay:2.2f];
        
    }
}

//用户忘记登陆密码 使用手势密码登陆的状态
-(void)todomain{
    
    if (btn==nil) {
        
        btn= [[UIButton alloc]init];
        
        [btn setFrame:CGRectMake(self.myLogonBtn.frame.origin.x, self.myLogonBtn.frame.origin.y+IOS7HEIGHT/2-20, self.myLogonBtn.frame.size.width, self.myLogonBtn.frame.size.height)];
        
        myLogonBtn.frame= CGRectMake(self.myLogonBtn.frame.origin.x, self.myLogonBtn.frame.origin.y+IOS7HEIGHT/2+30, self.myLogonBtn.frame.size.width, self.myLogonBtn.frame.size.height);
        
        [self.BGimageView addSubview:myLogonBtn];
        
        /*测试适配*/
        _forgetBtn.frame= CGRectMake(self.forgetBtn.frame.origin.x, self.forgetBtn.frame.origin.y+IOS7HEIGHT/2, self.forgetBtn.frame.size.width, self.forgetBtn.frame.size.height);
        
        _LoginBtn.frame= CGRectMake(self.LoginBtn.frame.origin.x, self.LoginBtn.frame.origin.y+IOS7HEIGHT/2, self.LoginBtn.frame.size.width, self.LoginBtn.frame.size.height);
       
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:@"change_btn_press"] forState:UIControlStateNormal];
    [btn setTitle:@"尝试手势密码登录" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)btn{
    
    Gesture *ges= [[Gesture alloc]init];
    ges.loginMobile= _phonetextfiled.text;
    ges.loginFlage=YES;
    [self presentModalViewController:ges animated:YES];
    
}

-(void)docheckAuthorLoginNotify:(NLProtocolResponse*)response
{
    NLProtocolData* authoridStr = [response.data find:@"msgbody/authorid" index:0];
    _authorid = authoridStr.value;
    [NLUtils setAuthorid:_authorid];
    
    /*** madfrog add 6.20***/
    
    NLProtocolData* agentidStr = [response.data find:@"msgbody/agentid" index:0];
    NSString  *agentid = agentidStr.value;
    [NLUtils setAgentid:agentid];
   
     /*** madfrog add 6.20***/
   
    /*relateAgent字段*/
    NLProtocolData* relateAgent = [response.data find:@"msgbody/relateAgent" index:0];
    NSString  *relateAgentStr = relateAgent.value;
    [NLUtils setRelateAgent:relateAgentStr];
   
    /*relateAgent*/
    
    /*Agenttypeid字段 0/1/2 */
    NLProtocolData* Agenttypeid = [response.data find:@"msgbody/relateAgent" index:0];
    NSString  *AgenttypeidStr = Agenttypeid.value;
    [NLUtils setAgenttypeid:relateAgentStr];
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
    
    NSMutableArray *array= [NSMutableArray array];
    
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
        //手势密码没存
        NSString *count= @"5";
        
        [array addObject:@{@"passwordConfirmFieldDL": passwordConfirmFieldStr,@"phonetextfiledDL":_phonetextfiled.text,@"authoridDL":_authorid,@"countNum":count}];
        
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"DLarray"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    
        //手势判断次数 存本地
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",5] forKey:KEY_RECORD_GESTURE_NUM];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        GestureToLogin *new= [[GestureToLogin alloc]init];
        new.mobile= _phonetextfiled.text;
        [self presentModalViewController:new animated:YES];
       
    }
    
}


//检查版本号
-(void)checkAppVersion
{
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
}


//忘记支付密码
- (IBAction)MissPasswd:(id)sender {
    
    NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
    vl.myViewControllerType = TFBRegisterVCFind;
    [NLUtils presentModalViewController:self newViewController:vl];
    
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
        [self showErrorInfo:@"请输入正确位数的支付密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }if ([NLUtils checkPassword:_passwordConfirmField.textField.text]!=YES) {
        [self showErrorInfo:@"请勿输入特殊字符作为支付密码" status:NLHUDState_Error];
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
    
    //[txt resignFirstResponder];
}


#pragma mark - NLProgressHUDDelegate
- (void)hudWasHidden:(NLProgressHUD *)hud
{
    //NLLogNoLocation(@"hud = %d",hud.isClose);
    if (NLProgressHUDCloseBtnMode_Clicked == hud.isClose)
    {
        _test = YES;
    }
}

- (void)onClickedCloseBtn:(NLProgressHUD *)hud
{
    //NLLogNoLocation(@"hud = %d",hud.isClose);
    if (NLProgressHUDCloseBtnMode_Clicked == hud.isClose)
    {
        _test = YES;
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
