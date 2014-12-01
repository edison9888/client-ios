//
//  CardInfo.h
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardInfo : NSObject

//卡号
@property (nonatomic, copy) NSString *bkcardno;
//所属银行ID
@property (nonatomic, copy) NSString *bkcardbankid;
//银行名称
@property (nonatomic, copy) NSString *bkcardbank;
//银行logo
@property (nonatomic, copy) NSString *bkcardbanklogo;
//开户人
@property (nonatomic, copy) NSString *bkcardbankman;
//预留电话
@property (nonatomic, copy) NSString *bkcardbankphone;
//有效月
@property (nonatomic, copy) NSString *bkcardyxmonth;
//有效年
@property (nonatomic, copy) NSString *bkcardyxyear;
//CVV校验
@property (nonatomic, copy) NSString *bkcardcvv;
//身份证
@property (nonatomic, copy) NSString *bkcardidcard;
//是否默认
@property (nonatomic, copy) NSString *bkcardisdefault;
//卡类型
@property (nonatomic, copy) NSString *bkcardcardtype;
//卡id
@property (nonatomic, copy) NSString *bkcardid;
//通道名
@property (nonatomic, copy) NSString *paychalname;
//价钱
@property (nonatomic, copy) NSString *payMoney;
//Q号
@property (nonatomic, copy) NSString *qNumber;
//刷卡器设备号
@property (nonatomic, copy) NSString *paycardid;
//优惠券id
@property (nonatomic, copy) NSString *couponid;



+ (id)infoWithBkcardno:(NSString *)bkcardno bkcardbankid:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardbanklogo:(NSString *)bkcardbanklogo bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardisdefault:(NSString *)bkcardisdefault bkcardcardtype:(NSString *)bkcardcardtype bkcardid:(NSString *)bkcardid;

@end










