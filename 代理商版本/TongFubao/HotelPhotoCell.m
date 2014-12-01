//
//  HotelPhotoCell.m
//  TongFubao
//
//  Created by Delpan on 14-9-2.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelPhotoCell.h"

@implementation HotelPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        for (int i = 0; i < 3; i++)
        {
            photoBtn[i] = [UIButton buttonWithFrame:CGRectMake(10 + (10 + 280 / 3.0) * i, 10, 280 / 3.0, 280 / 4.0)
                                      unSelectImage:nil
                                        selectImage:nil
                                                tag:3501 + i
                                         titleColor:nil
                                              title:nil];
            [photoBtn[i] addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:photoBtn[i]];
        }
        
        _firstBtn = photoBtn[0];
        _secondBtn = photoBtn[1];
        _thirdBtn = photoBtn[2];
    }
    
    return self;
}

#pragma mark - 查看酒店相片触发
- (void)photoBtnAction:(UIButton *)sender
{
    self.photoBlock(sender);
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
