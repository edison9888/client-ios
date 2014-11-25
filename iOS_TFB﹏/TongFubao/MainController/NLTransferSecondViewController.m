//
//  NLTransferSecondViewController.m
//  TongFubao
//
//  Created by MD313 on 13-10-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLTransferSecondViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLUtils.h"
#import "NLTransferThirdViewController.h"

@interface NLTransferSecondViewController ()

@property(nonatomic,strong)IBOutlet UITableView* myTableView;
@property(nonatomic,strong)IBOutlet UIButton* myButton;

-(IBAction)onButtonBtnClicked:(id)sender;

@end

@implementation NLTransferSecondViewController

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
    self.navigationController.topViewController.title = @"核对信息";
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

//核对完成的按钮
-(IBAction)onButtonBtnClicked:(id)sender
{
    NLTransferThirdViewController* vc = [[NLTransferThirdViewController alloc] initWithNibName:@"NLTransferThirdViewController" bundle:nil];
    vc.myDictionary = [NSDictionary dictionaryWithDictionary:self.myDictionary];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
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
    cell.myContentLabel.hidden = NO;
    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.myTextField.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"收款银行";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shoucardbank"];
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"收款卡号";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shoucardno"];
        }
            break;
        case 2:
        {
            cell.myHeaderLabel.text = @"收款姓名";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shoucardman"];
        }
            break;
        case 3:
        {
            cell.myHeaderLabel.text = @"转账金额";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"paymoney"];
        }
            break;
        case 4:
        {
            cell.myHeaderLabel.text = @"到账方式";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"arriveidStr"];
        }
            break;
        case 5:
        {
            cell.myHeaderLabel.text = @"手机号码";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shoucardmobile"];
        }
            break;
        case 6:
        {
            cell.myHeaderLabel.text = @"手续费";
            cell.myContentLabel.text = [NSString stringWithFormat:@"%@元",[self.myDictionary objectForKey:@"payfee"]];
        }
            break;
        case 7:
        {
            cell.myHeaderLabel.text = @"刷卡金额";
            cell.myContentLabel.text = [NSString stringWithFormat:@"%@元",[self.myDictionary objectForKey:@"money"]];
        }
            break;
        case 8:
        {
            cell.myHeaderLabel.text = @"备注";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shoucardmemo"];
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
    label.text = @"请核对信息";
    [view addSubview:label];
    return view;
}

@end








