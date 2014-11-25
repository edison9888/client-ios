//
//  SMSChooseABankTableViewController.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  选择银行 (废弃类、暂时不用)

#import <UIKit/UIKit.h>

@class SMSChooseABankTableViewController;
@protocol ChooseABankDelegate
-(void)upload:(SMSChooseABankTableViewController *)vc bank:(NSString *)bank;

@end



@interface SMSChooseABankTableViewController : UITableViewController

@property(weak,nonatomic)id<ChooseABankDelegate>delegate;


@end
