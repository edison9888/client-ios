//
//  SelectSeatCell.h
//  TongFubao
//
//  Created by Delpan on 14-7-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSeatCell : UITableViewCell

//舱位等级
@property (nonatomic, strong) UILabel *levelLabel;
//折扣
@property (nonatomic, strong) UILabel *discountLabel;
//条件
@property (nonatomic, strong) UILabel *conditionLabel;
//价钱
@property (nonatomic, strong) UILabel *priceLabel;

@end
