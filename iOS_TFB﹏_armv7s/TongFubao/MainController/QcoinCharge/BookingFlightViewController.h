//
//  BookingFlightViewController.h
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirFilterView.h"
@interface BookingFlightViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AirFilterViewdelegate>

{
    BOOL AlertBoxBool;
    NSInteger PM;
    NSInteger Time;
    NSInteger Price;
    NSInteger Play;
    
    NSInteger PMTag;
    NSInteger TimeTag;
    NSInteger PriceTag;
    NSInteger PlayTag;

}
@property (retain,nonatomic) UITapGestureRecognizer *tapGesture;

@property (retain,nonatomic) UITableView *BookingTableView;
// 城市code
@property (retain,nonatomic) NSString *DepartCtity;
@property (retain,nonatomic) NSString *arriveCity;
// 时间
@property (retain,nonatomic) NSString *departDate;
@property (retain,nonatomic) NSString *returnDate;
// 单返类型
@property (retain,nonatomic) NSString *searchType;
// 城市id
@property (retain,nonatomic) NSString *cityIDFromBookin;
@property (retain,nonatomic) NSString *cityIDToBooking;
// 起飞到达城市
@property (retain,nonatomic) NSString *BookingDepartCity;
@property (retain,nonatomic) NSString *BookingArriveCity;
//筛选城市key
@property (retain,nonatomic) NSString *CityKey;


// 装载网络数据
@property (retain,nonatomic) NSArray *HotCityArray;
@property (retain,nonatomic) NSArray *takeOffTimeArray;
@property (retain,nonatomic) NSArray *arriveTimeArray;
@property (retain,nonatomic) NSArray *flightArray;
@property (retain,nonatomic) NSArray *craftTypeArray;
@property (retain,nonatomic) NSArray *airLineCodeArray;
@property (retain,nonatomic) NSArray *priceArray;
@property (retain,nonatomic) NSArray *quantityArray;
@property (retain,nonatomic) NSArray *dPortNameArray;
@property (retain,nonatomic) NSArray *aPortNameArray;
@property (retain,nonatomic) NSArray *dPortCodeArray;
@property (retain,nonatomic) NSArray *aPortCodeArray;
@property (retain,nonatomic) NSArray *airLineNameArray;

// 装载筛选数组
@property (retain,nonatomic) NSMutableArray *PaiXuaAllArray;
// 装载筛选数组
@property (retain,nonatomic) NSMutableArray *temporaryPaiXuaAllArray;
// 航空名
@property (retain,nonatomic) NSMutableArray *otherAirPlayArray;




















@end
