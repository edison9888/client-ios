//
//  FlightData.h
//  TongFubao
//
//  Created by kin on 14-8-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FlightDataDelegate <NSObject>
- (void)getDataWithArray:(NSArray *)array oldLogoString:(NSString *)newlogoString requestCityName:(NSString *)newCityName buttonTag:(NSInteger)newTag cityCodeArray:(NSArray *)newcityCodeArray cityIdArray:(NSArray *)newcityIdArray;
@end

@interface FlightData : NSObject

@property(retain,nonatomic)NSArray *HotCityArray;
@property(retain,nonatomic)NSArray *cityCodeArray;
@property(retain,nonatomic)NSArray *cityIdArray;



@property(retain,nonatomic)NSString *cellLetter;
@property(retain,nonatomic)NSString *logoString;
@property(retain,nonatomic)NSString *CityName;
@property(assign,nonatomic)NSInteger buttonTeger;
@property (weak, nonatomic) id <FlightDataDelegate> flightDataDelegate;

-(id)init;
-(void)CitytToFindTheNetworkRequest:(NSString *)newfirstLetter requestCityName:(NSString *)newCityName buttonTag:(NSInteger)newTag;

@end









