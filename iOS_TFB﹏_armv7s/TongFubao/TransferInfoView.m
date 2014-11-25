//
//  TransferInfoView.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-9-24.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "TransferInfoView.h"

@implementation TransferInfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        /*标题*/
        _titleLabel = [UILabel labelWithFrame:CGRectMake(10, 15, 80 * (frame.size.width / 320.0), 20)
                              backgroundColor:[UIColor clearColor]
                                    textColor:[UIColor blackColor]
                                         text:nil
                                         font:[UIFont systemFontOfSize:16.0]];
        [self addSubview:_titleLabel];
        NSLog(@"");
        /*信息输入框*/
        _infoText = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, 180 * (frame.size.width / 320.0), 30)];
        _infoText.opaque = YES;
        _infoText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_infoText];
    }
    
    return self;
}



@end


@implementation TextfiledView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        /*信息输入框*/
        _infoText = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 288, 30)];
        _infoText.opaque = YES;
        _infoText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_infoText];
    }
    
    return self;
}

@end


















