//
//  CardInfo.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-8-8.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "CardInfo.h"

@implementation CardInfo


+ (id)infoWithBkcardno:(NSString *)bkcardno bkcardbankid:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardbanklogo:(NSString *)bkcardbanklogo bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardisdefault:(NSString *)bkcardisdefault bkcardcardtype:(NSString *)bkcardcardtype bkcardid:(NSString *)bkcardid
{
    CardInfo *card = [[CardInfo alloc] init];
    card.bkcardno = bkcardno;
    card.bkcardbankid = bkcardbankid;
    card.bkcardbank = bkcardbank;
    card.bkcardbanklogo = bkcardbanklogo;
    card.bkcardbankman = bkcardbankman;
    card.bkcardbankphone = bkcardbankphone;
    card.bkcardyxmonth = bkcardyxmonth;
    card.bkcardyxyear = bkcardyxyear;
    card.bkcardcvv = bkcardcvv;
    card.bkcardidcard = bkcardidcard;
    card.bkcardisdefault = bkcardisdefault;
    card.bkcardcardtype = bkcardcardtype;
    card.bkcardid = bkcardid;
    
    return card;
}


//新增接口  跟上一个接口相比 多加了一个默认收款字段  /*雨*/
+ (id)infoWithBkcardno:(NSString *)bkcardno bkcardbankid:(NSString *)bkcardbankid bkcardbank:(NSString *)bkcardbank bkcardbanklogo:(NSString *)bkcardbanklogo bkcardbankman:(NSString *)bkcardbankman bkcardbankphone:(NSString *)bkcardbankphone bkcardyxmonth:(NSString *)bkcardyxmonth bkcardyxyear:(NSString *)bkcardyxyear bkcardcvv:(NSString *)bkcardcvv bkcardidcard:(NSString *)bkcardidcard bkcardisdefault:(NSString *)bkcardisdefault bkcardisdefaultPayment:(NSString *)bkcardisdefaultPayment bkcardcardtype:(NSString *)bkcardcardtype bkcardid:(NSString *)bkcardid{
 
 CardInfo *card = [[CardInfo alloc] init];
 card.bkcardno = bkcardno;
 card.bkcardbankid = bkcardbankid;
 card.bkcardbank = bkcardbank;
 card.bkcardbanklogo = bkcardbanklogo;
 card.bkcardbankman = bkcardbankman;
 card.bkcardbankphone = bkcardbankphone;
 card.bkcardyxmonth = bkcardyxmonth;
 card.bkcardyxyear = bkcardyxyear;
 card.bkcardcvv = bkcardcvv;
 card.bkcardidcard = bkcardidcard;
 card.bkcardisdefault = bkcardisdefault;
 card.bkcardisdefaultPayment = bkcardisdefaultPayment;
 card.bkcardcardtype = bkcardcardtype;
 card.bkcardid = bkcardid;
 
 return card;
 
 }




@end
