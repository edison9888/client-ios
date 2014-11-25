//
//  ReturnPlayView.m
//  TongFubao
//
//  Created by kin on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ReturnPlayView.h"

@implementation ReturnPlayView

- (id)initWithFrame:(CGRect)frame firstSecondArray:(NSArray *)newfirstSecondArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // 底线条
        UIImageView *infoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 190, 300, 40)];
        infoImage.userInteractionEnabled = YES;
        infoImage.image = [[UIImage imageNamed:@"BG2lightblue@2x.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(0, 0, 18, 0)) resizingMode:UIImageResizingModeStretch];
        [self addSubview:infoImage];
        
        // 顶图
        UIImageView *timeImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 300, 200)];
        timeImage.userInteractionEnabled = YES;
        timeImage.image = [[UIImage imageNamed:@"BG2blue@2x.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(300, 0, 0, 0)) resizingMode:UIImageResizingModeStretch];
        timeImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:timeImage];
        
        NSArray *fromCity = @[[newfirstSecondArray objectAtIndex:0],[newfirstSecondArray objectAtIndex:1],[newfirstSecondArray objectAtIndex:8],[newfirstSecondArray objectAtIndex:4],[newfirstSecondArray objectAtIndex:7],[newfirstSecondArray objectAtIndex:10]];
        for (int i = 0 ; i < 6 ; i++)
        {
            UILabel *playLabel = [[UILabel alloc]init];
            playLabel.tag = i;
            
            if (playLabel.tag < 3)
            {
                playLabel.frame = CGRectMake(10, 10+20*i, 90, 20);
                playLabel.text = [fromCity objectAtIndex:i];
                if (playLabel.tag == 1)
                {
                    playLabel.font = [UIFont systemFontOfSize:26];
                }
                else
                {
                    playLabel.font = [UIFont systemFontOfSize:13];
                }
            }
            if (playLabel.tag >2)
            {
                playLabel.frame = CGRectMake(10, 30+i*20, 90, 20);
                playLabel.text = [fromCity objectAtIndex:i];
                if (playLabel.tag == 4)
                {
                    playLabel.font = [UIFont systemFontOfSize:28];
                }
                else
                {
                    playLabel.font = [UIFont systemFontOfSize:13];
                }
            }
            playLabel.textAlignment = NSTextAlignmentCenter;
            playLabel.textColor = [UIColor whiteColor];
            [timeImage addSubview:playLabel];
        }
        
        NSArray *toCity = @[[newfirstSecondArray objectAtIndex:2],[newfirstSecondArray objectAtIndex:3],[newfirstSecondArray objectAtIndex:9],[newfirstSecondArray objectAtIndex:6],[newfirstSecondArray objectAtIndex:5],[newfirstSecondArray objectAtIndex:11]];
        for (int i = 0 ; i < 6 ; i++)
        {
            UILabel *playLabel = [[UILabel alloc]init];
            playLabel.tag = i;
            
            if (playLabel.tag < 3)
            {
                playLabel.frame = CGRectMake(210, 10+20*i, 90, 20);
                playLabel.text = [toCity objectAtIndex:i];
                if (playLabel.tag == 1)
                {
                    playLabel.font = [UIFont systemFontOfSize:26];
                }
                else
                {
                    playLabel.font = [UIFont systemFontOfSize:13];
                }
            }
            if (playLabel.tag >2)
            {
                playLabel.frame = CGRectMake(210, 30+i*20, 90, 20);
                playLabel.text = [toCity objectAtIndex:i];
                if (playLabel.tag == 4)
                {
                    playLabel.font = [UIFont systemFontOfSize:28];
                }
                else
                {
                    playLabel.font = [UIFont systemFontOfSize:13];
                }
            }
            playLabel.textAlignment = NSTextAlignmentCenter;
            playLabel.textColor = [UIColor whiteColor];
            [timeImage addSubview:playLabel];
        }
        // 箭头图
        UIImageView *fromImage = [[UIImageView alloc]initWithFrame:CGRectMake(110, 40, 80, 30)];
        fromImage.userInteractionEnabled = YES;
        fromImage.image = [UIImage imageNamed:@"arrow@2x.png"];
        fromImage.contentMode = UIViewContentModeScaleToFill;
        [timeImage addSubview:fromImage];
        // 箭头图
        UIImageView *toImage = [[UIImageView alloc]initWithFrame:CGRectMake(110, 90, 80, 30)];
        toImage.userInteractionEnabled = YES;
        toImage.image = [UIImage imageNamed:@"arrow2@2x.png"];
        toImage.contentMode = UIViewContentModeScaleToFill;
        [timeImage addSubview:toImage];
        
        NSArray *addArray = @[[newfirstSecondArray objectAtIndex:12],[newfirstSecondArray objectAtIndex:13]];
        for (int i = 0 ; i < 2; i++)
        {
            UILabel *fromToLabel = [[UILabel alloc]init];
            fromToLabel.text = [addArray objectAtIndex:i];
            fromToLabel.backgroundColor = [UIColor clearColor];
            fromToLabel.textColor = [UIColor whiteColor];
            fromToLabel.frame = CGRectMake(100+70*i, 65, 40, 30);
            [timeImage addSubview:fromToLabel];
        }
        
        // 线
        for (int i = 0; i < 2 ; i++)
        {
            UIImageView *backeimage =[[UIImageView alloc]init];
            backeimage.image = [UIImage imageNamed:@"shortdottedline@2x.png"];
            backeimage.frame = CGRectMake(10+200*i, 80, 80, 1);
            [timeImage addSubview:backeimage];
        }
        for (int i = 0; i < 2 ; i++)
        {
            UIImageView *backeimage =[[UIImageView alloc]init];
            backeimage.image = [UIImage imageNamed:@"v_short_dotted_line@2x.png"];
            backeimage.frame = CGRectMake(150, 5+i*120, 1, 30);
            [timeImage addSubview:backeimage];
        }
        
        
        NSArray *fromInfo = @[@"去程",[newfirstSecondArray objectAtIndex:14],[newfirstSecondArray objectAtIndex:15],[newfirstSecondArray objectAtIndex:18]];
        NSArray *returnInfo = @[@"返程",[newfirstSecondArray objectAtIndex:16],[newfirstSecondArray objectAtIndex:17],[newfirstSecondArray objectAtIndex:19]];
        
        for (int i = 0 ; i < 4; i++)
        {
            UILabel *fromToLabel = [[UILabel alloc]init];
            fromToLabel.text = [fromInfo objectAtIndex:i];
            fromToLabel.backgroundColor = [UIColor colorWithRed:30 green:30 blue:30 alpha:0.3];
            fromToLabel.textColor = [UIColor whiteColor];
            fromToLabel.font = [UIFont systemFontOfSize:15];
            fromToLabel.textAlignment = NSTextAlignmentCenter;
            fromToLabel.frame = CGRectMake(300/4*i, 160, 300/4, 20);
            [timeImage addSubview:fromToLabel];
        }
        for (int i = 0 ; i < 4; i++)
        {
            UILabel *fromToLabel = [[UILabel alloc]init];
            fromToLabel.text = [returnInfo objectAtIndex:i];
            fromToLabel.backgroundColor = [UIColor colorWithRed:30 green:30 blue:30 alpha:0.3];
            fromToLabel.textColor = [UIColor whiteColor];
            fromToLabel.font = [UIFont systemFontOfSize:15];
            fromToLabel.textAlignment = NSTextAlignmentCenter;
            fromToLabel.frame = CGRectMake(300/4*i, 180, 300/4, 20);
            [timeImage addSubview:fromToLabel];
        }
        
        for (int i = 0; i < 3 ; i++)
        {
            UIImageView *backeimage =[[UIImageView alloc]init];
            backeimage.image = [UIImage imageNamed:@"v_shor_line@2x@2x.png"];
            backeimage.frame = CGRectMake(70+320/4*i, 160, 1, 40);
            [timeImage addSubview:backeimage];
        }
        
        // 显示详情
        UIImageView *AccordingInfoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 230, 300, 130)];
        AccordingInfoImage.userInteractionEnabled = YES;
        AccordingInfoImage.image = [[UIImage imageNamed:@"BG2white1@2x.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(12, 0, 12, 0)) resizingMode:UIImageResizingModeStretch];
        [self addSubview:AccordingInfoImage];
        
        NSArray *accorArray = @[@"票价",[newfirstSecondArray objectAtIndex:20],@"基建",[newfirstSecondArray objectAtIndex:21],@"燃油",[newfirstSecondArray objectAtIndex:22]];
        NSInteger accorInteger = 0;
        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 2; j++)
            {
                accorInteger++;
                UILabel *accorLabel = [[UILabel alloc]init];
                accorLabel.frame = CGRectMake(10+j*220, 5+i*30,100, 30);
                accorLabel.textColor = [UIColor grayColor];
                accorLabel.text = [accorArray objectAtIndex:(accorInteger-1)];
                accorLabel.font = [UIFont systemFontOfSize:15];
                accorLabel.backgroundColor = [UIColor clearColor];
                [AccordingInfoImage addSubview:accorLabel];
            }
        }
        UIImageView *lineAccorIamge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 95, 300, 1)];
        lineAccorIamge.image = [UIImage imageNamed:@"line@2x.png"];
        [AccordingInfoImage addSubview:lineAccorIamge];
        
        UIButton *tickButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        tickButton.frame = CGRectMake(0, 105,200, 15);
        [tickButton setTitleColor:RGBACOLOR(19, 193, 245, 1) forState:(UIControlStateNormal)];
        [tickButton setTitle:@"*查看退改票须知" forState:(UIControlStateNormal)];
        [tickButton addTarget:self action:@selector(tupiao) forControlEvents:(UIControlEventTouchUpInside)];
        [AccordingInfoImage addSubview:tickButton];
        
        
    }
    return self;
}
-(void)tupiao
{
    [self.delegate ReturnPlayViewInfoTuPiao];
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
