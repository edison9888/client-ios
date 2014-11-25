//
//  AddNewBankCardController.h
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  添加银行卡

#import <UIKit/UIKit.h>
#import "CardInfo.h"
#import "AreaSelectView.h"
#import "NLBankListViewController.h"

@class AddNewBankCardController;

@protocol AddDelegate <NSObject>

@optional

- (void)popAndReloadData;

@end

@interface AddNewBankCardController : UIViewController <UITextFieldDelegate, AreaSelectViewDelegate, NLBankLisDelegate>

@property (assign,nonatomic) BOOL rightflag;

@property (nonatomic, weak) id <AddDelegate> addDelegate;

@property (nonatomic, strong) CardInfo *cardInfo;

@property (nonatomic, copy) NSArray *masterInfos;

- (id)initWithEdit:(BOOL)edit creditCard:(BOOL)creditCard_;

@end
