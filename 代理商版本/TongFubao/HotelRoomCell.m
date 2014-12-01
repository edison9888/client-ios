//
//  HotelRoomCell.m
//  TongFubao
//
//  Created by Delpan on 14-9-2.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelRoomCell.h"

@implementation HotelRoomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //logo
        _logoBtn = [UIButton buttonWithFrame:CGRectMake(10, 10, 280 / 3.0, 280 / 4.0)
                               unSelectImage:nil
                                 selectImage:nil
                                         tag:100000
                                  titleColor:nil
                                       title:nil];
        [_logoBtn addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_logoBtn];
        
        //价格
        _priceLabel = [UILabel labelWithFrame:CGRectMake(220, 15, 100, 20)
                              backgroundColor:[UIColor clearColor]
                                    textColor:RGBACOLOR(22, 178, 240, 1.0)
                                         text:@"$ 480"
                                         font:[UIFont systemFontOfSize:20.0]];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_priceLabel];
        
        //预订
        _reserveBtn = [UIButton buttonWithFrame:CGRectMake(240, 40, 64, 35)
                                  unSelectImage:imageName(@"yellow_button@2x", @"png")
                                    selectImage:nil
                                            tag:100000
                                     titleColor:[UIColor whiteColor]
                                          title:@"预订"];
        _reserveBtn.layer.masksToBounds = YES;
        _reserveBtn.layer.cornerRadius = 5.0;
        [_reserveBtn addTarget:self action:@selector(reserveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_reserveBtn];
    }
    
    return self;
}

#pragma mark - 查看酒店相片
- (void)photoBtnAction:(UIButton *)sender
{
    self.photoBlock();
}

#pragma mark - 酒店预订
- (void)reserveBtnAction:(UIButton *)sender
{
    self.reserveBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end












