//
//  NLPushViewIntoNav.m
//  TongFubao
//
//  Created by MD313 on 13-8-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLPushViewIntoNav.h"
#import "NLCreditCardPaymentsViewController.h"
#import "NLPassWordManagerViewController.h"
#import "NLUsersInfoSettingsViewController.h"
#import "NLMyBankCardViewController.h"
#import "NLMyCouponsMainViewController.h"
#import "NLTransferRemittanceViewController.h"
#import "NLBalanceQueryViewController.h"
#import "NLReturnLoanViewController.h"
#import "NLHelpCenterViewController.h"
#import "NLLogOnViewController.h"
#import "NLCashArriveMainViewController.h"
#import "NLOpenSwipCardViewController.h"
#import "NLOrderQueryViewController.h"
#import "NLFormQueryViewController.h"
#import "NLAboutUsViewController.h"
#import "NLFeedbackViewController.h"
#import "PhoneMoneyView.h"
#import "QCoinView.h"
#import "NLMyWalletViewController.h"
#import "WalletMainView.h"
#import "PaySKQ.h"
#import "TFAgentMainCtr.h"
#import "WaterElec.h"
#import "GameCharge.h"
#import "TFAgentSearchCtr.h"
#import "TFAgentAddgoodsCtr.h"
#import "planeView.h"

static NLPushViewIntoNav* gPushViewIntoNav = nil;

@implementation NLPushViewIntoNav

+(id)sharePushViewIntoNav
{
    if (gPushViewIntoNav == nil)
    {
        gPushViewIntoNav=[[NLPushViewIntoNav alloc] init];
    }
    return gPushViewIntoNav;
}

-(UIViewController*)getPushViewIntoNavByType:(NLPushViewType)type
{
    UIViewController* vc = nil;
    switch (type)
    {
        case NLPushViewType_None:
        {
            
        }
            break;
            
        case NLPushViewType_UsersInfoSettings:
        {
           vc = (UIViewController*)[[NLUsersInfoSettingsViewController alloc] initWithNibName:@"NLUsersInfoSettingsViewController" bundle:nil];
            
        }
            break;
            
        case NLPushViewType_MyBankCard:
        {
            vc = (UIViewController*)[[NLMyBankCardViewController alloc] initWithNibName:@"NLMyBankCardViewController" bundle:nil];
            
        }
            break;
            
        case NLPushViewType_CreditCardPayments:
        {
             vc = (UIViewController*)[[NLCreditCardPaymentsViewController alloc] initWithNibName:@"NLCreditCardPaymentsViewController" bundle:nil];
        }
            break;
            
        case NLPushViewType_PassWordManager:
        {
             vc = (UIViewController*)[[NLPassWordManagerViewController alloc] initWithNibName:@"NLPassWordManagerViewController" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_TransferRemittance:
        {
            //转账 超级和普通
            vc = (UIViewController*)[[NLTransferRemittanceViewController alloc] initWithNibName:@"NLTransferRemittanceViewController" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_BalanceQuery:
        {
            //查询短信
            vc = (UIViewController*)[[NLBalanceQueryViewController alloc] initWithNibName:@"NLBalanceQueryViewController" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_MyWallet:
        {
            //我的钱包
          
            vc = (UIViewController*)[[NLMyWalletViewController alloc] initWithNibName:@"NLMyWalletViewController" bundle:nil] ;
        
           
        }
            break;
            
        case NLPushViewType_WallerView:
        {
             //新界面我的钱包
             vc= [[WalletMainView alloc]initWithNibName:@"WalletMainView" bundle:nil];
        }
            break;
    
        case NLPushViewType_PaySKQtoPeople:{
            //购买刷卡器
             vc = (UIViewController*)[[PaySKQ alloc] initWithNibName:@"PaySKQ" bundle:nil] ;
        }
             break;
        case NLPushViewType_ReturnLoan:
        {
            vc = (UIViewController*)[[NLReturnLoanViewController alloc] initWithNibName:@"NLReturnLoanViewController" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_MyCoupons:
        { //优惠劵
            vc = (UIViewController*)[[NLMyCouponsMainViewController alloc] initWithNibName:@"NLMyCouponsMainViewController" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_HelpCenter:
        {
            vc = (UIViewController*)[[NLHelpCenterViewController alloc] initWithNibName:@"NLHelpCenterViewController" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_Logon:
        {
            //登陆 注册
            vc = (UIViewController*)[[NLLogOnViewController alloc] initWithNibName:@"NLLogOnViewController" bundle:nil] ;
        }
            break;
         
        case NLPushViewType_CashArriveMain:
        {
            vc = (UIViewController*)[[NLCashArriveMainViewController alloc] initWithNibName:@"NLCashArriveMainViewController" bundle:nil] ;
        }
            break;
         
        case NLPushViewType_OpenSwipCard:
        {
            vc = (UIViewController*)[[NLOpenSwipCardViewController alloc] initWithNibName:@"NLOpenSwipCardViewController" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_OrderQuery:
        {
            vc = (UIViewController*)[[NLOrderQueryViewController alloc] initWithNibName:@"NLOrderQueryViewController" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_FormQuery:
        {  //订单
            NLFormQueryViewController* v = [[NLFormQueryViewController alloc] initWithNibName:@"NLFormQueryViewController" bundle:nil] ;
            v.myFormQueryType = FormQuery_FormQuery;
            vc = (UIViewController*)v;
        }
            break;
            
        case NLPushViewType_FormPay:
        {
            //刷卡器
            vc = (UIViewController*)[[PaySKQ alloc] initWithNibName:@"PaySKQ" bundle:nil] ;
        }
            break;
            
        case NLPushViewType_AboutUs:
        {
            //版本
            NLAboutUsViewController* v = [[NLAboutUsViewController alloc] initWithNibName:@"NLAboutUsViewController" bundle:nil];
            vc = (UIViewController*)v;
        }
            break;
            
        case NLPushViewType_Feedback:
        {
            NLFeedbackViewController* v = [[NLFeedbackViewController alloc] initWithNibName:@"NLFeedbackViewController" bundle:nil];
            vc = (UIViewController*)v;
        }
            break;
        case NLPushViewType_PhoneMoney:{
            vc= (UIViewController*)[[PhoneMoneyView alloc]initWithNibName:@"PhoneMoneyView" bundle:nil];
        }
           break;
        case NLPushViewType_QCoinCharge:{
            vc= (UIViewController*)[[QCoinView alloc]initWithNibName:@"QCoinView" bundle:nil];
        }
            break;
        case NLPushViewType_Agent:{
           
            //代理商登录 TFAgentMainCtr TFNewVersionAgentMainCtr
                 vc = (UIViewController*)[[TFAgentMainCtr alloc]init];
        }
            break;
        case NLPushViewType_AgentAddgoodsCtr:{
            
            //代理商补货
            vc = (UIViewController*)[[TFAgentAddgoodsCtr alloc]init];
        }
            break;
        case NLPushViewType_AgentSearchCtr: {
            
            //代理商客户列表
            vc = (UIViewController*)[[TFAgentSearchCtr alloc]init];
        }
            break;
        case NLPushViewType_WaterElec:{
            vc= (UIViewController*)[[WaterElec alloc]init];
        }
            break;
        case NLPushViewType_GameCharge:{
            vc= (UIViewController*)[[GameCharge alloc]init];
        }
            break;
        case NLPushViewType_plane:{
            vc= (UIViewController*)[[planeView alloc]init];
        }
            break;
            
        default:
            break;
    }
    
    return vc;
}

@end
