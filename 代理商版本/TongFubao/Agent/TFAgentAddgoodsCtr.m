//
//  TFAgentAddgoodsCtr.m
//  TongFubao
//
//  Created by ec on 14-5-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFAgentAddgoodsCtr.h"
#import "NLUtils.h"
#import "TFAgentAddgoodsBill.h"

@interface TFAgentAddgoodsCtr ()
{
    NLProgressHUD* _hud;
    NSString* _msgstart;
    NSString* _msgdisplay;
    
    NSString* limitmaxnum;
    NSString* nowprice;
    NSString* limitminnum;
    NSString* produreid;
    NSString* produrename;
}

@property (nonatomic,strong) UITextField *numTextField;

@property (nonatomic,strong) UITableView *table;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic, retain) PullToLoadMore                *pullToLoadMore;
@property (nonatomic, strong) PullToRefreshView             *pullToRefresh;

@property (nonatomic,strong) NSIndexPath *clickPath;

@end

@implementation TFAgentAddgoodsCtr

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
    // Do any additional setup after loading the view.

    _dataArr = [NSMutableArray array];
    
    _msgstart = @"0";
    _msgdisplay = @"10";
    
    [self UIInit];
    
    [self performSelector:@selector(getData) withObject:nil afterDelay:0.1];

}

-(void)UIInit
{
    self.view.backgroundColor = SACOLOR(208, 1.0);
    CGFloat ctrH = [NLUtils getCtrHeight];
    
    CGFloat IOS7HEIGHT = IOS7_OR_LATER == YES? 64 : 0;

    CGFloat tableHeight = IOS7_OR_LATER == YES? (ctrH - 65 - 44 - 64) : (ctrH - 65 - 44);
    
    _numTextField = [[UITextField alloc]initWithFrame:CGRectMake(11, IOS7HEIGHT + 16, 190, 34)];
    _numTextField.keyboardType = UIKeyboardTypeNumberPad;
    _numTextField.backgroundColor = [UIColor whiteColor];
    _numTextField.placeholder = @"  请输入补货台数";
    _numTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _numTextField.layer.cornerRadius = 3.0;
    [self.view addSubview:_numTextField];
    
    UIButton *tfbPay = [UIButton buttonWithType:UIButtonTypeCustom];
    tfbPay.frame = CGRectMake(212, IOS7HEIGHT + 16, 100, 35);
    tfbPay.layer.cornerRadius = 3.0;
    [tfbPay setTitle:@"通付宝支付" forState:UIControlStateNormal];
    tfbPay.titleLabel.font = [UIFont fontWithName:TFB_FONT size:15];
    [tfbPay setBackgroundImage:[UIImage imageNamed:@"tfb_pay_button_normal"] forState:UIControlStateNormal];
    [tfbPay setBackgroundImage:[UIImage imageNamed:@"tfb_pay_button_selected"] forState:UIControlStateHighlighted];
    [tfbPay addTarget:self action:@selector(clickPay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tfbPay];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT + 64, 320, 44)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 26)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = @"订单列表";
    titleLabel.font = [UIFont fontWithName:TFB_FONT size:17];
    titleLabel.textColor = RGBACOLOR(18, 141, 226, 1.0);
    [titleView addSubview:titleLabel];
    
    //列表
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT + 108, 320, tableHeight)style:UITableViewStyleGrouped];
//    [self setExtraCellLineHidden:_table];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    //添加上拉刷新
    _pullToLoadMore = [[PullToLoadMore alloc] initWithScrollView:_table];
    [_pullToLoadMore setDelegate:self];
    [_table addSubview:_pullToLoadMore];
    
    _pullToRefresh = [[PullToRefreshView alloc] initWithScrollView:_table];
    [_pullToRefresh setDelegate:self];
    [_table addSubview:_pullToRefresh];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"agentAddgoodsListCell";
    TFAgentAddgoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TFAgentAddgoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row % 2 == 0)
    {
        cell.contentView.backgroundColor = SACOLOR(236, 1.0);
    }
    else
    {
        cell.contentView.backgroundColor = SACOLOR(243, 1.0);
    }
    
    cell.delegate = self;
    
    if (_dataArr.count > 0)
    {
        NSDictionary *dict = _dataArr[indexPath.row];
        [cell setData:dict];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

#pragma mark cell delegate
-(void)cellClickReceive:(TFAgentAddgoodsCell *)cell
{
    NSIndexPath *path = [_table indexPathForCell:cell];
    _clickPath = path;
    
    NSMutableDictionary *dict = _dataArr[path.row];
    NSString *productId = dict[KEY_AGENT_ORDER_ID];
    
    NSString* name = [NLUtils getNameForRequest:Notify_agentorderstaterq];
    REGISTER_NOTIFY_OBSERVER(self, agentorderstaterqNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] agentorderstaterq:productId];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)agentorderstaterqNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doAgentorderstaterqNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [_pullToLoadMore finishedLoading];
        [_pullToRefresh finishedLoading];
        
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_pullToLoadMore finishedLoading];
        [_pullToRefresh finishedLoading];
        
        [_hud hide:YES];
        NSString *detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doAgentorderstaterqNotify:(NLProtocolResponse *)response
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
        NSMutableDictionary *dict = _dataArr[_clickPath.row];

        if([dict respondsToSelector:@selector(setObject:forKey:)])
        {
            dict[KEY_AGENT_ORDER_RECEIVESTATE] = @"1";
        }
        
        //刷新
        [_table reloadRowsAtIndexPaths:@[_clickPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//下拉
- (void)PullToLoadMoreViewShouldRefresh:(PullToLoadMore *)view
{
    [self getData];
}

#pragma mark 刷新
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view
{
    [_dataArr removeAllObjects];
    _msgstart = @"0";
    _msgdisplay = @"10";
    [self getData];
}

#pragma mark 点击支付
- (void)clickPay:(UIButton *)sender
{
    if ([self checkData])
    {
        NSDictionary *billInfo = @{@"num":_numTextField.text, @"factBill":nowprice, @"totalPay":[NSString stringWithFormat:@"%d", [_numTextField.text intValue] * [nowprice intValue]], @"productId":produreid, @"productName":produrename};
        TFAgentAddgoodsBill *addgoodsBill = [[TFAgentAddgoodsBill alloc]initWithInfor:billInfo];
        addgoodsBill.title = @"补货账单";
        [self.navigationController pushViewController:addgoodsBill animated:YES];
    }
}

-(BOOL)checkData
{    
    if (nowprice == nil)
    {
        [NLUtils showTosatViewWithMessage:[NSString stringWithFormat:@"获取价格失败，请检查网络"] inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return NO;
    }
    
    if ([_numTextField.text intValue] > [limitmaxnum intValue])
    {
        [NLUtils showTosatViewWithMessage:[NSString stringWithFormat:@"购买数量不能超过%@台",limitmaxnum] inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return NO;
    }
    
    if ([_numTextField.text intValue] < [limitminnum intValue])
    {
        [NLUtils showTosatViewWithMessage:[NSString stringWithFormat:@"购买数量不能少于%@台",limitminnum] inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return NO;
    }
    
    if ([NLUtils checkInterNum:_numTextField.text] && ([_numTextField.text intValue] > 0))
    {
        return YES;
    }
    else
    {
        [NLUtils showTosatViewWithMessage:@"请输入正确的数字" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return NO;
    }
}

//获取数据
-(void)getData
{
    NSString* name = [NLUtils getNameForRequest:Notify_readagentorder];
    REGISTER_NOTIFY_OBSERVER(self, readagentorderoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readagentorderlist:@"" msgstart:_msgstart msgdisplay:_msgdisplay];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)readagentorderoNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    [_pullToLoadMore finishedLoading];
    [_pullToRefresh finishedLoading];
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self doReadagentorderoNotify:response];
        });
        
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
        NSString *detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doReadagentorderoNotify:(NLProtocolResponse *)response
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
        data = [response.data find:@"msgbody/limitmaxnum" index:0];
        limitmaxnum = data.value;
        
        if (limitmaxnum.length==0)
        {
            limitmaxnum = @"20";  //后台没数据改成20
        }
        
        //data.value;
        data = [response.data find:@"msgbody/nowprice" index:0];
        nowprice = data.value;
        data = [response.data find:@"msgbody/limitminnum" index:0];
        limitminnum = data.value;
        
        if (limitmaxnum.length == 0)
        {
            limitminnum = @"1";  //后台没数据改为1
        }
        
        //data.value;
        data = [response.data find:@"msgbody/produreid" index:0];
        produreid = data.value;
        data = [response.data find:@"msgbody/produrename" index:0];
        produrename = data.value;
       
        /*
         orderid      订单号
         orderdate    订单日期
         ordermemo    订单描述
         orderstate   订单状态
        */
        
        NSArray* orderid = [response.data find:@"msgbody/msgchild/orderid"];
        NSArray* orderdate = [response.data find:@"msgbody/msgchild/orderdate"];
        NSArray* ordermemo = [response.data find:@"msgbody/msgchild/ordermemo"];
        // 订单状态 0.订单处理 1.已收款 2.已发货 9.已收货 -1.已取消
        NSArray* orderstate = [response.data find:@"msgbody/msgchild/orderstate"];
        
        NSString* orderidStr = nil;
        NSString* orderdateStr = nil;
        NSString* ordermemoStr = nil;
        NSString* orderstateStr = nil;
        
        for (int i = 0; i < [orderid count]; i++)
        {
            NLProtocolData* data = [orderid objectAtIndex:i];
            orderidStr = data.value;
            data = [orderdate objectAtIndex:i];
            orderdateStr = data.value;
            data = [ordermemo objectAtIndex:i];
            ordermemoStr = data.value;
            data = [orderstate objectAtIndex:i];
            orderstateStr = data.value;
            
            NSArray *timeStrArr = [orderdateStr componentsSeparatedByString:@"-"];
            NSString *timeStr = nil;
            
            if (timeStrArr.count > 2)
            {
                timeStr = [NSString stringWithFormat:@"%@/%@",timeStrArr[2],timeStrArr[1]];
            }
            else
            {
                timeStr = @"未知";
            }
            
            NSString *sendState =@"0";
            NSString *receiveState = @"0";
            
            if ([orderstateStr intValue] == 0 || [orderstateStr intValue] == 1 || [orderstateStr intValue] == -1)
            {
                sendState = @"0";
                receiveState = @"0";
            }
            else if ([orderstateStr intValue] == 2)
            {
                sendState = @"1";
                receiveState = @"0";
            }
            else if ([orderstateStr intValue] == 9)
            {
                sendState = @"1";
                receiveState = @"1";
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:timeStr,KEY_AGENT_ORDER_TIME, ordermemoStr,KEY_AGENT_ORDER_NUM,sendState,KEY_AGENT_ORDER_SENDSTATE,receiveState,KEY_AGENT_ORDER_RECEIVESTATE,orderidStr,KEY_AGENT_ORDER_ID,nil];
            [_dataArr addObject:dict];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [_table reloadData];
        });
        
        _msgstart = [NSString stringWithFormat:@"%d",[_msgstart integerValue]+10];
    }
}

//超时
- (void)doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

#pragma showErrorInfo
//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [_hud hide:YES];
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

#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end








