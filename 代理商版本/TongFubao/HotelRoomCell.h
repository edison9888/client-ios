//
//  HotelRoomCell.h
//  TongFubao
//
//  Created by Delpan on 14-9-2.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelRoomCell : UITableViewCell

//logo
@property (nonatomic, strong) UIButton *logoBtn;
//价格
@property (nonatomic, strong) UILabel *priceLabel;
//预订
@property (nonatomic, strong) UIButton *reserveBtn;
//查看酒店相片
@property (nonatomic, copy) void (^photoBlock)(void);
//酒店预订
@property (nonatomic, copy) void (^reserveBlock)(void);

@end
