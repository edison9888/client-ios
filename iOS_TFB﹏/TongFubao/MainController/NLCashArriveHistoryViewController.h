//
//  NLCashArriveHistoryViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NLHistoryRecordType_CashArrive = 0,
    NLHistoryRecordType_TransferMoney,
    NLHistoryRecordType_CreditCardPayments,
    NLHistoryRecordType_ReturnLoan,
    NLHistoryRecordType_SupTransferMoney
} NLHistoryRecordType;

@interface NLCashArriveHistoryViewController : UIViewController

@property(nonatomic,assign) NLHistoryRecordType myHistoryRecordType;

@end
