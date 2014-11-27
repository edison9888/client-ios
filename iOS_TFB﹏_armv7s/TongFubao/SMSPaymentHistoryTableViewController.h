//
//  SMSPaymentHistoryTableViewController.h
//  TongFubao
//
//  Created by 湘郎 on 14-11-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  收款历史

#import <UIKit/UIKit.h>

@class SMSPaymentHistoryTableViewController;
@protocol paymentHistoryDelegate
-(void)agent:(SMSPaymentHistoryTableViewController *)vc paymentHistoryPhone:(NSString *)phone;
@end

@interface SMSPaymentHistoryTableViewController : UIViewController

@property(weak,nonatomic)id<paymentHistoryDelegate>delegate;

@end
