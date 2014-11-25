//
//  NLMoreOrderQueryViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-25.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLMoreOrderQueryViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLStartOrderQueryViewController.h"

@interface NLMoreOrderQueryViewController ()

@property(nonatomic, strong)IBOutlet UITableView* myTableView;

@end

@implementation NLMoreOrderQueryViewController

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
    self.navigationController.topViewController.title = @"更多查询";
    [self setExtraCellLineHidden:self.myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.myTableView setTableFooterView:view];
    [self.myTableView setTableHeaderView:view];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myArray count];
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
    cell.myTextField.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.myDownrightImage.hidden = YES;
    cell.myContentLabel.hidden = YES;
    cell.myUprightImage.hidden = NO;
    [cell.myUprightImage setFrame:CGRectMake(10, 7, 30, 30)];
    cell.myUprightImage.image = [UIImage imageNamed:@"orderPay.png"];
    cell.myHeaderLabel.hidden = NO;
    [cell.myHeaderLabel setFrame:CGRectMake(50, 7, 100, 30)];
    cell.myHeaderLabel.textAlignment = NSTextAlignmentLeft;
    cell.myHeaderLabel.text = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"comname"];
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NLStartOrderQueryViewController* vc = [[NLStartOrderQueryViewController alloc] initWithNibName:@"NLStartOrderQueryViewController" bundle:nil];
    vc.myCompanyName = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"comname"];
    vc.myCompanyCom = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"com"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
