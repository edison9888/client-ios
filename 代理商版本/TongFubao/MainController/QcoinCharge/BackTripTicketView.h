//
//  BackTripTicketView.h
//  TongFubao
//
//  Created by kin on 14-9-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirFilterView.h"
#import "leftView.h"
#import "RigthView.h"
#import "AirPlayPaixuObject.h"

@protocol BackTripTicketViewdelegate <NSObject>

-(void)BackTripTicketViewAirLineInfoArray:(NSMutableArray *)newairLineInfoArray;

@end

@interface BackTripTicketView : UIView<UITableViewDataSource,UITableViewDelegate,AirFilterViewdelegate,leftViewDelegate,RigthViewDelegate>
{
    BOOL rigthButton;
    BOOL selectionButton;
    AirPlayPaixuObject *_airPlayPaixu ;
    //  筛选
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

@property (retain,nonatomic) NSString *CityKey;
@property (retain,nonatomic)id<BackTripTicketViewdelegate>delegata;
@property (retain,nonatomic)UITableView *BackTripTicketTableView;
@property (retain,nonatomic)leftView *leftTicket;
@property (retain,nonatomic)RigthView *rigthTicket;
@property (retain,nonatomic)NSMutableArray *PaiXuaAllArray;
@property (retain,nonatomic)NSMutableArray *temporaryPaiXuaAllArray;


-(void)BackTripDataSource:(NSMutableArray *)newTripDataSource BackRigthTicketName:(NSArray *)newrigthTicket BackRigthTicketCode:(NSArray *)newrigthTicketCode;

-(void)BackTripTableViewdataSource;
-(void)leftItemClickNavigation;




@end
