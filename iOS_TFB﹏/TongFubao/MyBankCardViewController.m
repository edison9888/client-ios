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
    //默认
    NSArray *bkcardisdefaults;
    
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
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewBankAction:)];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    //读取商户银行卡列表
    [self loadDataForKuaibkCard];
}

#pragma mark - 添加新的银行卡
- (void)addNewBankAction:(UIBarButtonItem *)sender
{
    if (_bankXY==YES||_bankDF==YES) {
        AddNewBankCardController *addView;
        if (_bankXY==YES) {
           addView  = [[AddNewBankCardController alloc] initWithEdit:NO creditCard:YES];
        }else{
           addView = [[AddNewBankCardController alloc] initWithEdit:NO creditCard:NO];
        }
        addView.addDelegate = self;
        [self.navigationController pushViewController:addView animated:YES];
    }else{
        /*添加银行卡的*/
    AddNewBankCardController *addView = [[AddNewBankCardController alloc] initWithEdit:NO creditCard:NO];
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
}

- (void)checkDataForCardLists:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getApiAuthorKuaibkcardInfoListsWithResponse:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"string = %@",string);
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
        //默认
        bkcardisdefaults = [response.data find:@"msgbody/msgchild/bkcardisdefault"];
        //卡类型
        bkcardcardtypes = [response.data find:@"msgbody/msgchild/bkcardcardtype"];
    
        /*易宝支付*/
        if (_bankDF==YES||_bankXY==YES) {
            
            NSString *bkcardcardtypesStr= nil;
            NSString *bkcardisdefaultsStr= nil;
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
            
            person= [NSMutableArray array];
            mainPerson = [NSMutableArray array];

            for (int i=0; i<bkcardcardtypes.count; i++) {
                
                NLProtocolData* data = [bkcardcardtypes objectAtIndex:i];
                bkcardcardtypesStr = data.value;
                
                data = [bkcardisdefaults objectAtIndex:i];
                bkcardisdefaultsStr = data.value;
                
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
                paylist.bkcardcardtypes= bkcardcardtypesStr;
                paylist.bkcardbankcode = bkcardbankcode;
                
                [mainPerson addObject:paylist];
                /*分类卡号类型*/
                if ([bkcardcardtypesStr isEqualToString:@"bankcard"]&&_bankDF) {
                    /*储蓄卡*/
                     [person addObject:paylist];
                }else  if ([bkcardcardtypesStr isEqualToString:@"creditcard"]&&_bankXY){
                    /*信用卡*/
                     [person addObject:paylist];
                }
                
                mainArr= [NSMutableArray array];
                
                for (int i=0; i<bkcardcardtypes.count; i++) {
                    
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
            if ([str isEqualToString:@"bankcard"]) {
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
    //卡类型
    NLProtocolData *bkcardisdefaultData = bkcardisdefaults[indexPath.row];
    
    NSString *cardType = [bkcardcardtype.value isEqualToString:@"bankcard"]? @"储蓄卡" : @"信用卡";
    /*截取数据 不行*/
    NSString *cardNumbe = [bkcardnoData.value substringFromIndex:(bkcardnoData.value.length - 4)];
    
    cell.defaultCard.text = [bkcardisdefaultData.value isEqualToString:@"1"]? @"默认卡" : @" ";
    cell.logoView.image = [UIImage imageNamed:bkcardbanklogoData.value];
    cell.cardNumber.text = [NSString stringWithFormat:@"尾号:%@",cardNumbe];
    cell.bankName.text = bankNameData.value;
    cell.masterName.text = bkcardbankmanData.value;
    cell.cardType.text = cardType;
    
    /*筛选信用卡 储蓄卡列表的
    if (_bankDF==YES||_bankXY==YES)
    {
        NSString *cardType = [[person valueForKey:@"bkcardcardtypes"][indexPath.row] isEqualToString:@"bankcard"]? @"储蓄卡" : @"信用卡";
     
        NSString *bkcard= [person valueForKey:@"bkcardnos"][indexPath.row];
        NSString *cardNumbe= @"1234";
        if (bkcard.length>4) {
            cardNumbe = [bkcard substringFromIndex:(bkcard.length - 4)];
        }
       
        if (_bankXY == YES)
        {
              cell.cardType.text = cardType;
        }
        else
        {
              cell.cardType.text = cardType;
        }
        
        cell.cardNumber.text = [NSString stringWithFormat:@"尾号:%@",cardNumbe];
        cell.defaultCard.text =[[person valueForKey:@"bkcardisdefaults"][indexPath.row]  isEqualToString:@"1"]? @"默认卡" : @" ";
        cell.bankName.text = [person valueForKey:@"bkcardbanks"][indexPath.row];
        cell.masterName.text = [person valueForKey:@"bkcardbankmans"][indexPath.row];
        cell.logoView.image = [UIImage imageNamed:[person valueForKey:@"Bkcardbanklogos"][indexPath.row]];
    }
    */
//    else
//    {
//       
//    }
    
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
    //默认
    NLProtocolData *bkcardisdefaultData = bkcardisdefaults[indexPath.row];
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
        
        AddNewBankCardController *addView = [[AddNewBankCardController alloc] initWithEdit:YES creditCard:creditCard];
        addView.addDelegate = self;
        addView.masterInfos = infos;
        addView.cardInfo = cardInfo;
        [self.navigationController pushViewController:addView animated:YES];
    }
    else
    {
        /*返回直接添加到对应的银行付款列表*/
        NSString *DForXY= [mainPerson valueForKey:@"bkcardcardtypes"][indexPath.row];
        BOOL flag = [DForXY isEqualToString:@"bankcard"]? YES: NO;
        [self.navigationController popViewControllerAnimated:YES];
        [_bankPayListDelegate popWithValue:[mainPerson objectAtIndex:indexPath.row] creditCard:flag];
    }
}

#pragma mark - AddDelegate
- (void)popAndReloadData
{
    if (_bankDF==YES||_bankXY==YES)
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

