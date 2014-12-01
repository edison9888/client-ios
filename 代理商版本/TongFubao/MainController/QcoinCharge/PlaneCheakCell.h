//
//  PlaneCheakCell.h
//  TongFubao
//
//  Created by Delpan on 14-7-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaneCheakCell : UITableViewCell

//机场
@property (nonatomic, strong) UILabel *airportLabel;
//价钱
@property (nonatomic, strong) UILabel *priceLabel;
//折扣
@property (nonatomic, strong) UILabel *discountLabel;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//机型
@property (nonatomic, strong) UILabel *typeLabel;

@end
