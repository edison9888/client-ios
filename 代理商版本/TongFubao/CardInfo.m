//
//  CardInfo.m
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
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

@end
