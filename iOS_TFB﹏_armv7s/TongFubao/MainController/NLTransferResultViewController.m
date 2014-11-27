//
//  NLTransferResultViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-8.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLTransferResultViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLUtils.h"
#import "NLContants.h"

@interface NLTransferResultViewController ()

@property(nonatomic,retain) IBOutlet UIButton* myFinishedBtn;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UIImageView* myImageView;
@property(nonatomic,retain) IBOutlet UILabel* myLabel;

- (IBAction)onFinishedBtnClicked:(UIButton *)sender;

@end

@implementation NLTransferResultViewController

@synthesize myFinishedBtn;
@synthesize myImageView; @synthesize myLabel;
@synthesize myTableView;

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
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initControllers];
}

-(void)initControllers
{
//     [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    self.navigationItem.hidesBackButton = self.buyType? NO : YES;
    
    if (1 == self.myType)
    {
        self.navigationController.topViewController.title = self.myNavigationTitle;
        self.myLabel.hidden = YES;
        self.myImageView.hidden = YES;
        self.myFinishedBtn.hidden = YES;
        [self.myTableView setFrame:CGRectMake(self.myTableView.frame.origin.x,0, self.myTableView.frame.size.width, 416)];
        
        IOS6_7_DELTA(self.myTableView, 0, 64, 0, 0);
    }
    else
    {
        self.navigationController.topViewController.title = self.myNavigationTitle;
        self.myLabel.hidden = NO;
        self.myImageView.hidden = NO;
        self.myFinishedBtn.hidden = NO;
        self.myLabel.text = self.myTitle;
    }
    if (self.buyType)
    {
        self.againBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFinishedBtnClicked:(UIButton *)sender
{
    if (sender.tag==1)
    {
        NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate backToMain];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"renovateData" object:nil];
    }
    else
    {
      [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}

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
    
    cell.myTextField.hidden = YES;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.myHeaderLabel.hidden = NO;
    cell.myHeaderLabel.text = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"header"];
    cell.myContentLabel.hidden = NO;
    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
    cell.myContentLabel.text = [[self.myArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    return cell;
}


@end
