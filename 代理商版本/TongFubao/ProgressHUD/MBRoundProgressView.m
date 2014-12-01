//
//  MBRoundProgressView.m
//  NLUitlsLib
//
//  Created by MD313 on 13-8-14.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "MBRoundProgressView.h"

@implementation MBRoundProgressView

#pragma mark - Accessors

- (float)progress {
	return _progress;
}

- (void)setProgress:(float)progress {
	_progress = progress;
	[self setNeedsDisplay];
}

- (BOOL)isAnnular {
	return _annular;
}

- (void)setAnnular:(BOOL)annular {
	_annular = annular;
	[self setNeedsDisplay];
}

#pragma mark - Lifecycle

- (id)init {
	return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
}

- (id)initWithLable:(BOOL)lable
{
    if (lable)
    {
        return [self initWithFrame:CGRectMake(0.f, 0.f, 70.f, 70.f) lable:YES];
    }
    else
    {
        return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f) lable:NO];
    }
}

- (id)initWithFrame:(CGRect)frame lable:(BOOL)label
{
	self = [super initWithFrame:frame];
	if (self)
    {
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		_progress = 0.f;
		_annular = NO;
        int x = (frame.size.width - 40)/2;
        int y = (frame.size.height - 15)/2;
        if (label)
        {
            self.lable = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 40, 15)];
            self.lable.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f];
            self.lable.textAlignment = NSTextAlignmentCenter;
            self.lable.backgroundColor = [UIColor clearColor];
            if (_annular)
            {
                self.lable.textColor = [UIColor whiteColor];
            }
            else
            {
                self.lable.textColor = [UIColor blackColor];
            }
            [self addSubview:self.lable];
        }
        else
        {
            self.lable = nil;
        }
	}
	return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	
	CGRect allRect = self.bounds;
	CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.lable)
    {
        if (_annular)
        {
            self.lable.textColor = [UIColor whiteColor];
        }
        else
        {
            self.lable.textColor = [UIColor blackColor];
        }
        float p = _progress*100;
        NSMutableString *string = [NSMutableString string];
        [string appendFormat:@"%d",(int)p];
        [string appendFormat:@"%@",@"%"];
        self.lable.text = string;
    }
	
	if (_annular) {
		// Draw background
		CGFloat lineWidth = 5.f;
		UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
		processBackgroundPath.lineWidth = lineWidth;
		processBackgroundPath.lineCapStyle = kCGLineCapRound;
		CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		CGFloat radius = (self.bounds.size.width - lineWidth)/2;
		CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
		CGFloat endAngle = (2 * (float)M_PI) + startAngle;
		[processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1f] set];
		[processBackgroundPath stroke];
		// Draw progress
		UIBezierPath *processPath = [UIBezierPath bezierPath];
		processPath.lineCapStyle = kCGLineCapRound;
		processPath.lineWidth = lineWidth;
		endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
		[processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[[UIColor whiteColor] set];
		[processPath stroke];
	} else {
		// Draw background
		CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
		CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.1f); // translucent white
		CGContextSetLineWidth(context, 2.0f);
		CGContextFillEllipseInRect(context, circleRect);
		CGContextStrokeEllipseInRect(context, circleRect);
		// Draw progress
		CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
		CGFloat radius = (allRect.size.width - 4) / 2;
		CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
		CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
		CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
		CGContextClosePath(context);
		CGContextFillPath(context);
	}
}


@end
