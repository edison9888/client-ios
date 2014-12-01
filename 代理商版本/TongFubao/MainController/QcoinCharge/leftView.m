//
//  leftView.m
//  TongFubao
//
//  Created by kin on 14-8-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "leftView.h"

@implementation leftView
@synthesize buttonArray,priceTimeArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.buttonArray = [[NSMutableArray alloc]init];
        self.priceTimeArray = [[NSMutableArray alloc]init];

        
        self.backgroundColor = RGBACOLOR(19, 193, 245, 1);
        NSArray *nameLabel = @[@" 时段",@"早上(6点－12点)",@"下午(12点－18点)",@"晚上(18点－24点)",@" 排序",@"时间从早到晚",@"时间从晚到早",@"价格从高到低",@"价格从低到高",];
        for (int i = 0; i < 9; i++)
        {
            UILabel *selectionLabel = [[UILabel alloc]init];
            selectionLabel.tag = i;
            selectionLabel.backgroundColor = RGBACOLOR(19, 193, 245, 1);
            if (i == 0 || i == 4)
            {
                selectionLabel.frame = CGRectMake(0,(self.frame.size.height/9)*i , 160, self.frame.size.height/9);
                selectionLabel.backgroundColor =  RGBACOLOR(165, 238, 255, 1);
            }
            else
            {
                selectionLabel.backgroundColor = [UIColor clearColor];
                selectionLabel.font = [UIFont systemFontOfSize:15];
                selectionLabel.frame = CGRectMake(40,(self.frame.size.height/9)*i , 130, self.frame.size.height/9);
            }
            selectionLabel.textColor = [UIColor whiteColor];
            selectionLabel.text = [nameLabel objectAtIndex:i];
            [self addSubview:selectionLabel];
        }
        // 时间段
        for (int j = 0; j < 3; j++)
        {
            UIButton * selecButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [selecButton setImage:[UIImage imageNamed:@"Cityclick_frame@2x.png"] forState:(UIControlStateNormal)];
            selecButton.tag =j;
                selecButton.frame = CGRectMake(1,  self.frame.size.height/9+self.frame.size.height/9*j+2,  self.frame.size.height/10-4,  self.frame.size.height/10-4);
            selecButton.tag = j;
            selecButton.selected = YES;
            [selecButton addTarget:self action:@selector(selectionButton:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.buttonArray addObject:selecButton];
            [self addSubview:selecButton];
        }
        // 时间，价格
        for (int j = 3; j < 7; j++)
        {
            UIButton * selecButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [selecButton setImage:[UIImage imageNamed:@"Cityclick_frame@2x.png"] forState:(UIControlStateNormal)];
            selecButton.tag =j;
            selecButton.frame = CGRectMake(1,  self.frame.size.height/9*(2+j)+2,  self.frame.size.height/10-4,  self.frame.size.height/10-4);
            selecButton.tag = j;
            selecButton.selected = YES;
            [selecButton addTarget:self action:@selector(TimeButton:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.priceTimeArray addObject:selecButton];
            [self addSubview:selecButton];
        }
    }
    return self;
}
// 时间段
-(void)selectionButton:(UIButton *)sender
{
    UIButton *senderBut = (UIButton *)sender;
    
    for (int i = 0; i < 3; i++)
    {
        if (senderBut.tag == 0)
        {
            if (i != 0)
            {
                [self buttonSty:i infoButtonArray:self.buttonArray];
            }
        }
        else if (senderBut.tag == 1)
        {
            if (i != 1)
            {
                [self buttonSty:i infoButtonArray:self.buttonArray];
            }
        }
        else if (senderBut.tag == 2)
        {
            if (i != 2)
            {
                [self buttonSty:i infoButtonArray:self.buttonArray];
            }
        }
    }
    [self buttonObject:(UIButton *)sender];
    
}
// 时间
-(void)TimeButton:(UIButton *)sender
{
    UIButton *senderBut = (UIButton *)sender;
    for (int i = 0; i < 4; i++)
    {
        if (senderBut.tag == 3)
        {
            if (i != 0)
            {
                [self buttonSty:i infoButtonArray:self.priceTimeArray];
            }
        }
        else  if (senderBut.tag == 4)
        {
            if (i != 1)
            {
                [self buttonSty:i infoButtonArray:self.priceTimeArray];
            }
        }
        else if (senderBut.tag == 5)
        {
            if (i != 2)
            {
                [self buttonSty:i infoButtonArray:self.priceTimeArray];
            }
        }
        else if (senderBut.tag == 6)
        {
            if (i != 3)
            {
                [self buttonSty:i infoButtonArray:self.priceTimeArray];
            }
        }
    }
    [self buttonObject:(UIButton *)sender];
}

-(void)buttonSty:(int)number infoButtonArray:(NSMutableArray*)newinfoButtonArray
{
    UIButton *senderButton0 = [newinfoButtonArray objectAtIndex:number];
    [senderButton0 setImage:[UIImage imageNamed:@"Cityclick_frame@2x.png"] forState:(UIControlStateNormal)];
    senderButton0.selected = YES;
}

-(void)buttonObject:(UIButton *)sender
{
    if (sender.selected == YES)
    {
        [sender setImage:[UIImage imageNamed:@"9@2x.png"] forState:(UIControlStateNormal)];
        sender.selected = NO;
        [self.delegate SelectButtonAction:sender];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"Cityclick_frame@2x.png"] forState:(UIControlStateNormal)];
        sender.selected = YES;
        [self.delegate DonChooseButtonEvents:sender];
    }
}
// 所有的按钮还原
-(void)ButtontToRecover
{
    [self.buttonArray removeAllObjects];
    [self.priceTimeArray removeAllObjects];
    

    for (UIButton *button in [self subviews])
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button removeFromSuperview];
        }
    }
    [self.buttonArray removeAllObjects];
    [self.priceTimeArray removeAllObjects];
    
    // 时间段
    for (int j = 0; j < 3; j++)
    {
        UIButton * selecButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [selecButton setImage:[UIImage imageNamed:@"Cityclick_frame@2x.png"] forState:(UIControlStateNormal)];
        selecButton.tag =j;
        selecButton.frame = CGRectMake(1,  self.frame.size.height/9+self.frame.size.height/9*j+2,  self.frame.size.height/10-4,  self.frame.size.height/10-4);
        selecButton.tag = j;
        selecButton.selected = YES;
        [selecButton addTarget:self action:@selector(selectionButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.buttonArray addObject:selecButton];
        [self addSubview:selecButton];
    }
    // 时间
    for (int j = 3; j < 7; j++)
    {
        UIButton * selecButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [selecButton setImage:[UIImage imageNamed:@"Cityclick_frame@2x.png"] forState:(UIControlStateNormal)];
        selecButton.tag =j;
        selecButton.frame = CGRectMake(1,  self.frame.size.height/9*(2+j)+2,  self.frame.size.height/10-4,  self.frame.size.height/10-4);
        selecButton.tag = j;
        selecButton.selected = YES;
        [selecButton addTarget:self action:@selector(TimeButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.priceTimeArray addObject:selecButton];
        [self addSubview:selecButton];
    }

}
//
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end























