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

@interface NLCashSecondViewController : UIViewController<UPPayPluginDelegate,VisaReaderDelegate,NLBankLisDelegate,UIAlertViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)IBOutlet NLKeyboardAvoidingTableView* myTableView;
@property (weak, nonatomic) IBOutlet UILabel *textLable;
@property(nonatomic,strong) IBOutlet UIButton* myButton;
@property(nonatomic,strong) NSDictionary     * myDictionary;
/*验证码超时期限*/
@property(nonatomic, readwrite, retain) NSTimer *myTimer;
-(IBAction)onButtonBtnClicked:(id)sender;

@end
