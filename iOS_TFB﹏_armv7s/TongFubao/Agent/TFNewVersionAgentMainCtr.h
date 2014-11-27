//
//  TFNewVersionAgentMainCtr.h
//  TongFubao
//
//  Created by 湘郎 on 14-11-26.
//  Copyright (c) 2014年 MD313. All rights reserved.
//
//  新版正式代理商界面

#import <UIKit/UIKit.h>

@interface TFNewVersionAgentMainCtr : UIViewController

@property(strong,nonatomic)NSString *totalRevenue;//本区历史总收益
@property(strong,nonatomic)NSString *theNumberOfUsers;//本区用户数
@property(strong,nonatomic)NSString *onTheSameDayReturns;//代理商号
@property(strong,nonatomic)NSString *anticipatedRevenues;//新增收益
@property(strong,nonatomic)NSString *amountOfMoneys;//当天收益

@property(strong,nonatomic)NSString *toString;


@end
