//
//  SMSTradingNoticeViewController.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-6.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  交易通知

#import <UIKit/UIKit.h>

@interface SMSTradingNoticeViewController : UIViewController

@property(strong,nonatomic)NSString *telephone;//手机号码
@property(strong,nonatomic)NSString *amountOfMoney;//金额
@property(strong,nonatomic)NSString *theOpeningBank;//开户行
@property(strong,nonatomic)NSString *bankAccount;//银行卡号

//再来一次
- (IBAction)onceAgain:(UIButton *)sender;
//确认
- (IBAction)confirmation:(UIButton *)sender;


@end
