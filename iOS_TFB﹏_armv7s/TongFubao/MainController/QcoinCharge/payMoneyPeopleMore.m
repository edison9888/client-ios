//
//  ayMoneyPeopleMore.m
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "payMoneyPeopleMore.h"

@interface payMoneyPeopleMore ()
{
    /*刷卡基本变量*/
    NSString* _bankid;
    NSString* _supshoucardno;
    NSString* _shoucardno;
    NSString* _reshoucardno;
    NSString* _paycardid;
    NSString* _cardno;
    NSString* _payCardCheck;
    NSString* _result;
    NSArray * _visaReaderArray;
    
    NSString*paytype_check;
    NSString*skqhaveYes;
    NSString*wagelistidStr;
    
    /*显示或不显示*/
    BOOL _enablePayCard;
    BOOL _enableCardImage;
    UIImageView    *imageCard;
    VisaReader     * _visaReader;
    NLProgressHUD  * _hud;
    
    /*刷卡器对比信用卡信息*/
    NSString * bkcardyxmonthStr;
    NSString * bkcardbanknameStr;
    NSString * bkcardbankidCheckStr;
    NSString * bkcardphoneStr;
    NSString * bkcardmanCheckStr;
    NSString * bkcardnoCheckStr;
    NSString * bkcardtypeStr;
    NSString * bkcardidcardStr;
    NSString * bkcardcvvStr;
    NSString * bkcardyxyearStr;
    NSString * bkcardbankids;
    
    /*接口参数cell*/
    NSString *wagepaymoney; //刷卡金额
    NSString *wagemonth;	//支付月份
    NSString *wagemoney;	//支付金额
    NSString *fucardno;		//银行卡号
    NSString *fucardbank;	//发卡银行
    NSString *wagelistid;	//工资月份id
    
    /*CELL PAY LIST*/
    NSString *cellAllMoney;/*刷金需要发放总金额*/
    NSString *cellisPayMoney;/*已支付*/
    NSString *cellPeople;
    NSString *cellPaySXF;
    NSString *cellPayMoneySXF;
    NSString *cellAllPayMoney;/*实际支付*/
    
    NSDictionary *dataDictionary;
    /*第五次改了 懒得说*/
    NSMutableArray *yibaoarrid;/*当前为易宝支付通道id数组*/
    
    BOOL         flagTY;
    BOOL         moneyType;/*懒得算了 直接布尔值区分*/
    BOOL         flagupp;
    UITextField    *alertText;
    /*接口不确定改了三次 懒得删了 不敢删*/
    NSString *strMax;/*刷卡数值金额*/
    NSString *paychalSXF;/*最大金额支付*/
    NSString *payMoneySXF;/*获取手续费*/
    NSString *payIsOkMoney;/*已支付*/
    
    /*验证码等变量*/
    NSString *bkordernumber;
    NSString *verifytoken;
    
    /*还需支付*/
    NSString *cellMoneyNeedPay;
    /*本次需支付手续费*/
    NSString *payfee;
    /*手续费最低额*/
    NSString *minfee;
    /*手续费最高额*/
    NSString *maxfee;
    /*手续费%*/
    NSString *feeperent;

    /*银联银行名支付*/
    NSArray *banknames;
    
    NSString *Feepaymoney;//刷卡金额
    NSString *Feepayfee;//刷卡金额
    NSString *Feemoney;//交易金额
    
}

@end

@implementation payMoneyPeopleMore

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*获取手续费98 */
-(void)appmenunpaychannels
{
    if (_hud==nil) {
        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    }
    /*支付工资*/
    NSDictionary *dataDictionaryChanne = @{ @"paytype" : paytype_check,  };
 
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryChanne apiName:@"ApiPaychannelInfo" apiNameFunc:@"AppmenupaychannelsList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        NSLog(@"请求成功%@",data);
        //通道id的判断是否为易宝
        
        if ([[data valueForKey:@"paychalid"] count]!=0 )
        {
            for (int i=0; i<[[data  valueForKey:@"paychalid"] count]; i++)
            {
                if ([[[data valueForKey:@"paychalname"] objectAtIndex:i] isEqualToString:@"易宝支付"])
                {
                    [yibaoarrid addObject:[data objectAtIndex:i]];
                }
            }
            //paychalid 通道id 获取不到则循环获取
            if ([yibaoarrid valueForKey:@"paychalname"]==0)
            {
                [self appmenunpaychannels];
                return ;
            }else
            {
                /*
                 银联支付流程 分为银联公司等信息 tb_sendcenter 关联,
                 易宝支付通道,
                 记录信用卡信，实现便捷走易宝支付
                 paychalmaxmoney 每次最大支付金额 这是第七次改动了 我擦
                 */
                [_hud hide:YES];
                if ([[[yibaoarrid valueForKey:@"paychalmaxmoney"] objectAtIndex:0]isEqualToString:@""]) {
                    NSLog(@"当前无最大限额");
                }
                /*最大限额*/
                strMax = [[yibaoarrid valueForKey:@"paychalmaxmoney"] objectAtIndex:0];
                /*工资总支付减已支付的差*/
                payIsOkMoney= [NSString stringWithFormat:@"%.2lf",[cellAllMoney doubleValue]- [cellisPayMoney doubleValue]];
                /*
                 是否获得最大支付值 通过135接口获取手续费、刷卡金额及交易金额
                 获取135到之前的刷卡金额的计算最大值
                 剩余支付大于最大支付额度
                 剩余为需要支付减剩下支付的
                */
                cellAllPayMoney = (moneyType = [payIsOkMoney doubleValue]>[strMax doubleValue] ? YES : NO)
                ?[NSString stringWithFormat:@"%.2lf",[strMax doubleValue]/([feeperent doubleValue]/100+1)]
                :[NSString stringWithFormat:@"%.2lf",[cellMoneyNeedPay doubleValue]/([feeperent doubleValue]/100+1)];
            }
        }
        /*获取135的手续费计算接口*/
        [self checkpayfeeurl];
        /*延迟刷不了问题 银联回来的刷新
        if (flagupp==YES) {
             [self pushok];
        }*/
    }];
}

/*135根据业务类型手续费*/
-(void)checkpayfeeurl
{
    //通道id 业务类型 支付金额
    if (_hud==nil) {
        [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    }
    NSDictionary *dataDictionaryChanne = @{ @"paychalid" : [[yibaoarrid valueForKey:@"paychalid"] objectAtIndex:0], @"paytpe" : paytype_check , @"money" : cellAllPayMoney, };
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryChanne apiName:@"ApiPaychannelInfo" apiNameFunc:@"checkPayFee" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary * data, NSError *error) {
        NSLog(@"请求成功 135%@",data);
        if (data[@"message"]==nil) {
            [self checkpayfeeurl];
            return ;
        }else{
            [_hud hide:YES];
            Feepaymoney= data[@"paymoney"];//刷卡金额
            Feepayfee= data[@"payfee"];//手续费
            Feemoney= data[@"money"];//交易金额
            
            /*是否获得最大支付值*/
            if ([payIsOkMoney doubleValue]>[strMax doubleValue]) {
                moneyType= YES;
                /*剩余支付大于最大支付额度*/
                cellAllPayMoney= strMax;
            }else{
                moneyType= NO;
                /*剩余为需要支付减剩下支付的*/
                cellAllPayMoney= Feepaymoney;
            }

            [_Mytable reloadData];
        }
    }];
}
#pragma bankcard
-(void)payMoneyPeopleToBankCard
{
    wagelistidStr= [[_cellArr valueForKey:@"wagelistid"] objectAtIndex:0];

    //刷卡金额  支付金额 支付月份 发卡银行 工资月份id 银行卡号
    NSDictionary *dataDictionaryBankCard = @{ @"wagepaymoney" : cellAllPayMoney, @"wagemoney":cellAllPayMoney, @"wagemonth": _TimerStr, @"fucardbank": @"",  @"wagelistid": wagelistidStr , @"fucardno": _shoucardno };
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryBankCard apiName:@"ApiWageInfo" apiNameFunc:@"paywageRq" rolePath:@"//operation_response/msgbody" type:PublicList completionBlock:^(id data, NSError *error) {
        NSLog(@"请求成功%@",data);
        
        _bkntnoStr= [[data valueForKey:@"bkntno"] objectAtIndex:0];
         [_hud hide:YES];
         [self doStartPay:_bkntnoStr
         sysProvide:nil
         spId:nil
         mode:[NLUtils get_req_bkenv]
         viewController:self
         delegate:self];
    
    }];
}

/*验证码*/
-(void)paypeopleYZM
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];

    NSDictionary *dataDictionaryYZM = @{ @"bkntno" : _bkntnoStr ,@"bkordernumber":bkordernumber, @"verifytoken":verifytoken,@"SMSCode":alertText.text };
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryYZM apiName:@"ApiWageInfo" apiNameFunc:@"ybwagepaySMSverify" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        NSLog(@"请求成功%@",data);
        [_hud hide:YES];
        if (![data[@"message"] isEqualToString:@"success"]) {
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }else{
            
            [self pushok];
        }
    }];
}

/*信用卡*/
-(void)XYKtopayMoneyPeople
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];

     NSString *wagepaymoneyStr = cellAllPayMoney;//刷卡金额
     NSString *wagemonthStr = _TimerStr;//支付月份
     NSString *wagemoneyStr = cellAllPayMoney;//本次工资金额
     NSString *wagelistIDStr = [[_cellArr valueForKey:@"wagelistid"] objectAtIndex:0];//工资月份id
     NSString *paycardidStr = _paycardid;//刷卡器ID
     NSString *bkcardbankStr = bkcardbanknameStr;//银行名
     NSString *bkCardnoStr = bkcardnoCheckStr;//银行卡号
     NSString *bkcardmanStr = bkcardmanCheckStr;//执卡人
     NSString *bkcardexpireMonthStr = bkcardyxmonthStr;//有效月份
     NSString *bkcardmanidcardStr = bkcardidcardStr;//	执卡人身份证
     NSString *bankidStr = bkcardbankidCheckStr;//银行id
     NSString *bkcardexpireYearStr = bkcardyxyearStr;//有效年份
     NSString *bkcardPhoneStr = bkcardphoneStr;//预留手机号码
     NSString *bkcardCVVStr = bkcardcvvStr;// CVV
 
    /*
     易宝或者银联请求交易，有两个金额：
     wagemoney = 本次工资金额
     wagepaymoney  = 本次工资金额+手续费 即为实际支付
     */
    
    NSDictionary *dataDictionaryBnak =
    @{ @"wagepaymoney" : wagepaymoneyStr , @"wagemoney" : wagemoneyStr , @"wagemonth" : wagemonthStr , @"paycardid" : paycardidStr , @"bkcardbank" : bkcardbankStr , @"bkCardno": bkCardnoStr , @"bkcardman" : bkcardmanStr , @"bkcardexpireMonth" : bkcardexpireMonthStr , @"bkcardmanidcard" : bkcardmanidcardStr , @"bankid" : bankidStr , @"bkcardexpireYear" : bkcardexpireYearStr, @"bkcardPhone" : bkcardPhoneStr , @"bkcardcvv" : bkcardCVVStr , @"wagelistid" : wagelistIDStr };
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryBnak apiName:@"ApiWageInfo" apiNameFunc:@"ybwagePayrq" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        NSLog(@"请求成功%@",data);
        [_hud hide:YES];
        if (![data[@"result"] isEqualToString:@"success"])
        {
            [NLUtils showAlertView:@"提示"
                           message:data[@"message"]
                          delegate:self
                               tag:8
                         cancelBtn:@"确定"
                             other:nil];
        }
        else
        {
            _bkntnoStr= data[@"bkntno"];
            verifytoken= data[@"verifytoken"];
            bkordernumber= data[@"bkordernumber"];
            if ([data[@"verifyCode"] intValue]==1)
            {
                if (flagTY) {
                    NSString *message = @"请输入您手机验证码";
                    NSString *cancelName = @"取 消";
                    UIAlertView *alertTextView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelName otherButtonTitles:@"确 定", nil];
                    alertTextView.tag= 88;
                    alertTextView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    alertText = [alertTextView textFieldAtIndex:0];
                    alertText.keyboardType = UIKeyboardTypeNumberPad;
                    alertText.placeholder= @"请输入您的验证码";
                    alertText.delegate = self;
                    //                [alertText resignFirstResponder];
                    [alertTextView show];
                    flagTY = NO;
                }
            }
            else if ([data[@"verifyCode"] intValue]==0)
            {
                /*或者成功显示数据 有另外一个页面*/
                [NLUtils showAlertView:@"提示"
                               message:data[@"message"]
                              delegate:self
                                   tag:8
                             cancelBtn:@"确定"
                                 other:nil];
            }
        }
    }];
}

/*信用卡和储蓄卡发工资的*/
-(void)dfcard
{
    if ([self checkCreditCardMoneyInfoPay])
    {
        /*刷卡判断 后台有数据则选择卡号*/
        if (bkcardcvvStr.length==0) {
            
            /*16位的储蓄卡*/
            if ([bkcardtypeStr isEqualToString:@"bankcard"])
            {
                /*银联*/
                [self payMoneyPeopleToBankCard];
            }
            else
            {
                /*后台判断数据*/
                if (_shoucardno.length==16)
                {
                    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
                    
                    //数据筛选
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bankname == %@", bkcardbanknameStr];
                    
                    //请求参数
                    NSDictionary *dic = @{ @"activemobilesms" : @"0",
                                           @"msgstart" : @"0",
                                           @"msgdisplay" : @"50",
                                           @"querywhere" : @"",
                                           @"banktype" : @"yibao" };
                    
                    //数据请求
                    [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiAppInfo" apiNameFunc:@"readBankList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
                        
                        if (data)
                        {
                            banknames = [data filteredArrayUsingPredicate:predicate];
                            
                            if (banknames.count > 0)
                            {
                                /*弹框*/
                                [self alertNotoBtn];
                            }
                        }
                    }];
                }
                else
                {
                    /*银联*/
                    [self payMoneyPeopleToBankCard];
                }
            }
        }
        else
        {
            /*刷卡后信用卡有数据返回则是否储蓄卡或信用卡*/
            if (_shoucardno.length==16)
            {
                /*易宝信用卡通道 信用卡*/
                flagTY = YES;
                [self XYKtopayMoneyPeople];
                
            }
            else
            {
                /*银联*/
                [self payMoneyPeopleToBankCard];
            }
        }
    }
}

//现在要求是信用卡支付的
-(void)xybtnonpay
{
    if ([self checkCreditCardMoneyInfoPay])
    {
        /*刷卡后返回读取是否有保存默认卡*/
        if (bkcardcvvStr.length==0)
        {
            
            [self showErrorInfo:@"请稍候" status:NLHUDState_None];
            
            //数据筛选 代入信用卡在银联内所属银行id
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bankname == %@", bkcardbanknameStr];
            
            //请求参数
            NSDictionary *dic = @{ @"activemobilesms" : @"0",
                                   @"msgstart" : @"0",
                                   @"msgdisplay" : @"50",
                                   @"querywhere" : @"",
                                   @"banktype" : @"yibao" };
            
            //数据请求
            [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiAppInfo" apiNameFunc:@"readBankList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
                
                if (data)
                {
                    banknames = [data filteredArrayUsingPredicate:predicate];
                    
                    if (banknames.count > 0)
                    {
                        /*直接信用卡*/
                        [self XYdefualtoPay];
                    }
                }
            }];
        }else
        {
            /*易宝信用卡通道直接支付通道 信用卡*/
            flagTY = YES;
            [self XYKtopayMoneyPeople];
        }
    }
}

/*发放填写验证码*/
- (IBAction)OnbtnClick:(id)sender
{
    /*只能支付信用卡的*/
//    [self xybtnonpay];
    /*储蓄和信用卡的*/
//    [self dfcard];
    
    /*银联 text*/
     NSDictionary *dataDictionaryBankCard = @{ @"wagepaymoney" : cellAllPayMoney, @"wagemoney":cellAllPayMoney, @"wagemonth": _TimerStr, @"fucardbank": @"",  @"wagelistid": @"1" , @"fucardno": @"1234567890123" };
     
     [LoadDataWithASI loadDataWithMsgbody:dataDictionaryBankCard apiName:@"ApiWageInfo" apiNameFunc:@"paywageRq" rolePath:@"//operation_response/msgbody" type:PublicList completionBlock:^(id data, NSError *error) {
        NSLog(@"请求成功%@",data);
        
        _bkntnoStr= [[data valueForKey:@"bkntno"] objectAtIndex:0];
        [_hud hide:YES];
        [self doStartPay:_bkntnoStr
              sysProvide:nil
                    spId:nil
                    mode:[NLUtils get_req_bkenv]
          viewController:self
                delegate:self];
        
    }];

}

-(void)alertNotoBtn
{
    [NLUtils showAlertView:@"温馨提示"
                   message:@"您当前使用的卡号为信用卡，是否选择信用卡支付通道？"
                  delegate:self
                       tag:33
                 cancelBtn:@"信用卡支付"
                     other:@"借记卡支付",nil];
}

-(void)planeDic
{
    /*实际支付 支付金额 年月 卡号 月份id 卡号*/
    dataDictionary =
    @{@"wagepaymoney" : cellAllPayMoney, @"wagemoney": cellAllPayMoney, @"wagemonth": _TimerStr,  @"fucardbank": @"",  @"wagelistid": [[_cellArr valueForKey:@"wagelistid"] objectAtIndex:0] , @"fucardno": _shoucardno };

}

/*信用卡没保存填写的页面跳转*/
-(void)XYdefualtoPay
{
    [self planeDic];
    planePay *pla= [[planePay alloc]initWithNibName:@"planePay" bundle:nil];
    pla.paymoneyStr= Feepaymoney;
    pla.myViewYiBaoType= YiBaoPayType_payMonyPeople;
    pla.payCard= _shoucardno;
    pla.cardReaderId= _paycardid;
    pla.myDictionary= dataDictionary;
    pla.bankNameArr= banknames;
    pla.bankname= [[banknames valueForKey:@"bankname"] objectAtIndex:0];
    [self.navigationController pushViewController:pla animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==33) {
        if (0 == buttonIndex)
        {
            /*信用卡*/
            [self XYdefualtoPay];
            
        }else
        {
            /*储蓄卡*/
            [self payMoneyPeopleToBankCard];
        }
    }else if ( alertView.tag == 22) {
        
        if (0 == buttonIndex)
        {
            /*信用卡*/
            [self XYdefualtoPay];
            
        }else
        {
            /*储蓄卡*/
            [self payMoneyPeopleToBankCard];
        }
    }else if ( alertView.tag == 88)
    {
        [self paypeopleYZM];
    }
}

-(void)pushok
{
    [_hud hide:YES];
    payMoneyToPay *pay= [[payMoneyToPay alloc]init];
    pay.timerStr= _TimerStr;
    pay.wagepaymoneyStr= cellisPayMoney;
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"] )
    {
        flagupp= YES;
        /*支付工资*/
//        [self viewDataOnclick];
        [self pushok];
    }
}

- (BOOL)doStartPay:(NSString *)payData sysProvide:(NSString*)sysProvide spId:(NSString*)spId mode:(NSString*)mode viewController:(UIViewController *)viewController delegate:(id<UPPayPluginDelegate>)delegate;
{
    return [UPPayPlugin startPay:payData mode:mode viewController:viewController delegate:delegate];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

/*支付工资读取120*/
-(void)viewDataOnclick
{
    /*支付工资*/
    NSDictionary *dataDictionaryClick = @{ @"querytype" : @"month", @"querywhere" : _TimerStr ,  @"bossauthorid" : [NLUtils getbossauthorid] , @"wagelistid" : [NLUtils getgWagelistid] };
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"paymonthwage" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        if ([TFData getTempData][ADD_SKQ_ADDRESS_FLAG])
        {
            // 刷钱前移除所有数据
            [_cellArr removeAllObjects];
            
            [[TFData getTempData]removeObjectForKey:ADD_SKQ_ADDRESS_FLAG];
        }
        [_cellArr setArray:data];
        if (_cellArr.count!=0)
        {
            /*
             1.支付显示界面接口： ApiWageInfo::paymonthwage
             字段： 
             needpaymoney  = 总工资（未含）-已支付工资（未手含续费）
             
             2. 前端确定好支付通道后，用这个needpaymoney金额去获取即时手续费。。
             
             3.易宝或者银联请求交易，有两个金额： 
             wagemoney = 本次工资金额
             wagepaymoney  = 本次工资金额+手续费

             */
            NSLog(@"120 msgchild 请求成功%@",_cellArr);
            /*支付总金额*/
            cellAllMoney= [NSString stringWithFormat:@"%@",[[_cellArr valueForKey:@"wageallmoney"]objectAtIndex:0]];
            /*已支付*/
            cellisPayMoney=  [NSString stringWithFormat:@"%@",[[_cellArr valueForKey:@"wagepaymoney"]objectAtIndex:0]];
            cellPeople = [NSString stringWithFormat:@"%@人",[[_cellArr valueForKey:@"wagestanum"]objectAtIndex:0]];
            /*还需支付*/
            cellMoneyNeedPay = [NSString stringWithFormat:@"%.2lf",[[[data valueForKey:@"needpaymoney"]objectAtIndex:0] doubleValue]];
            /*本次需支付手续费*/
            payfee = [NSString stringWithFormat:@"%.2lf",[[[data valueForKey:@"payfee"]objectAtIndex:0] doubleValue]];
        }
    }];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryClick apiName:@"ApiWageInfo" apiNameFunc:@"paymonthwage" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error) {
         NSLog(@"120 msgbody 请求成功%@",_cellArr);
       [_hud hide:YES];
        if (![data[@"result"] isEqualToString:@"success"])
        {
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }
        else
        {
            /*手续费最低额*/
            minfee = [data valueForKey:@"minfee"];
            /*手续费最高额*/
            maxfee = [data valueForKey:@"maxfee"];
            /*手续费%*/
            feeperent =[data valueForKey:@"feeperent"];
        }
        /*手续费计算*/
        [self appmenunpaychannels];
    }];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLUserInforSettingsCell *cell =nil;
    static NSString *kCellID = @"NLUsersInforSettingsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
    {
        NSArray* temp = [[NSBundle mainBundle] loadNibNamed:kCellID owner:self options:nil];
        cell=[temp objectAtIndex:0];
    }
    cell.myHeaderLabel.hidden = NO;
    cell.myContentLabel.hidden = NO;
    cell.myContentLabel.textAlignment = NSTextAlignmentLeft;
    cell.myDownrightBtn.hidden = YES;
    cell.myUprightBtn.hidden = YES;
    cell.mySelectedBtn.hidden = YES;
    cell.myTextField.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell.myHeaderLabel setFrame:CGRectMake(cell.myHeaderLabel.frame.origin.x+5, cell.myHeaderLabel.frame.origin.y, cell.myHeaderLabel.frame.size.width+30, cell.myHeaderLabel.frame.size.height)];
    cell.myTextField.userInteractionEnabled= NO;
    [cell.myTextField setFrame:CGRectMake(140, cell.myTextField.frame.origin.y, 140, cell.myTextField.frame.size.height)];
    cell.myTextField.textAlignment = NSTextAlignmentCenter;
    cell.myHeaderLabel.textColor= SACOLOR(159, 1);
    cell.myTextField.textColor= SACOLOR(159, 1);
 
    switch (indexPath.row)
    {
        case 0:
        {
            cell.myHeaderLabel.text = @"发送人员:";
            cell.myContainer = self;
            cell.myContentLabel.hidden = YES;
            cell.myTextField.text = cellPeople;
        }
            break;
        case 1:
        {
            cell.myHeaderLabel.text = @"工资总额:";
            cell.myContainer = self;
            cell.myContentLabel.hidden = YES;
            if (cellAllMoney==nil) {
                cell.myTextField.text = @"";
            }else{
                cell.myTextField.text = [NSString stringWithFormat:@"%@元",cellAllMoney];
            }
        }
            break;
        case 2:
        {
            cell.myContainer = self;
            cell.myHeaderLabel.text = @"本次支付:";
            cell.myContentLabel.hidden = YES;
            if (Feemoney==nil) {
                cell.myTextField.text = @"";
            }else{
                cell.myTextField.text= [NSString stringWithFormat:@"%@元",Feemoney];
            }
        }
            break;
        case 3:
        {
            cell.myContainer = self;
            cell.myHeaderLabel.text = @"手续费率:";
            cell.myContentLabel.hidden = YES;
            if (feeperent==nil) {
                cell.myTextField.text = @"";
            }else{
            cell.myTextField.text = feeperent;
            }
        }
            break;
        case 4:
        {
            cell.myContainer = self;
            cell.myHeaderLabel.text = @"手续费:";
            cell.myContentLabel.hidden = YES;
            if (Feepayfee==nil) {
                cell.myTextField.text = @"";
            }else{
            cell.myTextField.text= [NSString stringWithFormat:@"%@元",Feepayfee];
            }
        }
            break;
        case 5:
        {
            cell.myContainer = self;
            cell.myHeaderLabel.text = @"实际支付:";
            cell.myContentLabel.hidden = YES;
            //cellAllPayMoney
            if (Feepaymoney==nil) {
                cell.myTextField.text = @"";
            }else{
                cell.myTextField.text = [NSString stringWithFormat:@"%@元",Feepaymoney];
            }
        }
            break;
            default:
            break;
    }
    return cell;
}

-(void)viewDidAppear:(BOOL)animated
{
    [NLUtils enableSliderViewController:NO];
    
    [self startVisaReader];
    
    [super viewDidAppear:animated];
    
    if ([TFData getTempData][ADD_SKQ_ADDRESS_FLAG]) {
        
        //手动增加过地址就需要刷新
        [self performSelector:@selector(viewDataOnclick) withObject:nil afterDelay:0.1];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [NLUtils enableSliderViewController:YES];
    
    [self stopVisaReader];
    
    [super viewWillDisappear:animated];
   
}

-(void)startVisaReader
{
    if (_visaReader)
    {
        [_visaReader resetVisaReader:YES];
    }
}

-(void)stopVisaReader
{
    if (_visaReader)
    {
        [_visaReader resetVisaReader:NO];
    }
}

-(void)initVisaReader
{
    _visaReader = [VisaReader initWithDelegate:self];
    [_visaReader createVisaReader];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initVisaReader];
    
    [self mainView];
//    paytype_check = [[[NSUserDefaults standardUserDefaults]objectForKey:BANK_PAYTYPE_CHECK] objectAtIndex:0];
    paytype_check= @"salarypay";
    _cellArr= [NSMutableArray array];
    yibaoarrid= [NSMutableArray array];
    [self viewDataOnclick];
}
 
-(void)mainView
{
    self.title= @"付款";
    _Mytable.separatorStyle= UITableViewCellSeparatorStyleSingleLineEtched;
    _Mytable.userInteractionEnabled= NO;
    UIView *rightCared = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    imageCard= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageCard.image=  [UIImage imageNamed:@"swipingCard.png"];
    [rightCared addSubview:imageCard];
    self.TextFiledCared.userInteractionEnabled= NO;
    self.TextFiledCared.rightView = rightCared;
    self.TextFiledCared.rightViewMode = UITextFieldViewModeAlways;
    
    if (_enableCardImage)//判断bool状态
    {
        imageCard.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        imageCard.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

#pragma mark - VisaReaderDelegate
-(void)doVisaReaderEvent:(SwiperReaderStatus)event object:(NSString*)object
{
    //NSLog(@"event = %d,object = %@",event,object);
    
    if (SRS_DeviceAvailable == event && [object isEqualToString:@"0"])
    {
        [self resetCardImage:YES];
    }
    else if (SRS_DeviceUnavailable == event)
    {
        [self resetCardImage:NO];
    }
    else if (SRS_OK == event)
    {
        [self doSRS_OK:object];
    }
}

-(void)resetCardImage:(BOOL)enable
{
    if (enable == YES)
    {
        _enableCardImage = YES;
        
        /*刷卡器重写*/
        imageCard.image = [UIImage imageNamed:@"swipingCard2.png"];
        
        NLUserInforSettingsCell *cell = (NLUserInforSettingsCell *)[self.Mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard2.png"];
    }
    else
    {
        _enableCardImage = NO;
        
        imageCard.image = [UIImage imageNamed:@"swipingCard.png"];
        
        NLUserInforSettingsCell *cell = (NLUserInforSettingsCell *)[self.Mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        
        cell.myUprightImage.image = [UIImage imageNamed:@"swipingCard.png"];
    }
}

-(void)resetCardNumber:(NSString *)str
{
    if (str.length > 0)
    {
        /*刷卡器重写*/
        _TextFiledCared.text= str;
        
        NLUserInforSettingsCell* cell = (NLUserInforSettingsCell*)[self.Mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        cell.myTextField.text = str;
    }
}

#pragma mark - oPayCardCheck
//验证刷卡器卡号的长度
-(BOOL)checkTransferInfo
{
    if (_supshoucardno.length<=0)
    {
        [self showErrorInfo:@"请刷卡或手动输入卡号" status:NLHUDState_Error];
        return NO;
    }
    
    NSString* mach = @"^[0-9]{14,20}$";
    
    if (![NLUtils matchRegularExpressionPsy:_supshoucardno match:mach]) {
        [self showErrorInfo:@"请确定您输入的银行卡是正确的" status:NLHUDState_Error];
        return NO;
    }
    
    return YES;
}

-(void)doSRS_OK:(NSString *)str
{
    _visaReaderArray = [str componentsSeparatedByString:@"***@@@$$$"];
    
    if (_visaReaderArray.count >= 3)
    {
        NSString *str = [_visaReaderArray objectAtIndex:0];
        
        if ([str isEqualToString:@""])
        {
            return;
        }
        
        if ([[str substringToIndex:2] intValue] >0)
        {
            _shoucardno = [_visaReaderArray objectAtIndex:0];
            _reshoucardno= [_visaReaderArray objectAtIndex:0];
            _supshoucardno= [_visaReaderArray objectAtIndex:0];
            _paycardid = [_visaReaderArray objectAtIndex:1];
            
            if (_paycardid.length >= 14)
            {
                _paycardid = [_paycardid substringToIndex:14];
                _paycardid = [_paycardid lowercaseString];
            }
            
            _payCardCheck = _paycardid;
            
            [self resetCardNumber:_shoucardno];
            [self resetCardNumber:_reshoucardno];
            [self resetCardNumber:_supshoucardno];
            
            [self ApipayCardCheck];
        }
    }
}

/*刷卡验证*/
-(void)ApipayCardCheck
{
    /*刷卡器唯一码*/
    NSString *paycardkey_check= _payCardCheck;
    /*银行卡号*/
    NSString *bkcardno_check= _shoucardno;
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApipayCardCheck];
    REGISTER_NOTIFY_OBSERVER(self, ApipayCardCheckNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES]getApipayCardCheck:paycardkey_check bkcardno:bkcardno_check paytype:paytype_check readmode:@""];
}

/*信用卡刷卡信息对比*/
-(void)ApipayCardCheckNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self doApiPayCardCheckNotify:response];
    }
    else
    {
        NSString *detailA = response.detail;
        if (!detailA || detailA.length <= 0)
        {
            detailA = @"服务器繁忙，请稍候再试";
        }
        [self showErrorInfo:detailA status:NLHUDState_Error];
    }
}

/*信用卡信息对比*/
-(void)doApiPayCardCheckNotify:(NLProtocolResponse*)response
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
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* result = data.value;
        [self showErrorInfo:result status:NLHUDState_NoError];
        
        skqhaveYes= @"cardtype";
        
        //银行卡号
        NLProtocolData* bkcardnoCheck = [response.data find:@"msgbody/bkcardno" index:0];
        bkcardnoCheckStr = bkcardnoCheck.value;
        //执卡人
        NLProtocolData* bkcardmanCheck = [response.data find:@"msgbody/bkcardman" index:0];
        bkcardmanCheckStr = bkcardmanCheck.value;
        //预留手机号码
        NLProtocolData* bkcardphoneCheck = [response.data find:@"msgbody/bkcardphone" index:0];
        bkcardphoneStr= bkcardphoneCheck.value;
        //银行id
        NLProtocolData* bkcardbankidCheck = [response.data find:@"msgbody/bkcardbankid" index:0];
        bkcardbankidCheckStr= bkcardbankidCheck.value;
        //银行名
        NLProtocolData* bkcardbanknameCheck = [response.data find:@"msgbody/bkcardbankname" index:0];
        bkcardbanknameStr= bkcardbanknameCheck.value;
        //有效月
        NLProtocolData* bkcardyxmonthCheck = [response.data find:@"msgbody/bkcardyxmonth" index:0];
        bkcardyxmonthStr= bkcardyxmonthCheck.value;
        //有效年
        NLProtocolData* bkcardyxyearCheck = [response.data find:@"msgbody/bkcardyxyear" index:0];
        bkcardyxyearStr= bkcardyxyearCheck.value;
        //CVV校验
        NLProtocolData* bkcardcvvCheck = [response.data find:@"msgbody/bkcardcvv" index:0];
        bkcardcvvStr= bkcardcvvCheck.value;
        //身份证
        NLProtocolData* bkcardidcardCheck = [response.data find:@"msgbody/bkcardidcard" index:0];
        bkcardidcardStr= bkcardidcardCheck.value;
        //银行卡类型
        NLProtocolData* bkcardtypeCheck = [response.data find:@"msgbody/bkcardtype" index:0];
        bkcardtypeStr= bkcardtypeCheck.value;
        
        /*填充信息 传到易宝*/
    }
}

-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [self oneFingerTwoTaps];
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
            break;
    }
    return;
}

- (void)textFieldWithText:(UITextField *)textField
{
    /*对应执照图片*/
}

-(BOOL)checkCreditCardMoneyInfoPay
{
    if ([payIsOkMoney doubleValue] == 0)
    {
        [self showErrorInfo:@"当前支付金额为 0" status:NLHUDState_Error];
        return NO;
    }
    if (_supshoucardno==nil)
    {
        [self showErrorInfo:@"请刷卡获取卡号" status:NLHUDState_Error];
        return NO;
    }
    return YES;

}

-(void)oneFingerTwoTaps
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    [firstResponder resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*银联交易流水号upp*/
-(void)upppayTook
{
    /*交易流水号*/
    NSDictionary *dataDictionaryUpp = @{ @"SMSCode" : _bkntnoStr ,@"bkordernumber" : _bkntnoStr , @"bkntno" : _bkntnoStr ,@"verifytoken" : _bkntnoStr  };
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionaryUpp apiName:@"ApiWageInfo" apiNameFunc:@"wagePayrqStatus" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        NSLog(@"请求成功%@",data);
        if (![data[@"message"] isEqualToString:@"success"]) {
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
            [_hud hide:YES afterDelay:1.5];
        }else{
            
            
        }
    }];
}


@end
