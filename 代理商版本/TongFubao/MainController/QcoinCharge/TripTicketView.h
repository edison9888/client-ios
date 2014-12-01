//
//  TripTicketView.h
//  TongFubao
//
//  Created by kin on 14-9-17.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirFilterView.h"
#import "leftView.h"
#import "RigthView.h"
#import "AirPlayPaixuObject.h"

@protocol TripTicketViewdelegate <NSObject>

-(void)TripTicketViewAirLineInfoArray:(NSMutableArray *)newairLineInfoArray;

@end


@interface TripTicketView : UIView<UITableViewDataSource,UITableViewDelegate,AirFilterViewdelegate,leftViewDelegate,RigthViewDelegate>
{
    BOOL rigthButton;
    BOOL selectionButton;
    AirPlayPaixuObject *_airPlayPaixu ;
    
    NSInteger PM;
    NSInteger Time;
    NSInteger Price;
    NSInteger Play;
    
    NSInteger PMTag;
    NSInteger TimeTag;
    NSInteger PriceTag;
    NSInteger PlayTag;
    AirFilterView *_AirView;

}
@property (retain,nonatomic) UITapGestureRecognizer *tapGesture;

//筛选城市key
@property (retain,nonatomic) NSString *CityKey;

@property (retain,nonatomic)id<TripTicketViewdelegate>delegata;
@property (retain,nonatomic)UITableView *tripTicketTableView;
@property (retain,nonatomic)leftView *leftTicket;
@property (retain,nonatomic)RigthView *rigthTicket;
@property (retain,nonatomic)NSMutableArray *PaiXuaAllArray;
@property (retain,nonatomic)NSMutableArray *temporaryPaiXuaAllArray;


-(void)TripDataSource:(NSMutableArray *)newTripDataSource rigthTicketName:(NSArray *)newrigthTicket rigthTicketCode:(NSArray *)newrigthTicketCode;

-(void)tripTicketTableViewdataSource;

-(void)HiddenInterfaceTripTicketView;
-(void)ShowInterfaceTripTicketView;
@end















