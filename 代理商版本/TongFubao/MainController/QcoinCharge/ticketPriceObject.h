//
//  ticketPriceObject.h
//  TongFubao
//
//  Created by kin on 14-9-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ticketPriceObject : NSObject


-(NSInteger)adultPrice:(NSString *)newAdultPrice childrenPrice:(NSString *)newChildrenPrice babyPrice:(NSString *)newBabyPrice  adultNumber:(int)newAdultArray childrenNumber:(int)newChildrenArray babyNumber:(int)newBabyArray;

-(NSInteger)adultTax:(NSString *)newAdultTax childrenTax:(NSString *)newChildrenTax babyTax:(NSString *)newBabyTax  adultNumber:(int)newAdultArray childrenNumber:(int)newChildrenArray babyNumber:(int)newBabyArray;

-(NSInteger)adultOil:(NSString *)newAdultOil childrenOil:(NSString *)newChildrenOil babyOil:(NSString *)newBabyOil  adultNumber:(int)newAdultArray childrenNumber:(int)newChildrenArray babyNumber:(int)newBabyArray;

//+(NSMutableArray *)AdultFare:(NSString *)newAdultFare AdultFuel:(NSString *)newAdultFuel AdultTaxes:(NSString *)newAdultTaxes;
//
//+(NSMutableArray *)ChildrenFare:(NSString *)newChildrenFare ChildrenFuel:(NSString *)newChildrenFuel ChildrenTaxes:(NSString *)newChildrenTaxes;
//
//+(NSMutableArray *)babyFare:(NSString *)newbabyFare babyFuel:(NSString *)newbabyFuel babyTaxes:(NSString *)newbabyTaxes;


@end











