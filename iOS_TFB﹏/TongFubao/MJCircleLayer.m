//
//  MJCircleLayer.m
//  MJCircleView
//
//  Created by  俊   on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "MJCircleLayer.h"
#import "MJPasswordView.h"

@implementation MJCircleLayer

/*画线*/
- (void)drawInContext:(CGContextRef)ctx
{
    CGRect circleFrame = self.bounds;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:circleFrame
                            cornerRadius:circleFrame.size.height / 2.0];
    CGContextSetFillColorWithColor(ctx, self.passwordView.circleFillColour.CGColor);
    CGContextAddPath(ctx, circlePath.CGPath);
    CGContextFillPath(ctx);
    if (self.highlighted)
    {
        CGContextSetFillColorWithColor(ctx, self.passwordView.circleFillColourHighlighted.CGColor);
        CGContextAddPath(ctx, circlePath.CGPath);
        CGContextFillPath(ctx);
    }
}

@end

