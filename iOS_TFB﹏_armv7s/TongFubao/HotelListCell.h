//
//  HotelListCell.h
//  TongFubao
//
//  Created by Delpan on 14-8-27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelListCell : UITableViewCell

//logo
@property (nonatomic, strong) UIImageView *logoView;
//酒店名称
@property (nonatomic, strong) UILabel *hotelNameLabel;
//价格
@property (nonatomic, strong) UILabel *priceLabel;
//评分
@property (nonatomic, strong) UILabel *ctripRateLabel;
//地址
@property (nonatomic, strong) UILabel *addressLabel;

@end

























