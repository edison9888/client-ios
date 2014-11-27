//
//  PlayCustomActivityView.m
//  TongFubao
//
//  Created by kin on 14-9-17.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PlayCustomActivityView.h"

#define LABEL_TAG 10
#define INDICATOR_TAG 11
#define BVIEW_TAG 12


@implementation PlayCustomActivityView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.opaque = NO;
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator setCenter:CGPointMake(self.center.x, self.center.y-10)];
		indicator.tag = INDICATOR_TAG;
		[self addSubview:indicator];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 100, self.frame.size.width, self.frame.size.height)];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont systemFontOfSize:15];
		label.textAlignment = UITextAlignmentCenter;
		label.text = @"加载中....";
		label.tag = LABEL_TAG;
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(1, 1);
		[self addSubview:label];
		self.hidden = YES;
    }
    return self;
}


- (void) starActivity
{
	self.hidden = NO;
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:INDICATOR_TAG];
	[indicator startAnimating];
}
- (void) endActivity
{
	self.hidden = YES;
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:INDICATOR_TAG];
	[indicator stopAnimating];
    [self removeFromSuperview];
    
}

- (void) setTipsText:(NSString*) aText
{
	UILabel *tempLB = (UILabel *)[self viewWithTag:LABEL_TAG];
	tempLB.text = aText;
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
