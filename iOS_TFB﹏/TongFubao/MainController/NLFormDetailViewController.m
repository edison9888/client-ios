//
//  NLFormDetailViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLFormDetailViewController.h"
#import "NLUtils.h"
#import "NLUserInforSettingsCell.h"
#import "NLTowLinesCell.h"

@interface NLFormDetailViewController ()

@property(nonatomic,strong)IBOutlet UITableView* myTableView;

@end

@implementation NLFormDetailViewController

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
    self.navigationController.topViewController.title = @"订单详情";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; 
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    if (0 == section)
    {
        return 4;
    }
    else if (1 == section)
    {
        return 8;
    }
    
    return 5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NLUserInforSettingsCell *cell =nil;
//    static NSString *kCellID = @"NLUsersInforSettingsCell";
//    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
//    if (cell == nil)
//    {
//        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
//        cell=[temp objectAtIndex:0];
//    }
//
//    cell.myDownrightBtn.hidden = YES;
//    cell.myUprightBtn.hidden = YES;
//    cell.mySelectedBtn.hidden = YES;
//    cell.myTextField.hidden = YES;
//    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.section)
    {
        case 0:
        {
            return [self cellForSection0:tableView indexPath:indexPath];
        }
            break;
        case 1:
        {
            return [self cellForSection1:tableView indexPath:indexPath];
        }
            break;
        case 2:
        {
            return [self cellForSection2:tableView indexPath:indexPath];
        }
            break;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (2 == indexPath.section)
    {
        if (0 == indexPath.row || 1 == indexPath.row)
        {
            return 57;
        } 
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (2 == section)
    {
        return 30;
    }
    else
    {
        return 10;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (2 == section)
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
        label.text = @"订单商品信息";
        [view addSubview:label];
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        return view;
    }
    return nil;
}

-(NLUserInforSettingsCell*)createNLUserInforSettingsCell:(UITableView*)tableView
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
    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(NLTowLinesCell*)createNLTowLinesCell:(UITableView*)tableView
{
    NLTowLinesCell *cell =nil;
    static NSString *kCellID = @"NLTowLinesCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (UITableViewCell*)cellForSection0:(UITableView*)tableView indexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell* cell = [self createNLUserInforSettingsCell:tableView];
    switch (indexPath.row)
    {
        case 0:    
        {
            cell.myHeaderLabel.text = @"订单状态";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"orderstate"];
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"订单编号";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"orderno"];
        }
            break;
        case 2:
        {
            cell.myHeaderLabel.text = @"支付方式";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"orderpaytype"];
        }
            break;
        case 3:
        {
            cell.myHeaderLabel.text = @"下单时间";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"ordertime"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (UITableViewCell*)cellForSection1:(UITableView*)tableView indexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell* cell = [self createNLUserInforSettingsCell:tableView];
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"收货人";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shman"];
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"公司";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shcmpyname"];
        }
            break;
        case 2:
        {
            cell.myHeaderLabel.text = @"手机号码";
            cell.myContentLabel.text = nil;
        }
            break;
        case 3:
        {
            cell.myHeaderLabel.text = @"电话号码";
            cell.myContentLabel.text = nil;
        }
            break;
        case 4:
        {
            cell.myHeaderLabel.text = @"收货地址";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"shaddress"];;
        }
            break;
        case 5:
        {
            cell.myHeaderLabel.text = @"配送仓库";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"fhstorage"];
        }
            break;
        case 6:
        {
            cell.myHeaderLabel.text = @"配送方式";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"fhwltype"];
        }
            break;
        case 7:
        {
            cell.myHeaderLabel.text = @"订单备注";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"ordermemo"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (UITableViewCell*)cellForSection2:(UITableView*)tableView indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* c = nil;
    switch (indexPath.row)
    {
        case 0:
        {
            NLTowLinesCell* cell = [self createNLTowLinesCell:tableView];
//            NSArray* arry = [self.myDictionary objectForKey:@"msproinfo"];
//            cell.myLabel1.text = [[arry objectAtIndex:0] objectForKey:@"proname"];
//            NSString* proprice = [[arry objectAtIndex:0] objectForKey:@"proprice"];
//            NSString* pronum = [[arry objectAtIndex:0] objectForKey:@"pronum"];
//            NSString* promoney = [[arry objectAtIndex:0] objectForKey:@"promoney"];
//            cell.myLabel2Behind.text = [NSString stringWithFormat:@"%@*%@=%@",proprice,pronum,promoney];
            c = cell;
        }
            break;
        case 1:
        {
            NLTowLinesCell* cell = [self createNLTowLinesCell:tableView];
//            NSArray* arry = [self.myDictionary objectForKey:@"msproinfo"];
//            cell.myLabel1.text = [[arry objectAtIndex:5] objectForKey:@"proname"];
//            NSString* proprice = [[arry objectAtIndex:5] objectForKey:@"proprice"];
//            NSString* pronum = [[arry objectAtIndex:5] objectForKey:@"pronum"];
//            NSString* promoney = [[arry objectAtIndex:5] objectForKey:@"promoney"];
//            cell.myLabel2Behind.text = [NSString stringWithFormat:@"%@*%@=%@",proprice,pronum,promoney];
            c = cell;
        }
            break;
        case 2:
        {
            NLUserInforSettingsCell* cell = [self createNLUserInforSettingsCell:tableView];
            cell.myHeaderLabel.text = @"商品金额";
            cell.myContentLabel.text = [self.myDictionary objectForKey:@"allpromoney"];
            c = cell;
        }
            break;
        case 3:
        {
            NLUserInforSettingsCell* cell = [self createNLUserInforSettingsCell:tableView];
            cell.myHeaderLabel.text = @"运费";
            cell.myContentLabel.text = nil;
            c = cell;
        }
            break;
        case 4:
        {
            NLUserInforSettingsCell* cell = [self createNLUserInforSettingsCell:tableView];
            cell.myHeaderLabel.text = @"订单总金额";
            cell.myContentLabel.text = nil;//[self.myDictionary objectForKey:@"shaddress"];
            c = cell;
        }
            break;
            
        default:
            break;
    }
    return c;
}

@end
