//
//  NLOpenSwipCardViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-2.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLOpenSwipCardViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProtocolRequest.h"
#import "NLProgressHUD.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "NLUtils.h"

@interface NLOpenSwipCardViewController ()
{
    NSString* _key;
    NLProgressHUD* _hud;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myOpenNowBtn;

- (IBAction)onOpenNowBtnClicked:(id)sender;

@end

@implementation NLOpenSwipCardViewController

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
    
    UIButton* backButton = [NLUtils createNavigationLeftBarButtonImage];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationLeftBtnBack2"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backOpen) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationController.topViewController.title = @"开通刷卡器";
    _key = @"";
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backOpen
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)onOpenNowBtnClicked:(id)sender
{
    [self oneFingerTwoTaps];
    if (_key.length <= 0)
    {
        [self showErrorInfo:@"输入卡号" status:NLHUDState_Error];
        return;
    }
    [self activePayCard];
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
           _hud.labelText = detail; 
            
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

-(void)doActivePayCardNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
    NSString* message = data.value;
    [self showErrorInfo:message status:NLHUDState_NoError];
}

-(void)activePayCardNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doActivePayCardNotify:response];
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
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)activePayCard
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_activePayCard];
    REGISTER_NOTIFY_OBSERVER(self, activePayCardNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] activePayCard:_key];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.myContainer = self;
    cell.mySelectedBtn.hidden = YES;
    cell.myContentLabel.hidden = YES;
    
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    
    switch (indexPath.row)
    {
        case 0:
        {  
            cell.myHeaderLabel.text = @"设备号";
            cell.myTextField.hidden = NO;
            cell.myTextField.tag = 0;
            if ([_key length] <= 0)
            {
                cell.myTextField.placeholder = @"输入刷卡器的设备号";
            }
            else
            {
                cell.myTextField.text = _key;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    UIView* view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    rect.origin.x = 10;
    rect.origin.y = 5;
    rect.size.width = 300;
    rect.size.height = 20;
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.adjustsFontSizeToFitWidth = NO;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor blackColor];
    if (0 == section)
    {
        label.text = @"设备号为刷卡器的唯一号";
    }
    [view addSubview:label];
    return view;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0://key号
            _key = textField.text;
            break;
        default:
            break;
    }
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
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
