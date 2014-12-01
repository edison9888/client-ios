//
//  HotelInfo.m
//  TongFubao
//
//  Created by Delpan on 14-9-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelInfo.h"

@implementation HotelInfo

+ (id)hotelInfoWithNSDictionary:(NSDictionary *)infoDictionary
{
    HotelInfo *hotelInfo = [[HotelInfo alloc]init];
    hotelInfo.cityName = infoDictionary[@"cityName"];
    hotelInfo.cityId = infoDictionary[@"cityID"];
    
    return hotelInfo;
}

@end
