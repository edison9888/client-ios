//
//  RoundTriprReservationViewController.h
//  TongFubao
//
//  Created by kin on 14-9-17.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerButtonView.h"
#import "TripTicketView.h"
#import "BackTripTicketView.h"
@interface RoundTriprReservationViewController : UIViewController<TimerButtonViewDelegate,TripTicketViewdelegate,BackTripTicketViewdelegate>
{
    NSInteger timeInteger;
    BOOL TimeSwitch;
    BOOL PageSwitching;
//    BOOL AlertBoxBool;
}


// 城市code
@property (retain,nonatomic) NSString *DepartCodeCtity;
@property (retain,nonatomic) NSString *arriveCodeCity;
// 时间
@property (retain,nonatomic) NSString *departFromTime;
@property (retain,nonatomic) NSString *returnToTime;
// 城市id
@property (retain,nonatomic) NSString *cityIDFrom;
@property (retain,nonatomic) NSString *cityIDTo;
// 城市
@property (retain,nonatomic) NSString *RoundDepartCity;
@property (retain,nonatomic) NSString *RoundArriveCity;

// 往返类型
@property (retain,nonatomic) NSString *searchType;

// 第一个页面的数据
@property (retain,nonatomic) NSMutableArray *firstPlayInfoArray;
// 第二个页面的数据
@property (retain,nonatomic) NSMutableArray *seconPlayInfoArray;


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
@property (retain,nonatomic) NSArray  *dCityCodeArray ;


// 行程传数据源
@property (retain,nonatomic) NSMutableArray *TripFromTimeArray;




@end




















