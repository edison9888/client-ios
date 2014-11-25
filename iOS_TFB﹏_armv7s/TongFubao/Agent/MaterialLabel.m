//
//  MaterialLabel.m
//  TongFubao
//
//  Created by Delpan on 14-7-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "MaterialLabel.h"

@implementation MaterialLabel

@synthesize imageBtn = _imageBtn;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:20.0];
        
        [self createButton];
    }
    
    return self;
}

- (void)createButton
{
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageBtn.opaque = YES;
    _imageBtn.frame = CGRectMake(200, 0, 35, 35);
    [self addSubview:_imageBtn];
}

@end








