//
//  NewPhoneIsOn.h
//  TongFubao
//
//  Created by  俊   on 14-5-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisaReader.h"
#import "UPPayPluginDelegate.h"
#import "NLKeyboardAvoid.h"

@interface NewPhoneIsOn : UIViewController<UPPayPluginDelegate,VisaReaderDelegate>

@property (strong, nonatomic) IBOutlet NLKeyboardAvoidingTableView *myTableView;
@property(nonatomic,strong)NSDictionary* myDictionary;
@property(nonatomic,retain) NSString* myMoney;
@property(nonatomic,assign) BOOL myNotifySMS;
-(IBAction)onButtonBtnClicked:(id)sender;

@end

