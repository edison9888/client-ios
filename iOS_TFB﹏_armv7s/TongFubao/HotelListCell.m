//
//  HotelListCell.m
//  TongFubao
//
//  Created by Delpan on 14-8-27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelListCell.h"

@implementation HotelListCell

@synthesize logoView = _logoView;
@synthesize hotelNameLabel = _hotelNameLabel;
@synthesize priceLabel = _priceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        //logo
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 100, 80)];
//        _logoView.image = imageName(@"bank1", @"png");
        [self.contentView addSubview:_logoView];
        
        //酒店名称
        _hotelNameLabel = [UILabel labelWithFrame:CGRectMake(110, 10, 115, 20)
                                  backgroundColor:[UIColor clearColor]
                                        textColor:[UIColor grayColor]
                                             text:nil
                                             font:[UIFont systemFontOfSize:15.0]];
        [self.contentView addSubview:_hotelNameLabel];
        
        //价格
        _priceLabel = [UILabel labelWithFrame:CGRectMake(235, 10, 80, 20)
                              backgroundColor:[UIColor clearColor]
                                    textColor:[UIColor blueColor]
                                         text:nil
                                         font:[UIFont systemFontOfSize:15.0]];
        [self.contentView addSubview:_priceLabel];
        
        //评分
        _ctripRateLabel = [UILabel labelWithFrame:CGRectMake(240, 40, 50, 20)
                                  backgroundColor:[UIColor clearColor]
                                        textColor:[UIColor grayColor]
                                             text:nil
                                             font:[UIFont systemFontOfSize:15.0]];
        [self.contentView addSubview:_ctripRateLabel];
        
        //地址
        _addressLabel = [UILabel labelWithFrame:CGRectMake(110, 65, 125, 20)
                                backgroundColor:[UIColor clearColor]
                                      textColor:[UIColor grayColor]
                                           text:nil
                                           font:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_addressLabel];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end















