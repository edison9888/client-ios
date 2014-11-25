//
//  ChangeButton.m
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ChangeButton.h"

@implementation ChangeButton

+ (id)buttonWithFrame:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.opaque = YES;
    btn.frame = frame;
    [btn setBackgroundImage:imageName(@"text2@2x", @"png") forState:UIControlStateNormal];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 35, 5, 30, 30)];
    imageView.opaque = YES;
    imageView.image = imageName(@"chosenside@2x", @"png");
    [btn addSubview:imageView];
    
    return btn;
}



@end
