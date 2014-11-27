//
//  MobileRechangeHistoryCtr.m
//  TongFubao
//
//  Created by ec on 14-4-27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "MobileRechangeHistoryCtr.h"
#import "NLProtocolRequest.h"
#import "NLProtocolData.h"
#import "NLProgressHUD.h"
#import "NLUtils.h"
#import "MJRefresh.h"
#import "MobileRechangeHistoryCell.h"
#import "MobileReChangeDetailCtr.h"

@interface MobileRechangeHistoryCtr ()<MJRefreshBaseViewDelegate>
{
    NLProgressHUD* _hud;
    NSString* _msgstart;
    NSString* _msgdisplay;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    BOOL _shouldFree;
}
@property (weak, nonatomic) IBOutlet UILabel *moneylb;
@property (weak, nonatomic) IBOutlet UILabel *datalb;
@property (weak, nonatomic) IBOutlet UILabel *phonelb;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray* myArray;
@property (weak, nonatomic) IBOutlet UIView *viewA;

@end

@implementation MobileRechangeHistoryCtr

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
    _msgdisplay = @"10";
    _shouldFree = YES;
    [self setExtraCellLineHidden:self.myTableView];
    
    [self performSelector:@selector(protocalRequest) withObject:nil afterDelay:0.1];
   
    _phonelb.text= _myChargeHistoryType == MobileChargeType ? @"手机号码" : @"QQ号码";
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
  
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:_viewA];
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
            break;
        default:
            break;
    }
    return;
}

-(void)protocalRequest
{
    switch (self.myChargeHistoryType)
    {
        case MobileChargeType:
        {
            [self readMobileRechangelist];
        }
            break;
            
        case QCoinChargeType:
        {
            [self readQcoinRechangelist];
        }
            break;
            
        case buySKQType:
        {
            [self readBuySKQlist];
        }
            break;
        case WaterEleType:
        {
            [self readWaterEleclist];
        }
            break;
        case GameType:
        {
            [self readGameChargelist];
        }
            break;
        case payPeopleMoney:{
            
        }
            break;
        default:
            break;
    }
}

//查询历史
-(void)readMobileRechangelist
{
    NSString* name = [NLUtils getNameForRequest:Notify_readMobileRechangelist];
    REGISTER_NOTIFY_OBSERVER(self, readMobileRechangelistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readMobileRechangelist:@"" msgstart:_msgstart msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)readMobileRechangelistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadMobileRechangelistNotify:response];
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
        [_header endRefreshing];
        [_footer endRefreshing];
        [_viewA setHidden:YES];
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doReadMobileRechangelistNotify:(NLProtocolResponse*)response
{
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        /*
         rechamoney       充值金额
         rechapaymoney    支付金额
         rechamobile      手机号码
         Rechamobileprov  手机所属地
         rechabkcardno    银行卡号
         rechadatetime    订单时间
         rechastate       订单状态
         */
        
        NSArray* rechamoney = [response.data find:@"msgbody/msgchild/rechamoney"];
        NSArray* rechapaymoney = [response.data find:@"msgbody/msgchild/rechapaymoney"];
        NSArray* rechamobile = [response.data find:@"msgbody/msgchild/rechamobile"];
        NSArray* rechamobileprov = [response.data find:@"msgbody/msgchild/rechamobileprov"];
        
        NSArray* rechabkcardno = [response.data find:@"msgbody/msgchild/rechabkcardno"];
        NSArray* rechadatetime = [response.data find:@"msgbody/msgchild/rechadatetime"];
        NSArray* rechastate = [response.data find:@"msgbody/msgchild/rechastate"];
        
        NSString* rechamoneyStr = nil;
        NSString* rechapaymoneyStr = nil;
        NSString* rechamobileStr = nil;
        NSString* rechamobileprovStr = nil;
        NSString* rechabkcardnoStr = nil;
        NSString* rechadatetimeStr = nil;
        NSString* rechastateStr = nil;
        
        for (int i=0; i<[rechadatetime count]; i++)
        {
            NLProtocolData* data = [rechamoney objectAtIndex:i];
            rechamoneyStr = [self checkInfo:data.value];
            data = [rechapaymoney objectAtIndex:i];
            rechapaymoneyStr = [self checkInfo:data.value];
            data = [rechamobile objectAtIndex:i];
            rechamobileStr = [self checkInfo:data.value];
            data = [rechamobileprov objectAtIndex:i];
            rechamobileprovStr = [self checkInfo:data.value];
            data = [rechabkcardno objectAtIndex:i];
            rechabkcardnoStr = [self checkInfo:data.value];
            data = [rechadatetime objectAtIndex:i];
            rechadatetimeStr = [self checkInfo:data.value];
            data = [rechastate objectAtIndex:i];
            rechastateStr = [self checkInfo:data.value];
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:rechamoneyStr, @"rechamoney", rechapaymoneyStr, @"rechapaymoney", rechamobileStr, @"rechamobile", rechamobileprovStr, @"rechamobileprov", rechabkcardnoStr, @"rechabkcardno", rechadatetimeStr, @"rechadatetime", rechastateStr, @"rechastate", nil];
            [self.myArray addObject:dic];
        }
    }
}


//查询q币充值历史
-(void)readQcoinRechangelist
{
    NSString* name = [NLUtils getNameForRequest:Notify_readRechangeQQlist];
    REGISTER_NOTIFY_OBSERVER(self, readRechangeQQlistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readMobileRechangeQQlist:@"" msgstart:_msgstart msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}


-(void)readRechangeQQlistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadRechangeQQlistNotify:response];
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
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString *detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doReadRechangeQQlistNotify:(NLProtocolResponse *)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        /*
         rechamoney       充值金额
         rechapaymoney    支付金额
         rechamobile      手机号码
         Rechamobileprov  手机所属地
         rechabkcardno    银行卡号
         rechadatetime    订单时间
         rechastate       订单状态
         */
        
        NSArray* rechamoney = [response.data find:@"msgbody/msgchild/rechamoney"];
        NSArray* rechapaymoney = [response.data find:@"msgbody/msgchild/rechapaymoney"];
        NSArray* rechaqq = [response.data find:@"msgbody/msgchild/rechaqq"];
        
        NSArray* rechabkcardno = [response.data find:@"msgbody/msgchild/rechabkcardno"];
        NSArray* rechadatetime = [response.data find:@"msgbody/msgchild/rechadatetime"];
        NSArray* rechastate = [response.data find:@"msgbody/msgchild/rechastate"];
        
        NSString* rechamoneyStr = nil;
        NSString* rechapaymoneyStr = nil;
        NSString* rechaqqStr = nil;
        NSString* rechabkcardnoStr = nil;
        NSString* rechadatetimeStr = nil;
        NSString* rechastateStr = nil;
        
        for (int i=0; i<[rechastate count]; i++)
        {
            NLProtocolData* data = [rechamoney objectAtIndex:i];
            rechamoneyStr = [self checkInfo:data.value];
            data = [rechapaymoney objectAtIndex:i];
            rechapaymoneyStr = [self checkInfo:data.value];
            data = [rechaqq objectAtIndex:i];
            rechaqqStr = [self checkInfo:data.value];
            data = [rechabkcardno objectAtIndex:i];
            rechabkcardnoStr = [self checkInfo:data.value];
            data = [rechadatetime objectAtIndex:i];
            rechadatetimeStr = [self checkInfo:data.value];
            data = [rechastate objectAtIndex:i];
            rechastateStr = [self checkInfo:data.value];
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:rechamoneyStr, @"rechamoney", rechapaymoneyStr, @"rechapaymoney", rechaqqStr, @"rechamobile", rechabkcardnoStr, @"rechabkcardno", rechadatetimeStr, @"rechadatetime", rechastateStr, @"rechastate", nil];
            [self.myArray addObject:dic];
        }
    }
}

//查询设备购买历史
-(void)readBuySKQlist
{
    NSString* name = [NLUtils getNameForRequest:Notify_readSKQOrderlist];
    REGISTER_NOTIFY_OBSERVER(self, readBuySKQlistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readPaySKQhistorylist:@"" msgstart:_msgstart msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}


-(void)readBuySKQlistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadBuySKQlistNotify:response];
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
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doReadBuySKQlistNotify:(NLProtocolResponse*)response
{
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }else{
        
        /**
         orderno                    订单编号
         orderprodurename           产品名称
         ordernum                   购买数量
         orderprice                 购买单价
         ordermoney                 订单金额
         ordershaddress             详细收货地址
         ordershman                 收货人
         ordershphone               收货电话
         orderpaystatus             支付状态
         orderstate                 订单状态
         wlno                       物流订单号
         kdcomanyid                 物流公司id
         yunmoney                   运费金额
         promoney                   产品总额
         */
        
        NSArray* orderno = [response.data find:@"msgbody/msgchild/orderno"];
        NSArray* orderprodurename = [response.data find:@"msgbody/msgchild/orderprodurename"];
        NSArray* ordernum = [response.data find:@"msgbody/msgchild/ordernum"];
        
        NSArray* orderprice = [response.data find:@"msgbody/msgchild/orderprice"];
        NSArray* ordermoney = [response.data find:@"msgbody/msgchild/ordermoney"];
        NSArray* ordershaddress = [response.data find:@"msgbody/msgchild/ordershaddress"];
        
        NSArray *ordershman = [response.data find:@"msgbody/msgchild/ordershman"];
        NSArray *ordershphone = [response.data find:@"msgbody/msgchild/ordershphone"];
        NSArray *orderpaystatus = [response.data find:@"msgbody/msgchild/orderpaystatus"];
        NSArray *orderstate = [response.data find:@"msgbody/msgchild/orderstate"];
        NSArray *wlno = [response.data find:@"msgbody/msgchild/wlno"];
        NSArray *kdcomanyid = [response.data find:@"msgbody/msgchild/kdcomanyid"];
        NSArray *yunmoney = [response.data find:@"msgbody/msgchild/yunmoney"];
        NSArray *promoney = [response.data find:@"msgbody/msgchild/promoney"];
        
        NSString* ordernoStr = nil;
        NSString* orderprodurenameStr = nil;
        NSString* ordernumStr = nil;
        NSString* orderpriceStr = nil;
        NSString* ordermoneyStr = nil;
        NSString* ordershaddressStr = nil;
        
        NSString *ordershmanStr = nil;
        NSString *ordershphoneStr = nil;
        NSString *orderpaystatusStr = nil;
        NSString *orderstateStr = nil;
        NSString *wlnoStr = nil;
        NSString *kdcomanyidStr = nil;
        NSString *yunmoneyStr = nil;
        NSString *promoneyStr = nil;
        
        
        for (int i=0; i<[orderno count]; i++)
        {
            NLProtocolData* data = [orderno objectAtIndex:i];
            ordernoStr = [self checkInfo:data.value];
            data = [orderprodurename objectAtIndex:i];
            orderprodurenameStr = [self checkInfo:data.value];
            data = [ordernum objectAtIndex:i];
            ordernumStr = [self checkInfo:data.value];
            data = [orderprice objectAtIndex:i];
            orderpriceStr = [self checkInfo:data.value];
            data = [ordermoney objectAtIndex:i];
            ordermoneyStr = [self checkInfo:data.value];
            data = [ordershaddress objectAtIndex:i];
            ordershaddressStr = [self checkInfo:data.value];
            data = [ordershman objectAtIndex:i];
            ordershmanStr = [self checkInfo:data.value];
            data = [ordershphone objectAtIndex:i];
            ordershphoneStr = [self checkInfo:data.value];
            data = [orderpaystatus objectAtIndex:i];
            orderpaystatusStr = [self checkInfo:data.value];
            data = [orderstate objectAtIndex:i];
            orderstateStr = [self checkInfo:data.value];
            data = [wlno objectAtIndex:i];
            wlnoStr = [self checkInfo:data.value];
            data = [kdcomanyid objectAtIndex:i];
            kdcomanyidStr = [self checkInfo:data.value];
            data = [yunmoney objectAtIndex:i];
            yunmoneyStr = [self checkInfo:data.value];
            data = [promoney objectAtIndex:i];
            promoneyStr = [self checkInfo:data.value];
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:ordernoStr,@"orderno",orderprodurenameStr,@"orderprodurename",ordernumStr,@"ordernum",orderpriceStr,@"orderprice",ordermoneyStr,@"ordermoney",ordershaddressStr,@"ordershaddress",ordershmanStr,@"ordershman",ordershphoneStr,@"ordershphone",orderpaystatusStr,@"orderpaystatus",orderstateStr,@"orderstate",wlnoStr,@"wlno",kdcomanyidStr,@"kdcomanyid",yunmoneyStr,@"yunmoney",promoneyStr,@"promoney",nil];
           [self.myArray addObject:dic];
        }
    }
}

//水电煤缴费历史
-(void)readWaterEleclist
{
    NSString* name = [NLUtils getNameForRequest:Notify_waterEle_getOrderHistory];
    REGISTER_NOTIFY_OBSERVER(self, readWaterEleclistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getWaterEleOrderHistory:@"" msgstart:_msgstart msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}


-(void)readWaterEleclistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadWaterEleclistNotify:response];
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
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doReadWaterEleclistNotify:(NLProtocolResponse*)response
{
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }else{
        
        /**
         unionPaySerialNumber       订单流水号
         factNumber                 实际金额
         payNumber                  支付金额
         company                    收费单位
         proId                      公共事业产品编号数量
         status                     状态
         completeTime               完成
        */
        
        NSArray* bkntno = [response.data find:@"msgbody/msgchild/bkntno"];
        NSArray* factNumber = [response.data find:@"msgbody/msgchild/factNumber"];
        NSArray* payNumber = [response.data find:@"msgbody/msgchild/payNumber"];
        NSArray* company = [response.data find:@"msgbody/msgchild/company"];
        NSArray* proId = [response.data find:@"msgbody/msgchild/proId"];
        NSArray* status = [response.data find:@"msgbody/msgchild/status"];
        NSArray* completeTime = [response.data find:@"msgbody/msgchild/completeTime"];
        
        NSString* bkntnoStr = nil;
        NSString* factNumberStr = nil;
        NSString* payNumberStr = nil;
        NSString* companyStr = nil;
        NSString* proIdStr = nil;
        NSString* statusStr = nil;
        NSString* completeTimeStr = nil;
        
        for (int i=0; i<[bkntno count]; i++)
        {
            NLProtocolData* data = [bkntno objectAtIndex:i];
            bkntnoStr = [self checkInfo:data.value];
            data = [factNumber objectAtIndex:i];
            factNumberStr = [self checkInfo:data.value];
            data = [payNumber objectAtIndex:i];
            payNumberStr = [self checkInfo:data.value];
            data = [company objectAtIndex:i];
            companyStr = [self checkInfo:data.value];
            data = [proId objectAtIndex:i];
            proIdStr = [self checkInfo:data.value];
            data = [status objectAtIndex:i];
            statusStr = [self checkInfo:data.value];
            data = [completeTime objectAtIndex:i];
            completeTimeStr = [self checkInfo:data.value];
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:bkntnoStr,@"bkntno",factNumberStr,@"factNumber",payNumberStr,@"payNumber",companyStr,@"company",proIdStr,@"proId",statusStr,@"status",completeTimeStr,@"completeTime",nil];
            [self.myArray addObject:dic];
        }
    }
}

//游戏充值历史
-(void)readGameChargelist
{
    NSString* name = [NLUtils getNameForRequest:Notify_gameCharge_getOrderHistory];
    REGISTER_NOTIFY_OBSERVER(self, readGameChargelistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getGameChargeOrderHistoryWithmsgStart:_msgstart msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)readGameChargelistNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doReadGameChargelistNotify:response];
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
        [_header endRefreshing];
        [_footer endRefreshing];
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doReadGameChargelistNotify:(NLProtocolResponse*)response
{
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }else{
        
        /**
         bkntno             银联流水号
         quantity           充值数量
         gamename           游戏名
         status             状态
         totalPrice         总价
         completeTime       完成时间
         price              优惠单价
         area               分区
         account            付款账号
         */
        
        NSArray* bkntno = [response.data find:@"msgbody/msgchild/bkntno"];
        NSArray* quantity = [response.data find:@"msgbody/msgchild/quantity"];
        NSArray* gamename = [response.data find:@"msgbody/msgchild/gamename"];
        NSArray* totalPrice = [response.data find:@"msgbody/msgchild/totalPrice"];
        NSArray* completeTime = [response.data find:@"msgbody/msgchild/completeTime"];
        NSArray* account = [response.data find:@"msgbody/msgchild/account"];
        
        NSString* bkntnoStr = nil;
        NSString* quantityStr = nil;
        NSString* gamenameStr = nil;
        NSString* totalPriceStr = nil;
        NSString* completeTimeStr = nil;
        NSString* accountStr = nil;

        for (int i=0; i<[bkntno count]; i++)
        {
            NLProtocolData* data = [bkntno objectAtIndex:i];
            bkntnoStr = [self checkInfo:data.value];
            data = [quantity objectAtIndex:i];
            quantityStr = [self checkInfo:data.value];
            data = [gamename objectAtIndex:i];
            gamenameStr = [self checkInfo:data.value];
            data = [totalPrice objectAtIndex:i];
            totalPriceStr = [self checkInfo:data.value];
            data = [completeTime objectAtIndex:i];
            completeTimeStr = [self checkInfo:data.value];
            data = [account objectAtIndex:i];
            accountStr = [self checkInfo:data.value];
           
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:bkntnoStr,@"bkntno",quantityStr,@"quantity",gamenameStr,@"gamename",totalPriceStr,@"totalPrice",completeTimeStr,@"completeTime",accountStr,@"account",nil];
            [self.myArray addObject:dic];
        }
    }
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *HistoryRowIdentifier = @"HistoryRowIdentifier";
    MobileRechangeHistoryCell *historyCell;
    
        historyCell = [_myTableView dequeueReusableCellWithIdentifier:HistoryRowIdentifier];
        if (historyCell==nil) {
            historyCell = [[MobileRechangeHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HistoryRowIdentifier];
        }
    
        if (indexPath.row >= [self.myArray count])
        {
        return historyCell;
        }
        NSDictionary *dict = self.myArray[indexPath.row];

    switch (self.myChargeHistoryType) {
        case MobileChargeType:
            _viewA.hidden= NO;
            [historyCell setData:dict];
            break;
        case QCoinChargeType:
            _viewA.hidden= NO;
            [historyCell setQcoinData:dict];
            break;
        case buySKQType:
            [historyCell setSKQData:dict];
            break;
        case WaterEleType:
            [historyCell setWaterElecData:dict];
        case GameType:
            [historyCell setGameChargeData:dict];
            break;
        case payPeopleMoney:
            [historyCell setPayPeopleMoneyChargeData:dict];
            break;
        default:
            break;
    }
    return historyCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dict = _myArray[indexPath.row];
    
    MobileReChangeDetailCtr *mobileReChangeDetailCtr = [[MobileReChangeDetailCtr alloc]initWithNibName:@"MobileReChangeDetailCtr" bundle:nil];
    [mobileReChangeDetailCtr setData:dict];
    mobileReChangeDetailCtr.myChargeHistoryType = self.myChargeHistoryType;
    mobileReChangeDetailCtr.title = @"交易详情";
    [self.navigationController pushViewController:mobileReChangeDetailCtr animated:YES];
}

#pragma mark
//超时跳转
- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
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
        [self protocalRequest];
    }
    else
    {
        [self setRequestValues:NO];
        [self protocalRequest];
    }
}

-(void)setRequestValues:(BOOL)isDownPush
{
    if (isDownPush)//下拉
    {
        _msgstart = @"0";
        _msgdisplay = @"10";
    }
    else
    {
        int start = [_msgstart intValue];
        int display = [_msgdisplay intValue];
        _msgstart = [NSString stringWithFormat:@"%d",(start+display)];
        _msgdisplay = @"10";
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
