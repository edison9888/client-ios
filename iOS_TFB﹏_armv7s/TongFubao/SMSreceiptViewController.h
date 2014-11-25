//
//  SMSreceiptViewController.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  短信收款主界面

#import <UIKit/UIKit.h>

@interface SMSreceiptViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//银行卡
- (IBAction)tapBankCard:(UIButton *)sender;
//服务协议
- (IBAction)tapServiceAgreement:(UIButton *)sender;
//发起收款
- (IBAction)tapInitiateCollection:(UIButton *)sender;

@end
