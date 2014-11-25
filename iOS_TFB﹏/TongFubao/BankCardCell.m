//
//  BankCardCell.m
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BankCardCell.h"

@implementation BankCardCell

@synthesize logoView = _logoView;
@synthesize bankName = _bankName;
@synthesize masterName = _masterName;
@synthesize cardNumber = _cardNumber;
@synthesize cardType = _cardType;
@synthesize defaultCard = _defaultCard;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        //银行卡logo
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 35, 35)];
        _logoView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_logoView];
        
        //银行卡名称
        _bankName = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
        _bankName.backgroundColor = [UIColor clearColor];
        _bankName.textAlignment = NSTextAlignmentLeft;
        _bankName.textColor = [UIColor blackColor];
        _bankName.font = [UIFont systemFontOfSize:20.0];
        [self.contentView addSubview:_bankName];
        
        //用户名
        _masterName = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 200, 20)];
        _masterName.backgroundColor = [UIColor clearColor];
        _masterName.textAlignment = NSTextAlignmentLeft;
        _masterName.textColor = [UIColor grayColor];
        _masterName.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_masterName];
        
        //卡号
        _cardNumber = [[UILabel alloc] initWithFrame:CGRectMake(150, 40, 200, 20)];
        _cardNumber.backgroundColor = [UIColor clearColor];
        _cardNumber.textAlignment = NSTextAlignmentLeft;
        _cardNumber.textColor = [UIColor grayColor];
        _cardNumber.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_cardNumber];
        
        //卡类型
        _cardType = [[UILabel alloc] initWithFrame:CGRectMake(240, 40, 200, 20)];
        _cardType.backgroundColor = [UIColor clearColor];
        _cardType.textAlignment = NSTextAlignmentLeft;
        _cardType.textColor = [UIColor grayColor];
        _cardType.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_cardType];
        
        //默认卡
        _defaultCard = [[UILabel alloc] initWithFrame:CGRectMake(190, 10, 200, 25)];
        _defaultCard.backgroundColor = [UIColor clearColor];
        _defaultCard.textAlignment = NSTextAlignmentLeft;
        _defaultCard.textColor = RGBACOLOR(0, 194, 240, 1);
        _defaultCard.font = [UIFont systemFontOfSize:17.0];
        [self.contentView addSubview:_defaultCard];
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











