//
//  SMSBankCardViewController.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  设置默认收款账户

#import <UIKit/UIKit.h>

@class SMSBankCardViewController;
@protocol BankCardDelegate
-(void)agent:(SMSBankCardViewController *)vc BankName:(NSString *)bankName AccountName:(NSString *)accountName TailNumber:(NSString *)tailNumber Category:(NSString *)category BankLogo:(UIImage *)bankLogo Bankphone:(NSString *)bankphone;

@end

@interface SMSBankCardViewController : UIViewController

@property(weak,nonatomic)id<BankCardDelegate>delegate;


@end
