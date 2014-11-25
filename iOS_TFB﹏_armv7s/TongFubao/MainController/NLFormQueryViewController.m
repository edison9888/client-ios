//
//  NLFormQueryViewController.m
//  TongFubao
//
//  Created by MD313 on 13-9-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLFormQueryViewController.h"
#import "NLFourLinesCell.h"
#import "NLProtocolRequest.h"
#import "NLUtils.h"
#import "NLProgressHUD.h"
#import "MJRefresh.h"
#import "NLFormDetailViewController.h"
#import "NLOrderPayFirstViewController.h"

typedef enum
{
    TablePushType_None = 0,
    TablePushType_Down,
    TablePushType_Up
} NLFormQueryTablePushType;

@interface NLFormQueryViewController () <MJRefreshBaseViewDelegate>
{
    NLProgressHUD* _hud;
    NSString* _querywhere;
    NSString* _orderstate;
    NSString* _orderno;
    NSString* _msgstart;
    NSString* _msgdisplay;
    NSString* _orderid;
    NSString* _paymoney;
    NSString* _bankcardno;
    NSString* _bankname;
    NSString* _bkntno;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    BOOL _shouldFree;
    BOOL _hasLoadLeft;
    BOOL _hasLoadRight;
    BOOL _isFirstLoadAll;
}

@property(nonatomic,strong)NSMutableArray* myArray;
@property(nonatomic,strong)NSMutableArray* myMsproinfoArry;
@property(nonatomic,strong)IBOutlet UIButton* myLeftButton;
@property(nonatomic,strong)IBOutlet UIButton* myRightButton;
@property(nonatomic,strong)IBOutlet UIButton* myQueryButton;
@property(nonatomic,strong)IBOutlet UITextField* myTextField;
@property(nonatomic,strong)IBOutlet UITableView* myTableView;
@property(nonatomic,strong)IBOutlet UIView* myView;
@property(nonatomic,strong)IBOutlet UILabel* myLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myTopImageView;

-(IBAction)onLeftBtnClicked:(id)sender;
-(IBAction)onRightBtnClicked:(id)sender;
-(IBAction)onQueryBtnClicked:(id)sender;

@end

@implementation NLFormQueryViewController

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
    _isFirstLoadAll = YES;
    if (FormQuery_FormQuery == self.myFormQueryType)
    {
        self.navigationController.topViewController.title = @"订单查询";
        [self initOrderQueryView];
    }
    else if(FormQuery_FormPay == self.myFormQueryType)
    {
        self.navigationController.topViewController.title = @"订单号付款";
        [self initOrderPayView];
    }
    else
    {
        self.navigationController.topViewController.title = @"订单查询";
//        [self initOrderQueryView];
        [self initOrderPayQueryView];
    }
    _shouldFree = YES;
    self.myArray = [NSMutableArray arrayWithCapacity:1];
    self.myMsproinfoArry = [NSMutableArray arrayWithCapacity:1];
    [self setExtraCellLineHidden:self.myTableView];
    //[self addTapGestureRecognizer];
    _hasLoadLeft = NO;
    _hasLoadRight = NO;
    [self onLeftBtnClicked:nil];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.myTableView setTableFooterView:view];
    [self.myTableView setTableHeaderView:view];
}

-(void)initOrderPayView
{
    self.myView.hidden = YES;
    self.myLabel.frame = CGRectMake(10, 30, 50, 21);
    self.myTextField.frame = CGRectMake(70, 26, 180, 30);
    self.myQueryButton.frame = CGRectMake(260, 26, 50, 30);
    
    IOS6_7_DELTA(self.myLabel, 0, 64, 0, 0);
    IOS6_7_DELTA(self.myTextField, 0, 64, 0, 0);
    IOS6_7_DELTA(self.myQueryButton, 0, 64, 0, 0);
    
    UIBarButtonItem *anotherButtonL = [[UIBarButtonItem alloc] initWithTitle:@"订单历史"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(onHistoryDetailBtnClicked:)] ;
    self.navigationItem.rightBarButtonItem = anotherButtonL;
    [self setRequestValues:@"@"
                orderstate:@"nopay"
                   orderno:@""
                msgdisplay:@""
                  pushType:TablePushType_None];
}

-(void)initOrderPayQueryView
{
    self.myView.hidden = NO;
    self.myLabel.frame = CGRectMake(10, 46, 50, 21);
    self.myTextField.frame = CGRectMake(70, 42, 180, 30);
    self.myQueryButton.frame = CGRectMake(260, 42, 50, 30);
    
    IOS6_7_DELTA(self.myLabel, 0, 64, 0, 0);
    IOS6_7_DELTA(self.myTextField, 0, 64, 0, 0);
    IOS6_7_DELTA(self.myQueryButton, 0, 64, 0, 0);
    
    [self setRequestValues:@"@"
                orderstate:@"pay"
                   orderno:@""
                msgdisplay:@""
                  pushType:TablePushType_None];
    
}

-(void)initOrderQueryView
{
    self.myView.hidden = NO;
    self.myLabel.frame = CGRectMake(10, 46, 50, 21);
    self.myTextField.frame = CGRectMake(70, 42, 180, 30);
    self.myQueryButton.frame = CGRectMake(260, 42, 50, 30);
    
    IOS6_7_DELTA(self.myLabel, 0, 64, 0, 0);
    IOS6_7_DELTA(self.myTextField, 0, 64, 0, 0);
    IOS6_7_DELTA(self.myQueryButton, 0, 64, 0, 0);
    
    [self setRequestValues:@"@"
                orderstate:@"all"
                   orderno:@""
                msgdisplay:@""
                  pushType:TablePushType_None];
   
}

-(void)onHistoryDetailBtnClicked:(id)sender
{
    NSString* name = [NLUtils getNameForRequest:Notify_readOrderList];
    REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, name);
    _shouldFree = NO;
    NLFormQueryViewController* vc = [[NLFormQueryViewController alloc] initWithNibName:@"NLFormQueryViewController" bundle:nil];
    vc.myFormQueryType = FormQuery_FormPayQuery;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addTapGestureRecognizer
{
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(oneFingerTwoTaps)];
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    //[oneFingerTwoTaps setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:oneFingerTwoTaps];
}

-(void)initMJRefresh
{
    // 下拉刷新
    if (_header == nil)
    {
        _header = [[MJRefreshHeaderView alloc] init];
        _header.delegate = self;
        _header.scrollView = self.myTableView;
    }
    
    // 上拉加载更多
    if (_footer == nil)
    {
        _footer = [[MJRefreshFooterView alloc] init];
        _footer.delegate = self;
        _footer.scrollView = self.myTableView;
    }
}

-(void)setRequestValues:(NSString*)querywhere
             orderstate:(NSString*)orderstate
                orderno:(NSString*)orderno
             msgdisplay:(NSString*)msgdisplay
               pushType:(NLFormQueryTablePushType)pushType
{
    _querywhere = querywhere;
    _orderstate = orderstate;
    _orderno = orderno;
    switch (pushType)
    {
        case TablePushType_None:
        {
        }
            break;
        case TablePushType_Down:
        {
            int start = [_msgstart intValue];
            int display = [_msgdisplay intValue];
            _msgstart = [NSString stringWithFormat:@"%d",(start+display)];
            _msgdisplay = @"3";
        }
            break;
        case TablePushType_Up:
        {
            _msgstart = @"0";
            if (FormQuery_FormQuery != self.myFormQueryType)
            {
                if (_isFirstLoadAll)
                {
                    _msgdisplay = @"1";
                }
                else
                {
                    _msgdisplay = msgdisplay;
                }
            }
            else
            {
                _msgdisplay = @"3";
            }
        }
            break;
            
        default:
            break;
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - buttons clicked event

-(IBAction)onLeftBtnClicked:(id)sender
{
    [self.myTextField resignFirstResponder];
    [self.myTopImageView setImage:[UIImage imageNamed:@"TransferRemittanceTopLeft@2x.png"]];
//    if (_hasLoadLeft)
//    {
//        return;
//    }
//    _hasLoadLeft = YES;
    if (FormQuery_FormQuery != self.myFormQueryType)
    {
        _isFirstLoadAll = YES;
    }
    [self.myArray removeAllObjects];
    [self setRequestValues:@"@"
                orderstate:_orderstate
                   orderno:_orderno
                msgdisplay:@""
                  pushType:TablePushType_Up];
    [self readOrderList];
}

-(IBAction)onRightBtnClicked:(id)sender
{
    [self.myTextField resignFirstResponder];
    [self.myTopImageView setImage:[UIImage imageNamed:@"TransferRemittanceTopRight@2x.png"]];
//    if (_hasLoadRight)
//    {
//        return;
//    }
//    _hasLoadRight = YES;
    if (FormQuery_FormQuery != self.myFormQueryType)
    {
        _isFirstLoadAll = YES;
    }
    [self.myArray removeAllObjects];
    [self setRequestValues:@"#"
                orderstate:_orderstate
                   orderno:_orderno
                msgdisplay:@""
                  pushType:TablePushType_Up];
    [self readOrderList];
}

-(IBAction)onQueryBtnClicked:(id)sender
{
    [self.myTextField resignFirstResponder];
    if ([self.myTextField.text length] <= 0)
    {
//        [self showErrorInfo:@"订单号不能为空" status:NLHUDState_Error];
        if (FormQuery_FormQuery != self.myFormQueryType)
        {
            _isFirstLoadAll = YES;
        }
        [self.myArray removeAllObjects];
        [self setRequestValues:_querywhere orderstate:_orderstate orderno:@"" msgdisplay:@"" pushType:TablePushType_Up];
        [self readOrderList];
    }
    else
    {
        [self.myArray removeAllObjects];
        [self setRequestValues:_querywhere
                    orderstate:_orderstate
                       orderno:self.myTextField.text
                    msgdisplay:@""
                      pushType:TablePushType_None];
        [self readOrderList];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    int count = [self.myArray count];
    return count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLFourLinesCell *cell =nil;
    static NSString *kCellID = @"NLFourLinesCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    
    //int test = cell.frame.origin.y;
//    if (FormQuery_FormPay == self.myFormQueryType && 0 == indexPath.row)
//    {
//        cell.frame = CGRectMake(0, -32, 320, 116);
//    }
    if (indexPath.row >= [self.myArray count])
    {
        return cell;
    }
    NSString* str1 = [NSString stringWithFormat:@"订单状态: %@",[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"orderstate"]];
    cell.myLabel1.text = str1;
    NSString* str2 = [NSString stringWithFormat:@"订单编号: %@",[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"orderno"]];
    cell.myLabel2.text = str2;
    NSString* str3 = [NSString stringWithFormat:@"下单时间: %@",[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"ordertime"]];
    cell.myLabel3.text = str3;
    NSString* str4 = [NSString stringWithFormat:@"订单金额: %@  共%@件商品",[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"ordermoney"],[[self.myArray objectAtIndex:indexPath.row] objectForKey:@"orderpronum"]];
    cell.myLabel4.text = str4;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (FormQuery_FormPay == self.myFormQueryType)
    {
        [self doSelectRowIndexPath:indexPath.row];
    }
    else
    {
        [self showFormDetailVC:indexPath.row];
    }
}

-(void)doSelectRowIndexPath:(int)index
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: nil
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                            otherButtonTitles:@"查看详情", @"确认支付", nil];
    menu.actionSheetStyle = UIActionSheetStyleDefault;
    menu.tag = index;
    [menu setDestructiveButtonIndex:0];
    [menu showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self showFormDetailVC:actionSheet.tag];
        }
            break;
        case 1:
        {
            [self showOrderPayFirestVC:actionSheet.tag];
        }
            break;
    }
}

-(void)showFormDetailVC:(int)index
{
    NLFormDetailViewController* vc = [[NLFormDetailViewController alloc] initWithNibName:@"NLFormDetailViewController" bundle:nil];
    vc.myDictionary = [NSDictionary dictionaryWithDictionary:[self.myArray objectAtIndex:index]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showOrderPayFirestVC:(int)index
{
    NLOrderPayFirstViewController* vc = [[NLOrderPayFirstViewController alloc] initWithNibName:@"NLOrderPayFirstViewController" bundle:nil];
    vc.myDictionary = [NSDictionary dictionaryWithDictionary:[self.myArray objectAtIndex:index]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - readKuaiDicmpList

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
    int count = [self.myArray count];
    if (count <= 0)
    {
//        return;
    }
    [self.myTableView reloadData];
}

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    return str;
}

-(void)doReadOrderListNotify:(NLProtocolResponse*)response
{
//    NSArray* msgallcount = [response.data find:@"msgbody/msgallcount"];
//    NLProtocolData* data = [msgallcount objectAtIndex:0];
//    NSString* msgallcountStr = data.value;
//    NSArray* msgdiscount = [response.data find:@"msgbody/msgdiscount"];
//    data = [msgdiscount objectAtIndex:0];
//    NSString* msgdiscountStr = data.value;
    NSArray* orderstate = [response.data find:@"msgbody/msorder/msgchild/orderstate"];
    NSString* orderstateStr = nil;
    NSArray* orderid = [response.data find:@"msgbody/msorder/msgchild/orderid"];
    NSString* orderidStr = nil;
    NSArray* orderno = [response.data find:@"msgbody/msorder/msgchild/orderno"];
    NSString* ordernoStr = nil;
    NSArray* ordertime = [response.data find:@"msgbody/msorder/msgchild/ordertime"];
    NSString* ordertimeStr = nil;
    NSArray* ordermoney = [response.data find:@"msgbody/msorder/msgchild/ordermoney"];
    NSString* ordermoneyStr = nil;
    NSArray* orderpronum = [response.data find:@"msgbody/msorder/msgchild/orderpronum"];
    NSString* orderpronumStr = nil;
    NSArray* orderpaytype = [response.data find:@"msgbody/msorder/msgchild/orderpaytype"];
    NSString* orderpaytypeStr = nil;
    NSArray* shman = [response.data find:@"msgbody/msorder/msgchild/shman"];
    NSString* shmanStr = nil;
    NSArray* shcmpyname = [response.data find:@"msgbody/msorder/msgchild/shcmpyname"];
    NSString* shcmpynameStr = nil;
    NSArray* shaddress = [response.data find:@"msgbody/msorder/msgchild/shaddress"];
    NSString* shaddressStr = nil;
    NSArray* fhstorage = [response.data find:@"msgbody/msorder/msgchild/fhstorage"];
    NSString* fhstorageStr = nil;
    NSArray* fhwltype = [response.data find:@"msgbody/msorder/msgchild/fhwltype"];
    NSString* fhwltypeStr = nil;
    NSArray* ordermemo = [response.data find:@"msgbody/msorder/msgchild/ordermemo"];
    NSString* ordermemoStr = nil;
    NSArray* allpromoney = [response.data find:@"msgbody/msorder/msgchild/allpromoney"];
    NSString* allpromoneyStr = nil;
    NSArray* fhwlmoney = [response.data find:@"msgbody/msorder/msgchild/fhwlmoney"];
    NSString* fhwlmoneyStr = nil;
    
    NSArray* proname = [response.data find:@"msgbody/msgchild/msproinfo/msgchild/proname"];
    NSString* pronameStr = nil;
    NSArray* proprice = [response.data find:@"msgbody/msgchild/msproinfo/msgchild/proprice"];
    NSString* propriceStr = nil;
    NSArray* prounit = [response.data find:@"msgbody/msgchild/msproinfo/msgchild/prounit"];
    NSString* prounitStr = nil;
    NSArray* pronum = [response.data find:@"msgbody/msgchild/msproinfo/msgchild/pronum"];
    NSString* pronumStr = nil;
    NSArray* promoney = [response.data find:@"msgbody/msgchild/msproinfo/msgchild/promoney"];
    NSString* promoneyStr = nil;
    
    int count = [orderstate count];
    for (int i=0; i<count; i++)
    {
        NLProtocolData* data = [orderstate objectAtIndex:i];
        orderstateStr = [self getNoNilStr:data.value];
        data = [orderid objectAtIndex:i];
        orderidStr = [self getNoNilStr:data.value];
        data = [orderno objectAtIndex:i];
        ordernoStr = [self getNoNilStr:data.value];
        data = [ordertime objectAtIndex:i];
        ordertimeStr = [self getNoNilStr:data.value];
        data = [ordermoney objectAtIndex:i];
        ordermoneyStr = [self getNoNilStr:data.value];
        data = [orderpronum objectAtIndex:i];
        orderpronumStr = [self getNoNilStr:data.value];
        data = [orderpaytype objectAtIndex:i];
        orderpaytypeStr = [self getNoNilStr:data.value];
        data = [shman objectAtIndex:i];
        shmanStr = [self getNoNilStr:data.value];
        data = [shcmpyname objectAtIndex:i];
        shcmpynameStr = [self getNoNilStr:data.value];
        data = [shaddress objectAtIndex:i];
        shaddressStr = [self getNoNilStr:data.value];
        data = [fhstorage objectAtIndex:i];
        fhstorageStr = [self getNoNilStr:data.value];
        data = [fhwltype objectAtIndex:i];
        fhwltypeStr = [self getNoNilStr:data.value];
        data = [ordermemo objectAtIndex:i];
        ordermemoStr = [self getNoNilStr:data.value];
        data = [allpromoney objectAtIndex:i];
        allpromoneyStr = [self getNoNilStr:data.value];
        data = [fhwlmoney objectAtIndex:i];
        fhwlmoneyStr = [self getNoNilStr:data.value];
        
        NSMutableArray* msproinfoArry = [NSMutableArray arrayWithCapacity:10];
        int c = [proname count];
        for (int j=0; j<c; j++)
        {
            data = [proname objectAtIndex:i];
            pronameStr = [self getNoNilStr:data.value];
            data = [proprice objectAtIndex:i];
            propriceStr = [self getNoNilStr:data.value];
            data = [prounit objectAtIndex:i];
            prounitStr = [self getNoNilStr:data.value];
            data = [pronum objectAtIndex:i];
            pronumStr = [self getNoNilStr:data.value];
            data = [promoney objectAtIndex:i];
            promoneyStr = [self getNoNilStr:data.value];
            //NLLogNoLocation(@"pronameStr:%@,propriceStr:%@,prounitStr:%@,pronumStr:%@,promoneyStr:%@",pronameStr,propriceStr,prounitStr,pronumStr,promoneyStr);
            
            NSDictionary* msproinfoDic = [NSDictionary dictionaryWithObjectsAndKeys:pronameStr,@"proname",propriceStr,@"proprice",prounitStr,@"prounit",pronumStr,@"pronum",promoneyStr,@"promoney", nil];
            [msproinfoArry addObject:msproinfoDic];
        }
        
         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderstateStr,@"orderstate",orderidStr,@"orderid",ordernoStr,@"orderno",ordertimeStr,@"ordertime",ordermoneyStr,@"ordermoney",orderpronumStr,@"orderpronum",orderpaytypeStr,@"orderpaytype",shmanStr,@"shman",shcmpynameStr,@"shcmpyname",shaddressStr,@"shaddress",fhstorageStr,@"fhstorage",fhwltypeStr,@"fhwltype",ordermemoStr,@"ordermemo",allpromoneyStr,@"allpromoney",fhwlmoneyStr,@"fhwlmoney",msproinfoArry,@"msproinfo",nil];
        [self.myArray addObject:dic];
    }
    
    [self refresh];
}

-(void)readOrderListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        if (_isFirstLoadAll)
        {
            _isFirstLoadAll = NO;
            NSArray* msgallcount = [response.data find:@"msgbody/msgallcount"];
            NLProtocolData* data = [msgallcount objectAtIndex:0];
            NSString* msgallcountStr = data.value;
            [self.myArray removeAllObjects];
            [self setRequestValues:_querywhere orderstate:_orderstate orderno:@"" msgdisplay:msgallcountStr pushType:TablePushType_Up];
            [self readOrderList];
            return;
        }
        else
        {
            [self doReadOrderListNotify:response];
        }
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        NSString* detail = response.detail;
        // 让刷新控件恢复默认的状态
        [_header endRefreshing];
        [_footer endRefreshing];
        [self refresh];
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)readOrderList
{
    NSString* name = [NLUtils getNameForRequest:Notify_readOrderList];
    REGISTER_NOTIFY_OBSERVER(self, readOrderListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readOrderList:_msgstart msgdisplay:_msgdisplay orderno:_orderno orderstate:_orderstate querywhere:_querywhere];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

#pragma mark MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (_header == refreshView)
    {
        if (FormQuery_FormQuery != self.myFormQueryType)
        {
            _isFirstLoadAll = YES;
        }
        [self.myArray removeAllObjects];
        [self setRequestValues:_querywhere orderstate:_orderstate orderno:_orderno msgdisplay:@"" pushType:TablePushType_Up];
        [self readOrderList];
    }
    else
    {
        [self setRequestValues:_querywhere orderstate:_orderstate orderno:_orderno msgdisplay:@"" pushType:TablePushType_Down];
        [self readOrderList];
    }
}

#pragma mark - keyboard hide event

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (void) doPush
{
    [_hud hide:YES];
    
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

@end
