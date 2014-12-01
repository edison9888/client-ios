//
//  NLInOutcomeDetailHeaderCell.m
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLInOutcomeDetailHeaderCell.h"

@interface NLInOutcomeDetailHeaderCell ()

- (IBAction)onArrowBtnClicked:(id)sender;

@end

@implementation NLInOutcomeDetailHeaderCell

@synthesize myArrowBtn;
@synthesize myContainer;
@synthesize myIncomeLabel;
@synthesize myMonthLabel;
@synthesize myOutcomeLabel;
@synthesize myDownArrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.myDownArrow = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onArrowBtnClicked:(id)sender
{
    if ([self.myContainer respondsToSelector:@selector(doArrowBtnEvent:)])
    {
        [self.myContainer performSelector:@selector(doArrowBtnEvent:) withObject:self];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(doRotation:) userInfo:nil repeats:NO];
}

-(void)doRotation:(NSTimer *)timer
{
    [UIView beginAnimations:nil context:nil];
    [timer invalidate];
    if (self.myDownArrow)
    {
        self.myArrowBtn.transform = CGAffineTransformMakeRotation(0);
    }
    else
    {
        self.myArrowBtn.transform = CGAffineTransformMakeRotation(1.57);
    }
    self.myDownArrow = !self.myDownArrow;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.25f];
    [UIView commitAnimations];
}

@end
