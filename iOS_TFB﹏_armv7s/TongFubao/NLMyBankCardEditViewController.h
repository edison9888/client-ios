//
//  NLMyBankCardEditViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLBankListViewController.h"
#import "NLMyBankCardViewController.h"
//#import "VisaReader.h"

@interface NLMyBankCardEditViewController : UIViewController<UITextFieldDelegate,NLBankLisDelegate,/*VisaReaderDelegate,*/UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (nonatomic ,assign) NLMyBankCardViewController *delegate;

-(void)setInitValue:(NSString*)bank no:(NSString*)no man:(NSString*)man mobile:(NSString*)mobile;

@end
