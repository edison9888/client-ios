//
//  NLLogonPWManagerViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLLogonPWManagerViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProgressHUD.h"
#import "NLToast.h"
#import "NLProtocolRequest.h"
#import "NLPlistOper.h"
#import "NLUtils.h"
#import "SecretText.h"
#import "NLLoginView.h"

#define MaxPhoneNum 20

@interface NLLogonPWManagerViewController ()
{
    NSString * _oldPw;
    NSString * _newPw;
    NSString * _reset;
    NLProgressHUD* _hud;
    UIButton *btn;
    UIButton *btnSectre;
    TransferInfoView * infoView[3];
}
@property (weak, nonatomic) IBOutlet UIView *viewA;

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* mySaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *gestureBtn;
@property (weak, nonatomic) IBOutlet UILabel *lablePhone;


- (IBAction)onSaveBtnClicked:(id)sender;
@end

@implementation NLLogonPWManagerViewController

@synthesize myTableView;
@synthesize mySaveBtn;
@synthesize myPasswordModifyVCType;

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
    if (self.myBackToLogon)
    {
        [NLUtils enableSliderViewController:NO];
    }
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.myBackToLogon)
    {
        [NLUtils enableSliderViewController:YES];
    }
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    /*重新写界面好了 以前的table恶心死了*/
       [self changeLoginView];
    
    if (TFBRegisterVCPayment == self.myPasswordModifyVCType)
    {
        self.navigationController.topViewController.title =  @"修改手势密码";
    }
    else
    {
        [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
        
        if (_gesturFlag==YES)
        {
     
            self.navigationController.topViewController.title = @"重设密码";
            
            [self.mySaveBtn setTitle:@"重设密码" forState:UIControlStateNormal];
        }else
        {
            self.navigationController.topViewController.title = @"修改登录密码";
            NSArray *DLlogin = [[NSUserDefaults standardUserDefaults]objectForKey:@"NLLoginView"];
            NSLog(@"dddd%@",DLlogin);
            
            /*暂不需要这样了 改版
            if ([[[DLlogin valueForKey:@"gesturepasswd"]objectAtIndex:0] isEqualToString: @"0"])
            {
                _gestureBtn.hidden= YES;
            }else{
                _gestureBtn.hidden= NO;
            }
             */
        }
    }
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
//    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
 
}

-(void)leftItemClick:(id)sender
{
    if (_gesturFlag==YES)
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}


/*界面 代码重新写*/
-(void)changeLoginView
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    /*卡背景图*/
    NSArray *infoTitles = @[ @"当前密码", @"新密码", @"确认密码" ];
    NSArray *infoTexts = @[ @"请输入原密码", @"输入新密码", @"确认新密码" ];
    
    /*手势改密码界面的*/
    _lablePhone.text = [NLUtils getRegisterMobile];
    _lablePhone.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:17.0];
    [_viewA.layer setValue:@5 forKeyPath:@"frame.origin.y"];
    
    NSInteger currint= _gesturFlag ? 2 : 3;
    UIView *infoBasicView = [UIView viewWithFrame:CGRectMake(16,  135 / currint, 288, 50* currint )];
    infoBasicView.layer.borderColor = [UIColor grayColor].CGColor;
    infoBasicView.layer.borderWidth = 0.5;
    infoBasicView.layer.cornerRadius = 5.0;
    [self.view addSubview:infoBasicView];
   
    for (int i = 0; i < currint; i++)
    {
        /*分割线*/
        if (i > 0)
        {
            UIImageView *lineView = [UIImageView viewWithFrame:CGRectMake(0, 50 * i, 288, 1) image:imageName(@"line1@2x", @"png")];
            [infoBasicView addSubview:lineView];
        }
        /*修改密码 密保/手势及普通修改区分*/
        infoView[i] =  [[TransferInfoView alloc] initWithFrame:CGRectMake(0, 50 * i , 288, 45)];
        infoView[i].titleLabel.text       = _gesturFlag ? infoTitles[1+i] : infoTitles[i];
        infoView[i].infoText.placeholder  = _gesturFlag ? infoTexts[1+i] : infoTexts[i];
        infoView[i].infoText.delegate     = self;
        infoView[i].infoText.tag          = 3838+i;
        infoView[i].infoText.font         = [UIFont systemFontOfSize:15.0];
        infoView[i].infoText.secureTextEntry = YES;
        infoView[i].infoText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [infoBasicView addSubview:infoView[i]];

    }
}

- (IBAction)OnClickChangeBtn:(id)sender {
    
    NSString *checkString = [self checkWithInfo];
    if (!checkString && [self checkData])
    {
        [self changeLoginPW];
    } else
    {
        [self showError:checkString];
    }
}

#pragma showErrorInfo
- (void)showError:(NSString *)detail
{
    if (detail)
    {
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
    /*
    else
    {
        [self showErrorInfo:@"服务器繁忙，请稍候再试" status:NLHUDState_Error];
    }
    */
}

/*修改密码的*/
-(void)changeLoginPW
{
    
    NSArray *DLArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"];
    NSString* authorid= [[DLArr valueForKey:@"authoridDL"]objectAtIndex:0];
    [NLUtils setAuthorid:authorid];
    NSString* name = [NLUtils getNameForRequest:Notify_authorPwdModify];
    REGISTER_NOTIFY_OBSERVER(self, authorPwdModifyNotify, name);
    
    if (_gesturFlag==YES) {
        
        [[[NLProtocolRequest alloc] initWithRegister:YES] authorPwdModify:@""
                                                                    newPW:infoView[1].infoText.text
                                                                     type:@"2" reset:@"1"];
        
        [self showErrorInfo:@"正在重设密码" status:NLHUDState_None];
        
    }else{
        
        [[[NLProtocolRequest alloc] initWithRegister:YES] authorPwdModify:infoView[0].infoText.text
                                                    newPW:infoView[2].infoText.text
                                                                     type:@"2" reset:@"0"];
        
        [self showErrorInfo:@"正在重设密码" status:NLHUDState_None];
    }
}


#pragma mark - 信息检测
- (NSString *)checkWithInfo
{
    [self.view endEditing:YES];
    
    if (infoView[0].infoText.text.length == 0 || [infoView[0].infoText.text isEqualToString:@""])
    {
        return _gesturFlag ? @"请输入新密码" : @"请输入原密码";
    }
    
    if (infoView[1].infoText.text.length == 0 || [infoView[1].infoText.text isEqualToString:@""])
    {
        return _gesturFlag ? @"请输入确认新密码" : @"请输入新密码";
    }
    
    if ((infoView[2].infoText.text.length == 0 || [infoView[2].infoText.text isEqualToString:@""]) &&_gesturFlag == NO )
    {
        return @"请输入确认新密码";
    }
    
    if (! (_gesturFlag ? [infoView[0].infoText.text isEqualToString:infoView[1].infoText.text]: [infoView[1].infoText.text isEqualToString:infoView[2].infoText.text]))
    {
        return @"两次输入密码不一致";
    }
    if (_gesturFlag ? infoView[0].infoText.text.length < 6 || infoView[1].infoText.text.length < 6 : infoView[0].infoText.text.length < 6 || infoView[1].infoText.text.length < 6 || infoView[2].infoText.text.length < 6 )
    {
        return @"请输入6-20位的英文或数字组成的密码";
    }
    
    return nil;
}

/*判断一个都行啦 反正不对就密码不一致的*/
-(BOOL)checkData
{
    BOOL check = YES;
    check= [NLUtils checkPassword:_gesturFlag ? infoView[0].infoText.text : infoView[1].infoText.text];
    if (!check)
    {
        [self showErrorInfo:@"请勿输入特殊字符设为登录密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }
    check= [NLUtils checkPassword:_gesturFlag ? infoView[1].infoText.text : infoView[2].infoText.text];
    if (!check)
    {
        [self showErrorInfo:@"请勿输入特殊字符设为确认登录密码" status:NLHUDState_Error];
        check = NO;
        return check;
    }

     return check;
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



/*判断当前手机是否有设置过密保问题*/
-(void)getChangeSerctre{
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiSafeGuardLoginUp];
    REGISTER_NOTIFY_OBSERVER(self, getGuardUserNotifity, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiSafeGuardLoginUp:[NLUtils getRegisterMobile]];
}

/*密保找回密码*/
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
        //密保问题找回
        SecretText *sec= [[SecretText alloc]init];
        sec.pushResponse= pushResponse;
        sec.UserBool = YES;
        sec.phoneNumber= [NLUtils getRegisterMobile];
        [self.navigationController pushViewController:sec animated:YES];
    }
}

- (IBAction)btnsectre:(id)sender {
     [_hud hide:YES];
     [self performSelector:@selector(getChangeSerctre) withObject:nil afterDelay:0.1f];
}

- (IBAction)btntochage:(id)sender {
    [_hud hide:YES];
    Gesture *gesture= [[Gesture alloc]init];
    gesture.changeFlage=YES;
    [self presentModalViewController:gesture animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)getOldPW
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.myTextField.text;
}

-(NSString*)getNewPW
{
    if (_gesturFlag==YES) {
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        return cell.myTextField.text;
    }else{
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        return cell.myTextField.text;
    }
}

-(NSString*)getReNewPW
{
    if (_gesturFlag==YES) {
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        return cell.myTextField.text;
        
    }else{
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        return cell.myTextField.text;
    }
    
}

-(BOOL)checkInputInfo
{
    if (_gesturFlag==YES) {
        
        _newPw = [self getNewPW];

    }else{
        _oldPw = [self getOldPW];
        _newPw = [self getNewPW];
    }
    
    if (_gesturFlag!=YES) {
        
        if (![NLUtils checkPassword:_oldPw])
        {
            [self showErrorInfo:@"请输入6-20位字母或数字组成的当前密码" status:NLHUDState_Error];
            return NO;
        }
    }
    
    
    if (![NLUtils checkPassword:_newPw])
    {
        [self showErrorInfo:@"请输入6-20位字母或数字组成的新密码" status:NLHUDState_Error];
        return NO;
    }
    
    _reset = [self getReNewPW];
    
    if (_reset.length == 0)
    {
        [self showErrorInfo:@"请输入确认密码" status:NLHUDState_Error];
        return NO;
    }
    
    if (![_reset isEqualToString:_newPw])
    {
        [self showErrorInfo:@"两次输入的密码不相同" status:NLHUDState_Error];
        return NO;
    }
    return YES;
}

-(void)authorPwdModifyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    NSString* detail = response.detail;
    
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        
       /* [self doauthorPwdModifyNotify:response];*/
        
        [_hud hide:YES];
        
        if (_gesturFlag==YES) {
            
            [self showErrorInfo:@"密码重设成功" status:NLHUDState_NoError];
            
            [self performSelector:@selector(dissBack) withObject:nil afterDelay:2.0f];
            
        }
        else{
            
            [self showErrorInfo:@"修改成功" status:NLHUDState_NoError];
            // dissmiss
            [self performSelector:@selector(dissBack) withObject:nil afterDelay:2.0f];
        }
     
        if (TFBRegisterVCPayment == self.myPasswordModifyVCType)
        {
            return;
        }

    }
    else
    {
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

/*旧版本的*/
- (IBAction)onSaveBtnClicked:(id)sender
{
    if ([self checkInputInfo])
    {
        /*old密码和new密码我改了 要看可看旧版本*/
        [self changeLoginPW];
    }
}


#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

-(void)dissBack{
    
//    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    [delegate backToMain];

    /*
    NLMoreViewController *vl = [[NLMoreViewController alloc] initWithNibName:@"NLMoreViewController" bundle:nil];
    vl.settingFlag= YES;
    NSString *agentID= [NLUtils getAgenttypeid];
    if (![agentID isEqualToString:@"0"]) {
        vl.agentFlag= YES;
    }
    [NLUtils presentModalViewController:self newViewController:vl];
     */
    
    /*新版注销*/
    NLLoginView *vc= [[NLLoginView alloc]initWithNibName:@"NLLoginView" bundle:nil];
    vc.flagdenchu= YES;
    [NLUtils presentModalViewController:self newViewController:vc];
    
}
-(void)dissmiss{
   
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    NLMoreViewController *vl = [[NLMoreViewController alloc] initWithNibName:@"NLMoreViewController" bundle:nil];
    vl.settingFlag= YES;
    /*agenttypeid字段 0普通/1正式/2虚拟 */
    NSString *agentID= [NLUtils getAgenttypeid];
    if (![agentID isEqualToString:@"0"]) {
        vl.agentFlag= YES;
    }
    [NLUtils presentModalViewController:self newViewController:vl];
    
}

-(void)dissmissLogin
{
    NLLoginView *vl= [[NLLoginView alloc]init];
    vl.flagChange= YES;
    [NLUtils presentModalViewController:self newViewController:vl];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self oneFingerTwoTaps];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UILabel *lable= [[UILabel alloc]init];
    lable.text= [NSString stringWithFormat:@"   账户:   %@",[NLUtils getRegisterMobile]];
    lable.frame= CGRectMake(20, 15, 220, 30);
    lable.font= [UIFont systemFontOfSize:17];
    [self.view addSubview:lable];
    
    return lable;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_gesturFlag==YES) {
        
         return 2;
    }else{
        
         return 3;
    }
   
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
    
    cell.myTextField.secureTextEntry = YES;
    
    cell.myContentLabel.hidden = YES;
    
    cell.myDownrightBtn.hidden = YES;
    
    cell.myUprightBtn.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (_gesturFlag==YES) {
        
        switch (indexPath.row)
        {
             case 0:
            {
                cell.myHeaderLabel.text = @"新密码";
                cell.myTextField.placeholder = @"6-20位字母或者数字组成";
            }
                break;
            case 1:
            {
                cell.myHeaderLabel.text = @"确认密码";
                cell.myTextField.placeholder = @"6-20位字母或者数字组成";
            }
                break;
                
            default:
                break;
                
        }
    }else{
        switch (indexPath.row)
        {
            case 0:
            {
                cell.myHeaderLabel.text = @"当前密码";
                cell.myTextField.placeholder = @"输入当前密码";
            }
                break;
            case 1:
            {
                cell.myHeaderLabel.text = @"新密码";
                cell.myTextField.placeholder = @"6-20位字母或者数字组成";
            }
                break;
            case 2:
            {
                cell.myHeaderLabel.text = @"确认密码";
                cell.myTextField.placeholder = @"6-20位字母或者数字组成";
            }
                break;
                
            default:
                break;
                
        }
    }
    
    
    return cell;
}

#pragma mark Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) doPush
{
    [_hud hide:YES];
    
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

- (void) doPopToTheLogon
{
    if (self.myBackToLogon)
    {
        [NLUtils popToTheLogonVCFromMain:self.navigationController mobile:[NLUtils getRegisterMobile]];
    }
    else
    {
        [NLUtils popToTheLogonVCFromMore:self.navigationController];
    }
}

-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    
    return;
}
@end
