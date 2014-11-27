//
//  NLCashArriveHistoryViewController.m
//  TongFubao
//
//  Created by MD313 on 13-8-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLCashArriveHistoryViewController.h"
#import "NLProtocolRequest.h"
#import "NLProtocolData.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"
#import "NLInOutcomeDetailCell.h"
#import "NLTransferResultViewController.h"
#import "MJRefresh.h"

@interface NLCashArriveHistoryViewController () <MJRefreshBaseViewDelegate>
{
    NLProgressHUD* _hud;
    NSString* _msgstart;
    NSString* _msgdisplay;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    BOOL _shouldFree;
}

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain) NSMutableArray* myArray;

@end

@implementation NLCashArriveHistoryViewController

-(void)viewDidAppear:(BOOL)animated
{
    [self initMJRefresh];
    
    _shouldFree = YES;
    
    [NLUtils enableSliderViewController:NO];
    
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_shouldFree)
    {
        [_footer free];
        [_header free];
        _footer = nil;
        _header = nil;
    }
    
    [NLUtils enableSliderViewController:YES];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.topViewController.title = @"历史记录";
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.myArray = [NSMutableArray arrayWithCapacity:1];
    
    _msgstart = @"0";
    _msgdisplay = @"5";
    _shouldFree = YES;
    
    [self setExtraCellLineHidden:self.myTableView];
    [self protocolRequest];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

-(void)initMJRefresh
{
    // 下拉刷新
    if (_header == nil)
    {
        _header = [[MJRefreshHeaderView alloc] init];
        _header.delegate = self;
        _header.scrollView = self.myTableView;
        
//        [_header endRefreshing];
//        [_footer endRefreshing];
    }
    
    // 上拉加载更多
    if (_footer == nil)
    {
        _footer = [[MJRefreshFooterView alloc] init];
        _footer.delegate = self;
        _footer.scrollView = self.myTableView;
        
//        [_header endRefreshing];
//        [_footer endRefreshing];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = detail;
            [_hud show:YES];
        }
        default:
            break;
    }
    return;
}

-(void)doCouponSalelistNotify:(NLProtocolResponse*)response
{
    /*
     couponno   券号
     couponmoney    金额
     coupondate 购买时间
     paycardid  刷卡器设备号
     couponid   抵用券号
     couponmemo 其他描述
     couponbank 付款银行
     couponcardno   付款卡号
     */
    
    NSArray* coupondate = [response.data find:@"msgbody/msgchild/coupondate"];
    NSArray* couponno = [response.data find:@"msgbody/msgchild/couponno"];
    NSArray* couponmoney = [response.data find:@"msgbody/msgchild/couponmoney"];
    
    NSArray* paycardid = [response.data find:@"msgbody/msgchild/paycardid"];
    NSArray* couponid = [response.data find:@"msgbody/msgchild/couponid"];
    NSArray* couponbank = [response.data find:@"msgbody/msgchild/couponbank"];
    NSArray* couponcardno = [response.data find:@"msgbody/msgchild/couponcardno"];
    NSArray* couponmemo = [response.data find:@"msgbody/msgchild/couponmemo"];
    
    NSString* coupondateStr = nil;
    NSString* couponnoStr = nil;
    NSString* couponmoneyStr = nil;
    
    NSString* paycardidStr = nil;
    NSString* couponidStr = nil;
    NSString* couponmemoStr = nil;
    
    NSString* couponbankStr = nil;
    NSString* couponcardnoStr = nil;
    
    for (int i=0; i<[couponno count]; i++)
    {
        NLProtocolData* data = [coupondate objectAtIndex:i];
        coupondateStr = [self checkInfo:data.value];
        data = [couponno objectAtIndex:i];
        couponnoStr = [self checkInfo:data.value];
        data = [couponmoney objectAtIndex:i];
        couponmoneyStr = [self checkInfo:data.value];
        
        data = [paycardid objectAtIndex:i];
        paycardidStr = [self checkInfo:data.value];
        data = [couponid objectAtIndex:i];
        couponidStr = [self checkInfo:data.value];
        
        data = [couponbank objectAtIndex:i];
        couponbankStr = [self checkInfo:data.value];
        data = [couponcardno objectAtIndex:i];
        couponcardnoStr = [self checkInfo:data.value];
        
        
        data = [couponmemo objectAtIndex:i];//这个是其他描述，一般为空。
        couponmemoStr = data.value;
        
         NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:coupondateStr, @"coupondate", couponnoStr, @"couponno", couponmoneyStr, @"couponmoney", paycardidStr, @"paycardid", couponidStr, @"couponid", couponbankStr, @"couponbank", couponcardnoStr, @"couponcardno", couponmemoStr, @"couponmemo", nil];
        [self.myArray addObject:dic];
    }
}

-(void)couponSalelistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doCouponSalelistNotify:response];
//        self.myTableView.hidden = NO;
        [self.myTableView reloadData];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
        //self.myTableView.hidden = YES;
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString* detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)couponSalelist
{
    NSString* name = [NLUtils getNameForRequest:Notify_couponSalelist];
    REGISTER_NOTIFY_OBSERVER(self, couponSalelistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] couponSalelist:_msgstart
                                                          msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)doReadCreditCardglistNotify:(NLProtocolResponse*)response
{
    /*
     ccgno  流水号
     ccgtime    交易时间
     huancardno 还款卡号
     huancardbank 还款银行
     fucardno   付款卡号
     fucardbank 付款银行
     paymoney   还款金额
     feemoney   手续费
     allmoney   总额
     state  状态
    */
    
    NSArray* ccgtime = [response.data find:@"msgbody/msgchild/ccgtime"];
    NSArray* ccgno = [response.data find:@"msgbody/msgchild/ccgno"];
    NSArray* message = [response.data find:@"msgbody/msgchild/state"];
    NSArray* allmoney = [response.data find:@"msgbody/msgchild/allmoney"];
    NSArray* huancardno = [response.data find:@"msgbody/msgchild/huancardno"];
    NSArray* fucardno = [response.data find:@"msgbody/msgchild/fucardno"];
    NSArray* feemoney = [response.data find:@"msgbody/msgchild/feemoney"];
    
    
    NSArray* huancardbank = [response.data find:@"msgbody/msgchild/huancardbank"];
    NSArray* fucardbank = [response.data find:@"msgbody/msgchild/fucardbank"];
    
    
    NSString* ccgtimeStr = nil;
    NSString* ccgnoStr = nil;
    NSString* messageStr = nil;
    NSString* allmoneyStr = nil;
    NSString* huancardnoStr = nil;
    NSString* fucardnoStr = nil;
    NSString* feemoneyStr = nil;
    
    NSString* huancardbankStr = nil;
    NSString* fucardbankStr = nil;
    
    for (int i=0; i<[ccgno count]; i++)
    {
        NLProtocolData* data = [ccgtime objectAtIndex:i];
        ccgtimeStr = data.value;
        data = [ccgno objectAtIndex:i];
        ccgnoStr = data.value;
        data = [message objectAtIndex:i];
        messageStr = data.value;
        data = [allmoney objectAtIndex:i];
        allmoneyStr = data.value;
        data = [huancardno objectAtIndex:i];
        huancardnoStr = data.value;
        data = [fucardno objectAtIndex:i];
        fucardnoStr = data.value;
        data = [feemoney objectAtIndex:i];
        feemoneyStr = data.value;
        
        data = [huancardbank objectAtIndex:i];
        huancardbankStr = data.value;
        data = [fucardbank objectAtIndex:i];
        fucardbankStr = data.value;
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:ccgtimeStr, @"ccgtime", ccgnoStr, @"ccgno", messageStr, @"message", allmoneyStr, @"allmoney", huancardnoStr, @"huancardno", huancardbankStr, @"huancardbank", fucardnoStr, @"fucardno", fucardbankStr, @"fucardbank", feemoneyStr, @"feemoney", nil];
        [self.myArray addObject:dic];
    }
}

-(void)readCreditCardglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadCreditCardglistNotify:response];
//        self.myTableView.hidden = NO;
        [self.myTableView reloadData];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
        //self.myTableView.hidden = YES;
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readCreditCardglist
{
    NSString* name = [NLUtils getNameForRequest:Notify_readCreditCardglist];
    REGISTER_NOTIFY_OBSERVER(self, readCreditCardglistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readCreditCardglist:@"pay"
                                                                 msgstart:_msgstart
                                                               msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)doReadRepayMoneyglistNotify:(NLProtocolResponse*)response
{
    /*
     ccgno  流水号
     ccgtime    交易时间
     huancardno 还贷卡号
     huancardbank   还贷银行
     fucardno   付款卡号
     fucardbank 付款银行
     paymoney   还贷金额
     feemoney   手续费
     allmoney   总额
     state  状态
     */
    
    NSArray* ccgtime = [response.data find:@"msgbody/msgchild/ccgtime"];
    NSArray* ccgno = [response.data find:@"msgbody/msgchild/ccgno"];
    NSArray* state = [response.data find:@"msgbody/msgchild/state"];
    NSArray* allmoney = [response.data find:@"msgbody/msgchild/allmoney"];
    
    NSArray* huancardno = [response.data find:@"msgbody/msgchild/huancardno"];
    NSArray* huancardbank = [response.data find:@"msgbody/msgchild/huancardbank"];
    NSArray* fucardno = [response.data find:@"msgbody/msgchild/fucardno"];
    NSArray* fucardbank = [response.data find:@"msgbody/msgchild/fucardbank"];
    NSArray* paymoney = [response.data find:@"msgbody/msgchild/paymoney"];
    NSArray* feemoney = [response.data find:@"msgbody/msgchild/feemoney"];
    
    NSString* ccgtimeStr = nil;
    NSString* ccgnoStr = nil;
    NSString* stateStr = nil;
    NSString* allmoneyStr = nil;
    NSString* huancardnoStr = nil;
    NSString* huancardbankStr = nil;
    NSString* fucardnoStr = nil;
    NSString* paymoneyStr = nil;
    NSString* feemoneyStr = nil;
    NSString* fucardbankStr = nil;
    
    for (int i=0; i<[ccgno count]; i++)
    {
        NLProtocolData* data = [ccgtime objectAtIndex:i];
        ccgtimeStr = [self checkInfo:data.value];
        data = [ccgno objectAtIndex:i];
        ccgnoStr = [self checkInfo:data.value];
        data = [state objectAtIndex:i];
        stateStr = [self checkInfo:data.value];
        data = [allmoney objectAtIndex:i];
        allmoneyStr = [self checkInfo:data.value];
        
        data = [huancardno objectAtIndex:i];
        huancardnoStr = [self checkInfo:data.value];
        data = [huancardbank objectAtIndex:i];
        huancardbankStr = [self checkInfo:data.value];
        data = [fucardno objectAtIndex:i];
        fucardnoStr = [self checkInfo:data.value];
        data = [paymoney objectAtIndex:i];
        paymoneyStr = [self checkInfo:data.value];
        data = [feemoney objectAtIndex:i];
        feemoneyStr = [self checkInfo:data.value];
        
        data = [fucardbank objectAtIndex:i];
        fucardbankStr = [self checkInfo:data.value];
        
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:ccgtimeStr, @"ccgtime", ccgnoStr, @"ccgno", stateStr, @"state", allmoneyStr, @"allmoney", huancardnoStr, @"huancardno", huancardbankStr, @"huancardbank", fucardnoStr, @"fucardno",  fucardbankStr, @"fucardbank", paymoneyStr, @"paymoney", feemoneyStr, @"feemoney", nil];
        [self.myArray addObject:dic];
    }
}

-(void)readRepayMoneyglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadRepayMoneyglistNotify:response];
//        self.myTableView.hidden = NO;
        [self.myTableView reloadData];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
        //self.myTableView.hidden = YES;
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readRepayMoneyglist
{
    NSString* name = [NLUtils getNameForRequest:Notify_readRepayMoneyglist];
    REGISTER_NOTIFY_OBSERVER(self, readRepayMoneyglistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readRepayMoneyglist:@"pay"
                                                                 msgstart:_msgstart
                                                               msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)doReadTransferMoneyglistNotify:(NLProtocolResponse*)response
{
    /*
     ccgno  流水号
     ccgtime    交易时间
     zhuancardno    转账卡号＊＊＊＊＊收款卡号
     fucardno   付款卡号
     paymoney   转账金额
     huancardbank 还款银行
     fucardbank 付款银行
     feemoney   手续费
     allmoney   总额
     state  状态
     */
    
    NSArray* ccgtime = [response.data find:@"msgbody/msgchild/ccgtime"];
    NSArray* ccgno = [response.data find:@"msgbody/msgchild/ccgno"];
    NSArray* allmoney = [response.data find:@"msgbody/msgchild/allmoney"];
    NSArray* state = [response.data find:@"msgbody/msgchild/state"];
    NSArray* zhuancardno = [response.data find:@"msgbody/msgchild/huancardno"];
    NSArray* fucardno = [response.data find:@"msgbody/msgchild/fucardno"];
    NSArray* paymoney = [response.data find:@"msgbody/msgchild/paymoney"];
    NSArray* feemoney = [response.data find:@"msgbody/msgchild/feemoney"];
    
    NSArray* huancardbank = [response.data find:@"msgbody/msgchild/huancardbank"];
    NSArray* fucardbank = [response.data find:@"msgbody/msgchild/fucardbank"];
    
    NSString* ccgtimeStr = nil;
    NSString* ccgnoStr = nil;
    NSString* allmoneyStr = nil;
    NSString* stateStr = nil;
    NSString* zhuancardnoStr = nil;
    NSString* fucardnoStr = nil;
    NSString* paymoneyStr = nil;
    NSString* feemoneyStr = nil;
    
    NSString* huancardbankStr = nil;
    NSString* fucardbankStr = nil;
    
    for (int i=0; i<[ccgtime count]; i++)
    {
        NLProtocolData* data = [ccgtime objectAtIndex:i];
        ccgtimeStr = [self checkInfo:data.value];
        data = [ccgno objectAtIndex:i];
        ccgnoStr = [self checkInfo:data.value];
        data = [allmoney objectAtIndex:i];
        allmoneyStr = [self checkInfo:data.value];
        data = [state objectAtIndex:i];
        stateStr = [self checkInfo:data.value];
        data = [zhuancardno objectAtIndex:i];
        zhuancardnoStr = [self checkInfo:data.value];
        data = [fucardno objectAtIndex:i];
        fucardnoStr = [self checkInfo:data.value];
        data = [paymoney objectAtIndex:i];
        paymoneyStr = [self checkInfo:data.value];
        data = [feemoney objectAtIndex:i];
        feemoneyStr = [self checkInfo:data.value];
        
        data = [huancardbank objectAtIndex:i];
        huancardbankStr = [self checkInfo:data.value];
        data = [fucardbank objectAtIndex:i];
        fucardbankStr = [self checkInfo:data.value];
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:ccgtimeStr, @"ccgtime", ccgnoStr, @"ccgno", allmoneyStr, @"allmoney",stateStr, @"state", zhuancardnoStr, @"huancardno", huancardbankStr, @"huancardbank", fucardnoStr, @"fucardno", fucardbankStr, @"fucardbank", paymoneyStr, @"paymoney", feemoneyStr, @"feemoney", nil];
        [self.myArray addObject:dic];
    }
}

-(void)readTransferMoneyglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadTransferMoneyglistNotify:response];
//        self.myTableView.hidden = NO;
        [self.myTableView reloadData];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
        //self.myTableView.hidden = YES;
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString* detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readTransferMoneyglist
{
    NSString* name = [NLUtils getNameForRequest:Notify_readTransferMoneyglist];
    REGISTER_NOTIFY_OBSERVER(self, readTransferMoneyglistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readTransferMoneyglist:@"tfmg"
                                                                    msgstart:_msgstart
                                                                  msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark - 历史记录
-(void)doReadSupTransferMoneyglistNotify:(NLProtocolResponse*)response
{
    /*
     ccgno  流水号
     ccgtime    交易时间
     zhuancardno    转账卡号＊＊＊＊＊收款卡号
     fucardno   付款卡号
     paymoney   转账金额
     huancardbank 还款银行
     fucardbank 付款银行
     feemoney   手续费
     allmoney   总额
     state  状态
     */
    
    NSArray* ccgtime = [response.data find:@"msgbody/msgchild/ccgtime"];
    NSArray* ccgno = [response.data find:@"msgbody/msgchild/ccgno"];
    NSArray* allmoney = [response.data find:@"msgbody/msgchild/allmoney"];
    NSArray* state = [response.data find:@"msgbody/msgchild/state"];
    NSArray* zhuancardno = [response.data find:@"msgbody/msgchild/huancardno"];
    NSArray* fucardno = [response.data find:@"msgbody/msgchild/fucardno"];
    NSArray* paymoney = [response.data find:@"msgbody/msgchild/paymoney"];
    NSArray* feemoney = [response.data find:@"msgbody/msgchild/feemoney"];
    
    NSArray* huancardbank = [response.data find:@"msgbody/msgchild/huancardbank"];
    NSArray* fucardbank = [response.data find:@"msgbody/msgchild/fucardbank"];
    
    NSString* ccgtimeStr = nil;
    NSString* ccgnoStr = nil;
    NSString* allmoneyStr = nil;
    NSString* stateStr = nil;
    NSString* zhuancardnoStr = nil;
    NSString* fucardnoStr = nil;
    NSString* paymoneyStr = nil;
    NSString* feemoneyStr = nil;
    
    NSString* huancardbankStr = nil;
    NSString* fucardbankStr = nil;
    
    for (int i=0; i<[ccgtime count]; i++)
    {
        NLProtocolData* data = [ccgtime objectAtIndex:i];
        ccgtimeStr = [self checkInfo:data.value];
        data = [ccgno objectAtIndex:i];
        ccgnoStr = [self checkInfo:data.value];
        data = [allmoney objectAtIndex:i];
        allmoneyStr = [self checkInfo:data.value];
        data = [state objectAtIndex:i];
        stateStr = [self checkInfo:data.value];
        data = [zhuancardno objectAtIndex:i];
        zhuancardnoStr = [self checkInfo:data.value];
        data = [fucardno objectAtIndex:i];
        fucardnoStr = [self checkInfo:data.value];
        data = [paymoney objectAtIndex:i];
        paymoneyStr = [self checkInfo:data.value];
        data = [feemoney objectAtIndex:i];
        feemoneyStr = [self checkInfo:data.value];
        
        data = [huancardbank objectAtIndex:i];
        huancardbankStr = [self checkInfo:data.value];
        data = [fucardbank objectAtIndex:i];
        fucardbankStr = [self checkInfo:data.value];
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:ccgtimeStr, @"ccgtime", ccgnoStr, @"ccgno", allmoneyStr, @"allmoney", stateStr, @"state", zhuancardnoStr, @"huancardno", huancardbankStr, @"huancardbank", fucardnoStr, @"fucardno", fucardbankStr, @"fucardbank", paymoneyStr, @"paymoney", feemoneyStr, @"feemoney", nil];
        [self.myArray addObject:dic];
    }
}

-(void)readSupTransferMoneyglistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadSupTransferMoneyglistNotify:response];
//        self.myTableView.hidden = NO;
        
        [self.myTableView reloadData];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
        //self.myTableView.hidden = YES;
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString* detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readSupTransferMoneyglist
{
    NSString* name = [NLUtils getNameForRequest:Notify_readSupTransferMoneyglist];
    REGISTER_NOTIFY_OBSERVER(self, readSupTransferMoneyglistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readSupTransferMoneyglist:@"suptfmg"
                                                                       msgstart:_msgstart
                                                                     msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)protocolRequest
{
//    [self.myArray removeAllObjects];
    switch (self.myHistoryRecordType)
    {
        case NLHistoryRecordType_TransferMoney:
        {
            [self readTransferMoneyglist];
        }
            break;
        case NLHistoryRecordType_CashArrive:
        {
            [self couponSalelist];
        }
            break;
        case NLHistoryRecordType_CreditCardPayments:
        {
            [self readCreditCardglist];
        }
            break;
        case NLHistoryRecordType_ReturnLoan:
        {
            [self readRepayMoneyglist];
        }
            break;
            /*转账*/
        case NLHistoryRecordType_SupTransferMoney:
        {
            [self readSupTransferMoneyglist];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _shouldFree = NO;
    
    NLTransferResultViewController* vc = [[NLTransferResultViewController alloc] initWithNibName:@"NLTransferResultViewController" bundle:nil];
    vc.buyType = YES;
    [self createInforForResultView:vc index:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    return [self.myArray count];
//    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
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
    if (indexPath.row >= [self.myArray count])
    {
        return cell;
    }
    [cell.myTypeLabel setFrame:CGRectMake(cell.myTypeLabel.frame.origin.x, cell.myTypeLabel.frame.origin.y, 180, cell.myTypeLabel.frame.size.height)];
    [cell.myDateLabel setFrame:CGRectMake(cell.myDateLabel.frame.origin.x, cell.myDateLabel.frame.origin.y, 180, cell.myDateLabel.frame.size.height)];
    [cell.myAmountLabel setFrame:CGRectMake(190, cell.myAmountLabel.frame.origin.y, 100, cell.myAmountLabel.frame.size.height)];
    [cell.myResultLabel setFrame:CGRectMake(190, cell.myResultLabel.frame.origin.y, 100, cell.myResultLabel.frame.size.height)];
    cell.myBackImageView.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    switch (self.myHistoryRecordType)
    {
        case NLHistoryRecordType_CreditCardPayments:
        {
            [self doCreditCardPaymentsTablViewCell:indexPath cell:cell];
        }
            break;
        case NLHistoryRecordType_CashArrive:
        {
            [self doCashArriveTablViewCell:indexPath cell:cell];
        }
            break;
        case NLHistoryRecordType_TransferMoney:
        {
            [self doTransferMoneyTablViewCell:indexPath cell:cell];
        }
            break;
        case NLHistoryRecordType_ReturnLoan:
        {
            [self doReturnLoanTablViewCell:indexPath cell:cell];
        }
            break;
        case NLHistoryRecordType_SupTransferMoney:
        {
            [self doSupTransferMoneyTablViewCell:indexPath cell:cell];
        }
            break;
            
        default:
        {
            cell.myTypeLabel.text = @"12312312";
            cell.myAmountLabel.text = @"12312312";
            cell.myResultLabel.text = @"12312312";
            cell.myDateLabel.text = @"12312312";
        }
            break;
    }
    return cell;
}

-(void)doCreditCardPaymentsTablViewCell:(NSIndexPath *)indexPath cell:(NLInOutcomeDetailCell *)cell
{
    NSDictionary* dic = [self.myArray objectAtIndex:indexPath.row];
    cell.myTypeLabel.text = [dic objectForKey:@"ccgno"];
    cell.myAmountLabel.text = [dic objectForKey:@"allmoney"];
    cell.myResultLabel.text = [dic objectForKey:@"message"];
    cell.myDateLabel.text = [dic objectForKey:@"ccgtime"];
}

-(void)doTransferMoneyTablViewCell:(NSIndexPath *)indexPath cell:(NLInOutcomeDetailCell *)cell
{
    NSDictionary* dic = [self.myArray objectAtIndex:indexPath.row];
    cell.myTypeLabel.text = [dic objectForKey:@"ccgno"];
    cell.myAmountLabel.text = [dic objectForKey:@"allmoney"];
    cell.myResultLabel.text = [dic objectForKey:@"state"];
    cell.myDateLabel.text = [dic objectForKey:@"ccgtime"];
}

/*商户收款历史*/
-(void)doCashArriveTablViewCell:(NSIndexPath *)indexPath cell:(NLInOutcomeDetailCell *)cell
{
    NSDictionary* dic = [self.myArray objectAtIndex:indexPath.row];
    cell.myTypeLabel.text = [dic objectForKey:@"couponno"];
    cell.myAmountLabel.text = [dic objectForKey:@"couponmoney"];
    cell.myResultLabel.text = nil;//[dic objectForKey:@"couponmoney"];
    cell.myDateLabel.text = [dic objectForKey:@"coupondate"];
}

-(void)doReturnLoanTablViewCell:(NSIndexPath *)indexPath cell:(NLInOutcomeDetailCell*)cell
{
    NSDictionary* dic = [self.myArray objectAtIndex:indexPath.row];
    cell.myTypeLabel.text = [dic objectForKey:@"ccgno"];
    cell.myAmountLabel.text = [dic objectForKey:@"allmoney"];
    cell.myResultLabel.text = [dic objectForKey:@"state"];
    cell.myDateLabel.text = [dic objectForKey:@"ccgtime"];
}

-(void)doSupTransferMoneyTablViewCell:(NSIndexPath *)indexPath cell:(NLInOutcomeDetailCell*)cell
{
    NSDictionary* dic = [self.myArray objectAtIndex:indexPath.row];
    cell.myTypeLabel.text = [dic objectForKey:@"ccgno"];
    cell.myAmountLabel.text = [dic objectForKey:@"allmoney"];
    cell.myResultLabel.text = [dic objectForKey:@"state"];
    cell.myDateLabel.text = [dic objectForKey:@"ccgtime"];
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

-(NSMutableArray*)doCreditCardPaymentsDetail:(int)index
{
    NSDictionary* dictionary = [self.myArray objectAtIndex:index];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
    /*
     ccgno  流水号
     ccgtime    交易时间
     huancardno 还款卡号
     fucardno   付款卡号
     paymoney   还款金额
     feemoney   手续费
     allmoney   总额
     state  状态
     */
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易类别",@"header", @"信用卡还款",@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易流水号",@"header", [dictionary objectForKey:@"ccgno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易时间",@"header", [dictionary objectForKey:@"ccgtime"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款卡号",@"header", [dictionary objectForKey:@"huancardno"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款银行",@"header", [dictionary objectForKey:@"huancardbank"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", [dictionary objectForKey:@"fucardno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", [dictionary objectForKey:@"fucardbank"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手续费",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"feemoney"]],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"allmoney"]],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易状态",@"header", [dictionary objectForKey:@"message"],@"content", nil];
    [arr addObject:dic];
  
    return arr;
}

-(NSMutableArray*)doTransferMoneyDetail:(int)index
{
    NSDictionary* dictionary = [self.myArray objectAtIndex:index];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
    /*
     ccgno  流水号
     ccgtime    交易时间
     zhuancardno    收款卡号
     fucardno   付款卡号
     paymoney   转账金额
     feemoney   手续费
     allmoney   总额
     state  状态
     */
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易类别",@"header", @"转账汇款",@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易流水号",@"header", [dictionary objectForKey:@"ccgno"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易时间",@"header", [dictionary objectForKey:@"ccgtime"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款卡号",@"header", [dictionary objectForKey:@"huancardno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款银行",@"header", [dictionary objectForKey:@"huancardbank"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", [dictionary objectForKey:@"fucardno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", [dictionary objectForKey:@"fucardbank"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"allmoney"]],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"转账金额",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"paymoney"]],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手续费",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"feemoney"]],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易状态",@"header", [dictionary objectForKey:@"state"],@"content", nil];
    [arr addObject:dic];
    
    return arr;    
}

-(NSMutableArray*)doCashArriveDetail:(int)index
{
    NSDictionary* dictionary = [self.myArray objectAtIndex:index];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    /*
     couponno   券号
     couponmoney    金额
     coupondate 购买时间
     paycardid  刷卡器设备号
     couponid   抵用券号
     couponmemo 其他描述
     couponbank 付款银行
     couponcardno   付款卡号
     */
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易类别",@"header", @"购买抵用券",@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易流水号",@"header", [dictionary objectForKey:@"couponno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"couponmoney"]],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易时间",@"header", [dictionary objectForKey:@"coupondate"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", [dictionary objectForKey:@"couponbank"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", [dictionary objectForKey:@"couponcardno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"抵用券号",@"header", [dictionary objectForKey:@"couponid"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"刷卡器设备号",@"header", [dictionary objectForKey:@"paycardid"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"其他描述",@"header", [dictionary objectForKey:@"couponmemo"],@"content", nil];
    [arr addObject:dic];
    
    return arr;
}

-(NSMutableArray*)doReturnLoanDetail:(int)index
{
    NSDictionary* dictionary = [self.myArray objectAtIndex:index];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
    /*
     ccgno  流水号
     ccgtime    交易时间
     huancardno 还贷卡号
     huancardbank   还贷银行
     fucardno   付款卡号
     paymoney   还贷金额
     feemoney   手续费
     allmoney   总额
     state  状态
     */
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易类别",@"header", @"还贷款",@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易流水号",@"header", [dictionary objectForKey:@"ccgno"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易时间",@"header", [dictionary objectForKey:@"ccgtime"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"还贷卡号",@"header", [dictionary objectForKey:@"huancardno"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"还贷银行",@"header", [dictionary objectForKey:@"huancardbank"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", [dictionary objectForKey:@"fucardno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", [dictionary objectForKey:@"fucardbank"],@"content", nil];
    [arr addObject:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"allmoney"]],@"content", nil];
    [arr addObject:dic];

    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"还贷金额",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"paymoney"]],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手续费",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"feemoney"]],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易状态",@"header", [dictionary objectForKey:@"state"],@"content", nil];
    [arr addObject:dic];
    
    return arr;
}

-(NSMutableArray*)doSupTransferMoneyDetail:(int)index
{
    NSDictionary* dictionary = [self.myArray objectAtIndex:index];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
    
    /*
     ccgno  流水号
     ccgtime    交易时间
     zhuancardno    收款卡号
     fucardno   付款卡号
     paymoney   转账金额
     feemoney   手续费
     allmoney   总额
     state  状态
     */
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易类别",@"header", @"超级转账",@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易流水号",@"header", [dictionary objectForKey:@"ccgno"],@"content", nil];
    [arr addObject:dic];
 
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易时间",@"header", [dictionary objectForKey:@"ccgtime"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款卡号",@"header", [dictionary objectForKey:@"huancardno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"收款银行",@"header", [dictionary objectForKey:@"huancardbank"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款卡号",@"header", [dictionary objectForKey:@"fucardno"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"付款银行",@"header", [dictionary objectForKey:@"fucardbank"],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易金额",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"allmoney"]],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"转账金额",@"header", [NSString stringWithFormat:@"%@元",[dictionary objectForKey:@"paymoney"]],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"手续费",@"header",[NSString stringWithFormat:@"%@元", [dictionary objectForKey:@"feemoney"]],@"content", nil];
    [arr addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@"交易状态",@"header", [dictionary objectForKey:@"state"],@"content", nil];
    [arr addObject:dic];
    
    return arr;
}

-(void)createInforForResultView:(NLTransferResultViewController*)vc index:(int)index
{
    NSArray* arr = nil;
    
    switch (self.myHistoryRecordType)
    {
        case NLHistoryRecordType_TransferMoney:
        {
            arr = [self doTransferMoneyDetail:index];
        }
            break;
        case NLHistoryRecordType_CashArrive:
        {
            arr = [self doCashArriveDetail:index];
        }
            break;
        case NLHistoryRecordType_CreditCardPayments:
        {
            arr = [self doCreditCardPaymentsDetail:index];
        }
            break;
        case NLHistoryRecordType_ReturnLoan:
        {
            arr = [self doReturnLoanDetail:index];
        }
            break;
        case NLHistoryRecordType_SupTransferMoney:
        {
            arr = [self doSupTransferMoneyDetail:index];
        }
            break;

            
        default:
            break;
    }
    
    vc.myArray = [NSArray arrayWithArray:arr];
    vc.myType = 1;
    vc.myNavigationTitle = @"交易详情";
}

#pragma mark MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (_header == refreshView)
    {
        [self.myArray removeAllObjects];
        [self setRequestValues:YES];
        [self protocolRequest];
    }
    else
    {
        [self setRequestValues:NO];
        [self protocolRequest];
    }
}

-(void)setRequestValues:(BOOL)isDownPush
{
    if (isDownPush)//下拉
    {
        _msgstart = @"0";
        _msgdisplay = @"5";
    }
    else
    {
        int start = [_msgstart intValue];
        int display = [_msgdisplay intValue];
        _msgstart = [NSString stringWithFormat:@"%d",(start+display)];
        _msgdisplay = @"5";
    }
}

-(NSString *)checkInfo:(NSString *)str
{
    if (str == nil)
    {
        return @"未知";
    }
    else
    {
        return str;
    }
}

@end







