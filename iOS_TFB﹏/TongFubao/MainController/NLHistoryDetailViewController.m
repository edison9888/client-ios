//
//  NLHistoryDetailViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-12.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLHistoryDetailViewController.h"
#import "NLInOutcomeDetailCell.h"

@interface NLHistoryDetailViewController ()

@property(nonatomic,retain) IBOutlet UITableView* myTableView;

@end

@implementation NLHistoryDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLInOutcomeDetailCell *cell =nil;
    static NSString *kCellID = @"NLInOutcomeDetailCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    [cell.myTypeLabel setFrame:CGRectMake(cell.myTypeLabel.frame.origin.x, cell.myTypeLabel.frame.origin.y, 200, cell.myTypeLabel.frame.size.height)];
    cell.myTypeLabel.text = @"优惠券20130813678123";
    [cell.myDateLabel setFrame:CGRectMake(cell.myDateLabel.frame.origin.x, cell.myDateLabel.frame.origin.y, 200, cell.myDateLabel.frame.size.height)];
    cell.myDateLabel.text = @"800000元";
    [cell.myAmountLabel setFrame:CGRectMake(210, cell.myAmountLabel.frame.origin.y, 100, cell.myAmountLabel.frame.size.height)];
    cell.myAmountLabel.text = @"成功";
    [cell.myResultLabel setFrame:CGRectMake(210, cell.myResultLabel.frame.origin.y, 100, cell.myResultLabel.frame.size.height)];
    cell.myResultLabel.text = @"2013-08-13";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

@end
