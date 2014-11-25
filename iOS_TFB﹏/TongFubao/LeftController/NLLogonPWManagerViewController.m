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

@interface NLLogonPWManagerViewController ()
{
    NSString* _oldPw;
    NSString* _newPw;
    NSString* _reset;
    NLProgressHUD* _hud;
    UIButton *btn;
    UIButton *btnSectre;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* mySaveBtn;
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
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (TFBRegisterVCPayment == self.myPasswordModifyVCType)
    {
        self.navigationController.topViewController.title =  @"修改手势密码";
    }
    else
    {
        if (_PushFlag==YES||_gesturFlag==YES) {
            
            [self navbtn];
            
            self.navigationController.topViewController.title = @"重设密码";
            
            [mySaveBtn setFrame:CGRectMake(self.mySaveBtn.frame.origin.x, self.mySaveBtn.frame.origin.y-35, self.mySaveBtn.frame.size.width, self.mySaveBtn.frame.size.height)];
            
            [self.mySaveBtn setTitle:@"重设密码" forState:UIControlStateNormal];
        }else{
            
            self.navigationController.topViewController.title = @"修改登录密码";
            [self.mySaveBtn setTitle:@"修改登录密码" forState:UIControlStateNormal];
            
            if (btn==nil) {
                
                btn= [[UIButton alloc]init];
                
                btnSectre= [[UIButton alloc]init];
                
                [btn setFrame:CGRectMake(self.mySaveBtn.frame.origin.x, self.mySaveBtn.frame.origin.y+65, self.mySaveBtn.frame.size.width/2-7.5, self.mySaveBtn.frame.size.height)];
                
                [btnSectre setFrame:CGRectMake(self.mySaveBtn.frame.origin.x+self.mySaveBtn.frame.size.width/2+7.5, self.mySaveBtn.frame.origin.y+65, self.mySaveBtn.frame.size.width/2-7.5, self.mySaveBtn.frame.size.height)];
                }
            
            [btn setBackgroundImage:[UIImage imageNamed:@"next_press.png"] forState:UIControlStateNormal];
            [btn setTitle:@"手势修改" forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(btnToChage) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            [btnSectre setBackgroundImage:[UIImage imageNamed:@"next_press.png"] forState:UIControlStateNormal];
            [btnSectre setTitle:@"密保修改" forState:UIControlStateNormal];
            
            [btnSectre addTarget:self action:@selector(btnSectre) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnSectre];
        }
       
    }
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
}

-(void)navbtn{
    
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backInpush) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

-(void)backInpush{

    [self dismissViewControllerAnimated:YES completion:nil];
}


//判断当前手机是否有设置过密保问题
-(void)getChangeSerctre{
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApiSafeGuardLoginUp];
    REGISTER_NOTIFY_OBSERVER(self, getGuardUserNotifity, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiSafeGuardLoginUp:_mobile];
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
            detail = @"请求失败，请检查网络";
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
        sec.phoneNumber= _mobile;
        [self.navigationController pushViewController:sec animated:YES];
    }
}

//密保修改
-(void)btnSectre{

    [self performSelector:@selector(getChangeSerctre) withObject:nil afterDelay:0.1f];
    
}

//手势修改密码
-(void)btnToChage{
  
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
   
    if (_PushFlag==YES||_gesturFlag==YES) {
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        return cell.myTextField.text;
    }else{
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        return cell.myTextField.text;
    }
}

-(NSString*)getReNewPW
{
    if (_PushFlag==YES||_gesturFlag==YES) {
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        return cell.myTextField.text;
        
    }else{
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        return cell.myTextField.text;
    }
    
}

-(BOOL)checkInputInfo
{
    if (_PushFlag==YES||_gesturFlag==YES) {
        
        _newPw = [self getNewPW];

    }else{
        _oldPw = [self getOldPW];
        _newPw = [self getNewPW];
    }
    
    if (_PushFlag!=YES&&_gesturFlag!=YES) {
        
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
        if (_PushFlag==YES) {
            
            [self showErrorInfo:@"密码重设成功" status:NLHUDState_NoError];
            
            [self performSelector:@selector(dissmiss) withObject:nil afterDelay:2.0f];
        }else{
            
            [self showErrorInfo:@"修改成功" status:NLHUDState_NoError];
            
            [self performSelector:@selector(dissmiss) withObject:nil afterDelay:2.0f];
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
            detail = @"网络异常，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

- (IBAction)onSaveBtnClicked:(id)sender
{
    if ([self checkInputInfo])
    {
        NSArray *DLArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"];
        
       NSString* authorid= [[DLArr valueForKey:@"authoridDL"]objectAtIndex:0];
        
      [NLUtils setAuthorid:authorid];

        NSString* name = [NLUtils getNameForRequest:Notify_authorPwdModify];
        
         REGISTER_NOTIFY_OBSERVER(self, authorPwdModifyNotify, name);
        
        if (_PushFlag==YES||_gesturFlag==YES) {
            
            [[[NLProtocolRequest alloc] initWithRegister:YES] authorPwdModify:@""
                                                                        newPW:_newPw
                                                                         type:@"2" reset:@"1"];
            
            [self showErrorInfo:@"正在重设密码" status:NLHUDState_None];
            
        }else{
            
            [[[NLProtocolRequest alloc] initWithRegister:YES] authorPwdModify:_oldPw
                                                                        newPW:_newPw
                                                                         type:@"2" reset:@"0"];
            
            [self showErrorInfo:@"正在重设密码" status:NLHUDState_None];
        }
        
        
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
    
    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate backToMain];

}
-(void)dissmiss{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    lable.text= [NSString stringWithFormat:@"   账户:   %@",_mobile];
    lable.frame= CGRectMake(20, 15, 220, 30);
    lable.font= [UIFont systemFontOfSize:17];
    [self.view addSubview:lable];
    
    return lable;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_PushFlag==YES||_gesturFlag==YES) {
        
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
    
    if (_PushFlag==YES||_gesturFlag==YES) {
        
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
        [NLUtils popToTheLogonVCFromMain:self.navigationController mobile:_mobile];
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
