//
//  HotelListController.h
//  TongFubao
//
//  Created by Delpan on 14-8-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelListCell.h"
#import "StarPriceView.h"
#import "HotelInfoController.h"
#import "HotelAreaSiftTable.h"
#import "HotelInfo.h"

@interface HotelListController : UIViewController <UITableViewDataSource, UITableViewDelegate, StarPriceViewDelegate, HotelAreaSiftTableDelegate>

@property (nonatomic, strong) HotelInfo *hotelInfo;

@end
