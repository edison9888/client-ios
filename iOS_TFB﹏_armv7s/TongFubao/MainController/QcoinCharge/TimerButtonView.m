//
//  TimerButtonView.m
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TimerButtonView.h"
#import "watchTimeObject.h"

@implementation TimerButtonView
{
    int TimeMaxMin;
    NSMutableArray *_timeArray;
}
@synthesize dateString,nowTimeString;
- (id)initWithFrame:(CGRect)frame  wacthTime:(NSString *)newWacthTime shijianca:(NSInteger)newshijianca
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeArray = [[NSMutableArray alloc]init];
        TimeMaxMin = newshijianca;
        self.backgroundColor = RGBACOLOR(255, 255, 255, 255);
        self.dateString = newWacthTime;
//        NSLog(@"====_dateString====%@",self.dateString);
        // 比较时间获取现在时间或对比时间
        self.nowTimeString = [[watchTimeObject changeTime] stringByReplacingOccurrencesOfString :@"-" withString:@""];

        NSArray *titleArray = @[@"前一天",self.dateString,@"后一天"];
        for (int i = 0; i < 3; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.backgroundColor  = RGBACOLOR(200, 200, 200, 200);
            [button setTitle:[titleArray objectAtIndex:i] forState:(UIControlStateNormal)];
            if (button.tag == 0)
            {
                [button setImage:[UIImage imageNamed:@"Citybefore@2x.png"] forState:(UIControlStateNormal)];
                [button setImageEdgeInsets:(UIEdgeInsetsMake(0, 3, 0, 50))];
                button.frame = CGRectMake(0, 0, 90, 45);
            }
            else if (button.tag == 1)
            {
                button.frame = CGRectMake(91, 0, 138, 45);
            }
            else if (button.tag == 2)
            {
                [button setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
                [button setImage:[UIImage imageNamed:@"Citynday@2x.png"] forState:(UIControlStateNormal)];
                [button setImageEdgeInsets:(UIEdgeInsetsMake(0, 70, 0, 3))];
                button.frame = CGRectMake(230, 0, 90, 45);
            }
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_timeArray addObject:button];
            [self addSubview:button];
        }
    }
    return self;
}

/*时间单往返互换*/
-(void)selectionDateTime:(NSString *)newDateTime goTime:(NSString *)newGoTime  shijianca:(NSInteger)newshijianca
{
    // 选择的时间
    self.dateString = newDateTime;
//    NSLog(@"======dateString====%@",self.dateString);

    self.nowTimeString = [newGoTime stringByReplacingOccurrencesOfString :@"-" withString:@""];
//    NSLog(@"======nowTimeString====%@",self.nowTimeString);

    UIButton *button = [_timeArray objectAtIndex:1];
    [button setTitle:self.dateString forState:(UIControlStateNormal)];
    TimeMaxMin = newshijianca;


}

-(void)buttonClick:(UIButton *)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    if (senderButton.tag == 0)
    {
        NSString * selectionTime = [self.dateString stringByReplacingOccurrencesOfString :@"-" withString:@""];
        if ([selectionTime integerValue] > [self.nowTimeString integerValue])
        {
            TimeMaxMin--;
//            NSLog(@"===时间变量＋＋－－==%d",TimeMaxMin);
            self.dateString = [watchTimeObject returnaddTime:self.dateString number:TimeMaxMin];
            UIButton *button = [_timeArray objectAtIndex:1];
            [button setTitle:self.dateString forState:(UIControlStateNormal)];
            [self.delegate returnDate:self.dateString];
        }
    }
    else if (senderButton.tag == 1)
    {
        
    }
    else if (senderButton.tag == 2)
    {
        TimeMaxMin ++;
//        NSLog(@"===222=%d",TimeMaxMin);
//        NSLog(@"====_dateString====%@",self.dateString);
        self.dateString = [watchTimeObject returnaddTime:self.dateString number:TimeMaxMin];
        UIButton *button = [_timeArray objectAtIndex:1];
        [button setTitle:self.dateString forState:(UIControlStateNormal)];
        [self.delegate returnDate:self.dateString];
        
    }
}

@end


