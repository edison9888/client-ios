//
//  ReserveHotelController.h
//  TongFubao
//
//  Created by Delpan on 14-8-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

//酒店第一页面/预订界面/发票界面

#import <UIKit/UIKit.h>
#import "StarPriceView.h"
#import "CityChangeController.h"
#import "HotelListController.h"
#import "HotelInfo.h"

typedef enum
{
    //主界面
    HotelMainType = 0,
    //预订界面
    HotelReserveType = 1,
    //发票界面
    HotelInvoiceType = 2,
}HotelCurrentType;

@interface ReserveHotelController : UIViewController <UITableViewDataSource, UITableViewDelegate, StarPriceViewDelegate, CityChangeControllerDelegate>

- (id)initWithType:(HotelCurrentType)type;

@end










