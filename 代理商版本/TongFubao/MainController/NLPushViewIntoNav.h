//
//  NLPushViewIntoNav.h
//  TongFubao
//
//  Created by MD313 on 13-8-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NLPushViewType_None = 0,
    NLPushViewType_Feed,
    NLPushViewType_Left,
    NLPushViewType_CreditCardPayments ,
    NLPushViewType_PassWordManager,
    NLPushViewType_UsersInfoSettings,
    NLPushViewType_MyBankCard,
    NLPushViewType_TransferRemittance,
    NLPushViewType_BalanceQuery,
    NLPushViewType_MyWallet,
    NLPushViewType_ReturnLoan,
    NLPushViewType_MyCoupons,
    NLPushViewType_HelpCenter,
    NLPushViewType_Logon,
    NLPushViewType_CashArriveMain,
    NLPushViewType_OpenSwipCard,
    NLPushViewType_OrderQuery,
    NLPushViewType_FormQuery,
    NLPushViewType_FormPay,
    NLPushViewType_AboutUs,
    NLPushViewType_Feedback,
    NLPushViewType_PhoneMoney,
    NLPushViewType_QCoinCharge,
    NLPushViewType_WallerView,
    NLPushViewType_PaySKQtoPeople,
    NLPushViewType_Agent,
    NLPushViewType_WaterElec,
    NLPushViewType_SavingsCard,
    NLPushViewType_GameCharge,
    NLPushViewType_AgentSearchCtr,
    NLPushViewType_AgentAddgoodsCtr,
    NLPushViewType_plane
} NLPushViewType;

@interface NLPushViewIntoNav : NSObject

@property(nonatomic,assign) NLPushViewType myNextType;

+(id)sharePushViewIntoNav;
-(UIViewController*)getPushViewIntoNavByType:(NLPushViewType)type;

@end
