//
//  MyBankCardViewController.h
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

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

@property(nonatomic,assign) BOOL bankDF;
@property(nonatomic,assign) BOOL bankXY;
@property (nonatomic, assign) BOOL QCoin;

@property (nonatomic, weak) id <BankPayListDelegate> bankPayListDelegate;

@end

















