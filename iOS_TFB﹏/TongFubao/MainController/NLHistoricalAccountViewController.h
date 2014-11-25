//
//  NLHistoricalAccountViewController.h
//  TongFubao
//
//  Created by jiajie on 13-12-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLCreditCardPaymentsViewController.h"
#import "NLTransferRemittanceViewController.h"
#import "NLReturnLoanViewController.h"

typedef enum
{
    NLHistoryPayType_Creditcard = 0, //信用卡还款
    NLHistoryPayType_Repay,          //还贷款
    NLHistoryPayType_Order,          //订单付款
    NLHistoryPayType_Tfmg,           //转账汇款
    NLHistoryPayType_Suptfmg         //超级转账
} NLHistoryPayType;

@interface NLHistoricalAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NLHistoryPayType myHistoryPayType;
@property (nonatomic, assign) NLCreditCardPaymentsViewController *creditcardDelegate;
@property (nonatomic, assign) NLTransferRemittanceViewController *tfmgDelegate;
@property (nonatomic, assign) NLReturnLoanViewController *repayDelegate;

@end
