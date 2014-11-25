//
//  NLCreditCardSecondViewController.h
//  TongFubao
//
//  Created by MD313 on 13-10-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLBankListViewController.h"
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"
#import "NLCreditCardPaymentsViewController.h"

@interface NLCreditCardSecondViewController : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,NLBankLisDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)NSDictionary* myDictionary;
@property(nonatomic,assign)NLCreditCardPaymentsViewController* CreditCardDelgate;

@end
