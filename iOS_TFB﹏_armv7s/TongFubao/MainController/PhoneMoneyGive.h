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
#import "MyBankCardViewController.h"

@interface PhoneMoneyGive : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,NLBankLisDelegate,UITextFieldDelegate,UIAlertViewDelegate, BankPayListDelegate>

@property(nonatomic,strong)IBOutlet NLKeyboardAvoidingTableView* myTableView;

@property(nonatomic,assign) BOOL myNotifySMS;
@property(nonatomic,strong) NSDictionary* myDictionary;
/*默认卡好储值*/
@property (nonatomic,strong) NSMutableArray *arrBankListPay;

@property(nonatomic,retain) NSString* myMoney;
@property(nonatomic,strong) NSString *PhoneGiveStr;
@property(nonatomic,strong) NSString *PhoneGiveStr2;
@property(nonatomic,strong) NSString *PhoneNum;
@property(nonatomic,strong) NSString *PhoneAddress;

-(IBAction)onButtonBtnClicked:(id)sender;

@end
