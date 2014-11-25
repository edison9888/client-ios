//
//  NLAboutUsViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLAboutUsViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProtocolRequest.h"
#import "NLUtils.h"
#import "NLProgressHUD.h"
#import "NLShowTextViewController.h"
#import "AttentionWKViewController.h"

@interface NLAboutUsViewController ()
{
    NLProgressHUD* _hud;
    int _type;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UILabel* myVersionLabel;

@end

@implementation NLAboutUsViewController

@synthesize myTableView;
@synthesize myVersionLabel;

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
    self.navigationController.topViewController.title=@"关于我们";
    
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self initValue];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initValue
{
    self.myVersionLabel.text = [NSString stringWithFormat:@"V%@",TFBVersion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)showTextView
{
    NLShowTextViewController* vc = [[NLShowTextViewController alloc] initWithNibName:@"NLShowTextViewController" bundle:nil];
    vc.myType = _type;
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)aboutUsProtocol:(int)type
{
    _type = type;
     NSString* name = [NLUtils getNameForRequest:Notify_readAppruleList];
     REGISTER_NOTIFY_OBSERVER(self, readAppruleListNotify, name);
    NSString* str = [NSString stringWithFormat:@"%d",type];
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAppruleList:str];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
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
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.myHeaderLabel.text = @"通付宝钱包服务协议";
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                    break;
                case 1:
                {
                    cell.myHeaderLabel.text = @"关于通付宝公司";
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                    break;
                case 2:
                {
                    cell.myHeaderLabel.text = @"关注通付宝官方微信";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"服务电话: 400-6868-956";
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
    // set the root controller
    int section = indexPath.section;
    int row = indexPath.row;
    switch (section)
    {
        case 0:
        {
            switch (row)
            {
                case 0:
                {
                    [self aboutUsProtocol:2];
                }
                    break;
                case 1:
                {
                   [self aboutUsProtocol:4];
                }
                    break;
                case 2:
                {
                    NSURL *URL = [NSURL URLWithString:@"www.tfbpay.cn/mobilepay/wechat.php"];
                    
                    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
                    [NLUtils presentModalViewController:self newViewController:webViewController];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1:
        {
            switch (row)
            {
            case 0:
                {
                    [NLUtils callTel:@"4006868956"];
                }
        
            default:
                break;
            }
        }
            break;
        default:
            break;
    }
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

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}

@end
