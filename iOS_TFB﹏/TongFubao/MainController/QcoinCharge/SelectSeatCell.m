//
//  SelectSeatCell.m
//  TongFubao
//
//  Created by Delpan on 14-7-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SelectSeatCell.h"

@implementation SelectSeatCell

@synthesize levelLabel = _levelLabel;
@synthesize discountLabel = _discountLabel;
@synthesize conditionLabel = _conditionLabel;
@synthesize priceLabel = _priceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //舱位
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 20)];
        _levelLabel.opaque = YES;
        _levelLabel.backgroundColor = [UIColor clearColor];
        _levelLabel.textColor = RGBACOLOR(150, 161, 200, 1.0);
        _levelLabel.textAlignment = NSTextAlignmentLeft;
        _levelLabel.font = [UIFont systemFontOfSize:20.0];
        _levelLabel.text = @"舱位";
        [self.contentView addSubview:_levelLabel];
        
        //折扣
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, 50, 15)];
        _discountLabel.opaque = YES;
        _discountLabel.backgroundColor = [UIColor clearColor];
        _discountLabel.textColor = RGBACOLOR(229, 185, 75, 1.0);
        _discountLabel.textAlignment = NSTextAlignmentLeft;
        _discountLabel.font = [UIFont systemFontOfSize:15.0];
        _discountLabel.text = @"(折扣)";
        [self.contentView addSubview:_discountLabel];
        
        //条件
        _conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 20, 85, 20)];
        _conditionLabel.opaque = YES;
        _conditionLabel.backgroundColor = [UIColor clearColor];
        _conditionLabel.textColor = RGBACOLOR(150, 161, 200, 1.0);
        _conditionLabel.textAlignment = NSTextAlignmentLeft;
        _conditionLabel.font = [UIFont systemFontOfSize:17.0];
        _conditionLabel.text = @"等级与条件";
        [self.contentView addSubview:_conditionLabel];
        
        //价钱
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 20, 40, 20)];
        _priceLabel.opaque = YES;
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = RGBACOLOR(229, 185, 75, 1.0);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = [UIFont systemFontOfSize:20.0];
        _priceLabel.text = @"价钱";
        [self.contentView addSubview:_priceLabel];
    }
    
    return self;
}


@end
