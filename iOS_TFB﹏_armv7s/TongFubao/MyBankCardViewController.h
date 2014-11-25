//
//  MyBankCardViewController.h
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  我的银行卡

#import <UIKit/UIKit.h>
#import "CardInfo.h"
#import "Person.h"
#import "AddNewBankCardController.h"


@class MyBankCardViewController;

@protocol BankPayListDelegate <NSObject>

@optional

- (void)popWithValue:(id)person creditCard:(BOOL)flag;

@end

@interface MyBankCardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddDelegate>

/*代码懒得动了 直接加一个算了*/
@property (nonatomic, assign) BOOL bankDF;
@property (nonatomic, assign) BOOL bankXY;
@property (nonatomic, assign) BOOL planeFlag;
@property (nonatomic, assign) BOOL QCoin;
@property (nonatomic, assign) BOOL agentflag;
@property (nonatomic, assign) BOOL righthidden;

@property (nonatomic, weak) id <BankPayListDelegate> bankPayListDelegate;

@end

















