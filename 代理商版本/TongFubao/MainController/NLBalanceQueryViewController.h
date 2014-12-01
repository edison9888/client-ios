//
//  NLBalanceQueryViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "NLBankListViewController.h"
#import "VisaReader.h"

@interface NLBalanceQueryViewController : UIViewController<MFMessageComposeViewControllerDelegate,NLBankLisDelegate,VisaReaderDelegate>

@end
