//
//  HotelAreaSiftTable.h
//  TongFubao
//
//  Created by Delpan on 14-9-1.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelAreaSiftTableDelegate <NSObject>

@optional

- (void)returnWithValue:(NSString *)value;

@end

@interface HotelAreaSiftTable : UIView <UITableViewDataSource, UITableViewDelegate>
{
    //筛选名称底图
    UIView *siftTitleView;
    //筛选列表
    UITableView *siftInfoTable;
    //筛选名称按钮
    UIButton *siftTitleBtn[5];
}

@property (nonatomic, weak) id <HotelAreaSiftTableDelegate> hotelAreaSiftTableDelegate;

@end




















