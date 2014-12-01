//
//  ReserveHotelController.h
//  TongFubao
//
//  Created by Delpan on 14-8-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarPriceView.h"
#import "CityChangeController.h"
#import "HotelListController.h"
#import "HotelInfo.h"

typedef enum
{
    HotelMainType = 0,
    HotelReserveType = 1,
    HotelInvoiceType = 2,
}HotelCurrentType;

@interface ReserveHotelController : UIViewController <UITableViewDataSource, UITableViewDelegate, StarPriceViewDelegate, CityChangeControllerDelegate>

- (id)initWithType:(HotelCurrentType)type;

@end
