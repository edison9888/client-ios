//
//  CBCLabel.m
//  CBCSZ
//
//  Created by 〝Cow﹏. on 13-11-15.
//  Copyright (c) 2013年 〝Cow﹏. All rights reserved.
//
#define kTextFont [UIFont boldSystemFontOfSize:13]
#define kTextColor [UIColor colorWithRed:(32 / 255.0) green:(32 / 255.0) blue:(32 / 255.0) alpha:1]

#define PaomaLabelTimerInterval 0.1

#import "PaomaLabel.h"
static NSInteger anotherTimers;
@interface PaomaLabel ()
{
    NSTimer *_timer;
    NSInteger times;
}
@end

/* 自己看着抄 跑马灯效果
 PaomaLabel *aUILabel= [[PaomaLabel alloc]init];
 [aUILabel setFrame:CGRectMake(16, 23, 64, 2)];
 aUILabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15];
 aUILabel.text= [MobClick getConfigParams:@"tongzhi"];
 aUILabel.textColor = [UIColor whiteColor];
 [self.view addSubview:aUILabel];

 //如view2 大小添加父视图且超出view1 可设置部分隐藏
 imageView.clipsToBounds = YES;

 */

@implementation PaomaLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    times = -1;
    anotherTimers = 0;
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:PaomaLabelTimerInterval
                                                  target:self
                                                selector:@selector(timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)timerAction
{
    times++;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGSize size = [_text sizeWithFont:_font == nil? kTextFont:_font];
    if (size.width > self.frame.size.width)
    {
        CGFloat perDistance = (size.width / _text.length) / 4;         CGFloat moveDistance = -(times * perDistance);
        if (abs(moveDistance) >= size.width)
        {
            moveDistance = self.frame.size.width - anotherTimers * perDistance;
            times = - (anotherTimers + 1);
            anotherTimers = 0;
        }
        
        CGRect dRect = (CGRect){moveDistance,0,size.width,self.frame.size.height};
        [nil == _textColor? kTextColor:_textColor set];
        [_text drawInRect:dRect withFont:_font == nil? kTextFont:_font];

        CGFloat aDistance = (self.frame.size.width/2);
        if (moveDistance < 0 && (moveDistance + size.width) < aDistance) {
            anotherTimers++;
            CGFloat appearTextLength = size.width + moveDistance;
            CGFloat remainDistance = self.frame.size.width - appearTextLength - aDistance;

            NSInteger subStringIndex = remainDistance/perDistance;
            NSString *subText = [_text substringToIndex:MIN(subStringIndex, _text.length - 1)];
            
            [subText drawInRect:(CGRect){self.frame.size.width - remainDistance,0,self.frame.size.width,self.frame.size.height}
                       withFont:_font == nil? kTextFont:_font];
        }
        
        if (nil == _timer)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:PaomaLabelTimerInterval
                                                      target:self
                                                    selector:@selector(timerAction)
                                                    userInfo:nil
                                                     repeats:YES];
        }
    }else
    {
        [nil == _textColor? kTextColor:_textColor set];
        [_text drawInRect:self.bounds withFont:_font == nil? kTextFont:_font];
    }
}

- (void)removeFromSuperview
{
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc
{
    self.text = nil;
    self.textColor = nil;
    self.font = nil;
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
