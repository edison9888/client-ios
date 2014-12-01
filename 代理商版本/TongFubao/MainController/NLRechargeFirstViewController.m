//
//  NLRechargeFirstViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLRechargeFirstViewController.h"
#import "NLRechargeCreditCardSecondViewController.h"
#import "NLRechargeDepositCardSecondViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"
#import "NLKeyboardAvoid.h"

@interface NLRechargeFirstViewController ()
{
    BOOL _freeNotify;
    NSString* _money;
    NLProgressHUD* _hud;
}

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myNextBtn;

- (IBAction)onNextBtnClicked:(id)sender;

@end

@implementation NLRechargeFirstViewController

@synthesize myTableView;
@synthesize myNextBtn;
@synthesize myRechargeFirstType;

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
    if (NLRechargeFirstDepositCard == self.myRechargeFirstType)
    {
//        self.navigationController.topViewController.title = @"储蓄卡充值(1)";
        self.navigationController.topViewController.title = @"储蓄卡充值";
    }
    else
    {
//        self.navigationController.topViewController.title = @"信用卡充值(1)";
        self.navigationController.topViewController.title = @"信用卡充值";
    }
    _freeNotify = YES;
//    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                       action:@selector(oneFingerTwoTaps)];
//    // Set required taps and number of touches
//    [oneFingerTwoTaps setNumberOfTapsRequired:1];
//    [self.myTableView addGestureRecognizer:oneFingerTwoTaps];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

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
    cell.myContentLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    [self addTapGestureRecognizer:cell.myHeaderLabel];
                    cell.myHeaderLabel.text = @"充值金额";
                    cell.myTextField.hidden = NO;
                    cell.myTextField.placeholder = @"请输入充值金额";
                    cell.myTextField.delegate = self;
                    cell.myTextField.keyboardType = UIKeyboardTypeDecimalPad;
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                   
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 250, cell.myHeaderLabel.frame.size.height)];
                    [self addTapGestureRecognizer:cell.myHeaderLabel];
                    cell.myContainer = self;
                    cell.myHeaderLabel.text = @"短信提醒";
                    cell.myTextField.hidden = YES;
                    cell.mySelectedBtn.hidden = NO;
                    [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 10;
    }
    else
    {
        return 30;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        return view;
    }
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    UIView* view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    
    rect.origin.x = 10;
    rect.size.width = 270;
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.adjustsFontSizeToFitWidth = NO;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor blackColor];
    label.text = @"免费短信通知账户充值号持有人";
    [view addSubview:label];
    [self addTapGestureRecognizer:view];
    return view;
}

- (IBAction)onNextBtnClicked:(id)sender
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.myTextField.text.length <= 0)
    {
        [self showErrorInfo:@"请输入充值金额" status:NLHUDState_Error];
        return;
    }
    else if ([cell.myTextField.text floatValue] <= 0)
    {
        [self showErrorInfo:@"充值金额必须大于0元" status:NLHUDState_Error];
        return;
    }
    _money = cell.myTextField.text;
    //UIViewController* vc = nil;
    if (NLRechargeFirstCreditCard == self.myRechargeFirstType)
    {
        NLRechargeCreditCardSecondViewController* vc = [[NLRechargeCreditCardSecondViewController alloc] initWithNibName:@"NLRechargeCreditCardSecondViewController" bundle:nil];
        vc.myMoney = _money;
        vc.myNotifySMS = _freeNotify;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        NLRechargeDepositCardSecondViewController* vc = [[NLRechargeDepositCardSecondViewController alloc] initWithNibName:@"NLRechargeDepositCardSecondViewController" bundle:nil];
        vc.myMoney = _money;
        vc.myNotifySMS = _freeNotify;
        [self.navigationController pushViewController:vc animated:YES];
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

-(void)doSelectedBtnClicked:(id)sender
{
    NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)sender;
    
    _freeNotify = !_freeNotify;
    if (_freeNotify)
    {
        [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"]
                                      forState:UIControlStateNormal];
    }
    else
    {
        [cell.mySelectedBtn setBackgroundImage:[UIImage imageNamed:@"unSelected.png"]
                                      forState:UIControlStateNormal];
    }
    return;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL input = YES;
    int result = [NLUtils doTextFieldDelegate:textField
                shouldChangeCharactersInRange:range
                            replacementString:string];
    switch (result)
    {
        case 0:
        {
            input = YES;
        }
            break;
        case 1:
        {
            input = NO;
            [self showErrorInfo:@"只能保留二位小数" status:NLHUDState_Error];
        }
            break;
        case 2:
        {
            input = NO;
            [self showErrorInfo:@"第一位不能输入小数点" status:NLHUDState_Error];
        }
            break;
        case 3:
        {
            input = NO;
            [self showErrorInfo:@"不能大于八位数" status:NLHUDState_Error];
        }
            break;
        case 5:
        {
            input = NO;
            [self showErrorInfo:@"第一位不能为0" status:NLHUDState_Error];
        }
            break;
        case 6:
        {
            input = NO;
            [self showErrorInfo:@"粘贴数目第一位为0,请手动输入" status:NLHUDState_Error];
        }
        default:
            break;
    }
    
    return input;
}

-(void)addTapGestureRecognizer:(UIView*)view
{
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:oneFingerTwoTaps];
}

@end
