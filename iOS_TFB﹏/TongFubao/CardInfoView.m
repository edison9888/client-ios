//
//  CardInfoView.m
//  TongFubao
//
//  Created by Delpan on 14-8-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "CardInfoView.h"

@implementation CardInfoView

@synthesize infoLabel = _infoLabel;
@synthesize infoText = _infoText;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.image = imageName(@"input_and_choose@2x", @"png");
        
        //信息名称
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        _infoLabel.opaque = YES;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.textColor = [UIColor grayColor];
        _infoLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_infoLabel];
        
        //输入信息
        _infoText = [[UITextField alloc] initWithFrame:CGRectMake(95, 0, 205, 40)];
        _infoText.opaque = YES;
        _infoText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_infoText];
    }
    
    return self;
}



@end














