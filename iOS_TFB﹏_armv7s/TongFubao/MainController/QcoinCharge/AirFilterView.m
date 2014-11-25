//
//  AirFilterView.m
//  TongFubao
//
//  Created by kin on 14-8-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AirFilterView.h"

@implementation AirFilterView
{
    UILabel *_backLable;
    NSMutableArray *_buttonArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = RGBACOLOR(230, 230, 230, 1);
        _buttonArray = [[NSMutableArray alloc]init];
        _backLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 45)];
        _backLable.backgroundColor = RGBACOLOR(100, 100, 100, 1);
        _backLable.hidden = YES;
        [self addSubview:_backLable];
        
        NSArray *array = @[@"分类筛选",@"航空公司"];
        for (int i = 0; i < 2; i++)
        {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(320/2*i,0, 320/2, 45);
            [button setTitle:[array objectAtIndex:i] forState:(UIControlStateNormal)];
            button.tag = i;
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            if (button.tag == 0)
            {
                [button setImageEdgeInsets:(UIEdgeInsetsMake(10, 30, 10, 105))];
                [button setImage:[UIImage imageNamed:@"Cityselecti@2x.png"] forState:(UIControlStateNormal)];
            }
            if (button.tag == 1)
            {
                [button setImageEdgeInsets:(UIEdgeInsetsMake(10, 30, 10, 105))];
                [button setImage:[UIImage imageNamed:@"Citycompan@2x.png"] forState:(UIControlStateNormal)];
            }
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(clik:) forControlEvents:(UIControlEventTouchUpInside)];
            [_buttonArray addObject:button];
            [self addSubview:button];
        }
    }
    return self;
}
-(void)clik:(UIButton *)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"===%d",senderButton.tag);
    [senderButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    if (senderButton.tag == 0)
    {
        [senderButton setImage:[UIImage imageNamed:@"Cityselection_sele@2x.png"] forState:(UIControlStateNormal)];
        UIButton *button1 = [_buttonArray objectAtIndex:1];
        [button1 setImage:[UIImage imageNamed:@"Citycompan@2x.png"] forState:(UIControlStateNormal)];
        [button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _backLable.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _backLable.frame = CGRectMake(0, 0, 160, 45);
        }];
        
    }
    else if (senderButton.tag == 1)
    {
        [senderButton setImage:[UIImage imageNamed:@"Citycompany_selected@2x.png"] forState:(UIControlStateNormal)];
        UIButton *button2 = [_buttonArray objectAtIndex:0];
        [button2 setImage:[UIImage imageNamed:@"Cityselecti@2x.png"] forState:(UIControlStateNormal)];
        [button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _backLable.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _backLable.frame = CGRectMake(160, 0, 160, 45);
        }];
    }
    [self.delegate moveLeftRightView:senderButton.tag];
}
-(void)backLableMove
{
    UIButton *button1 = [_buttonArray objectAtIndex:0];
    [button1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    if (button1.tag == 0)
    {
        [button1 setImage:[UIImage imageNamed:@"Cityselection_sele@2x.png"] forState:(UIControlStateNormal)];
        UIButton *button1 = [_buttonArray objectAtIndex:1];
        [button1 setImage:[UIImage imageNamed:@"Citycompan@2x.png"] forState:(UIControlStateNormal)];
        [button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _backLable.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _backLable.frame = CGRectMake(0, 0, 160, 45);
        }];
        
    }
    
}
-(void)leftBackLableMove
{
    UIButton *button1 = [_buttonArray objectAtIndex:1];
    [button1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

     if (button1.tag == 1)
    {
        [button1 setImage:[UIImage imageNamed:@"Citycompany_selected@2x.png"] forState:(UIControlStateNormal)];
        UIButton *button1 = [_buttonArray objectAtIndex:0];
        [button1 setImage:[UIImage imageNamed:@"Cityselecti@2x.png"] forState:(UIControlStateNormal)];
        [button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _backLable.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _backLable.frame = CGRectMake(160, 0, 160, 45);
        }];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end



































