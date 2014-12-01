//
//  NLMoreViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLMoreViewController.h"
#import "NLAboutUsViewController.h"
#import "NLFeedbackViewController.h"
#import "NLPassWordManagerViewController.h"
#import "NLLogOnViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLUtils.h"
#import "NLPushViewIntoNav.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "NLProgressHUD.h"
#import "NLProtocolRequest.h"
#import "NLToast.h"
#import "NLContants.h"
#import "FeedController.h"
#import "SecretText.h"
#import "NLOpenSwipCardViewController.h"
#import "MyBankCardViewController.h"
#import "NLMyBankCardEditViewController.h"
#import "NLLoginView.h"

@interface NLMoreViewController ()
{
    NLProgressHUD* _hud;
}

@property(nonatomic,assign)NSIndexPath *indexPathAgent;
@end

@implementation NLMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self myTableView] reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"账户管理";
    [self addBackButtonItemWithImage:imageName(@"navigationLeftBtnBack2@2x", @"png")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftItemClick:(id)sender
{
    if (_settingFlag==YES) {
        
        NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate backToMain];
        
    }else{
         [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
    cell.myTextField.hidden = YES;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.myContentLabel.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.myHeaderLabel.hidden = NO;
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
    cell.myTextField.delegate = self;
    [self cellForSection0:indexPath cell:cell];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doCellForSection0:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - create cell

- (void)cellForSection0:(NSIndexPath *)indexPath cell:(NLUserInforSettingsCell*)cell
{
           switch (indexPath.row)
        {
            case 0:
            {
                cell.myHeaderLabel.text = @"注销";
                cell.myContentLabel.hidden = NO;
                [cell.myContentLabel setFrame:CGRectMake(110, cell.myHeaderLabel.frame.origin.y, 165, cell.myContentLabel.frame.size.height)];
                
                cell.myContentLabel.text = [NLUtils getRegisterMobile];
            }
                break;
                
            case 1:
            {
                cell.myHeaderLabel.text = @"密码管理";
            }
                break;
                
            case 2:
            {
                cell.myHeaderLabel.text = @"用户信息设置";
            }
                break;
                
            case 3:
            {
                cell.myHeaderLabel.text = @"收款银行卡";
            }
                break;
            case 4:
            {
                cell.myHeaderLabel.text = @"我的银行卡";
            }
                break;
            case 5:
            {
                cell.myHeaderLabel.text = @"设置密保问题";
            }
                break;
                
            default:
                break;
        }
    
}

#pragma mark - UIAlertViewDelegate

//提示的alertview 登出
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [self doCleanRegister];
    }
}

-(void)doCleanRegister
{
    [NLUtils cleanLogonInfo];
    [self reloadRegisterCell];
    [self showHud];
}

-(void)reloadRegisterCell
{
    NSArray *arr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    //
    [self.myTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
}

-(void)showHud
{
    //主界面检测是否设置密保用的 退出注销有通知检测到
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SecretFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NLProgressHUD* hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    hud.labelText = @"已经注销当前账户";
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
    [hud hide:YES afterDelay:2];

    /*新注册界面
    id thisClass = [[NSClassFromString(@"NLLoginView") alloc] initWithNibName:@"NLLoginView" bundle:nil];
    [self presentViewController:thisClass animated:YES completion:nil];*/
    
    NLLoginView *vc= [[NLLoginView alloc]initWithNibName:@"NLLoginView" bundle:nil];
    vc.flagdenchu= YES;
    [NLUtils presentModalViewController:self newViewController:vc];
    
//    [self presentViewController:vc animated:YES completion:nil];
    
    /*
    NewLoginView *gest= [[NewLoginView alloc]initWithNibName:@"NewLoginView" bundle:nil];
    [self presentModalViewController:gest animated:YES];
     */
}


#pragma mark - do clicled cell event
- (void)doCellForSection0:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            if ([self isUserRegister:NLPushViewType_None])
            {
                [NLUtils showAlertView:@"确认注销当前账户?"
                               message:nil
                              delegate:self
                                   tag:0
                             cancelBtn:@"取消"
                                 other:@"确定",nil];
            }
        }
            break;
            
        case 1:
        {
            if ([self isUserRegister:NLPushViewType_PassWordManager])
            {
                NLPassWordManagerViewController *vc= [[NLPassWordManagerViewController alloc]init];
                vc.myBackToLogon = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case 2:
        {
           /*旧版*/
             NLUsersInfoSettingsViewController *vc=  [[NLUsersInfoSettingsViewController alloc] initWithNibName:@"NLUsersInfoSettingsViewController" bundle:nil];
            
                if (_agentFlag==YES) {
                    
                    vc.agentFlag= YES;
                }
            
            /*新版
            NLUserSettingViewNew *use=  [[NLUserSettingViewNew alloc] initWithNibName:@"NLUserSettingViewNew" bundle:nil];
            
            [self.navigationController pushViewController:use animated:YES];*/
            
        }
            break;
            
        case 3:
        {
            if ([self isUserRegister:NLPushViewType_MyBankCard])
            {
                NLMyBankCardEditViewController* vc = [[NLMyBankCardEditViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 4:
        {
            MyBankCardViewController *myBankCardView = [[MyBankCardViewController alloc] init];
            [self.navigationController pushViewController:myBankCardView animated:YES];
        }
            break;
        case 5:
        {
            //密保设置
            SecretText *ser= [[SecretText alloc]initWithNibName:@"SecretText" bundle:nil];
            [NLUtils presentModalViewController:self newViewController:ser];
            
        }
            break;//
//        case 5:
//        {
//            //刷卡器
//            NLOpenSwipCardViewController *ser= [[NLOpenSwipCardViewController alloc]initWithNibName:@"NLOpenSwipCardViewController" bundle:nil];
//            [NLUtils presentModalViewController:self newViewController:ser];
//            
//        }
//            break;//
        default:
            break;
    }
}

-(BOOL)isForceUpdate
{
    
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:@"qiangzhi"];
    
    if(result){
        
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"需要更新才可以使用"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles: nil];
        [av show];
        
    }
    
    return result;

}

-(BOOL)isUserRegister:(NLPushViewType)type
{
    if ([self isForceUpdate])
    {
        return NO;
    }
    
    BOOL reg = [NLUtils isUserRegister];
    if (!reg)
    {
        Gesture *ges= [[Gesture alloc]init];
        ges.timeOutType = @"timeOut";
        [self presentModalViewController:ges animated:YES];
        
    }
    return reg;
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


-(void)checkAppVersion
{

    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
    [[[NLToast alloc] init] show:@"正在检查,请稍候"
                         gravity:NLToastGravityBottom
                        duration:NLToastDurationNormal];
    //[self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}

@end
