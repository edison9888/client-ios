//
//  NLPassWordManagerViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLPassWordManagerViewController.h"
#import "NLLogonPWManagerViewController.h"
#import "NLFindPasswordViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLUtils.h"
#import "NLFindPasswordViewController.h"
#import "SecretText.h"

@interface NLPassWordManagerViewController ()
{
    NSString      * _ispaypwd;
    NLProgressHUD * _hud;
}


@end

@implementation NLPassWordManagerViewController

@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//这样子传值 相对哪个也行哦 myBackToLogon
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
    self.navigationController.topViewController.title = @"密码管理";
    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
    [self getNLPassWordIspaypwd];
    
    self.myMobile= [NLUtils getRegisterMobile];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getNLPassWordIspaypwd
{
    _ispaypwd = [NLUtils getIspaypwd];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myBackToLogon)
    {
        return 1;
    }
    else
    {
        return 4;
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
    
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 200, cell.myHeaderLabel.frame.size.height)];
    
    cell.myContentLabel.hidden = YES;
    
    cell.myTextField.hidden = YES;
    
    cell.myDownrightBtn.hidden = YES;
    
    cell.myUprightBtn.hidden = YES;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row)
    {
        
        case 0:
        {
            if ([_ispaypwd isEqualToString:@"0"])
            {
                cell.myHeaderLabel.text = @"设置登录密码";
            }
            else
            {
                cell.myHeaderLabel.text = @"修改登录密码";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"使用手势密码修改";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
            break;
        case 2:
        {
            cell.myHeaderLabel.text = @"使用密保问题修改";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
            break;
        case 3:
        {
            cell.myHeaderLabel.text = @"设置手势密码";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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
    [self doSelectCellEvent:indexPath];
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)doSelectCellEvent:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row >= 4)
    {
        return;
    }
    TFBPasswordType type = (TFBPasswordType)(row+1);
    if (self.myBackToLogon)
    {
        NLFindPasswordViewController* vc =  [[NLFindPasswordViewController alloc] initWithNibName:@"NLFindPasswordViewController" bundle:nil];
        vc.myPasswordType = type;
        vc.myMobile = self.myMobile;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if ([_ispaypwd isEqualToString:@"0"]) {
            /*忘记密码的吧 忘记了 下次再改*/
            if (0 == indexPath.row)
            {
                NLLogonPWManagerViewController *vc = [[NLLogonPWManagerViewController alloc] initWithNibName:@"NLLogonPWManagerViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                
                TFBPasswordType type = (TFBPasswordType)(row+1);
                NLFindPasswordViewController* vc =  [[NLFindPasswordViewController alloc] initWithNibName:@"NLFindPasswordViewController" bundle:nil];
                vc.myPasswordType = type;
                vc.myMobile = self.myMobile;
                vc.isPaypwd = _ispaypwd;
                vc.NLPassWordDetegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            /*普通用户信息的修改密码*/
            if (0 == indexPath.row)
            {
                /*修改登陆密码*/
                NLLogonPWManagerViewController *vc = [[NLLogonPWManagerViewController alloc] initWithNibName:@"NLLogonPWManagerViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (1 == indexPath.row)
            {
                /*使用手势修改登陆密码*/
                Gesture *gesture= [[Gesture alloc]init];
                gesture.changeFlage=YES;
                [self.navigationController pushViewController:gesture animated:YES];

            }
            else if (2 == indexPath.row)
            {
                /*使用密码问题修改*/
                [self performSelector:@selector(getChangeSerctre) withObject:nil afterDelay:0.1f];
            }
            else if (3 == indexPath.row)
            {
                //手势密码的修改
                GestureToLogin *vc = [[GestureToLogin alloc] init];
                vc.settingFlag= YES;
                [NLUtils presentModalViewController:self newViewController:vc];

            }
        }
    }
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
