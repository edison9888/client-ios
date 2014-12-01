//
//  HotelInfoController.h
//  TongFubao
//
//  Created by Delpan on 14-8-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserveHotelController.h"

@interface HotelInfoController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//酒店信息字典
@property (nonatomic, copy) NSDictionary *basicInfoDic;

@end
