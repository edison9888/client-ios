//
//  PlayFromToView.m
//  TongFubao
//
//  Created by kin on 14-8-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PlayFromToView.h"

@implementation PlayFromToView


- (id)initWithFrame:(CGRect)frame infoArray:(NSArray *)newIfoArray;
{
    self = [super initWithFrame:frame];
    if (self) {
        // 顶图
        UIImageView *timeImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 300, 100)];
        timeImage.userInteractionEnabled = YES;
        timeImage.image = [[UIImage imageNamed:@"BG2blue@2x.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(180, 0, 0, 0)) resizingMode:UIImageResizingModeStretch];
        timeImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:timeImage];
        // 箭头图
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(95, 30, 100, 30)];
        arrowImage.userInteractionEnabled = YES;
        arrowImage.image = [UIImage imageNamed:@"arrow@2x.png"];
        arrowImage.contentMode = UIViewContentModeScaleToFill;
        [timeImage addSubview:arrowImage];
        
        // 时间信息
        for (int i = 0; i < 4; i++)
        {
            UILabel *InfoLabel = [[UILabel alloc]init];
            InfoLabel.backgroundColor = [UIColor clearColor];
            InfoLabel.textAlignment = NSTextAlignmentLeft;
            InfoLabel.textColor = [UIColor whiteColor];
            InfoLabel.tag = i;
            if (InfoLabel.tag == 0)
            {
                InfoLabel.frame = CGRectMake(10, 10, 90, 20);
                InfoLabel.text = [newIfoArray objectAtIndex:0];
            }
            if (InfoLabel.tag == 1)
            {
                InfoLabel.frame = CGRectMake(200 , 10, 90, 20);
                InfoLabel.text = [newIfoArray objectAtIndex:1];
            }
            if (InfoLabel.tag == 2)
            {
                InfoLabel.frame = CGRectMake(10 , 30, 100, 35);
                InfoLabel.font = [UIFont systemFontOfSize:30];
                InfoLabel.text = [newIfoArray objectAtIndex:2];
                
            }
            if (InfoLabel.tag == 3)
            {
                InfoLabel.frame = CGRectMake(200 , 30, 100, 35);
                InfoLabel.font = [UIFont systemFontOfSize:30];
                InfoLabel.text = [newIfoArray objectAtIndex:3];
                
            }
            [timeImage addSubview:InfoLabel];
        }
        NSArray *nameArray = @[[newIfoArray objectAtIndex:4],[newIfoArray objectAtIndex:5],[newIfoArray objectAtIndex:6],[newIfoArray objectAtIndex:7]];
        for (int j = 0; j < 4; j++ )
        {
            UILabel *nameLabel = [[UILabel alloc]init];
            nameLabel.tag = j;
            if (nameLabel.tag == 0 || nameLabel.tag == 3)
            {
                nameLabel.frame = CGRectMake(j*70, 65,80, 30);
            }else
            {
                nameLabel.frame = CGRectMake(75+(j-1)*85, 65,45, 30);
            }
            nameLabel.text = [nameArray objectAtIndex:j];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont systemFontOfSize:15];
            [timeImage addSubview:nameLabel];
        }
        
        UIImageView *infoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 118, 300, 40)];
        infoImage.userInteractionEnabled = YES;
        infoImage.image = [[UIImage imageNamed:@"BG2lightblue@2x.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(0, 0, 18, 0)) resizingMode:UIImageResizingModeStretch];
        [self addSubview:infoImage];
        
        NSArray *InfoArray = @[@"行程",[newIfoArray objectAtIndex:8],[newIfoArray objectAtIndex:9],[newIfoArray objectAtIndex:10]];
        for (int j = 0; j < 4; j++ )
        {
            UILabel *infoLabel = [[UILabel alloc]init];
            infoLabel.frame = CGRectMake(j*75, 0,75, 40);
            infoLabel.textAlignment = NSTextAlignmentCenter;
            infoLabel.textColor = [UIColor whiteColor];
            infoLabel.text = [InfoArray objectAtIndex:j];
            infoLabel.font = [UIFont systemFontOfSize:15];
            infoLabel.backgroundColor = [UIColor clearColor];
            [infoImage addSubview:infoLabel];
        }
        for (int k = 0 ; k < 3; k++)
        {
            // 显示详情
            UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(75+75*k,0, 1, 40)];
            lineImage.image = [UIImage imageNamed:@"v_shor_line@2x@2x.png"];
            [infoImage addSubview:lineImage];
        }
        
        // 显示详情
        UIImageView *AccordingInfoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 158, 300, 130)];
        AccordingInfoImage.userInteractionEnabled = YES;
        AccordingInfoImage.image = [[UIImage imageNamed:@"BG2white1@2x.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(12, 0, 12, 0)) resizingMode:UIImageResizingModeStretch];
        [self addSubview:AccordingInfoImage];
        
        NSArray *accorArray = @[@"票价",[newIfoArray objectAtIndex:11],@"基建",[newIfoArray objectAtIndex:12],@"燃油",[newIfoArray objectAtIndex:13]];
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
    [self.delegate playFromToViewInfoTuPiao];
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
