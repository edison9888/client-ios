//
//  NLInputUserInforViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-7.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLInputUserInforViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLProtocolRequest.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLPlistOper.h"
#import "NLPushViewIntoNav.h"
#import "NLUtils.h"
#import "NLShowTextViewController.h"

@interface NLInputUserInforViewController ()
{
    BOOL _showPassword;
    BOOL _hasRead;
    NSString* _name;
    NSString* _password;
    NSString* _passwordtoo;
    NSString* _idCard;
    NSString* _email;
    NLProgressHUD* _hud;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myGetVerifyCodeBtn;
@property(nonatomic,retain) UIButton* myShowPasswordBtn;
@property(nonatomic,retain) UIButton* myHasReadBtn;
@property(nonatomic,retain) UIButton* myShowProtocolBtn;

- (IBAction)onGetVerifyCodeBtnClicked:(id)sender;

- (void)onShowPasswordBtnClicked:(id)sender;
- (void)onHasReadBtnClicked:(id)sender;
- (void)onShowProtocolBtnClicked:(id)sender;

@end

@implementation NLInputUserInforViewController

@synthesize myGetVerifyCodeBtn;
@synthesize myTableView;
@synthesize myHasReadBtn;
@synthesize myShowPasswordBtn;
@synthesize myShowProtocolBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    [super viewDidAppear:animated];
    if (animated)
    {
        [self.myTableView flashScrollIndicators];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"确认注册";
    _name = nil;
    _idCard = nil;
    _password = nil;
    _passwordtoo= nil;
    _email = nil;
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    _showPassword = YES;
    _hasRead = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
                    cell.myHeaderLabel.text = @"手机账号";
                    cell.myTextField.placeholder = @"请输入您的手机号码";
                    cell.myTextField.text = self.myMobile;
                    cell.myTextField.keyboardType = UIKeyboardTypePhonePad;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                case 1:
                {
                    cell.myHeaderLabel.text = @"支付密码";
                    cell.myTextField.placeholder = @"请输入您的支付密码";
                    cell.myTextField.secureTextEntry = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                case 2:
                {
                    cell.myHeaderLabel.text = @"支付密码";
                    cell.myTextField.placeholder = @"请再次输入您的支付密码";
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    UIView* view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    
    rect.origin.x = 10;
    rect.origin.y = 7;
    rect.size.width = 25;
    rect.size.height = 25;
    
    self.myHasReadBtn = [[UIButton alloc] initWithFrame:rect];
    [self.myHasReadBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [self.myHasReadBtn addTarget:self action:@selector(onHasReadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.myHasReadBtn];
        
    rect.origin.x = 20;
    rect.size.width = 270;
    self.myShowProtocolBtn = [[UIButton alloc] initWithFrame:rect];
    self.myShowPasswordBtn.backgroundColor= [UIColor redColor];
    [self.myShowProtocolBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.myShowProtocolBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.myShowProtocolBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.myShowProtocolBtn setTitle:@"已阅读并同意<<通付宝注册协议>>"forState:UIControlStateNormal];
    [self.myShowProtocolBtn addTarget:self action:@selector(onShowProtocolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.myShowProtocolBtn];
    
    return view;
}


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

-(BOOL)checkUsersInfor
{
    if ([_password isEqualToString:_passwordtoo]) {
       
        BOOL result = [NLUtils checkPassword:_passwordtoo];
        if (!result)
        {
            [self showErrorInfo:@"请输入正确的密码" status:NLHUDState_Error];
            return NO;
        }
        return YES;
    }else{
        [self showErrorInfo:@"请确定您输入的两次密码正确" status:NLHUDState_Error];
        return NO;
    }
    
    if (!_hasRead)
    {
        [self showErrorInfo:@"请同意注册协议" status:NLHUDState_Error];
        return NO;
    }
    
    return YES;
}

-(void)doRegisterSuccess
{
    [NLUtils popToTheLogonVCFromMain:self.navigationController mobile:self.myMobile];
}

-(void)authorRegNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        [self showErrorInfo:@"注册成功,稍后进入登录界面" status:NLHUDState_NoError];
        [self performSelector:@selector(doRegisterSuccess) withObject:nil afterDelay:3.0f];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"网络异常，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//接口
-(void)authorReg
{
    NSString* name = [NLUtils getNameForRequest:Notify_authorReg];
    REGISTER_NOTIFY_OBSERVER(self, authorRegNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] authorReg:self.myMobile
                                                        password:_password
                                                            name:_name
                                                          idCard:_idCard
                                                           email:_email];
}

- (IBAction)onGetVerifyCodeBtnClicked:(id)sender
{
    if ([self checkUsersInfor])
    {
        [self authorReg];
    }
}

- (void)onShowPasswordBtnClicked:(id)sender
{
     NLUserInforSettingsCell *cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _showPassword = !_showPassword;
    if (_showPassword)
    {
        [self.myShowPasswordBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"]
                                          forState:UIControlStateNormal];
        BOOL test = cell.myTextField.secureTextEntry;
        if (test)
        {
            cell.myTextField.secureTextEntry = NO;
        }
    }
    else
    {
        [self.myShowPasswordBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"]
                                          forState:UIControlStateNormal];
        
        BOOL test = cell.myTextField.secureTextEntry;
        if (!test)
        {
            cell.myTextField.secureTextEntry = YES;
        }
    }
    NSArray *arr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
   [self.myTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
}

- (void)onHasReadBtnClicked:(id)sender
{
    _hasRead = !_hasRead;
    if (_hasRead)
    {
        [self.myHasReadBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"]
                                          forState:UIControlStateNormal];
    }
    else
    {
        [self.myHasReadBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"]
                                          forState:UIControlStateNormal];
        
    }
}

-(void)showTextView
{
    NLShowTextViewController* vc = [[NLShowTextViewController alloc] initWithNibName:@"NLShowTextViewController" bundle:nil];
    vc.myType = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)readAppruleListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self showTextView];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"网络异常，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

//服务协议的内容
- (void)onShowProtocolBtnClicked:(id)sender
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAppruleList];
    REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, name);
    NSString* str = [NSString stringWithFormat:@"%d",3];
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAppruleList:str];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
