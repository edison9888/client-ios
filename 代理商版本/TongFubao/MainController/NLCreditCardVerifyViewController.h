//
//  NLCreditCardVerifyViewController.h
//  TongFubao
//
//  Created by MD313 on 13-10-22.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPPayPluginDelegate.h"

@interface NLCreditCardVerifyViewController : UIViewController<UPPayPluginDelegate>

@property(nonatomic,strong)NSDictionary* myDictionary;

@end
