//
//  SMSNewBankCardViewController.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  新增银行卡 主控制类 (废弃类、暂时不用)

#import <UIKit/UIKit.h>

#import "SUNSlideSwitchView.h"
#import "SMSCreditCardViewController.h"
#import "SMSTheSavingsCardViewController.h"
#import "SMSChooseABankTableViewController.h"
#import "XIAOYU_TheControlPackage.h"

@interface SMSNewBankCardViewController : UIViewController<SUNSlideSwitchViewDelegate,ChooseABankDelegate>

@property (nonatomic, strong)  SUNSlideSwitchView *slideSwitchView;
@property (nonatomic, strong)  SMSCreditCardViewController *creditCardVC;
@property (nonatomic, strong)  SMSTheSavingsCardViewController *theSavingsCardVC;

@end
