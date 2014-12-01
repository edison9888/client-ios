//
//  CityChangeController.h
//  TongFubao
//
//  Created by Delpan on 14-8-26.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTable.h"
#import "BlackTableView.h"
#import "HotelInfo.h"

@protocol CityChangeControllerDelegate <NSObject>

@optional

- (void)returnWithValue:(NSString *)name tag:(NSString *)tag nameKey:(NSString *)nameKey tagKey:(NSString *)tagKey;

@end

@interface CityChangeController : UIViewController <CustomTabelDelegate, UITextFieldDelegate, BlackTableViewDelegate>

@property (nonatomic, weak) id <CityChangeControllerDelegate> cityChangeControllerDelegate;
//城市ID
@property (nonatomic, copy) NSString *currentCityID;

- (id)initWithCity:(CustomTableType)customTableType;

@end
