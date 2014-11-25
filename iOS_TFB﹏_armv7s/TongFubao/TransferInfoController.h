//
//  TransferInfoController.h
//  TongFubao
//
//  Created by Delpan on 14-9-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferInfoView.h"
#import "NLTransferSecondViewController.h"
#import "NLTransferThirdViewController.h"

@interface TransferInfoController : UIViewController

@property (nonatomic, copy) NSMutableDictionary *dataDic;

- (id)initWithNewCard:(BOOL)newCard_;

@end
