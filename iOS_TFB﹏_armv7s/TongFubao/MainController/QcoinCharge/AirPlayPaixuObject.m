//
//  AirPlayPaixuObject.m
//  TongFubao
//
//  Created by kin on 14-9-1.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AirPlayPaixuObject.h"



@interface NSDictionary (compareDictionary)

-(NSComparisonResult)compareDictionary:(NSDictionary *)newotherDictionary;

@end

@implementation NSDictionary (compareDictionary)

-(NSComparisonResult)compareDictionary:(NSDictionary *)newotherDictionary;
{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    NSNumber *number1 = [[tempDictionary allKeys] objectAtIndex:0];
    NSNumber *number2 = [[newotherDictionary allKeys] objectAtIndex:0];
    
    NSComparisonResult result = [number1 compare:number2];
    
    return result == NSOrderedAscending;  // 降序
}



@end


@implementation AirPlayPaixuObject


-(id)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

// 时间排序
-(NSMutableArray *)timePaiXiuDescending:(NSMutableArray *)newTimePaiXiu timeTager:(NSInteger)timeTager;
{
    NSMutableArray *ArrayDictionary = [[NSMutableArray alloc]init];
    NSArray *paiHaoArray = [[NSMutableArray alloc]init];
    NSMutableArray *PaiXiuArrayDictionary = [[NSMutableArray alloc]init];
    NSMutableArray *AgenPaiXiuArrayDictionary = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [newTimePaiXiu count]; i++)
    {
        NSString *timeIndex = [[newTimePaiXiu objectAtIndex:i] objectAtIndex:0];
        NSString *day = [timeIndex substringWithRange:NSMakeRange(6, 1)];
        NSString *time = [timeIndex substringWithRange:NSMakeRange(11, 2)];
        NSString *timeKey = [day stringByAppendingString:time];
        NSMutableDictionary *objectDictionary = [[NSMutableDictionary alloc]init];
        [objectDictionary setObject:[newTimePaiXiu objectAtIndex:i] forKey:timeKey];
        [ArrayDictionary addObject:objectDictionary];
    }
    
    if (timeTager == 0)
    {
        paiHaoArray = [ArrayDictionary sortedArrayUsingSelector:@selector(compare:)];
    }
    else
    {
        paiHaoArray = [ArrayDictionary sortedArrayUsingSelector:@selector(compareDictionary:)];
    }
    for (int i = 0; i < [ArrayDictionary count]; i++)
    {
        [PaiXiuArrayDictionary addObject:[[paiHaoArray objectAtIndex:i] allValues]];
        [AgenPaiXiuArrayDictionary addObject:[[PaiXiuArrayDictionary objectAtIndex:i] objectAtIndex:0]];
    }
    return AgenPaiXiuArrayDictionary;
}

// 价格排序
-(NSMutableArray *)pricePaiXiuDescending:(NSMutableArray *)newPricePaiXiu priceTager:(NSInteger)newPriceTager
{
    NSMutableArray *priceArray = [[NSMutableArray alloc]init];
    NSMutableArray *allPricePaiHaoArray = [[NSMutableArray alloc]init];
    NSMutableArray *allAganPriceArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [newPricePaiXiu count]; i++)
    {
        NSMutableDictionary *objectDictionary = [[NSMutableDictionary alloc]init];
        [objectDictionary setObject:[newPricePaiXiu objectAtIndex:i] forKey:[[newPricePaiXiu objectAtIndex:i] objectAtIndex:2]];
        [priceArray addObject:objectDictionary];
    }
//    NSLog(@"=====priceArray====%@",priceArray);
    NSArray *pricePaiHaoArray;
    
    if (newPriceTager == 0)
    {
        pricePaiHaoArray = [priceArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2)
                            {
                                NSNumber *num1 = [NSNumber numberWithFloat:[[[obj1 allKeys] firstObject] floatValue]];
                                NSNumber *num2 = [NSNumber numberWithFloat:[[[obj2 allKeys] firstObject] floatValue]];
                                if ([num1 compare:num2] == NSOrderedAscending)
                                {
                                    return NSOrderedDescending;
                                }
                                if ([num1 compare:num2] == NSOrderedDescending)
                                {
                                    return NSOrderedAscending;
                                }
                                return [num1 compare:num2];
                            }];
//        NSLog(@"=====pricePaiHaoArray====%@",pricePaiHaoArray);


    }
    else if (newPriceTager == 1)
    {        
        pricePaiHaoArray = [priceArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2)
                            {
                                return [[[obj1 allKeys] firstObject] compare:[[obj2 allKeys] firstObject] options:NSNumericSearch];
                            }];
//        NSLog(@"=====pricePaiHaoArray====%@",pricePaiHaoArray);
    }
    
    for (int i = 0; i < [pricePaiHaoArray count]; i++)
    {
        [allPricePaiHaoArray addObject:[[pricePaiHaoArray objectAtIndex:i] allValues]];
        [allAganPriceArray addObject:[[allPricePaiHaoArray objectAtIndex:i] objectAtIndex:0]];
    }
//    NSLog(@"=======allAganPriceArray=====%@",allAganPriceArray);
    return allAganPriceArray;
}

// 航空公司
-(NSMutableArray *)airLineNamePaiXiuDescending:(NSMutableArray *)newairLineNamePaiXiu airCode:(NSString *)newairCode;
{
    
    NSMutableArray *airLineNameArray = [[NSMutableArray alloc]init];

    for (int i = 0; i < [newairLineNamePaiXiu count]; i++)
    {
            if ([[[newairLineNamePaiXiu objectAtIndex:i] objectAtIndex:3] isEqualToString:newairCode])
            {
                [airLineNameArray addObject:[newairLineNamePaiXiu objectAtIndex:i]];
            }
    }
    return airLineNameArray;
}



// 时间段排序
-(NSMutableArray *)pmTimePaiXiuDescending:(NSMutableArray *)newPmTimePaiXiu timeTager:(NSInteger)timeTager
{
    NSMutableArray *timeArray = [[NSMutableArray alloc]init];

    for (int i = 0; i < [newPmTimePaiXiu count]; i++)
    {
        NSString *timeIndex = [[newPmTimePaiXiu objectAtIndex:i] objectAtIndex:0];
        NSString *day = [timeIndex substringWithRange:NSMakeRange(11, 2)];
//        NSLog(@"==day==%@",day);

        if (timeTager == 0)
        {
            if ([day integerValue] >= 00 && [day integerValue] < 12)
            {
                [timeArray addObject:[newPmTimePaiXiu objectAtIndex:i]];
//                NSLog(@"====000====%@",timeArray);
            }
        }
       else  if (timeTager == 1)
        {
        if ([day integerValue] >= 12 && [day integerValue] < 18)
            {
                [timeArray addObject:[newPmTimePaiXiu objectAtIndex:i]];
//                NSLog(@"===111=====%@",timeArray);
            }
        }
        else if (timeTager == 2)
        {
            if ([day integerValue] >= 18 && [day integerValue] <= 24)
            {
                [timeArray addObject:[newPmTimePaiXiu objectAtIndex:i]];
//                NSLog(@"==22======%@",timeArray);
            }
        }
    }
    return timeArray;
    
}


@end




























