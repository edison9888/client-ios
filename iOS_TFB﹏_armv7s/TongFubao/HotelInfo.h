//
//  HotelInfo.h
//  TongFubao
//
//  Created by Delpan on 14-9-4.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelInfo : NSObject

//城市名
@property (nonatomic, copy) NSString *cityName;
//城市ID
@property (nonatomic, copy) NSString *cityId;
//行政区名
@property (nonatomic, copy) NSString *districtName;
//行政区ID
@property (nonatomic, copy) NSString *districtId;
//商业区名
@property (nonatomic, copy) NSString *zoneName;
//商业区ID
@property (nonatomic, copy) NSString *zoneId;
//酒店品牌名
@property (nonatomic, copy) NSString *brandName;
//酒店品牌ID
@property (nonatomic, copy) NSString *brandId;
//酒店主题名
@property (nonatomic, copy) NSString *themeName;
//酒店主题ID
@property (nonatomic, copy) NSString *themeId;
//城市地标名
@property (nonatomic, copy) NSString *locationName;
//城市地标ID
@property (nonatomic, copy) NSString *locationId;
//价格区间
@property (nonatomic, copy) NSString *priceRange;
//酒店星级
@property (nonatomic, copy) NSString *starRate;

+ (id)hotelInfoWithNSDictionary:(NSDictionary *)infoDictionary;

@end


















