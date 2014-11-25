//
//  TFData.h
//  TongFubao
//
//  Created by ec on 14-5-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADD_SKQ_ADDRESS_FLAG        @"add_skq_address_flag"
#define MAIN_IS_ON_GESTURESE        @"main_is_on_gesturese"
#define MAIN_IS_ON_NEWLOGINGESTURE  /*重新注销登录的手势密码状态*/@"main_is_on_newlogingesturese"
#define BOOS_PAY_MONEY_PEOPLE  @"boos_is_pay_money_people"
#define BOOS_DELETE_MONEY_PEOPLE @"boos_is_delete_money_people"
#define BOOS_CHANGE_MONEY_PEOPLE @"boos_is_change_money_people"
#define PLANE_ADD_PEOPLE                @"plane_add_people"
#define PAY_MONEY_BOOS_PUSH   /*支付不可编辑判断*/       @"pay_money_boos_push"

@interface TFData : NSObject

+(TFData *)Instance;

+(NSMutableDictionary*)getTempData;

@end
