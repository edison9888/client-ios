//
//  payMoneyToPay.h
//  TongFubao
//
//  Created by  俊   on 14-9-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payMoneyTopeople.h"

@interface payMoneyToPay : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labletextHeard;
@property (weak, nonatomic) IBOutlet NLKeyboardAvoidingTableView *Mytable;
@property (nonatomic,strong) NSMutableArray *cellArrPay;
@property (nonatomic,strong) NSString *timerStr;
@property (nonatomic,strong) NSString *wagepaymoneyStr;
@property (weak, nonatomic) IBOutlet UILabel *lableHeard;
@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@property (weak, nonatomic) IBOutlet UILabel *laleTOOK;
@property (weak, nonatomic) IBOutlet UIImageView *NotData;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (nonatomic,assign) BOOL pushFlag;
@end
