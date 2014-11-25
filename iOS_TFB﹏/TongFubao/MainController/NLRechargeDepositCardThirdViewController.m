//
//  NLRechargeDepositCardThirdViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-12.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLRechargeDepositCardThirdViewController.h"
#import "NLKeyboardAvoid.h"
#import "NLRechargeResultViewController.h"
#import "NLUserInforSettingsCell.h"

@interface NLRechargeDepositCardThirdViewController ()

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* mySureBtn;

- (IBAction)onSureBtnClicked:(id)sender;

@end

@implementation NLRechargeDepositCardThirdViewController

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
//    self.navigationController.topViewController.title = @"储蓄卡充值(3)";
    self.navigationController.topViewController.title = @"储蓄卡充值";
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSureBtnClicked:(id)sender
{
    NLRechargeResultViewController* vc = [[NLRechargeResultViewController alloc] initWithNibName:@"NLRechargeResultViewController" bundle:nil];
    vc.myRechargeFirstType = NLRechargeFirstDepositCard;
    vc.myRechargeResult = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

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
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {                    
                    cell.myTextField.hidden = YES;
                    cell.mySelectedBtn.hidden = YES;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"充值金额(元)";
                    cell.myContentLabel.hidden = NO;
                    [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    cell.myContentLabel.text = @"09876543211234567890";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case 1:
                {
                    cell.myTextField.hidden = YES;
                    cell.mySelectedBtn.hidden = YES;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"手机号码";
                    cell.myContentLabel.hidden = NO;
                    [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    cell.myContentLabel.text = @"13800138000";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case 2:
                {
                    cell.myTextField.hidden = YES;
                    cell.mySelectedBtn.hidden = YES;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"信用卡号";
                    cell.myContentLabel.hidden = NO;
                    [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    cell.myContentLabel.text = @"0987654321123456789009876";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
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
                    cell.myContentLabel.hidden = YES;
                    cell.mySelectedBtn.hidden = YES;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"信用卡密码";
                    cell.myTextField.hidden = NO;
                    [cell.myTextField setFrame:CGRectMake(110, cell.myTextField.frame.origin.y, 180, cell.myTextField.frame.size.height)];
                    cell.myTextField.placeholder = @"输入信用卡密码";
                    cell.myTextField.secureTextEntry = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
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

#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

@end
