//
//  SortView.m
//  TongFubao
//
//  Created by Delpan on 14-7-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SortView.h"

@implementation SortView

@synthesize sortViewDelegate = _sortViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //生成按扭
        [self createButtonWithFrame:frame];
        
        //生成功能标题
        [self createTitlesWithFrame:frame];
        
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    }
    
    return self;
}

//生成按扭
- (void)createButtonWithFrame:(CGRect)frame
{
    NSArray *titles = @[ @"早上(6点-12点)", @"下午(12点-18点)", @"晚上(18点-24点)", @"只显示大型机", @"时间从早到晚", @"时间从晚到早", @"价格从高到低", @"价格从低到高" ];
    
    UIImage *normalImage = imageName(@"unSelected@2x", @"png");
    UIImage *selectImage = imageName(@"selected@2x", @"png");
    
    for (int i = 0, j = 0; i < 8; i++)
    {
        CGRect rect;
        
        if (i < 3)
        {
            rect = CGRectMake(5, 50 + 40 * i, 20, 20);
        }
        else if (i == 3)
        {
            rect = CGRectMake(5, 215, 20, 20);
        }
        else if (i >3)
        {
            rect = CGRectMake(5, 300 + j * 40, 20, 20);
            j++;
        }
        
        //选择按扭
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1001 + i;
        btn.frame = rect;
        btn.opaque = YES;
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:selectImage forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //功能Label
        UILabel *btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, rect.origin.y - 5, frame.size.width - 30, 40)];
        btnLabel.backgroundColor = [UIColor clearColor];
        btnLabel.textColor = [UIColor grayColor];
        btnLabel.opaque = YES;
        btnLabel.textAlignment = NSTextAlignmentLeft;
        btnLabel.font = [UIFont systemFontOfSize:17.0];
        btnLabel.text = titles[i];
        [self addSubview:btnLabel];
    }
}

//功能按扭触发
- (void)btnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [_sortViewDelegate sortViewDidTouch:sender];
}

//生成功能标题
- (void)createTitlesWithFrame:(CGRect)frame
{
    //时段
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 45)];
    timeLabel.backgroundColor = [UIColor orangeColor];
    timeLabel.opaque = YES;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:20.0];
    timeLabel.text = @"时段";
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:timeLabel];
    
    //机型
    UILabel *planeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, frame.size.width, 45)];
    planeLabel.backgroundColor = [UIColor orangeColor];
    planeLabel.opaque = YES;
    planeLabel.textColor = [UIColor whiteColor];
    planeLabel.font = [UIFont systemFontOfSize:20.0];
    planeLabel.text = @"机型";
    planeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:planeLabel];
    
    //排序
    UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, frame.size.width, 45)];
    sortLabel.backgroundColor = [UIColor orangeColor];
    sortLabel.opaque = YES;
    sortLabel.textColor = [UIColor whiteColor];
    sortLabel.font = [UIFont systemFontOfSize:20.0];
    sortLabel.text = @"排序";
    sortLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:sortLabel];
}

@end
















