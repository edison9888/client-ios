//
//  NLCashSecondViewController.h
//  TongFubao
//
//  Created by MD313 on 13-10-10.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLBankListViewController.h"
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"
#import "NLKeyboardAvoid.h"

@interface NLCashSecondViewController : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,NLBankLisDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,strong)IBOutlet UIButton* myButton;
@property(nonatomic,strong)NSDictionary* myDictionary;

-(IBAction)onButtonBtnClicked:(id)sender;

@end
