//
//  NLReturnLoanViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLBankListViewController.h"

@interface NLReturnLoanViewController : UIViewController<UITextFieldDelegate,NLBankLisDelegate,UITableViewDataSource,UITableViewDelegate>

-(void)updateValue:(NSString*)shoucardno shoucardbank:(NSString*)shoucardbank shoucardman:(NSString*)shoucardman shoucardmobile:(NSString*)shoucardmobile bankid:(NSString*)bankid;

@end
