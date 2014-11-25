//
//  BossPayMoneyCell.m
//  TongFubao
//
//  Created by  俊   on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BossPayMoneyCell.h"

@implementation BossPayMoneyCell

- (void)awakeFromNib
{
    // Initialization code
}
- (IBAction)btnSelectAction:(id)sender {
    
    [self performSelector:@selector(delCell:) withObject:nil afterDelay:0.1];
    
    /*不用
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(doRotation:) userInfo:nil repeats:NO];*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)doRotation:(NSTimer *)timer
{
    /* 动画效果*/
    [UIView beginAnimations:nil context:nil];
    [timer invalidate];
    if (self.myDownArrow)
    {
        self.btnSelect.transform = CGAffineTransformMakeRotation(0);
    }
    else
    {
        self.btnSelect.transform = CGAffineTransformMakeRotation(1.57);
    }
    self.myDownArrow = !self.myDownArrow;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.25f];
    [UIView commitAnimations];
    
}

/*代理删除*/
-(void)delCell:(BossPayMoneyCell*)cell
{
    if (self.BossPayMoneyCellDelegate&&[self.BossPayMoneyCellDelegate respondsToSelector:@selector(delCell:)]) {
        [self.BossPayMoneyCellDelegate delCell:self];
    }
}


@end
