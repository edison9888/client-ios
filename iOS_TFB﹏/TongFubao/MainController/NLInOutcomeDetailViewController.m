//
//  NLInOutcomeDetailViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLInOutcomeDetailViewController.h"
#import "NLInOutcomeDetailCell.h"
#import "NLInOutcomeDetailHeaderCell.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"
#import "NLProtocolRequest.h"
#import "NLTransferResultViewController.h"

#define NLMONTH @"month"
#define NLINCOME @"income"
#define NLOUTCOME @"outcome"
#define NLDATE @"date"
#define NLRESULT @"result"
#define NLTYPE @"type"
#define NLAMOUNT @"amount"

@interface NLInOutcomeDetailViewController ()
{
    int _monthIndex;
    BOOL _readAccglistdetail;
    NLProgressHUD* _hud;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) NSMutableArray* myHeaderArray;
@property(nonatomic, retain) NSMutableArray* myCellArray;

@end

@implementation NLInOutcomeDetailViewController

@synthesize myTableView;
@synthesize myCellArray;
@synthesize myHeaderArray;

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
    [super viewDidAppear:animated];
    if (animated)
    {
        [self.myTableView flashScrollIndicators];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.topViewController.title = @"收支详情";
    _monthIndex = -1;
    _readAccglistdetail = NO;
    self.myHeaderArray = [NSMutableArray arrayWithCapacity:1];
    self.myCellArray = [NSMutableArray arrayWithCapacity:1];
    [self readAccglist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadHeaderArray
{
    if ([self.myHeaderArray count] == 0)
    {
        self.myHeaderArray = [NSMutableArray arrayWithCapacity:1];
    }
    else
    {
        [self.myHeaderArray removeAllObjects];
    }
    
    for (int i = 0; i < 12; i++)
    {
        NSString* str = [NSString stringWithFormat:@"%d月",i+1];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:str,NLMONTH,
                             @"12345678901234567890",NLINCOME,
                             @"12345678901234567890",NLOUTCOME, nil];
        [self.myHeaderArray addObject:dic];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = [self.myHeaderArray count];
    return count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _monthIndex)
    {
       return [self.myCellArray count]; 
    }
    else
    {
        return 0;
    }
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
    //int section = indexPath.section;
    NSDictionary*dic = [self.myCellArray objectAtIndex:indexPath.row];
    cell.myTypeLabel.text = [dic objectForKey:@"accgpaymode"];
    cell.myDateLabel.text = [dic objectForKey:@"accglistdate"];
    cell.myAmountLabel.text = [dic objectForKey:@"accglistmoney"];
    cell.myResultLabel.text = nil;//[dic objectForKey:@"accgpaymode"];
    cell.myBackImageView.hidden = YES;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the root controller
//    int row = indexPath.row;
//    switch (row)
//    {
//        case 0:
//        {
//
//        }
//            break;
//        case 1:
//        {
//
//        }
//            break;
//
//        default:
//            break;
//    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
    
    [self createInforForResultView:vc index:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray* temp = [[NSBundle mainBundle] loadNibNamed:@"NLInOutcomeDetailHeaderCell" owner:self options:nil];
    NLInOutcomeDetailHeaderCell* header = [temp objectAtIndex:0];
    header.myContainer = self;
    NSString* month = [[self.myHeaderArray objectAtIndex:section] objectForKey:@"accmonth"];
    header.myMonthLabel.text = [NSString stringWithFormat:@"%@月",month];
    header.myIncomeLabel.text = [[self.myHeaderArray objectAtIndex:section] objectForKey:@"accincome"];
    header.myOutcomeLabel.text = [[self.myHeaderArray objectAtIndex:section] objectForKey:@"accpayout"];
    if (section == _monthIndex)
    {
       [header.myArrowBtn setBackgroundImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
        header.myArrowBtn.transform = CGAffineTransformMakeRotation(1.57);
        header.myDownArrow = YES;
    }
    else
    {
        [header.myArrowBtn setBackgroundImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
        header.myDownArrow = NO;
    }
    header.myArrowBtn.tag = section;
    //header.myDownArrow = [[self.myShowArray objectAtIndex:section] boolValue];
    UIView *view = [[UIView alloc]initWithFrame:header.frame];
    [view addSubview:header];
    return view;
//    return header;
}

-(void)createInforForResultView:(NLTransferResultViewController*)vc index:(int)index
{
    
//    accgcardno 充值卡号
//    accgcardbank   充值银行
    
    NSDictionary* dictionary = [self.myCellArray objectAtIndex:index];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易类别",@"header", [dictionary objectForKey:@"accgpaymode"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易流水号",@"header", [dictionary objectForKey:@"accglistno"],@"content", nil];
    [arr addObject:dic];
    
    if ([[dictionary objectForKey:@"accgpaymode"] isEqualToString:@"充值"])  
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值银行",@"header", [dictionary objectForKey:@"accgcardbank"],@"content", nil];
        [arr addObject:dic];
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"充值卡号",@"header", [dictionary objectForKey:@"accgcardno"],@"content", nil];
        [arr addObject:dic];
    }
    else if([[dictionary objectForKey:@"accgpaymode"] isEqualToString:@"购买抵用券"])
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", [dictionary objectForKey:@"accgcardbank"],@"content", nil];
        [arr addObject:dic];
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", [dictionary objectForKey:@"accgcardno"],@"content", nil];
        [arr addObject:dic];
    }
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [dictionary objectForKey:@"accglistmoney"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易时间",@"header", [dictionary objectForKey:@"accglistdate"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易状态",@"header", [dictionary objectForKey:@"accgstate"],@"content", nil];
    [arr addObject:dic];
    
    vc.myArray = [NSArray arrayWithArray:arr];
    vc.myType = 1;
    vc.myNavigationTitle = @"交易详情";
}

#pragma mark - doArrowBtnEvent

-(void)doArrowBtnEvent:(NLInOutcomeDetailHeaderCell*)header
{
    BOOL value = (_monthIndex == header.myArrowBtn.tag);
    if (!value)
    {
        if (_readAccglistdetail)
        {
            NSString* name = [NLUtils getNameForRequest:Notify_readAccglistdetail];
            REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, name);
            
            [self.myCellArray removeAllObjects];
            int old = _monthIndex;
            _monthIndex = -1;
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:old]
                            withRowAnimation:UITableViewRowAnimationFade];
            
            _monthIndex = header.myArrowBtn.tag;
            [self readAccglistdetail];
        }
        else
        {
            _monthIndex = header.myArrowBtn.tag;
            [self readAccglistdetail];
        }
    }
    else
    {
        [self.myCellArray removeAllObjects];
        int old = _monthIndex;
        _monthIndex = -1;
        _readAccglistdetail = NO;
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:old]
                        withRowAnimation:UITableViewRowAnimationFade];
    }
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
    if ([self.myHeaderArray count] > 0)
    {
        [self.myTableView reloadData];
    }
}

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    return str;
}

#pragma mark - http request

-(void)doReadAccglistNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = nil;
    NSArray* accmonth = [response.data find:@"msgbody/msgchild/accmonth"];
    NSString* accmonthStr = nil;
    NSArray* accincome = [response.data find:@"msgbody/msgchild/accincome"];
    NSString* accincomeStr = nil;
    NSArray* accpayout = [response.data find:@"msgbody/msgchild/accpayout"];
    NSString* accpayoutStr = nil;
    
    [self.myCellArray removeAllObjects];
    int count = [accmonth count];
    for (int i=0; i<count; i++)
    {
        data = [accmonth objectAtIndex:i];
        accmonthStr = [self getNoNilStr:data.value];
        data = [accincome objectAtIndex:i];
        accincomeStr = [self getNoNilStr:data.value];
        data = [accpayout objectAtIndex:i];
        accpayoutStr = [self getNoNilStr:data.value];
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:accmonthStr,@"accmonth",accincomeStr,@"accincome",accpayoutStr,@"accpayout", nil];
        [self.myHeaderArray addObject:dic];
    }
    [self refresh];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

-(void)readAccglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    NSString* detail = response.detail;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self doReadAccglistNotify:response];
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readAccglist
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAccglist];
    REGISTER_NOTIFY_OBSERVER(self, readAccglistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAccglist:self.myAcctypeid];
    [self showErrorInfo:nil status:NLHUDState_None];
}

-(void)doReadAccglistdetailNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = nil;
    NSArray* accglistno = [response.data find:@"msgbody/msgchild/accglistno"];
    NSString* accglistnoStr = nil;
    NSArray* accgpaymode = [response.data find:@"msgbody/msgchild/accgpaymode"];
    NSString* accgpaymodeStr = nil;
    NSArray* accglistmoney = [response.data find:@"msgbody/msgchild/accglistmoney"];
    NSString* accglistmoneyStr = nil;
    NSArray* accglistdate = [response.data find:@"msgbody/msgchild/accglistdate"];
    NSString* accglistdateStr = nil;
    NSArray* accglistid = [response.data find:@"msgbody/msgchild/accglistid"];
    NSString* accglistidStr = nil;
    NSArray* accgstate = [response.data find:@"msgbody/msgchild/accgstate"];
    NSString* accgstateStr = nil;
    
    //    accgcardno 充值卡号
    //    accgcardbank   充值银行
    
    NSArray* accgcardno = [response.data find:@"msgbody/msgchild/accgcardno"];
    NSString* accgcardnoStr = nil;
    NSArray* accgcardbank = [response.data find:@"msgbody/msgchild/accgcardbank"];
    NSString* accgcardbankStr = nil;
    
    [self.myCellArray removeAllObjects];
    int count = [accglistno count];
    for (int i=0; i<count; i++)
    {
        data = [accglistno objectAtIndex:i];
        accglistnoStr = [self getNoNilStr:data.value];
        data = [accgpaymode objectAtIndex:i];
        accgpaymodeStr = [self getNoNilStr:data.value];
        data = [accglistmoney objectAtIndex:i];
        accglistmoneyStr = [self getNoNilStr:data.value];
        data = [accglistdate objectAtIndex:i];
        accglistdateStr = [self getNoNilStr:data.value];
        data = [accglistid objectAtIndex:i];
        accglistidStr = [self getNoNilStr:data.value];
        data = [accgstate objectAtIndex:i];
        accgstateStr = [self getNoNilStr:data.value];
        
        NSDictionary* dic =nil;
        
        if ([accgpaymodeStr isEqualToString:@"充值"])
        {
            
            data = [accgcardno objectAtIndex:i];
            accgcardnoStr = [self getNoNilStr:data.value];
            data = [accgcardbank objectAtIndex:i];
            accgcardbankStr = [self getNoNilStr:data.value];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:accglistnoStr,@"accglistno",accgpaymodeStr,@"accgpaymode",accglistmoneyStr,@"accglistmoney",accgcardnoStr,@"accgcardno",accgcardbankStr,@"accgcardbank",accglistdateStr,@"accglistdate",accglistidStr,@"accglistid",accgstateStr,@"accgstate",nil];
        }
        else if([accgpaymodeStr isEqualToString:@"购买抵用券"])
        {
            
            data = [accgcardno objectAtIndex:i];
            accgcardnoStr = [self getNoNilStr:data.value];
            data = [accgcardbank objectAtIndex:i];
            accgcardbankStr = [self getNoNilStr:data.value];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:accglistnoStr,@"accglistno",accgpaymodeStr,@"accgpaymode",accglistmoneyStr,@"accglistmoney",accgcardnoStr,@"accgcardno",accgcardbankStr,@"accgcardbank",accglistdateStr,@"accglistdate",accglistidStr,@"accglistid",accgstateStr,@"accgstate",nil];
        }
        else
        {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:accglistnoStr,@"accglistno",accgpaymodeStr,@"accgpaymode",accglistmoneyStr,@"accglistmoney",accglistdateStr,@"accglistdate",accglistidStr,@"accglistid",accgstateStr,@"accgstate",nil];
        }
        [self.myCellArray addObject:dic];
    }
    if (_monthIndex>=0 && _monthIndex<[self.myHeaderArray count])
    {
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:_monthIndex]
                        withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)readAccglistdetailNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    NSString* detail = response.detail;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self doReadAccglistdetailNotify:response];
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
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readAccglistdetail
{
    NSString* name = [NLUtils getNameForRequest:Notify_readAccglistdetail];
    REGISTER_NOTIFY_OBSERVER(self, readAccglistdetailNotify, name);
    _readAccglistdetail = YES;
    [[[NLProtocolRequest alloc] initWithRegister:YES] readAccglistdetail:self.myAcctypeid
                                                                   month:[[self.myHeaderArray objectAtIndex:_monthIndex] objectForKey:@"accmonth"]];
    [self showErrorInfo:nil status:NLHUDState_None];
}

@end
