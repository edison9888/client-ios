//
//  ticketPriceObject.m
//  TongFubao
//
//  Created by kin on 14-9-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ticketPriceObject.h"

@implementation ticketPriceObject

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(NSInteger)adultPrice:(NSString *)newAdultPrice childrenPrice:(NSString *)newChildrenPrice babyPrice:(NSString *)newBabyPrice  adultNumber:(int)newAdultArray childrenNumber:(int)newChildrenArray babyNumber:(int)newBabyArray
{
   NSInteger allInteger =  [newAdultPrice intValue]*newAdultArray + [newChildrenPrice intValue]*newChildrenArray+ [newBabyPrice intValue]*newBabyArray;

    return allInteger;
}

-(NSInteger)adultTax:(NSString *)newAdultTax childrenTax:(NSString *)newChildrenTax babyTax:(NSString *)newBabyTax  adultNumber:(int)newAdultArray childrenNumber:(int)newChildrenArray babyNumber:(int)newBabyArray;
{

        NSInteger allInteger =  [newAdultTax intValue]*newAdultArray + [newChildrenTax intValue]*newChildrenArray + [newBabyTax intValue]*newBabyArray;
        
        return allInteger;
}

-(NSInteger)adultOil:(NSString *)newAdultOil childrenOil:(NSString *)newChildrenOil babyOil:(NSString *)newBabyOil  adultNumber:(int)newAdultArray childrenNumber:(int)newChildrenArray babyNumber:(int)newBabyArray;
{
    NSInteger allInteger =  [newAdultOil intValue]*newAdultArray + [newChildrenOil intValue]*newChildrenArray + [newBabyOil intValue]*newBabyArray;
    
    return allInteger;
}

//+(NSMutableArray *)AdultFare:(NSString *)newAdultFare AdultFuel:(NSString *)newAdultFuel AdultTaxes:(NSString *)newAdultTaxes
//{
//    NSMutableArray *AdultInfo = [[NSMutableArray alloc]initWithObjects:newAdultFare,newAdultFuel,newAdultTaxes, nil];
//    
//    return AdultInfo;
//}
//
//+(NSMutableArray *)ChildrenFare:(NSString *)newChildrenFare ChildrenFuel:(NSString *)newChildrenFuel ChildrenTaxes:(NSString *)newChildrenTaxes;
//{
//    NSMutableArray *ChildrenInfo = [[NSMutableArray alloc]initWithObjects:newChildrenFare,newChildrenFuel,newChildrenTaxes, nil];
//    
//    return ChildrenInfo;
//}
//
//
//+(NSMutableArray *)babyFare:(NSString *)newbabyFare babyFuel:(NSString *)newbabyFuel babyTaxes:(NSString *)newbabyTaxes;
//{
//    NSMutableArray *babyInfo = [[NSMutableArray alloc]initWithObjects:newbabyFare,newbabyFuel,newbabyTaxes, nil];
//    
//    return babyInfo;
// 
//}

@end
















































