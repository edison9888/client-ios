//
//  SMSAddBankCardViewController.h
//  TongFubao
//
//  Created by 湘郎 on 14-11-11.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  添加银行卡

#import <UIKit/UIKit.h>

@class SMSAddBankCardViewController;
@protocol addBankCardDelegate
-(void)agent:(SMSAddBankCardViewController *)vc Refresh:(BOOL)refresh theOpeningBankString:(NSString *)theOpeningBankString creditCard:(NSString *)creditCard name:(NSString *)name phone:(NSString *)phone identity:(NSString *)identity ccv:(NSString *)ccv month:(NSString *)month years:(NSString *)years;

@end


@interface SMSAddBankCardViewController : UIViewController

@property(weak,nonatomic)id<addBankCardDelegate>delegate;

@property(assign,nonatomic)int stateIndex;

@end
