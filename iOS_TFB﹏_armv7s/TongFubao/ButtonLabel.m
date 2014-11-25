//
//  ButtonLabel.m
//  TongFubao
//
//  Created by Delpan on 14-8-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ButtonLabel.h"

@implementation ButtonLabel

@synthesize selectBtn = _selectBtn;
@synthesize titleLabel = _titleLabel;

- (id)initWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag
{
    if (self = [super init])
    {
        self.frame = frame;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *unSelectedImage = imageName(@"unSelected@2x", @"png");
        UIImage *seletedImage = imageName(@"selected@2x", @"png");
        
        _selectBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 30, 30) unSelectImage:unSelectedImage selectImage:seletedImage tag:tag titleColor:nil title:nil];
        [self addSubview:_selectBtn];
        
        _titleLabel = [UILabel labelWithFrame:CGRectMake(40, 0, 260, 30) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] text:title font:[UIFont systemFontOfSize:15.0]];
        [self addSubview:_titleLabel];
    }
    
    return self;
}


@end





