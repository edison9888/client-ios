//
//  NLOrderPayThirdViewController.m
//  TongFubao
//
//  Created by MD313 on 13-10-8.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLOrderPayThirdViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLUtils.h"
#import "NLOrderPayForthViewController.h"

@interface NLOrderPayThirdViewController ()

@property(nonatomic,strong)IBOutlet UITableView* myTableView;
@property(nonatomic,strong)IBOutlet UIButton* myButton;

-(IBAction)onButtonBtnClicked:(id)sender;

@end

@implementation NLOrderPayThirdViewController

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
    self.navigationController.topViewController.title = @"确认付款";
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

-(IBAction)onButtonBtnClicked:(id)sender
{
    NLOrderPayForthViewController* vc = [[NLOrderPayForthViewController alloc] initWithNibName:@"NLOrderPayForthViewController"
                                                                                        bundle:nil];
    vc.myDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self.myDictionary objectForKey:@"orderno"],@"orderno",[self.myDictionary objectForKey:@"ordermoney"],@"ordermoney",[self.myDictionary objectForKey:@"cardno"],@"cardno",[self.myDictionary objectForKey:@"bankname"],@"bankname",[self.myDictionary objectForKey:@"orderid"],@"orderid",[self.myDictionary objectForKey:@"merReserved"],@"merReserved", nil];
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
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.myContentLabel.hidden = NO;
    cell.mySelectedBtn.hidden = YES;
    cell.myTextField.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"订单编号";
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"orderno"];
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"支付金额";
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"ordermoney"];
        }
            break;
        case 2:
        {
            cell.myHeaderLabel.text = @"刷卡金额";
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"ordermoney"];
        }
            break;
        case 3:
        {
            cell.myHeaderLabel.text = @"付款卡号";
            cell.myContentLabel.hidden = NO;
            cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"cardno"];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
