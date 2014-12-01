//
//  HotelHostCell.m
//  TongFubao
//
//  Created by Delpan on 14-8-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelHostCell.h"

@implementation HotelHostCell

@synthesize logoView = _logoView;
@synthesize titleLabel = _titleLabel;
@synthesize infoLabel = _infoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.backgroundView.frame];
        imageView.image = imageName(@"input_fieldside@2x", @"png");
        self.backgroundView = imageView;
        
        //logo
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        _logoView.opaque = YES;
        _logoView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_logoView];
        
        //标题
        _titleLabel = [UILabel labelWithFrame:CGRectMake(35, 10, 80, 20)
                              backgroundColor:[UIColor clearColor]
                                    textColor:RGBACOLOR(153, 153, 153, 1.0)
                                         text:nil
                                         font:[UIFont systemFontOfSize:15.0]];
        [self.contentView addSubview:_titleLabel];
        
        //信息
        _infoLabel = [UILabel labelWithFrame:CGRectMake(115, 10, 150, 20)
                             backgroundColor:[UIColor clearColor]
                                   textColor:RGBACOLOR(153, 153, 153, 1.0)
                                        text:nil
                                        font:[UIFont systemFontOfSize:15.0]];
        _infoLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_infoLabel];
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
















