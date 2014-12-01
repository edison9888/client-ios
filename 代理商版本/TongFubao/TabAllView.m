//
//  TabAllView.m
//  TongFubao
//
//  Created by  俊   on 14-7-27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TabAllView.h"

@implementation TabAllView

+(TabAllView *)instanceTextView:(int)object
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TabAllView" owner:nil options:nil];
    return [nibView objectAtIndex:object];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         
    }
    return self;
}

/* 对应图标的名字
 [btAllArray addObject:@{@"img": @"icon_agentbuy",@"txt":@"代理商",@"mnuno":@"agentbuy"}];
 [btAllArray addObject:@{@"img": @"icon_mobilerecharge",@"txt":@"话费充值",@"mnuno":@"mobilerecharge"}];
 [btAllArray addObject:@{@"img": @"iocn_family",@"txt":@"水电煤缴费",@"mnuno":@"family"}];
 [btAllArray addObject:@{@"img": @"icon_delivery",@"txt":@"快递查询",@"mnuno":@"delivery"}];
 [btAllArray addObject:@{@"img": @"icon_airplane",@"txt":@"机票预订",@"mnuno":@"airplane"}];
 [btAllArray addObject:@{@"img": @"icon_train",@"txt":@"火车票预订",@"mnuno":@"train"}];
 [btAllArray addObject:@{@"img": @"icon_hotel",@"txt":@"酒店预订",@"mnuno":@"hotel"}];
 [btAllArray addObject:@{@"img": @"icon_game",@"txt":@"游戏充值",@"mnuno":@"game"}];
 [btAllArray addObject:@{@"img": @"icon_qqrecharge",@"txt":@"Q币充值",@"mnuno":@"qqrecharge"}];
 [btAllArray addObject:@{@"img": @"icon_tfmg",@"txt":@"转账汇款",@"mnuno":@"tfmg"}];
 [btAllArray addObject:@{@"img": @"icon_creditcard",@"txt":@"信用卡还款",@"mnuno":@"creditcard"}];
 [btAllArray addObject:@{@"img": @"icon_balance",@"txt":@"余额查询",@"mnuno":@"balance"}];
 [btAllArray addObject:@{@"img": @"icon_coupon",@"txt":@"商户收款" ,@"mnuno":@"coupon"}];
 [btAllArray addObject:@{@"img": @"icon_orderbuy",@"txt":@"内购刷卡器",@"mnuno":@"orderbuy"}];
 所有按钮*/

@end
