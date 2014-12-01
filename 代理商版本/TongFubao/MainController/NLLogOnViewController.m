 //
//  NLLogOnViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLLogOnViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLRegisterViewController.h"
#import "NLMoreViewController.h"
#import "NLToast.h"
#import "NLProtocolRequest.h"
#import "NLUtils.h"
#import "NLContants.h"
#import "NLPlistOper.h"
#import "NewLoginView.h"

#import "PaymentDf.h"

typedef enum
{
    NLLogOnInfoType_Logon = 0,
    NLLogOnInfoType_Mobile,
    NLLogOnInfoType_Password,
    NLLogOnInfoType_ProtocolFailure,
    NLLogOnInfoType_ProtocolSuccess
}NLLogOnInfoType;

@interface NLLogOnViewController ()
{
    BOOL _isRememberAccount;
    NLProgressHUD* _hud;
    NSString* _mobile;
    NSString* _authorid;
    NSString* _ispaypwd;
    NSString* _mpmodel;
    NSString* _auloginmethod;
    BOOL _test;
}

@property(nonatomic,retain) IBOutlet UIButton* myLogonBtn;
@property(nonatomic,retain) IBOutlet UIButton* myRegisterBtn;
@property(nonatomic,retain) IBOutlet UIButton* myRememberAccountBtn;
@property(nonatomic,retain) IBOutlet UIButton* myFindPWBtn;

- (IBAction)onLogonBtnClicked:(id)sender;
- (IBAction)onRegisterBtnClicked:(id)sender;
- (IBAction)onRememberAccounttnClicked:(id)sender;
- (IBAction)onFindPWBtnClicked:(id)sender;

-(void)oneFingerTwoTaps;
-(void)checkAuthorLoginNotify:(NSNotification*)notify;

@end

@implementation NLLogOnViewController

@synthesize myLogonBtn;
@synthesize myRegisterBtn;
@synthesize myRememberAccountBtn;
@synthesize myTableView;
@synthesize myFindPWBtn;

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
    self.navigationController.topViewController.title = @"登录";
    [self initValue];
    [self initAccount];
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches    
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
}

-(void)initValue
{
    _mpmodel = [NLUtils simplePlatformString];// @"";
    _auloginmethod = @"0";
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

-(void)initAccount
{
    self.myAccount = [NLUtils getRememberAccount];
    if (self.myAccount.length > 0)
    {
        _isRememberAccount = YES;
         [self.myRememberAccountBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        _isRememberAccount = NO;
         [self.myRememberAccountBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
    }
}

//获取对应的case跳转前注册页面
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
-(NSString*)getMobileFromTable
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    return cell.myTextField.text;
}

-(NSString*)getPasswordFromTable
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    return cell.myTextField.text;
}

//登陆的判断
- (IBAction)onLogonBtnClicked:(id)sender
{
    if (_isRememberAccount)
    {
        [self doSetRememberAccount:[self getMobileFromTable]];
    }
    else
    {
        [self doSetRememberAccount:@""];
    }
    [self hideKeyboard];
    
    _mobile = [self getMobileFromTable];
    
    BOOL result = [NLUtils checkMobilePhone:_mobile];
    if (!result)
    {
        [self showErrorInfo:NLLogOnInfoType_Mobile detail:nil];
        return;
    }
    
    NSString* pw = [self getPasswordFromTable];
    
    result = [NLUtils checkPassword:pw];
    if (!result)
    {
        [self showErrorInfo:NLLogOnInfoType_Password detail:nil];
        return;
    }
    NSString* name = [NLUtils getNameForRequest:Notify_checkAuthorLogin];
    REGISTER_NOTIFY_OBSERVER(self, checkAuthorLoginNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAuthorLogin:_mobile
                                                              password:pw
                                                         auloginmethod:_auloginmethod
                                                               mpmodel:_mpmodel];
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
    }
}


//登陆的判断
-(void)docheckAuthorLoginNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/authorid" index:0];
    _authorid = data.value;
    [NLUtils setAuthorid:_authorid];
    [NLUtils setLogonDate];
    [NLUtils setLogonPassword:[self getPasswordFromTable]];
    [NLUtils set_req_token:nil];//加密后获取的数据
    
    data = [response.data find:@"msgbody/ispaypwd" index:0];
    _ispaypwd = data.value;
    [NLUtils setIspaypwd:_ispaypwd];
    
    [self showErrorInfo:NLLogOnInfoType_ProtocolSuccess detail:@"登录成功"];
    if (NLPushViewType_Feed==self.myNextType || NLPushViewType_Left==self.myNextType)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self performSelector:@selector(doPush:) withObject:self.navigationController afterDelay:0.05f];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (IBAction)onRegisterBtnClicked:(id)sender
{
    
    NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
    vl.myViewControllerType = TFBRegisterVCRegister;
    [self.navigationController pushViewController:vl animated:YES];
}

-(void)doSetRememberAccount:(NSString*)mobile
{
    if (_isRememberAccount)
    {
        [NLUtils setRememberAccount:mobile];
    }
}

- (IBAction)onRememberAccounttnClicked:(id)sender
{
    _isRememberAccount = !_isRememberAccount;
    NSString* mobile = nil;
    if (_isRememberAccount)
    {
        mobile = [self getMobileFromTable];
        BOOL result = [NLUtils checkMobilePhone:mobile];
        if (!result)
        {
            _isRememberAccount = !_isRememberAccount;
            [self hideKeyboard];
            [self showErrorInfo:NLLogOnInfoType_Mobile detail:nil];            
            return;
        }
        [self.myRememberAccountBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.myRememberAccountBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
    }
    [NLUtils setRememberAccount:mobile];
}

//找回密码
- (IBAction)onFindPWBtnClicked:(id)sender
{
    NLRegisterViewController *vl = [[NLRegisterViewController alloc] initWithNibName:@"NLRegisterViewController" bundle:nil];
    vl.myViewControllerType = TFBRegisterVCFind;
    [self.navigationController pushViewController:vl animated:YES];
}

#pragma mark - UITableViewDataSource

#ifdef IOS_7
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

#endif

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
    switch (indexPath.section)
    {
        case 0:
        {
            cell.myHeaderLabel.hidden = NO;
            cell.myTextField.hidden = NO;
            cell.myDownrightBtn.hidden = YES;
            cell.myUprightBtn.hidden = YES;
            cell.myContentLabel.hidden = YES;
            
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.myHeaderLabel.text = @"账号";
                    cell.myTextField.placeholder = @"手机号码";
                    cell.myTextField.text = self.myAccount;
                    cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                case 1:
                {
                    cell.myHeaderLabel.text = @"密码";
                    cell.myTextField.placeholder = @"请输入密码";
                    cell.myTextField.secureTextEntry = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                    
                default:
                    break;
            }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

@end
