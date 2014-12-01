//
//  TFAgentBookCardCtr.m
//  TongFubao
//
//  Created by ec on 14-9-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFAgentBookCardCtr.h"
#import "NLUtils.h"
#import "TFAgentOrderOfPayment.h"
#import "NLpublic.h"
#import "TFAgentAddgoodsCell.h"

#import "DDXML.h"
#import "DDXMLElementAdditions.h"

@interface TFAgentBookCardCtr ()
{
    NLProgressHUD* _hud;
    NSString* _msgstart;
    NSString* _msgdisplay;
    NSString* msgPage;
    
    NSString* limitmaxnum;
    NSString* nowprice;
    NSString* limitminnum;
    NSString* produreid;
    NSString* produrename;
    NSMutableArray *dataArr;
}

@property (nonatomic,strong) UITextField *numTextField;

@property (nonatomic,strong) UITableView *table;


@property (nonatomic, retain) PullToLoadMore                *pullToLoadMore;
@property (nonatomic, strong) PullToRefreshView             *pullToRefresh;

@property (nonatomic,strong) NSIndexPath *clickPath;

@end

@implementation TFAgentBookCardCtr

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
    dataArr = [NSMutableArray arrayWithCapacity:10];
    
    _msgstart = @"0";
    _msgdisplay = @"100";
    msgPage = @"10";
    
    limitmaxnum = nil;
    limitminnum = nil;
    nowprice = nil;
    produreid = nil;
    produrename = nil;
    
    [self getInfo:@"0" :@"10"];
    
    _numTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self UIInit];
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
    _numTextField.placeholder = @"请输入订购数量";
    //---左缩进
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    _numTextField.leftView = view;
    
    _numTextField.leftViewMode = UITextFieldViewModeAlways;
    //---
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
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT + 108, 320, tableHeight)];
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
    
    //键盘隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
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
    return  dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row % 2 == 0)
    {
        cell.contentView.backgroundColor = SACOLOR(236, 1.0);
    }
    else
    {
        cell.contentView.backgroundColor = SACOLOR(243, 1.0);
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"       %@    %@",[[dataArr objectAtIndex:indexPath.row]objectForKey:@"orderdate"],[[dataArr objectAtIndex:indexPath.row]objectForKey:@"ordermemo"]];
    NSLog(@"indexPath.row:   %d",indexPath.row);
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
    
}



#pragma mark - 更多刷新
- (void)PullToLoadMoreViewShouldRefresh:(PullToLoadMore *)view
{
    NSString *stringInt = [NSString stringWithFormat:@"%d",([msgPage intValue]+10)];
    [self getData:msgPage :stringInt];
    [_pullToLoadMore finishedLoading];
    [_pullToRefresh finishedLoading];
    msgPage = stringInt;
}

#pragma mark 下拉刷新
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view
{
    [self getInfo:@"0" :@"10"];
    [_pullToLoadMore finishedLoading];
    [_pullToRefresh finishedLoading];
    msgPage = @"10";
}

#pragma mark - 点击支付
- (void)clickPay:(UIButton *)sender
{
    
    [self.view endEditing:YES];

    if ([self checkData])
    {
        NSDictionary *billInfo = @{@"num":_numTextField.text, @"factBill":[NSString stringWithFormat:@"%.2f", [nowprice floatValue]], @"totalPay":[NSString stringWithFormat:@"%.2f", [_numTextField.text floatValue]* [nowprice floatValue]], @"productId":produreid, @"productName":produrename};
        /*订购*/
        TFAgentOrderOfPayment *addBill = [[TFAgentOrderOfPayment alloc]initWithInfor:billInfo];
        addBill.title = @"订单支付";
        [self.navigationController pushViewController:addBill animated:YES];
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
        [NLUtils showTosatViewWithMessage:[NSString stringWithFormat:@"订购数量不能超过%@",limitmaxnum] inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return NO;
    }
    
    if ([_numTextField.text intValue] < [limitminnum intValue])
    {
        if ([_numTextField.text intValue]==0) {
            [NLUtils showTosatViewWithMessage:[NSString stringWithFormat:@"请输入订购数量"] inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        }else{
            [NLUtils showTosatViewWithMessage:[NSString stringWithFormat:@"订购数量不能少于%@",limitminnum] inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        }
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
#pragma mark - 获取产品信息数据
-(void)getInfo:(NSString *)start :(NSString *)display
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    NSString *str=[NSString stringWithFormat:SERVER_URL];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary * msgDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    [msgDictionary setValue:@"" forKey:@"paytype"];//
    [msgDictionary setValue:start forKey:@"msgstart"];//
    [msgDictionary setValue:display forKey:@"msgdisplay"];//
    
    NSData *bodyData = [[NLpublic new] encrypt:[[NLpublic new] msgbody:msgDictionary api_name:@"ApiExpresspayInfo" api_name_func:@"readagentorder"]];
    [request setHTTPBody:bodyData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSString *temp3 = [[NLpublic new] decrypt: html];
        
        NSDictionary *msg = [[NLpublic new] xml_TO_dictionary:[temp3 dataUsingEncoding: NSUTF8StringEncoding] rolePath:@"//operation_response/msgbody" type:PublicCommon];
        
        if ([msg[@"result"]isEqualToString:@"success"]) {
            dataArr = [[NLpublic new] xml_TO_dictionary_child:[temp3 dataUsingEncoding: NSUTF8StringEncoding] :@"//operation_response/msgbody/msgchild"];
            limitmaxnum = [msg stringValueForKeyPath:@"limitmaxnum"];
            limitminnum = [msg stringValueForKeyPath:@"limitminnum"];
            nowprice = [msg stringValueForKeyPath:@"nowprice"];
            produreid = [msg stringValueForKeyPath:@"produreid"];
            produrename = [msg stringValueForKeyPath:@"produrename"];
            [_table reloadData];
            [_hud hide:YES];
        }else{
            [NLUtils showTosatViewWithMessage:@"获取列表失败！" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}


#pragma mark - 列表数据分页缓冲
-(void)getData:(NSString *)start :(NSString *)display
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    NSDictionary *dataDictionary = @{ @"paytype" : @" ",
                                      @"msgstart" :  start,
                                      @"msgdisplay" :  display
                                      };
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiExpresspayInfo" apiNameFunc:@"readagentorder" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        NSLog(@"ddd %@",data);
        [self appendTableWith:data];
        [_hud hide:YES];
    }];
}

-(void) appendTableWith:(NSMutableArray *)data
{
    for (int i=0;i<[data count];i++) {
        [dataArr addObject:[data objectAtIndex:i]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [data count]; ind++) {
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[dataArr indexOfObject:[data objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [_table insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark -



#pragma mark showErrorInfo
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 键盘控制

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_numTextField resignFirstResponder];
}

@end