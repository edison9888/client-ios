//
//  AddNewBankCardController.h
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfo.h"
#import "AreaSelectView.h"

@class AddNewBankCardController;

@protocol AddDelegate <NSObject>

@optional

- (void)popAndReloadData;

@end

@interface AddNewBankCardController : UIViewController <UITextFieldDelegate, AreaSelectViewDelegate>

@property (nonatomic, weak) id <AddDelegate> addDelegate;

@property (nonatomic, strong) CardInfo *cardInfo;

@property (nonatomic, copy) NSArray *masterInfos;

- (id)initWithEdit:(BOOL)edit creditCard:(BOOL)creditCard_;

@end
