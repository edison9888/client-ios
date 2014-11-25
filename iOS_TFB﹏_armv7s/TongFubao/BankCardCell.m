//
//  BankCardCell.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-8-8.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "BankCardCell.h"

@implementation CacheView

/*下载logo*/
- (void)imageWitwURL:(NSString *)url
{
    if (![url isEqualToString:@""])
    {
        if (!loadImage)
        {
            loadImage = YES;
            
            //下载图片
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *urlString = [url rangeOfString:@"http://"].length > 0? url : [NSString stringWithFormat:@"http://%@",url];
                
                //图片数据
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
                //logo图片
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.image = image;
                    
                    loadImage = NO;
                });
            });
        }
    }
}

@end

@implementation BankCardCell

@synthesize logoView = _logoView;
@synthesize bankName = _bankName;
@synthesize masterName = _masterName;
@synthesize cardNumber = _cardNumber;
@synthesize cardType = _cardType;
@synthesize defaultCard = _defaultCard;
@synthesize receivables = _receivables;/*雨*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        /*银行卡logo*/
        _logoView = [[CacheView alloc] initWithFrame:CGRectMake(10, 15, 35, 35)];
        _logoView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_logoView];
        
        //银行卡名称
        _bankName = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 170, 20)];
        _bankName.backgroundColor = [UIColor clearColor];
        _bankName.textAlignment = NSTextAlignmentLeft;
        _bankName.textColor = [UIColor blackColor];
        _bankName.font = [UIFont systemFontOfSize:18.0];
        _bankName.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_bankName];
        
        //用户名
        _masterName = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 200, 20)];
        _masterName.backgroundColor = [UIColor clearColor];
        _masterName.textAlignment = NSTextAlignmentLeft;
        _masterName.textColor = [UIColor grayColor];
        _masterName.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_masterName];
        
        //卡号
        _cardNumber = [[UILabel alloc] initWithFrame:CGRectMake(140, 40, 200, 20)];
        _cardNumber.backgroundColor = [UIColor clearColor];
        _cardNumber.textAlignment = NSTextAlignmentLeft;
        _cardNumber.textColor = [UIColor grayColor];
        _cardNumber.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_cardNumber];
        
        //卡类型
        _cardType = [[UILabel alloc] initWithFrame:CGRectMake(230, 40, 200, 20)];
        _cardType.backgroundColor = [UIColor clearColor];
        _cardType.textAlignment = NSTextAlignmentLeft;
        _cardType.textColor = [UIColor grayColor];
        _cardType.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_cardType];
        
        //默认支付卡
        _defaultCard = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 15, 32)];
        _defaultCard.alpha = 0;
        [_defaultCard setTitle:@"支付" forState:UIControlStateNormal];
        [_defaultCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_defaultCard setTitleColor:RGBACOLOR(0, 194, 240, 1) forState:UIControlStateNormal];
        [_defaultCard setBackgroundImage:[UIImage imageNamed:@"SMS_receivables@2x"] forState:UIControlStateNormal];
        _defaultCard.titleLabel.lineBreakMode = 0;
        _defaultCard.titleLabel.font = [UIFont fontWithName:nil size:9];
        [_defaultCard.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_defaultCard];
        
        //默认付款卡 /*雨*/
        _receivables = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, 15, 32)];
        _receivables.alpha = 0;
        [_receivables setTitle:@"收款" forState:UIControlStateNormal];
        [_receivables setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_receivables setTitleColor:RGBACOLOR(0, 194, 240, 1) forState:UIControlStateNormal];
        [_receivables setBackgroundImage:[UIImage imageNamed:@"SMS_payment@2x"] forState:UIControlStateNormal];
        _receivables.titleLabel.lineBreakMode = 0;
        _receivables.titleLabel.font = [UIFont fontWithName:nil size:9];
        [_receivables.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_receivables];
        
        
    }
    
    return self;
}

/*下载logo*/
- (void)imageWitwURL:(NSString *)url
{
    NSLog(@"imageData = %@",url);
    
    if (![url isEqualToString:@""])
    {
        if (!_logoView.image)
        {
            if (!loadImage)
            {
                loadImage = YES;
                
                //下载图片
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    //图片数据
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url]]];
                    //logo图片
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _logoView.image = image;
                    });
                });
            }
        }
    }
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











