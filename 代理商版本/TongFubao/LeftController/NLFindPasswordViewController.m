//
//  NLFindPasswordViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-29.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLFindPasswordViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProtocolRequest.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"

@interface NLFindPasswordViewController ()
{
    NSString* _newPw;
    NSString* _reNewPw;
    NLProgressHUD* _hud;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myCommitBtn;

- (IBAction)onCommitBtnClicked:(id)sender;

@end

@implementation NLFindPasswordViewController

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
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.isPaypwd isEqualToString:@"0"])
    {
        self.navigationController.topViewController.title = @"设置支付密码";
    }
    else
    {
        self.navigationController.topViewController.title = @"找回 密码";
    }
    _newPw = nil;
    _reNewPw = nil;
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
//    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)getNewPW
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.myTextField.text;
}

-(NSString*)getReNewPW
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    return cell.myTextField.text;
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

-(BOOL)checkInputInfo
{
    _newPw = [self getNewPW];
    
    if (![NLUtils checkPassword:_newPw])
    {
        [self showErrorInfo:@"请输入6-20位字母或者数字组成的新密码" status:NLHUDState_Error];
        return NO;
    }
    
    _reNewPw = [self getReNewPW];
    
    if (_reNewPw.length == 0)
    {
        [self showErrorInfo:@"请输入确认密码" status:NLHUDState_Error];
        return NO;
    }
    
    if (![_reNewPw isEqualToString:_newPw])
    {
        [self showErrorInfo:@"两次输入的密码不相同" status:NLHUDState_Error];
        return NO;
    }
    return YES;
}

-(void)forgetPwdModifyNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    
    NSString* detail = response.detail;
    
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        
        [self doforgetPwdModifyNotify:response];
      
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
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

-(void)doforgetPwdModifyNotify:(NLProtocolResponse*)response{

    [NLUtils setLogonDate];
    
    [NLUtils get_au_token];
    
    [NLUtils get_req_token];
    
//    [NLUtils set_req_token:nil];
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        
        NSString* value = data.value;
        
        [self showErrorInfo:value status:NLHUDState_Error];
        
    }else{

    if ([self.isPaypwd isEqualToString:@"0"])
    {
        [self showErrorInfo:@"密码设置成功" status:NLHUDState_NoError];
    
        [self performSelector:@selector(doBack) withObject:nil afterDelay:2.0f];
        
        return;
    }else{
        
        [self showErrorInfo:@"密码找回成功" status:NLHUDState_NoError];
        
        [self performSelector:@selector(doPopToTheLogonVCFromMain) withObject:nil afterDelay:2.0f];
        
    }
  }
}

- (IBAction)onCommitBtnClicked:(id)sender
{
    [self oneFingerTwoTaps];
    
    if ([self checkInputInfo])
    {
       NSString *oldpasswd= @"";
       NSString *newpasswd= @"";
       NSString *aumoditype=@"2";
       NSString *reset= @"1";
        
        NSArray *DLArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"];
        
        NSString* authorid= [[DLArr valueForKey:@"authoridDL"]objectAtIndex:0];
        
        [NLUtils setAuthorid:authorid];
        
        [NLUtils setLogonDate];
        
        NSString* name = [NLUtils getNameForRequest:Notify_ApiAuthorInfoPasswordToChage];
        REGISTER_NOTIFY_OBSERVER(self, forgetPwdModifyNotify, name);
        
        [[[NLProtocolRequest alloc] initWithRegister:YES]getApiAuthorInfoPasswordToChage:oldpasswd newpassword:newpasswd aumoditype:aumoditype reset:reset];
        
        [self showErrorInfo:@"请稍候" status:NLHUDState_NoError];
        
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}

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
    cell.myTextField.secureTextEntry = YES;
    cell.myContentLabel.hidden = YES;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
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
    return cell;
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
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}

-(void)doPopToTheLogonVCFromMain
{
    
    NLMoreViewController *vl = [[NLMoreViewController alloc] initWithNibName:@"NLMoreViewController" bundle:nil];
    vl.settingFlag= YES;
    /*agenttypeid字段 0普通/1正式/2虚拟 */
    NSString *agentID= [NLUtils getAgenttypeid];
    if (![agentID isEqualToString:@"0"]) {
        vl.agentFlag= YES;
    }
    [NLUtils presentModalViewController:self newViewController:vl];
    
//    [self.navigationController.childViewControllers[0] dismissViewControllerAnimated:YES completion:nil];
}

-(void)doBack
{
    
    NLMoreViewController *vl = [[NLMoreViewController alloc] initWithNibName:@"NLMoreViewController" bundle:nil];
    vl.settingFlag= YES;
    /*agenttypeid字段 0普通/1正式/2虚拟 */
    NSString *agentID= [NLUtils getAgenttypeid];
    if (![agentID isEqualToString:@"0"]) {
        vl.agentFlag= YES;
    }
    [NLUtils presentModalViewController:self newViewController:vl];
    
//    [self.navigationController popViewControllerAnimated:YES];
}

@end
