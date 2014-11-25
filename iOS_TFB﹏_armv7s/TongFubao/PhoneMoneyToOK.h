//
//  PhoneMoneyToOK.h
//  TongFubao
//
//  Created by  俊   on 14-4-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneMoneyToOK : UIViewController

@property (strong, nonatomic) NSString *labletextStr; /*充值/转账 完成*/
@property (strong, nonatomic) NSString *NumPhoneStr;
@property (strong, nonatomic) NSString *OKPhoneStr;/*充值300元*/
@property (strong, nonatomic) NSString *phoneNumLable;/*手机号码*/
@property (strong,nonatomic) NSString *numInfo;/*类型 充值或转账*/
@end
