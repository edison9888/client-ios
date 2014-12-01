//
//  NLRechargeResultViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLRechargeResultViewController.h"
#import "NLUserInforSettingsCell.h"

#define CreditCardResultCount 4
#define DepositCardResultCount 6

@interface NLRechargeResultViewController ()

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myDoneBtn;
@property(nonatomic,retain) IBOutlet UIImageView* myImageView;
@property(nonatomic,retain) IBOutlet UILabel* myLabel;

- (IBAction)onDoneBtnClicked:(id)sender;

@end

@implementation NLRechargeResultViewController

@synthesize myTableView;
@synthesize myDoneBtn;
@synthesize myRechargeFirstType;
@synthesize myRechargeResult;

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
    if (NLRechargeFirstCreditCard == self.myRechargeFirstType)
    {
//        self.navigationController.topViewController.title = @"信用卡充值(4)";
        self.navigationController.topViewController.title = @"信用卡充值";
        [self.myDoneBtn setFrame:CGRectMake(self.myDoneBtn.frame.origin.x, 280, self.myDoneBtn.frame.size.width,  self.myDoneBtn.frame.size.height)];
        [self.myTableView setFrame:CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width,  200)];
    }
    else
    {
//        self.navigationController.topViewController.title = @"储蓄卡充值(4)";
        self.navigationController.topViewController.title = @"储蓄卡充值";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDoneBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)doCreateTableViewCell:(NLUserInforSettingsCell*)cell
                  headerText:(NSString*)headerText
                 contentText:(NSString*)contentText
                contentColor:(UIColor*)contentColor
            contentAlignment:(NSTextAlignment)contentAlignment
{
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x, cell.myHeaderLabel.frame.origin.y, 100, cell.myHeaderLabel.frame.size.height)];
    cell.myHeaderLabel.text = headerText;
    cell.myContentLabel.textAlignment = contentAlignment;
    [cell.myContentLabel setFrame:CGRectMake(110, cell.myContentLabel.frame.origin.y, 180, cell.myContentLabel.frame.size.height)];
    cell.myContentLabel.textColor = contentColor;
    cell.myContentLabel.text = contentText;
}

- (void)tableViewCellForCreditCard:(NSIndexPath *)indexPath cell:(NLUserInforSettingsCell*)cell
{
    if (indexPath.row > CreditCardResultCount)
    {
        return;
    }
    
    NSString* headerText = nil;
    NSString* contentText = nil;
    NSTextAlignment contentAlignment = NSTextAlignmentLeft;
    UIColor* contentColor = [UIColor blackColor];
    
    switch (indexPath.row)
    {
        case 0:
        {
            headerText = @"交易流水号";
            contentText = @"123456789009876543211234";
        }
            break;
        case 1:
        {
            headerText = @"充值银行卡";
            contentText = @"北京银行信用卡";
        }
            break;
        case 2:
        {
            headerText = @"银行卡号";
            contentText = @"123456789009876543211234";
        }
            break;
        case 3:
        {
            headerText = @"充值金额(元)";
            contentText = @"123456789009876543211234";
            contentColor = [UIColor redColor];
        }
            break;
        default:
            break;
    }
    [self doCreateTableViewCell:cell
                     headerText:headerText
                    contentText:contentText
                   contentColor:contentColor
               contentAlignment:contentAlignment];
}

- (void)tableViewCellForDepositCard:(NSIndexPath *)indexPath cell:(NLUserInforSettingsCell*)cell
{
    if (indexPath.row > DepositCardResultCount)
    {
        return;
    }
    
    NSString* headerText = nil;
    NSString* contentText = nil;
    NSTextAlignment contentAlignment = NSTextAlignmentLeft;
    UIColor* contentColor = [UIColor blackColor];
    
    switch (indexPath.row)
    {
        case 0:
        {
            headerText = @"交易流水号";
            contentText = @"123456789009876543211234";
        }
            break;
        case 1:
        {
            headerText = @"充值银行卡";
            contentText = @"北京银行信用卡";
        }
            break;
        case 2:
        {
            headerText = @"银行卡号";
            contentText = @"123456789009876543211234";
        }
            break;
        case 3:
        {
            headerText = @"开户人姓名";
            contentText = @"习小平";
        }
            break;
        case 4:
        {
            headerText = @"身份证号";
            contentText = @"123456789009876543211234";
        }
            break;
        case 5:
        {
            headerText = @"充值金额(元)";
            contentText = @"123456789009876543211234";
            contentColor = [UIColor redColor];
        }
            break;
        default:
            break;
    }
    [self doCreateTableViewCell:cell
                     headerText:headerText
                    contentText:contentText
                   contentColor:contentColor
               contentAlignment:contentAlignment];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (NLRechargeFirstCreditCard == self.myRechargeFirstType)
    {
        return CreditCardResultCount;
    }
    else
    {
        return DepositCardResultCount;
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
    
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.myTextField.hidden = YES;
    cell.myHeaderLabel.hidden = NO;
    cell.myContentLabel.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (NLRechargeFirstCreditCard == self.myRechargeFirstType)
    {
        [self tableViewCellForCreditCard:indexPath cell:cell];
    }
    else
    {
        [self tableViewCellForDepositCard:indexPath cell:cell];
    }
    
    return cell;
}

@end
