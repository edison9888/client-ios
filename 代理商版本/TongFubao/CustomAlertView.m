//
//  CustomAlertView.m
//  TongFubao
//
//  Created by Delpan on 14-8-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

@synthesize infoText = _infoText;

- (id)initWithframe:(CGRect)frame title:(NSString *)title delegate:(id <CustomAlertViewDelegate>)customDelegate firstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle
{
    if (self = [super init])
    {
        self.customAlertViewDelegate = customDelegate;
        self.frame = frame;
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 15.0;
        
        //提示
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(10, 10, 240, 40) backgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] text:title font:[UIFont systemFontOfSize:17.0]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        //信息输入框
        _infoText = [UITextField textWithFrame:CGRectMake(20, 60, 220, 40) placeholder:nil];
        _infoText.background = imageName(@"input_fieldside@2x", @"png");
        [self addSubview:_infoText];
        
        //左按钮
        leftBtn = [UIButton buttonWithFrame:CGRectMake(10, 110, 120, 35) unSelectImage:nil selectImage:nil tag:100001 titleColor:[UIColor whiteColor] title:firstTitle];
        [leftBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        rightBtn = [UIButton buttonWithFrame:CGRectMake(130, 110, 120, 35) unSelectImage:nil selectImage:nil tag:100002 titleColor:[UIColor whiteColor] title:secondTitle];
        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
    }
    
    return self;
}

- (void)buttonAction:(UIButton *)sender
{
    [self.customAlertViewDelegate customAlertViewTouch:sender.tag - 100000];
    
    [self removeFromSuperview];
}

@end












