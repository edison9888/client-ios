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

@interface QcoinMoneyGive : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,NLBankLisDelegate,UITextFieldDelegate,BankPayListDelegate>

@property(nonatomic,strong)IBOutlet NLKeyboardAvoidingTableView* myTableView;

@property(nonatomic,strong)NSDictionary* myDictionary;
@property(nonatomic,retain) NSString* myMoney;
@property(nonatomic,assign) BOOL myNotifySMS;
@property(nonatomic,strong) NSString *PhoneGiveStr;
@property(nonatomic,strong) NSString *PhoneGiveStr2;
@property(nonatomic,strong) NSString *PhoneNum;

-(IBAction)onButtonBtnClicked:(id)sender;

@end
