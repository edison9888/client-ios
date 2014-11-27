//
//  MyBankCardViewController.m
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//


#import "MyBankCardViewController.h"
#import "BankCardCell.h"
#import "CardInfo.h"
#import "PhoneMoneyGive.h"

@interface MyBankCardViewController ()
{
    NLProgressHUD *_hud;
    
    NSInteger currentHeight;
    //银行名称
    NSArray *bkcardbanks;
    //用户名
    NSArray *bkcardbankmans;
    //卡类型
    NSArray *bkcardcardtypes;
    NSArray *bkcardcardcct;

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
    NSArray *bkcardisdefaultpaymentData;/*雨*/
    
    /*信用卡支付*/
    NSMutableArray *mainArr;
    NSMutableArray *person;
    /*非筛选*/
    NSMutableArray *mainPerson;
    
    BankPayList *paylist;
    UITableView *table;
}

@end

@implementation MyBankCardViewController

@synthesize bankPayListDelegate = _bankPayListDelegate;
@synthesize QCoin = _QCoin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.title = @"我的银行卡";
    
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    //获取当前屏幕size
    currentHeight = iphoneSize;

    if (_righthidden != YES) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewBankAction:)];
    }
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, -24, SelfWidth, currentHeight - 40 ) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    //读取商户银行卡列表
    [self loadDataForKuaibkCard];
}

#pragma mark - 添加新的银行卡
- (void)addNewBankAction:(UIBarButtonItem *)sender
{
    if (_bankXY == YES || _bankDF == YES)
    {
        AddNewBankCardController *addView;
        
        if (_bankXY == YES)
        {
            addView = [[AddNewBankCardController alloc] initWithEdit:NO creditCard:YES];
        }
        else
        {
            addView = [[AddNewBankCardController alloc] initWithEdit:NO creditCard:NO];
        }
       
        addView.addDelegate = self;
        [self.navigationController pushViewController:addView animated:YES];
    }
    else
    {
        /*添加银行卡的*/
        AddNewBankCardController *addView = [[AddNewBankCardController alloc] initWithEdit:NO creditCard:YES];
        [addView addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
        addView.rightflag = YES;
        addView.addDelegate = self;
        [self.navigationController pushViewController:addView animated:YES];
    }
}

#pragma mark - 请求商户银行卡
- (void)loadDataForKuaibkCard
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoLists];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForCardLists, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoLists];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
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
        
        /*
        //默认支付 旧
        bkcardisdefaults = [response.data find:@"msgbody/msgchild/bkcardisdefault"];
         */
        
        //默认支付 新
        bkcardisdefaults = [response.data find:@"msgbody/msgchild/bkcardfudefault"];
        //默认收款
        bkcardisdefaultpaymentData = [response.data find:@"msgbody/msgchild/bkcardshoudefault"];/*雨*/
        
        //卡类型
        bkcardcardtypes = [response.data find:@"msgbody/msgchild/bkcardcardtype"];
        //cct
        bkcardcardcct = [response.data find:@"msgbody/msgchild/ctripbankctt"];
        NSLog(@"======bkcardcardcct====%@",bkcardcardcct);

        
        /*易宝支付*/
        if (_bankDF == YES || _bankXY == YES ||_agentflag == YES || _planeFlag== YES)
        {
            NSString *bkcardcardtypesStr= nil;
            NSString *bkcardisdefaultsStr= nil;
            NSString *bkcardisdefaultpaymentStr= nil;/*雨*/
            NSString *bkcardidcardsStr= nil;
            NSString *bkcardcvvsStr= nil;
            NSString *bkcardyxyearsStr= nil;
            NSString *bkcardyxmonthsStr= nil;
            NSString *bkcardbankphonesStr= nil;
            NSString *bkcardbanklogosStr= nil;
            NSString *bkcardbankidsStr= nil;
            NSString *bkcardidsStr= nil;
            NSString *bkcardnosStr= nil;
            NSString *bkcardbankmansStr= nil;
            NSString *bkcardbanksStr= nil;
            NSString *bkcardbankcode = nil;
            NSString *bkcardbankcctStr = nil;

            
            person= [NSMutableArray array];
            mainPerson = [NSMutableArray array];
            
            for (int i=0; i<bkcardcardtypes.count; i++)
            {
                NLProtocolData* data = [bkcardcardtypes objectAtIndex:i];
                bkcardcardtypesStr = data.value;
                
                data = [bkcardisdefaults objectAtIndex:i];
                bkcardisdefaultsStr = data.value;
                
                data = [bkcardisdefaultpaymentData objectAtIndex:i];
                bkcardisdefaultpaymentStr = data.value;/*雨*/
                
                data = [bkcardidcards objectAtIndex:i];
                bkcardidcardsStr = data.value;
                
                data = [bkcardcvvs objectAtIndex:i];
                bkcardcvvsStr = data.value;
                
                data = [bkcardyxyears objectAtIndex:i];
                bkcardyxyearsStr = data.value;
                
                data = [bkcardyxmonths objectAtIndex:i];
                bkcardyxmonthsStr = data.value;
                
                data = [bkcardbankphones objectAtIndex:i];
                bkcardbankphonesStr = data.value;
                
                data = [bkcardbanklogos objectAtIndex:i];
                bkcardbanklogosStr = data.value;
                
                data = [bkcardbankids objectAtIndex:i];
                bkcardbankidsStr = data.value;
                
                data = [bkcardids objectAtIndex:i];
                bkcardidsStr = data.value;
                
                data = [bkcardnos objectAtIndex:i];
                bkcardnosStr = data.value;
                
                data = [bkcardbankmans objectAtIndex:i];
                bkcardbankmansStr = data.value;
                
                data = [bkcardbanks objectAtIndex:i];
                bkcardbanksStr = data.value;
                
                /*拿bkcardbankids字段存bkcardbankcode*/
                data = [bkcardbankids objectAtIndex:i];
                bkcardbankcode = data.value;
                // cct
                data = [bkcardcardcct objectAtIndex:i];
                bkcardbankcctStr = data.value;
                NSLog(@"=====bkcardbankcctStr======%@",data.value);
            
                paylist= [[BankPayList alloc]init];
                paylist.bkcardbanks= bkcardbanksStr;
                paylist.bkcardbankmans= bkcardbankmansStr;
                paylist.bkcardnos= bkcardnosStr;
                paylist.bkcardids= bkcardidsStr;
                paylist.bkcardbankids= bkcardbankidsStr;
                paylist.Bkcardbanklogos= bkcardbanklogosStr;
                paylist.bkcardbankphones= bkcardbankphonesStr;
                paylist.bkcardyxmonths= bkcardyxmonthsStr;
                paylist.bkcardyxyears= bkcardyxyearsStr;
                paylist.bkcardcvvs= bkcardcvvsStr;
                paylist.bkcardidcards= bkcardidcardsStr;
                paylist.bkcardisdefaults= bkcardisdefaultsStr;
                paylist.bkcardisdefaultpayment = bkcardisdefaultpaymentStr;/*雨*/
                paylist.bkcardcardtypes= bkcardcardtypesStr;
                paylist.bkcardbankcode = bkcardbankcode;
                paylist.bkcardbankcctp = bkcardbankcctStr;
                [mainPerson addObject:paylist];
                NSLog(@"=====mainPerson11======%@",mainPerson);

                
                /*分类卡号类型*/
                if ([bkcardcardtypesStr isEqualToString:@"bankcard"] && _bankDF)
                {
                    /*储蓄卡*/
                    [person addObject:paylist];
                }
                else  if ([bkcardcardtypesStr isEqualToString:@"creditcard"] && _bankXY)
                {
                    /*信用卡*/
                    [person addObject:paylist];
                }
                
                mainArr= [NSMutableArray array];
                
                for (int i=0; i<bkcardcardtypes.count; i++)
                {
                    NLProtocolData* data = [bkcardcardtypes objectAtIndex:i];
                    bkcardcardtypesStr = data.value;
                    
                    [mainArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:bkcardcardtypesStr,@"bkcardcardtype",nil]];
                }
            }
            
            NSLog(@"mainArr %@",person);
        }
        
        [table reloadData];
    }
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (bkcardbanks)
    {
        return bkcardbanks.count;
    }
    
    /*
     if (_bankDF!=YES&&_bankXY!=YES)
     {
     return bkcardbanks.count;
     
     }
     暂时只需要一个支付通道
     NSMutableArray *arrcount= [NSMutableArray array];
     NSString *str;
     else if (_bankDF==YES)
     {
     for (int i=0; i<mainArr.count; i++) {
     str= [[mainArr valueForKey:@"bkcardcardtype"]objectAtIndex:i];
     po ([str isEqualToString:@"bankcard"]) {
     [arrcount addObject:str];
     }
     }
     return arrcount.count;
     
     }else if (_bankXY==YES){
     
     for (int i=0; i<mainArr.count; i++) {
     str= [[mainArr valueForKey:@"bkcardcardtype"]objectAtIndex:i];
     if ([str isEqualToString:@"creditcard"]) {
     [arrcount addObject:str];
     }
     }
     return arrcount.count;
     }
     */
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"注：只有信用卡能设置为默认支付，默认支付只能用于便民服务消费。";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[BankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_bankXY!=YES && _bankDF!=YES)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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
    //收款卡类型  /*雨*/
    NLProtocolData *bkcardisdefaultpaymentsData = bkcardisdefaultpaymentData[indexPath.row];
    NSLog(@"支付卡数组:%d  通付卡数组%d",bkcardisdefaults.count,bkcardisdefaultpaymentData.count);
    
    NSString *cardType = [bkcardcardtype.value isEqualToString:@"bankcard"]? @"储蓄卡" : @"信用卡";
    NSString *cardNumbe = bkcardnoData.value.length > 4? [bkcardnoData.value substringFromIndex:(bkcardnoData.value.length - 4)] : @" ";

    cell.defaultCard.alpha = [bkcardisdefaultData.value isEqualToString:@"1"]? 1 : 0;
    cell.receivables.alpha = [bkcardisdefaultpaymentsData.value isEqualToString:@"1"]? 1 : 0;/*雨*/
    
    NSLog(@"默认支付:%@    默认付款:%@",bkcardisdefaultData.value,bkcardisdefaultpaymentsData.value);
    
    cell.logoView.image = [UIImage imageNamed:bkcardbanklogoData.value];
    cell.cardNumber.text = [NSString stringWithFormat:@"尾号:%@",cardNumbe];
    cell.bankName.text = bankNameData.value;
    cell.masterName.text = bkcardbankmanData.value;
    cell.cardType.text = cardType;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //银行名称
    NLProtocolData *bankNameData = bkcardbanks[indexPath.row];
    //用户名
    NLProtocolData *bkcardbankmanData = bkcardbankmans[indexPath.row];
    //卡号
    NLProtocolData *bkcardnoData = bkcardnos[indexPath.row];
    //银行卡id
    NLProtocolData *bkcardidData = bkcardids[indexPath.row];
    //所属银行id
    NLProtocolData *bkcardbankidData = bkcardbankids[indexPath.row];
    //银行logo
    NLProtocolData *bkcardbanklogoData = bkcardbanklogos[indexPath.row];
    //预留电话
    NLProtocolData *bkcardbankphoneData = bkcardbankphones[indexPath.row];
    //有效月
    NLProtocolData *bkcardyxmonthData = bkcardyxmonths[indexPath.row];
    //有效年
    NLProtocolData *bkcardyxyearData = bkcardyxyears[indexPath.row];
    //cvv
    NLProtocolData *bkcardcvvData = bkcardcvvs[indexPath.row];
    //身份证
    NLProtocolData *bkcardidcardData = bkcardidcards[indexPath.row];
    //默认支付
    NLProtocolData *bkcardisdefaultData = bkcardisdefaults[indexPath.row];
    //默认收款
    NLProtocolData *bkcardisdefaultpaymentsData = bkcardisdefaultpaymentData[indexPath.row];/*雨*/
    
    //卡类型
    NLProtocolData *bkcardcardtypeData = bkcardcardtypes[indexPath.row];
    
    CardInfo *cardInfo = [CardInfo infoWithBkcardno:bkcardnoData.value
                                       bkcardbankid:bkcardbankidData.value
                                         bkcardbank:bankNameData.value
                                     bkcardbanklogo:bkcardbanklogoData.value
                                      bkcardbankman:bkcardbankmanData.value
                                    bkcardbankphone:bkcardbankphoneData.value
                                      bkcardyxmonth:bkcardyxmonthData.value
                                       bkcardyxyear:bkcardyxyearData.value
                                          bkcardcvv:bkcardcvvData.value
                                       bkcardidcard:bkcardidcardData.value
                                    bkcardisdefault:bkcardisdefaultData.value
                             bkcardisdefaultPayment: bkcardisdefaultpaymentsData.value
                                     bkcardcardtype:bkcardcardtypeData.value
                                           bkcardid:bkcardidData.value];
    
    BOOL creditCard = [bkcardcardtypeData.value isEqualToString:@"bankcard"]? NO :YES;
    
    //Q币支付选择
    if (_QCoin)
    {
        [_bankPayListDelegate popWithValue:cardInfo creditCard:creditCard];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return ;
    }
    
    if (_bankDF != YES && _bankXY != YES)
    {
        NSArray *infos = nil;
        
        NSString *bankName = bankNameData.value? bankNameData.value : @" ";
        NSString *bkcardno = bkcardnoData.value? bkcardnoData.value : @" ";
        NSString *bkcardbankman = bkcardbankmanData.value? bkcardbankmanData.value : @" ";
        NSString *bkcardbankphone = bkcardbankphoneData.value? bkcardbankphoneData.value : @" ";
        NSString *bkcardcvv = bkcardcvvData.value? bkcardcvvData.value : @" ";
        NSString *bkcardidcard = bkcardidcardData.value? bkcardidcardData.value : @" ";
        
        infos = @[ bankName, bkcardno, bkcardbankman, bkcardbankphone, bkcardcvv, bkcardidcard ];
        NSLog(@"====infos=====%@",infos);
        if (_agentflag == YES)
        {
            NSString *DForXY= [mainPerson valueForKey:@"bkcardcardtypes"][indexPath.row];
            BOOL flag = [DForXY isEqualToString:@"bankcard"]? YES : NO;
            [self.navigationController popViewControllerAnimated:YES];
            [_bankPayListDelegate popWithValue:[mainPerson objectAtIndex:indexPath.row] creditCard:flag];
        }
        else if (_planeFlag == YES)
        {
            /*返回直接添加到对应的银行付款列表 如果是储蓄卡 直接储蓄提示不可选*/
            NSString *DForXY= [mainPerson valueForKey:@"bkcardcardtypes"][indexPath.row];
            NSLog(@"=====DForXY=====%@",DForXY);
            BOOL flag = [DForXY isEqualToString:@"bankcard"]? YES : NO;
            NSLog(@"=====flag=====%d",flag);
            NSLog(@"=====mainPerson=====%@",mainPerson);

            //            [_bankPayListDelegate popWithValue:[mainPerson objectAtIndex:indexPath.row] creditCard:flag];
            if (flag == NO)
            {
                [_bankPayListDelegate popWithValue:[mainPerson objectAtIndex:indexPath.row] creditCard:flag];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示:" message:@"亲！请选择信用卡哦！" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
                [alertView show];
            }
                    }
        else
        {
            [self.view endEditing:YES];
            AddNewBankCardController *addView = [[AddNewBankCardController alloc] initWithEdit:YES creditCard:creditCard];
            addView.addDelegate = self;
            addView.rightflag= creditCard;
            addView.masterInfos = infos;
            addView.cardInfo = cardInfo;
//            NSLog(@"默认付款卡！！！ %@",cardInfo.bkcardisdefaultPayment);
            [self.navigationController pushViewController:addView animated:YES];
        }
    }
    else
    {
        /*返回直接添加到对应的银行付款列表*/
        NSString *DForXY= [mainPerson valueForKey:@"bkcardcardtypes"][indexPath.row];
        BOOL flag = [DForXY isEqualToString:@"bankcard"]? YES : NO;
        [self.navigationController popViewControllerAnimated:YES];
        [_bankPayListDelegate popWithValue:[mainPerson objectAtIndex:indexPath.row] creditCard:flag];
    }
}

#pragma mark - AddDelegate
- (void)popAndReloadData
{
    if (_bankDF == YES || _bankXY == YES)
    {
        [self loadDataForKuaibkCard];
    }
    else
    {
        [self loadDataForKuaibkCard];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

