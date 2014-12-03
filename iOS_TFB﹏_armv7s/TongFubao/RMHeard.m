//
//  RMHeard.m
//  RMSwipeTableViewCelliOS7UIDemo
//
//  Created by  俊   on 14-12-1.
//  Copyright (c) 2014年 The App Boutique. All rights reserved.
//

#import "RMHeard.h"
#import "BlockUI.h"

#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

@implementation RMHeard
@synthesize backBtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [self viewMainBtn];
    }
    return self;
}

-(void)viewMainBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:button];
    button.backgroundColor= RGBACOLOR(21, 205, 204, 1.0);
    button.frame = CGRectMake(0, 0, 320, 45);
    [button setTitle:@"2014-11" forState:UIControlStateNormal];
    backBtn= button;
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:sender:)])
        {
            [_delegate selectedWith:self sender:sender];
        }
    }];
}

@end
