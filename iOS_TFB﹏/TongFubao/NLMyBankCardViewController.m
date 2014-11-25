//
//  NLMyBankCardViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLMyBankCardViewController.h"
#import "NLMyBankCardEditViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLKeyboardAvoid.h"
#import "NLPlistOper.h"
#import "NLContants.h"
#import "NLUtils.h"
#import "NLProtocolRegister.h"
#import "NLReturnSecondViewController.h"

@interface NLMyBankCardViewController ()
{
    NLProgressHUD* _hud;
    
    NSString* _shoucardbank;
    NSString* _shoucardno;
    NSString* _shoucardman;
    NSString* _shoucardmobile;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;

@end

@implementation NLMyBankCardViewController
@synthesize isChanged;

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
    if (self.isChanged)
    {
        [self readAuBkCardInfo];
    }
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

-(void)initValue
{
    _shoucardbank = @"";
    _shoucardno = @"";
    _shoucardman = @"";
    _shoucardmobile = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"我的银行卡";
    [self initValue];
    self.isChanged = NO;
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
//                                                                      style:UIBarButtonItemStyleBordered
//                                                                     target:self
//                                                                     action:@selector(editBankCard)];
//    self.navigationItem.rightBarButtonItem = anotherButton;
//    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                       action:@selector(oneFingerTwoTaps)];
//    // Set required taps and number of touches
//    [oneFingerTwoTaps setNumberOfTapsRequired:2];
//    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
//    [self.view addGestureRecognizer:oneFingerTwoTaps];
    
    [self readAuBkCardInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editBankCard
{
    NLMyBankCardEditViewController* vc = [[NLMyBankCardEditViewController alloc] initWithNibName:@"NLMyBankCardEditViewController" bundle:nil];
    [vc setInitValue:_shoucardbank no:_shoucardno man:_shoucardman mobile:_shoucardmobile];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    [cell.myTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"开户银行";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            if (_shoucardbank && _shoucardbank.length > 0)
            {
                cell.myTextField.text = _shoucardbank;
            }
            else
            {
                cell.myTextField.placeholder = @"暂无信息";
            }
            cell.myTextField.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case 1:
        {
            cell.myHeaderLabel.text = @"银行卡号";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            if (_shoucardno && _shoucardno.length > 0)
            {
                cell.myTextField.text = _shoucardno;
            }
            else
            {
                cell.myTextField.placeholder = @"暂无信息";
            }
            cell.myTextField.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case 2:
        {
            cell.myHeaderLabel.text = @"开户人";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            if (_shoucardman && _shoucardman.length > 0)
            {
                cell.myTextField.text = _shoucardman;
            }
            else
            {
                cell.myTextField.placeholder = @"暂无信息";
            }
            cell.myTextField.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case 3:
        {
            cell.myHeaderLabel.text = @"手机号码";
            cell.myContentLabel.hidden = YES;
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(100, cell.myTextField.frame.origin.y, 185, cell.myTextField.frame.size.height)];
            if (_shoucardmobile && _shoucardmobile.length > 0)
            {
                cell.myTextField.text = _shoucardmobile;
            }
            else
            {
                cell.myTextField.placeholder = @"暂无信息";
            }
            cell.myTextField.userInteractionEnabled = NO;
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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//#pragma mark - keyboard hide event
//
//-(void)oneFingerTwoTaps
//{
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    [firstResponder resignFirstResponder];
//}

-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
//    [self oneFingerTwoTaps];
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

#pragma mark - http request

-(void)doReadAuBkCardInfoNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/aushoucardbank" index:0];
    _shoucardbank = data.value;
    if (_shoucardbank && _shoucardbank.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.myTextField.text = _shoucardbank;
    }
    
    data = [response.data find:@"msgbody/aushoucardno" index:0];
    _shoucardno = data.value;
    if (_shoucardno && _shoucardno.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.myTextField.text = _shoucardno;
    }
    
    data = [response.data find:@"msgbody/aushoucardman" index:0];
    _shoucardman = data.value;
    if (_shoucardman && _shoucardman.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.myTextField.text = _shoucardman;
    }
    
    data = [response.data find:@"msgbody/aushoucardphone" index:0];
    _shoucardmobile = data.value;
    if (_shoucardmobile && _shoucardmobile.length > 0)
    {
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.myTextField.text = _shoucardmobile;
    }
    
    data = [response.data find:@"msgbody/aushoucardstate" index:0];
    NSString* state = data.value;
    if (state && [state isEqualToString:@"1"])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editBankCard)];
        self.navigationItem.rightBarButtonItem = anotherButton;
    }
    
    data = [response.data find:@"msgbody/message" index:0];
    NSString* message = data.value;
    [self showErrorInfo:message status:NLHUDState_NoError];
}

-(void)readAuBkCardInfoNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [self doReadAuBkCardInfoNotify:response];
//        [_hud hide:YES];
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
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readAuBkCardInfo
{
    [self showErrorInfo:@"正在获取银行卡信息" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_readAuBkCardInfo];
    REGISTER_NOTIFY_OBSERVER(self, readAuBkCardInfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAuBkCardInfo];
}

//超时重新登陆
-(void)doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:0];
}

@end
