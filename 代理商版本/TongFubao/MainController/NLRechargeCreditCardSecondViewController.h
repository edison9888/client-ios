//
//  NLRechargeCreditCardSecondViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLBankListViewController.h"
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"
#import "NLKeyboardAvoid.h"

@interface NLRechargeCreditCardSecondViewController : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,NLBankLisDelegate>

@property(nonatomic,strong)IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property(nonatomic,strong)IBOutlet UIButton* myButton;
@property(nonatomic,strong)NSDictionary* myDictionary;
@property(nonatomic,retain) NSString* myMoney;
@property(nonatomic,assign) BOOL myNotifySMS;

-(IBAction)onButtonBtnClicked:(id)sender;

@end
