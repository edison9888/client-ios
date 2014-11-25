//
//  QCoinPayController.h
//  TongFubao
//
//  Created by Delpan on 14-8-13.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBankCardViewController.h"

@interface QCoinPayController : UIViewController <UITextFieldDelegate, BankPayListDelegate, VisaReaderDelegate>

//基本信息
@property (nonatomic, copy) NSArray *infos;
//详情
@property (nonatomic, copy) NSArray *particulars;

@end
