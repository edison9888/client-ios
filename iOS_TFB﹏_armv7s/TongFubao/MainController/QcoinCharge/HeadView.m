//
//  HeadView.m
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

@synthesize delegate = _delegate;
@synthesize section,backBtn;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self viewMainBtn];
    }
    return self;
}

-(void)viewMainBtn
{
    flag = YES;
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 320, 45);
    [btn addTarget:self action:@selector(doSelected:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(203, 205, 204, 1.0) rect:CGRectMake(0, 0, 420, 45.5)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(0, 162, 226, 1) rect:CGRectMake(0, 0, 420, 45.5)] forState:UIControlStateSelected];
    self.backBtn = btn;
    
    self.titleLabel = [UILabel labelWithFrame:CGRectMake(15, 10, 300, 25.5) backgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] text:nil font:[UIFont systemFontOfSize:18.0]];
    [self.backBtn addSubview:self.titleLabel];
    [self addSubview:btn];
    
    _backImg= [[UIImageView alloc]initWithFrame:CGRectMake(280, 7.5, 30, 30)];
    _backImg.image=  [UIImage imageNamed: @"chosenside.png"];
    [self.backBtn addSubview:_backImg];
}

-(void)doSelected:(UIButton*)sender
{
    if (_typeflag==YES) {
        /*签收工资*/
        if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:sender:)])
        {
            [_delegate selectedWith:self sender:sender];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)])
    {
        if (flag) {
            [UIView animateWithDuration:0.5 animations:^{
                _backImg.transform = CGAffineTransformMakeRotation(-M_PI_2);
            } completion:^(BOOL finished) {
                flag = NO;
            }];
        }
        else {
            [UIView animateWithDuration:0.5 animations:^{
                _backImg.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                flag = YES;
            }];
        }
        
        [_delegate selectedWith:self];
    }
    //    [self setImage];
}

@end








