//
//  PaymentDf.h
//  TongFubao
//
//  Created by  俊   on 14-6-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisaReader.h"
#import "NLKeyboardAvoid.h"
#import "NLPushViewIntoNav.h"
#import "NLKeyboardAvoid.h"

@interface PaymentDf : UIViewController<VisaReaderDelegate>
@property(nonatomic,strong)IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,assign) NLPushViewType myNextType;


@end
