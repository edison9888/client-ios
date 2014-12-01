//
//  PlaneCompanyView.m
//  TongFubao
//
//  Created by Delpan on 14-7-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PlaneCompanyView.h"

@implementation PlaneCompanyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //生成航空公司按扭
        [self createPlaneCompanyButtonWithFrame:frame];
        
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    }
    
    return self;
}

- (void)createPlaneCompanyButtonWithFrame:(CGRect)frame
{
    for (int i = 0; i < 8; i++)
    {
        //航空公司按扭
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 55 * i, frame.size.width, 45);
        btn.opaque = YES;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //航空公司图标
        UIImageView *planeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
        planeImageView.backgroundColor = [UIColor whiteColor];
        planeImageView.opaque = YES;
        [btn addSubview:planeImageView];
        
        //航空公司名称
        UILabel *planeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, frame.size.width - 40, 20)];
        planeNameLabel.backgroundColor = [UIColor clearColor];
        planeNameLabel.opaque = YES;
        planeNameLabel.textColor = [UIColor grayColor];
        planeNameLabel.textAlignment = NSTextAlignmentLeft;
        planeNameLabel.font = [UIFont systemFontOfSize:20.0];
        planeNameLabel.text = @"航空公司";
        [btn addSubview:planeNameLabel];
    }
}

- (void)btnAction:(UIButton *)sender
{
    
}

@end














