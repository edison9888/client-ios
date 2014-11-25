//
//  NLContants.h
//  TongFubao
//
//  Created by MD313 on 13-8-1.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#ifndef TongFubao_NLContants_h
#define TongFubao_NLContants_h

typedef enum
{
    NLHUDState_None = 0,
    NLHUDState_Error,
    NLHUDState_NoError
} NLHUDState;

typedef enum
{
    TFBRegisterVCLogon = 1,
    TFBRegisterVCPayment
} TFBPasswordType;

typedef enum
{
    NLRechargeFirstCreditCard = 0,
    NLRechargeFirstDepositCard
} NLRechargeFirstType;

#define TFBVersion @"2.1.0"//版本号

//#define NAV_COLOR [UIColor colorWithRed:5.0/255.0 green:168.0/255.0 blue:228.0/255.0 alpha:1.0]

//#define NAV_COLOR [UIColor colorWithRed:18.0/255.0 green:142.0/255.0 blue:227.0/255.0 alpha:1.0]

#define NAV_COLOR [UIColor colorWithRed:13.0/255.0 green:122.0/255.0 blue:185.0/255.0 alpha:1.0]

#define TFBConfigurator @"TFBConfigurator.plist"//程序配制文件
/***
 以下是程序配制文件各个项的关键字(不可重复)
 */
#define TFBC_MainAdImageCount                                     @"TFBC_MainAdImageCount"
#define TFBC_MainAdImageURL                                       @"TFBC_MainAdImageURL"
#define TFBC_MainAdImageTitle                                     @"TFBC_MainAdImageTitle"
#define TFBC_BankListReady                                        @"TFBC_BankListReady"
#define TFBC_TransferRemittanceBank                               @"TFBC_TransferRemittanceBank"
#define TFBC_TransferRemittanceBankID                             @"TFBC_TransferRemittanceBankID"
#define TFBC_CreditCardPaymentsBank                               @"TFBC_CreditCardPaymentsBank"
#define TFBC_CreditCardPaymentsBankID                             @"TFBC_CreditCardPaymentsBankID"
#define TFBC_ReturnLoanBank                                       @"TFBC_ReturnLoanBank"
#define TFBC_ReturnLoanBankID                                     @"TFBC_ReturnLoanBankID"
#define TFBC_getSmsCode_smscode                                   @"TFBC_getSmsCode_smscode"
#define TFBC_checkAuthorLogin_authorid                            @"TFBC_checkAuthorLogin_authorid"
#define TFBC_MobileForRegister                                    @"TFBC_MobileForRegister"
#define TFBC_RememberAccount                                      @"TFBC_RememberAccount"
#define TFBC_readAppruleList_path                                 @"TFBC_readAppruleList_path"
#define TFBC_readHelpList_count                                   @"TFBC_readHelpList_count"
#define TFBC_readHelpList_content                                 @"TFBC_readHelpList_content"
#define TFBC_readHelpList_date                                    @"TFBC_readHelpList_date"
#define TFBC_readHelpList_title                                   @"TFBC_readHelpList_title"
#define TFBC_readHelpList_forceUpdate                             @"TFBC_readHelpList_forceUpdate"
/***
 以上是程序配制文件各个项的关键字(不可重复)
 */

#define TFBUsersInfoUpImage @"usersUpImage.jpg" //本地的用户正面照片
#define TFBUsersInfoDownImage @"usersDownImage.jpg" //本地的用户背面照片
#define TFBAuthUsersInfoUpImage @"authUsersUpImage.jpg" //上传的用户正面照片
#define TFBAuthUsersInfoDownImage @"authUsersDownImage.jpg" //上传的用户背面照片

#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

#define IOS6_7_DELTA(V,X,Y,W,H) if (IOS_7) {CGRect f = V.frame;f.origin.x += X;f.origin.y += Y;f.size.width += W;f.size.height += H;V.frame=f;}

//IOS6_7_DELTA(view, 0, 20, 0, 0);


//根据相对文件名,生成绝对路径
#define FETCH_ABS_FILE_NAME(fileName)  [(NSString*)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:(fileName)]

//发送一个通知
#define POST_NOTIFY(notify)  [[NSNotificationCenter defaultCenter] postNotification:(notify)]

#define POST_NOTIFY_FOR_NAME(name,obj)  [[NSNotificationCenter defaultCenter] postNotificationName:(name) object:(obj)]

//注册通知监听
#define REGISTER_NOTIFY_OBSERVER(obs, method, notify)  [[NSNotificationCenter defaultCenter] removeObserver:obs name:notify object:nil]; [[NSNotificationCenter defaultCenter] addObserver:(obs) selector:@selector(method:) name:(notify) object:nil]

//移除某个监听者针对某个通知的监听
#define REMOVE_NOTIFY_OBSERVER_FOR_NAME(obs,notify)  [[NSNotificationCenter defaultCenter] removeObserver:(obs) name:(notify) object:nil]

//移除某个监听者所有通知的监听
#define REMOVE_NOTIFY_OBSERVER(obs)  [[NSNotificationCenter defaultCenter] removeObserver:(obs)]

//日志记录,在Release版本中,不记录日志
#ifdef DEBUG
   #define NLLog NSLog(@"File:%s, Line:%d",strrchr(__FILE__,'/'),__LINE__);NSLog
   #define NLLogNoLocation(format, ...) NSLog(@"{%s:%d}:: %@", __PRETTY_FUNCTION__,__LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__])
   #define MARKNoLocation	NLLogNoLocation(@"%s", __PRETTY_FUNCTION__);
   #define NLLogWithLocation(format, ...) NSLog(@"{%s} in {%s:%d} :: %@", __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__])
   #define MARKWithLocation	NLLogWithLocation(@"%s", __PRETTY_FUNCTION__);
#else
   #define NLLog 
   #define NLLogNoLocation(format, ...) 
   #define MARKNoLocation	
   #define NLLogWithLocation(format, ...) 
   #define MARKWithLocation	
#endif

#endif
