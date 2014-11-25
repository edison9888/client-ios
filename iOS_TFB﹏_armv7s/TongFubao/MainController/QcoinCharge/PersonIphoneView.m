//
//  PersonIphoneView.m
//  TongFubao
//
//  Created by kin on 14-9-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PersonIphoneView.h"

@implementation PersonIphoneView



- (id)initWithFrame:(CGRect)frame nameLabel:(NSString *)newNameLabel iphoneLabel:(NSString *)newiphoneLabel buttonTag:(NSInteger)newTag;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        self.backgroundColor = RGBACOLOR(19, 193, 245, 0.1);
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
        nameLabel.text =newNameLabel;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:nameLabel];
        
        UILabel *IphnoeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 20)];
        IphnoeLabel.text =newiphoneLabel;
        IphnoeLabel.textColor = [UIColor blackColor];
        IphnoeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:IphnoeLabel];
        
        UIButton *deleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        deleButton.frame = CGRectMake(250, 5, 30, 30);
        deleButton.selected = YES;
        deleButton.tag = newTag;
        [deleButton setImage:[UIImage imageNamed:@"delete2_selected@2x.png"] forState:(UIControlStateNormal)];
        [deleButton addTarget:self action:@selector(deleButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:deleButton];
        
    }
    return self;
}
-(void)deleButton:(UIButton *)sender
{
    if (sender.selected == YES) {
        [sender setImage:[UIImage imageNamed:@"delete@2x.png"] forState:(UIControlStateNormal)];
        sender.selected = NO;
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"delete2_selected@2x.png"] forState:(UIControlStateNormal)];
        sender.selected = YES;
    }
    [self.delegate deletSelectionPersonIphoneButtonTag:sender.tag];
    
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
