//
//  ButtonView.m
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView
@synthesize _cellButton;

- (id)initWithFrame:(CGRect)frame buttonTag:(NSInteger)newTag buttonTitle:(NSString *)newTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cellButton.frame = self.frame;
        _cellButton.tag  = newTag;
        if (_cellButton.tag == 0)
        {
            _cellButton.backgroundColor = RGBACOLOR(19, 193, 245, 1);
        }
        else
        {
            _cellButton.backgroundColor =  RGBACOLOR(200, 200, 200, 1);
        }
        _cellButton.selected = YES;
        [_cellButton setTitle:newTitle forState:(UIControlStateNormal)];
        [_cellButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 250))];
        [_cellButton addTarget:self action:@selector(clikButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_cellButton];
    }
    return self;
}
static NSInteger clickNumber = 0;
static NSInteger clickOneNumber = 1;


-(void)clikButton:(UIButton *)sender
{
    UIButton *senderButton = (UIButton *)sender;
    if (senderButton.selected == YES)
    {
        if (senderButton.tag == 0 )
        {
//            senderButton.backgroundColor = RGBACOLOR(165, 238, 255, 1);
            senderButton.backgroundColor = RGBACOLOR(200, 200, 200, 1);
            [self.delegate shouCell:senderButton];
            clickNumber = 1;

        }
        else
        {
            if (senderButton.tag == 1)
            {
                clickOneNumber = 1;
            }
            senderButton.backgroundColor = RGBACOLOR(19, 193, 245, 1);
            [self.delegate changeVuleCellSetype:senderButton];

        }
        senderButton.selected = NO;

    }
    else
    {
        if (senderButton.tag  == 0  )
        {
            senderButton.backgroundColor = RGBACOLOR(19, 193, 245, 1);
            [self.delegate changeVuleCellSetype:senderButton];
            clickNumber = 0;
        }
        else
        {
            if (senderButton.tag == 1)
            {
                clickOneNumber = 0;
            }

            senderButton.backgroundColor = RGBACOLOR(200, 200, 200, 1);
            [self.delegate shouCell:senderButton];
        }
        senderButton.selected = YES;
    }
}
-(void)ChangingStateButton
{
    if (_cellButton.tag == 1)
    {
        _cellButton.backgroundColor = RGBACOLOR(19, 193, 245, 1);
        _cellButton.selected = NO;
    }
}
-(void)ChangingIndexStateButton:(UIButton *)Sender
{
    if (Sender.tag == 0)
    {
        if (clickNumber == 0)
        {
            Sender.backgroundColor =  RGBACOLOR(200, 200, 200, 1);
            [self.delegate shouCell:Sender];
            _cellButton.selected = NO;
        }
        clickNumber++;
    }

      else  if (Sender.tag == 1)
       {
           if (clickOneNumber != 0)
           {
               Sender.backgroundColor =  RGBACOLOR(200, 200, 200, 1);
               [self.delegate shouCell:Sender];
               _cellButton.selected = NO;
           }
           clickOneNumber++;
       }
}

+(void)pushStateButton
{
    clickNumber = 0;
    clickOneNumber = 1;
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
















