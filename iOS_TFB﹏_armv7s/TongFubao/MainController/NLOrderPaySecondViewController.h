//
//  NLOrderPaySecondViewController.h
//  TongFubao
//
//  Created by MD313 on 13-9-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLBankListViewController.h"
#import "VisaReader.h"

@interface NLOrderPaySecondViewController : UIViewController<NLBankLisDelegate,VisaReaderDelegate>

@property(nonatomic,strong)NSDictionary* myDictionary;

@end
