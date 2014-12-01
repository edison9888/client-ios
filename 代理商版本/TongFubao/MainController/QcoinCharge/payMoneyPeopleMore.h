//
//  ayMoneyPeopleMore.h
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLBankListViewController.h"
#import "payMoneyToPay.h"
#import "UPPayPlugin.h"

@interface payMoneyPeopleMore : UIViewController<UITextFieldDelegate,NLBankLisDelegate,VisaReaderDelegate,UIAlertViewDelegate,UPPayPluginDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingTableView *Mytable;
@property (weak, nonatomic) IBOutlet UITextField *TextFiledCared;
@property (nonatomic,strong) NSMutableArray *pushArr;
@property (nonatomic,strong) NSMutableArray *cellArr;
@property (nonatomic,strong) NSString *TimerStr;
@property (nonatomic,strong) NSString *bkntnoStr;/*交易流水号*/
@end
