//
//  NLMyWalletViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLMyWalletViewController.h"
#import "NLRechargeViewController.h"
#import "NLUserInforSettingsCell.h"
#import "NLInOutcomeDetailViewController.h"
#import "NLRechargeViewController.h"
#import "NLUtils.h"
#import "NLProtocolRequest.h"
#import "NLProgressHUD.h"
#import "NLFormQueryViewController.h"

@interface NLMyWalletViewController ()
{
    NLProgressHUD* _hud;
    NSString* _accallmoney;
    int _numberOfSections;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) IBOutlet UIButton* myTransferBtn;
@property(nonatomic,retain) IBOutlet UIButton* myRechargeBtn;
@property(nonatomic,retain) NSMutableArray* myMoneyArray;

- (IBAction)onTransferBtnClicked:(id)sender;
- (IBAction)onRechargeBtnClicked:(id)sender;

@end

@implementation NLMyWalletViewController

@synthesize myTableView;
@synthesize myRechargeBtn;
@synthesize myTransferBtn;

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
    [self readMyAccount];
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
    self.navigationController.topViewController.title = @"我的钱包";
    
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"收支明细"
//                                                                      style:UIBarButtonItemStyleBordered
//                                                                     target:self
//                                                                     action:@selector(detail)];
//    self.navigationItem.rightBarButtonItem = anotherButton;
    [self initValue];
}

-(void)initValue
{
    _accallmoney = @"";
    _numberOfSections = 1;
    self.myMoneyArray = [NSMutableArray arrayWithCapacity:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)detail:(NSString*)acctypeid
{
    NLInOutcomeDetailViewController* vc = [[NLInOutcomeDetailViewController alloc] initWithNibName:@"NLInOutcomeDetailViewController" bundle:nil];
    vc.myAcctypeid = acctypeid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTransferBtnClicked:(id)sender
{
    NLFormQueryViewController* vc = [[NLFormQueryViewController alloc] initWithNibName:@"NLFormQueryViewController"
                                                                                bundle:nil];
    vc.myFormQueryType = FormQuery_FormPay;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onRechargeBtnClicked:(id)sender
{
    NLRechargeViewController*vc = [[NLRechargeViewController alloc] initWithNibName:@"NLRechargeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    
    return;
}

-(void)refresh
{
    if ([self.myMoneyArray count] > 0)
    {
        _numberOfSections = 2;
        int h = 44*[self.myMoneyArray count] + 80;
        [self.myTableView setFrame:CGRectMake(self.myTableView.frame.origin.x,self.myTableView.frame.origin.y, self.myTableView.frame.size.width, h)];
        h = self.myTableView.frame.origin.y + h + 10;
        [self.myRechargeBtn setFrame:CGRectMake(self.myRechargeBtn.frame.origin.x,h, self.myRechargeBtn.frame.size.width, self.myRechargeBtn.frame.size.height)];
        [self.myTransferBtn setFrame:CGRectMake(self.myTransferBtn.frame.origin.x,h, self.myTransferBtn.frame.size.width, self.myTransferBtn.frame.size.height)];
        
        [self.myTableView reloadData];
    }
    else
    {
        _numberOfSections = 1;
        int h = 60;
        [self.myTableView setFrame:CGRectMake(self.myTableView.frame.origin.x,self.myTableView.frame.origin.y, self.myTableView.frame.size.width, h)];
        h = self.myTableView.frame.origin.y + h + 10;
        [self.myRechargeBtn setFrame:CGRectMake(self.myRechargeBtn.frame.origin.x,h, self.myRechargeBtn.frame.size.width, self.myRechargeBtn.frame.size.height)];
        [self.myTransferBtn setFrame:CGRectMake(self.myTransferBtn.frame.origin.x,h, self.myTransferBtn.frame.size.width, self.myTransferBtn.frame.size.height)];
        
        [self.myTableView reloadData];
    }
    
    IOS6_7_DELTA(self.myTableView, 0, 0, 0, 64);
    IOS6_7_DELTA(self.myRechargeBtn, 0, 64, 0, 0);
    IOS6_7_DELTA(self.myTransferBtn, 0, 64, 0, 0);
}

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    return str;
}

-(void)doReadMyAccountNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/accallmoney" index:0];
    _accallmoney = data.value;
    
    NSArray* acctypeid = [response.data find:@"msgbody/msgchild/acctypeid"];
    NSString* acctypeidStr = nil;
    NSArray* acctypename = [response.data find:@"msgbody/msgchild/acctypename"];
    NSString* acctypenameStr = nil;
    NSArray* accmoney = [response.data find:@"msgbody/msgchild/accmoney"];
    NSString* accmoneyStr = nil;
    
    int count = [acctypeid count];
    for (int i=0; i<count; i++)
    {
        data = [acctypeid objectAtIndex:i];
        acctypeidStr = [self getNoNilStr:data.value];
        data = [acctypename objectAtIndex:i];
        acctypenameStr = [self getNoNilStr:data.value];
        data = [accmoney objectAtIndex:i];
        accmoneyStr = [self getNoNilStr:data.value];
    
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:acctypeidStr,@"acctypeid",acctypenameStr,@"acctypename",accmoneyStr,@"accmoney", nil];
        [self.myMoneyArray addObject:dic];
    }
    [self refresh];
}

-(void)readMyAccountNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    NSString* detail = response.detail;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self doReadMyAccountNotify:response];
//        [self.myTableView reloadData];
        
        [_hud hide:YES];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readMyAccount
{
    NSString* name = [NLUtils getNameForRequest:Notify_readMyAccount];
    REGISTER_NOTIFY_OBSERVER(self, readMyAccountNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readMyAccount];
    [self showErrorInfo:nil status:NLHUDState_None];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _numberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
       return 1;
    }
    else if (1 == section)
    {
       return [self.myMoneyArray count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell *cell =nil;
    static NSString *kCellID = @"NLUserInforSettingsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    cell.myHeaderLabel.hidden = NO;
    cell.myContentLabel.hidden = NO;
    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
    cell.myTextField.hidden = YES;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.myHeaderLabel.text = @"钱包总额";
                    if (_accallmoney.length > 0)
                    {
                        cell.myContentLabel.text = [NSString stringWithFormat:@"%@元",_accallmoney];
                    }
                    else
                    {
                        cell.myContentLabel.text = @"0元";
                    }
                }
                    break;
                    
                default:
                    break;
            }
        } 
            break;
        case 1:
        { 
            cell.myHeaderLabel.text = [[self.myMoneyArray objectAtIndex:indexPath.row] objectForKey:@"acctypename"];
            NSString* money = [[self.myMoneyArray objectAtIndex:indexPath.row] objectForKey:@"accmoney"];
            cell.myContentLabel.text = [NSString stringWithFormat:@"%@元",money];
        }
            
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the root controller
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.section)
    {
        [self detail:@"0"];
    }
    else
    {
        [self detail:[[self.myMoneyArray objectAtIndex:indexPath.row] objectForKey:@"acctypeid"]];
    }
}

- (void) doPush
{
    [_hud hide:YES];
    
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
