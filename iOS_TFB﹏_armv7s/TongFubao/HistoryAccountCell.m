//
//  HistoryAccountCell.m
//  TongFubao
//
//  Created by Delpan on 14-9-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HistoryAccountCell.h"

@implementation HistoryAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        loadImage = NO;
        
        //logo
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        _logoView.opaque = YES;
        [self.contentView addSubview:_logoView];
        
        //卡信息
        _infoLabel = [UILabel labelWithFrame:CGRectMake(55, 14, 245, 20)
                             backgroundColor:[UIColor clearColor]
                                   textColor:[UIColor blackColor]
                                        text:nil
                                        font:[UIFont systemFontOfSize:16.0]];
        [self.contentView addSubview:_infoLabel];
    }
    
    return self;
}

//下载logo
- (void)imageWitwURL:(NSString *)url
{
    if (![url isEqualToString:@""])
    {
        if (!_logoView.image)
        {
            if (!loadImage)
            {
                loadImage = YES;
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                    image = [[UIImage alloc] initWithData:imageData];
                    
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











