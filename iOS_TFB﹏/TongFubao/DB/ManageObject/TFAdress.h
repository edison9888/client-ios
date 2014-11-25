//
//  TFAdress.h
//  TongFubao
//
//  Created by  俊   on 14-5-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TFAdress : NSManagedObject

@property (nonatomic, retain) NSString * Alladdress;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * ProvinceStr;
@property (nonatomic, retain) NSString * CityStr;
@property (nonatomic, retain) NSString * ZoneStr;
@property (nonatomic, retain) NSString * AreaStr;
@property (nonatomic, retain) NSString * PatientiaAddressStr;

@end
