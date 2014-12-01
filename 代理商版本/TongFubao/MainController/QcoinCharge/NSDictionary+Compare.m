//
//  NSDictionary+Compare.m
//  lxArray
//
//  Created by kin on 14-8-30.
//  Copyright (c) 2014年 kin. All rights reserved.
//

#import "NSDictionary+Compare.h"

@implementation NSDictionary (Compare)

- (NSComparisonResult)compare: (NSDictionary *)otherDictionary
{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    NSNumber *number1 = [[tempDictionary allKeys] objectAtIndex:0];
    NSNumber *number2 = [[otherDictionary allKeys] objectAtIndex:0];
    
    NSComparisonResult result = [number1 compare:number2];
    
    return result == NSOrderedDescending; // 升序
    //    return result == NSOrderedAscending;  // 降序
    
}


@end







































