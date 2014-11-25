//
//  PlaneCheakCell.m
//  TongFubao
//
//  Created by Delpan on 14-7-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PlaneCheakCell.h"

@implementation PlaneCheakCell

@synthesize airportLabel = _airportLabel;
@synthesize priceLabel = _priceLabel;
@synthesize discountLabel = _discountLabel;
@synthesize timeLabel = _timeLabel;
@synthesize typeLabel = _typeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        //机场
        _airportLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 20)];
        _airportLabel.backgroundColor = [UIColor clearColor];
        _airportLabel.textColor = RGBACOLOR(162, 164, 163, 1.0);
        _airportLabel.opaque = YES;
        _airportLabel.text = @"机场";
        _airportLabel.textAlignment = NSTextAlignmentLeft;
        _airportLabel.font = [UIFont systemFontOfSize:20.0];
        [self.contentView addSubview:_airportLabel];
        
        //价钱
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 20, 100, 20)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = RGBACOLOR(229, 185, 75, 1.0);
        _priceLabel.opaque = YES;
        _priceLabel.text = @"价钱";
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = [UIFont systemFontOfSize:20.0];
        [self.contentView addSubview:_priceLabel];
        
        //折扣
        _discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 20, 50, 20)];
        _discountLabel.backgroundColor = [UIColor clearColor];
        _discountLabel.textColor = RGBACOLOR(162, 164, 163, 1.0);
        _discountLabel.opaque = YES;
        _discountLabel.text = @"(折扣)";
        _discountLabel.textAlignment = NSTextAlignmentLeft;
        _discountLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_discountLabel];
        
        //时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 260, 20)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = RGBACOLOR(111, 203, 238, 1.0);
        _timeLabel.opaque = YES;
        _timeLabel.text = @"时间";
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:20.0];
        [self.contentView addSubview:_timeLabel];
        
        //机型
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 50, 100, 20)];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.textColor = RGBACOLOR(162, 164, 163, 1.0);
        _typeLabel.opaque = YES;
        _typeLabel.text = @"机型";
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_typeLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
