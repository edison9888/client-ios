//
//  SMSTheSavingsCardViewController.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  储蓄类 (废弃类、暂时不用)

#import <UIKit/UIKit.h>

@interface SMSTheSavingsCardViewController : UIViewController

@property(nonatomic,strong)void (^setPopBlock)();

- (void)viewDidCurrentView;
- (void)dataRefresh;//数据刷新

@property(strong,nonatomic)NSString *bankString;//银行卡号

@end
