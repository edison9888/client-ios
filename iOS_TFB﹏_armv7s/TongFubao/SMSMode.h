//
//  SMSMode.h
//  TongFubao
//
//  Created by 湘郎 on 14-11-17.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSMode : NSObject

- (SMSMode*)initWithDictionary:(NSDictionary*)dic;
- (void)updateWithDictionary:(NSDictionary*)dic;
+ (SMSMode*)useWithDictionary:(NSDictionary*)dic;

@property(strong,nonatomic)NSString *historyPhone;//电话号码
@property(strong,nonatomic)NSString *historyDate;//时间
@property(strong,nonatomic)NSString *historyMoney;//金额
@property(strong,nonatomic)NSString *historyState;//支付成功/等待支付

@end
