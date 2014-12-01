//
//  SMSBankCardViewController.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSBankCardViewController.h"

#import "SMSAddBankCardViewController.h"

#import "XIAOYU_TheControlPackage.h"
#import "SMSBankCell.h"


@interface SMSBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,addBankCardDelegate>{
    
    NLProgressHUD *_hud;
    
    //银行名称
    NSArray *bkcardbanks;
    //用户名
    NSArray *bkcardbankmans;
    //卡类型
    NSArray *bkcardcardtypes;
    //银行logo
    NSArray *bkcardbanklogos;
    //卡号
    NSArray *bkcardnos;
    //银行卡id
    NSArray *bkcardids;
    //所属银行id
    NSArray *bkcardbankids;
    //预留电话
    NSArray *bkcardbankphones;
    //有效月
    NSArray *bkcardyxmonths;
    //有效年
    NSArray *bkcardyxyears;
    //cvv
    NSArray *bkcardcvvs;
    //身份证
    NSArray *bkcardidcards;
    //默认支付
    NSArray *bkcardisdefaults;
    //默认收款
    NSArray *bkcardisdefaultpaymentData;
    
    /*信用卡支付*/
    NSMutableArray *mainArr;
    NSMutableArray *person;
    /*非筛选*/
    NSMutableArray *mainPerson;
    
    BankPayList *paylist;
    
    UITableView *table;
 
    BOOL refreshs;
    
    
    
    NSString *bankNameStr;
    NSString *bkcardbankmanStr;
    NSString *bkcardnoStr;
    NSString *cardTypeStr;
    UIImage *bankLogoStr;
    NSString *bkcardbankphonesStr;
}




@end

@implementation SMSBankCardViewController

-(void)tapleftBarButtonItemBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -协议代理 添加银行卡成功 刷新当前银行卡列表
-(void)agent:(SMSAddBankCardViewController *)vc Refresh:(BOOL)refresh theOpeningBankString:(NSString *)theOpeningBankString creditCard:(NSString *)creditCard name:(NSString *)name phone:(NSString *)phone identity:(NSString *)identity ccv:(NSString *)ccv month:(NSString *)month years:(NSString *)years{
    
    refreshs = refresh;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"1刷新 0不刷新  %hhd",refreshs);
    
    if (refreshs == YES) {
        [self loadDataForKuaibkCard];//刷新银行卡列表
    }
    //还原初始值
    refreshs = NO;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    
    self.title = @"设置默认收款账户";
    //设定初始值
    refreshs = NO;
    
    [self navigationItems];
    [self tableViewController];
    
    [self loadDataForKuaibkCard];//获取银行卡列表
}


-(void)navigationItems{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapAddBankCard)];
    
}

#pragma mark -跳转添加银行卡
-(void)tapAddBankCard{
    
    SMSAddBankCardViewController *vc = [[SMSAddBankCardViewController alloc]init];
    vc.delegate = self;
    vc.stateIndex = 2;// 1:短信收款主界面  2:短信收款银行卡列表
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
    NSLog(@"添加银行卡");
}



#pragma mark - 请求 银行卡列表
- (void)loadDataForKuaibkCard
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoLists];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForCardLists, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoLists];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
}

#pragma mark - 网络请求判断
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]];
            
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


#pragma mark - 通知方法 接口网络数据处理写在这
- (void)checkDataForCardLists:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [_hud hide:YES];
        [self getApiAuthorKuaibkcardInfoListsWithResponse:response];
    }
    else
    {
        [_hud hide:YES];
        NSString *string = response.detail;
        NSLog(@"string = %@",string);
        
        if (bkcardbanks)
        {
            bkcardbanks = nil;
            
            [table reloadData];
        }
    }
}


- (void)getApiAuthorKuaibkcardInfoListsWithResponse:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@", errorData);
    }
    else
    {
        //银行卡名
        bkcardbanks = [response.data find:@"msgbody/msgchild/bkcardbank"];
        //用户名
        bkcardbankmans = [response.data find:@"msgbody/msgchild/bkcardbankman"];
        //卡号
        bkcardnos = [response.data find:@"msgbody/msgchild/bkcardno"];
        //银行卡id
        bkcardids = [response.data find:@"msgbody/msgchild/bkcardid"];
        //所属银行id
        bkcardbankids = [response.data find:@"msgbody/msgchild/bkcardbankcode"];
        //银行logo
        bkcardbanklogos = [response.data find:@"msgbody/msgchild/bkcardbanklogo"];
        //预留电话
        bkcardbankphones = [response.data find:@"msgbody/msgchild/bkcardbankphone"];
        //有效月
        bkcardyxmonths = [response.data find:@"msgbody/msgchild/bkcardyxmonth"];
        //有效年
        bkcardyxyears = [response.data find:@"msgbody/msgchild/bkcardyxyear"];
        //cvv
        bkcardcvvs = [response.data find:@"msgbody/msgchild/bkcardcvv"];
        //身份证
        bkcardidcards = [response.data find:@"msgbody/msgchild/bkcardidcard"];

        //默认支付
        bkcardisdefaults = [response.data find:@"msgbody/msgchild/bkcardfudefault"];
        //默认收款
        bkcardisdefaultpaymentData = [response.data find:@"msgbody/msgchild/bkcardshoudefault"];
        
        //卡类型
        bkcardcardtypes = [response.data find:@"msgbody/msgchild/bkcardcardtype"];
        }
        [table reloadData];
}


#pragma mark - UITableView创建
-(void)tableViewController{
    
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 280, 40)];
    label.text = @"该账户将作为您的默认收款账户。您可以通过“我的银行卡”菜单进行账户的新增、变更或删除。";
    label.numberOfLines = 2;
    [label setFont:[UIFont fontWithName:nil size:13]];
    [vc addSubview:label];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = vc;
    [self.view addSubview:table];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bkcardbanks.count;
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSBankCell*cell;
    static NSString *identifier = @"SMSBankCell";
    cell = (SMSBankCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SMSBankCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //银行名称
    NLProtocolData *bankNameData = bkcardbanks[indexPath.row];
    //用户名
    NLProtocolData *bkcardbankmanData = bkcardbankmans[indexPath.row];
    //卡类型
    NLProtocolData *bkcardcardtype = bkcardcardtypes[indexPath.row];
    //卡号
    NLProtocolData *bkcardnoData = bkcardnos[indexPath.row];
    //银行logo
    NLProtocolData *bkcardbanklogoData = bkcardbanklogos[indexPath.row];
    //支付卡类型
    NLProtocolData *bkcardisdefaultData = bkcardisdefaults[indexPath.row];
    //收款卡类型
    NLProtocolData *bkcardisdefaultpaymentsData = bkcardisdefaultpaymentData[indexPath.row];
    NSLog(@"支付卡数组:%d  通付卡数组%d",bkcardisdefaults.count,bkcardisdefaultpaymentData.count);
    
    
    NSString *cardType = [bkcardcardtype.value isEqualToString:@"bankcard"]? @"储蓄卡" : @"信用卡";
    NSString *cardNumbe = bkcardnoData.value.length > 4? [bkcardnoData.value substringFromIndex:(bkcardnoData.value.length - 4)] : @" ";
    
    cell.receivablesPayment.alpha = [bkcardisdefaultpaymentsData.value isEqualToString:@"1"]? 1 : 0;//默认收款
    cell.receivablesPaymentImageView.alpha = [bkcardisdefaultpaymentsData.value isEqualToString:@"1"]? 1 : 0;//默认收款
    
    cell.payment.alpha = [bkcardisdefaultData.value isEqualToString:@"1"]? 1 : 0;//默认支付
    cell.paymentImageView.alpha = [bkcardisdefaultData.value isEqualToString:@"1"]? 1 : 0;//默认支付
    

    cell.bankLOGO.image = [UIImage imageNamed:bkcardbanklogoData.value];//银行LOGO
    cell.tailNumber.text = [NSString stringWithFormat:@"尾号:%@",cardNumbe];//尾号
    cell.bank.text = bankNameData.value;//银行名称
    cell.name.text = bkcardbankmanData.value;//开户名称
    cell.bankCard.text = cardType;//银行卡类别
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //银行名称
    NLProtocolData *bankNameData = bkcardbanks[indexPath.row];
    //用户名
    NLProtocolData *bkcardbankmanData = bkcardbankmans[indexPath.row];
    //卡类型
    NLProtocolData *bkcardcardtype = bkcardcardtypes[indexPath.row];
    //银行卡号
    NLProtocolData *bkcardnoData = bkcardnos[indexPath.row];
    //银行logo
    NLProtocolData *bkcardbanklogoData = bkcardbanklogos[indexPath.row];
    //所属银行ID
    NLProtocolData *bkcardbankidsData = bkcardbankids[indexPath.row];
    //银行卡ID
    NLProtocolData *bkcardidsData = bkcardids[indexPath.row];
    //电话号码
    NLProtocolData *bkcardbankphonesData = bkcardbankphones[indexPath.row];
    //有效月
    NLProtocolData *bkcardyxmonthsData = bkcardyxmonths[indexPath.row];
    NSString *bkcardyxmonthsDatas = bkcardyxmonthsData.value ? bkcardyxmonthsData.value: @"nil";
    //有效年
    NLProtocolData *bkcardyxyearsData = bkcardyxyears[indexPath.row];
    NSString *bkcardyxyearsDatas = bkcardyxyearsData.value ? bkcardyxyearsData.value: @"nil";
    //cvv
    NLProtocolData *bkcardcvvsData = bkcardcvvs[indexPath.row];
    NSString *bkcardcvvsDatas = bkcardcvvsData.value ? bkcardcvvsData.value: @"nil";
    //身份证
    NLProtocolData *bkcardidcardsData = bkcardidcards[indexPath.row];
    NSString *bkcardidcardsDatas = bkcardidcardsData.value ? bkcardidcardsData.value: @"nil";
  
    NSString *cardType = [bkcardcardtype.value isEqualToString:@"bankcard"]? @"储蓄卡" : @"信用卡";

    bankNameStr = [NSString stringWithFormat:@"%@",bankNameData.value ];
    bkcardbankmanStr = [NSString stringWithFormat:@"%@",bkcardbankmanData.value ];
    bkcardnoStr = [NSString stringWithFormat:@"%@",bkcardnoData.value ];
    cardTypeStr = [NSString stringWithFormat:@"%@",cardType];
    bankLogoStr = [UIImage imageNamed:bkcardbanklogoData.value];
    bkcardbankphonesStr = [NSString stringWithFormat:@"%@",bkcardbankphonesData.value];
    
 
//    [self.delegate agent:self BankName:bankNameData.value AccountName:bkcardbankmanData.value TailNumber:bkcardnoData.value Category:cardType BankLogo:[UIImage imageNamed:bkcardbanklogoData.value] Bankphone:bkcardbankphonesData.value];

    
    if ([bkcardcardtype.value isEqualToString:@"信用卡"] && ([bankNameData.value isEqualToString:@"中国银行"] || [bankNameData.value isEqualToString:@"中国工商银行"] || [bankNameData.value isEqualToString:@"中国建设银行"] || [bankNameData.value isEqualToString:@"中国农业银行"] || [bankNameData.value isEqualToString:@"光大银行"] || [bankNameData.value isEqualToString:@"中国交通银行"])) {

        [self showErrorInfo:@"目前暂不支持以下六家银行的信用卡作为默认收款卡：中国银行,中国建设银行,中国工商银行,中国农业银行,交通银行,光大银行" status:NLHUDState_Error];
        
    }else{
    
    //设置选中卡为默认收款卡 信用卡与储蓄卡共用此接口
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoEdit];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForCardEdit, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoEdit:bkcardidsData.value
                                                                            bkcardbankid:bkcardbankidsData.value
                                                                              bkcardbank:bankNameData.value
                                                                               bkcardno:bkcardnoData.value
                                                                           bkcardbankman:bkcardbankmanData.value
                                                                         bkcardbankphone:bkcardbankphonesData.value
                                                                           bkcardyxmonth:bkcardyxmonthsDatas
                                                                            bkcardyxyear:bkcardyxyearsDatas
                                                                               bkcardcvv:bkcardcvvsDatas
                                                                            bkcardidcard:bkcardidcardsDatas
                                                                          bkcardcardtype:bkcardcardtype.value
                                                                         bkcardisdefault:@"999"
                                                                  bkcardisdefaultPayment:@"1"];
        
        NSLog(@"\n传的参数 :\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",bkcardidsData.value,bkcardbankidsData.value,bankNameData.value,bkcardnoData.value,bkcardbankmanData.value,bkcardbankphonesData.value,bkcardyxmonthsDatas,bkcardyxyearsDatas,bkcardcvvsDatas,bkcardidcardsDatas,bkcardcardtype.value);
    }
  
    
    
    
}


#pragma mark - 判断网络请求结果
- (void)checkDataForCardEdit:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        //成功或失败
        [self getDataWithNewCard:response];
    }
    else
    {
        NSString *string = response.detail;
        //服务器繁忙
        [self showError:string];
    }
}


- (void)showError:(NSString *)detail
{
    if (detail)
    {
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
    else
    {
        [self showErrorInfo:@"服务器繁忙，请稍候再试" status:NLHUDState_Error];
    }
}

- (void)getDataWithNewCard:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        [self showError:@"操作成功"];
        //代理协议方法
        [self.delegate agent:self BankName:bankNameStr AccountName:bkcardbankmanStr TailNumber:bkcardnoStr Category:cardTypeStr BankLogo:bankLogoStr Bankphone:bkcardbankphonesStr];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}








- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
