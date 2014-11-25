//
//  NLRechargeCreditCardThirdViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLRechargeCreditCardThirdViewController.h"
#import "NLKeyboardAvoid.h"
#import "NLRechargeResultViewController.h"
#import "NLUserInforSettingsCell.h"

@interface NLRechargeCreditCardThirdViewController ()

@property(nonatomic,retain) IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myNextBtn;

- (IBAction)onNextBtnClicked:(id)sender;

@end

@implementation NLRechargeCreditCardThirdViewController



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
    self.navigationController.topViewController.title = @"信用卡充值";
//    self.navigationController.topViewController.title = @"信用卡充值(3)";
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

- (IBAction)onNextBtnClicked:(id)sender
{
    NLRechargeResultViewController* vc = [[NLRechargeResultViewController alloc] initWithNibName:@"NLRechargeResultViewController" bundle:nil];
    vc.myRechargeFirstType = NLRechargeFirstCreditCard;
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
    
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.myHeaderLabel.hidden = NO;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"充值金额(元)";
                    cell.myTextField.hidden = YES;
                    cell.myContentLabel.hidden = NO;
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
                    cell.myContentLabel.text = @"12345678900987654321";
                }
                    break;
                case 1:
                {
                    cell.myHeaderLabel.hidden = NO;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"手机号码";
                    cell.myTextField.hidden = YES;
                    cell.myContentLabel.hidden = NO;
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
                    cell.myContentLabel.text = @"13800138000";
                }
                    break;
                case 2:
                {
                    cell.myHeaderLabel.hidden = NO;
                    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
                    cell.myHeaderLabel.text = @"信用卡号";
                    cell.myTextField.hidden = YES;
                    cell.myContentLabel.hidden = NO;
                    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
                    [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
                    cell.myContentLabel.text = @"09877654321234567890987654";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.hidden = NO;
            [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
            cell.myHeaderLabel.text = @"信用卡密码";
            cell.myTextField.hidden = NO;
            [cell.myTextField setFrame:CGRectMake(110, cell.myTextField.frame.origin.y, 180, cell.myTextField.frame.size.height)];
            cell.myTextField.placeholder = @"请输入信用卡密码";
            cell.myTextField.secureTextEntry = YES;
            cell.myContentLabel.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

@end
