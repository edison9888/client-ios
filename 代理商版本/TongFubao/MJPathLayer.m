//
//  MJPathLayer.m
//  MJPasswordView
//
//  Created by  俊   on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "MJPathLayer.h"
#import "MJPasswordView.h"
#import "MJPassword.h"


@implementation MJPathLayer

- (void)drawInContext:(CGContextRef)ctx
{
    if(!self.passwordView.isTracking)
    {
        return;
    }
    
    NSArray* circleIds = self.passwordView.trackingIds;
    self.passwordView.pathColour= [UIColor orangeColor];
    int circleId = [[circleIds objectAtIndex:0] intValue];
    CGPoint point = [self getPointWithId:circleId];
    CGContextSetLineWidth(ctx, kPathWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColor(ctx,CGColorGetComponents(self.passwordView.pathColour.CGColor));
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    
    for (int i = 1; i < [circleIds count]; i++)
    {
        circleId = [[circleIds objectAtIndex:i] intValue];
        point = [self getPointWithId:circleId];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
   
    point = self.passwordView.previousTouchPoint;
    CGContextAddLineToPoint(ctx, point.x, point.y);
    [self.passwordView.pathColour setStroke];
    CGContextDrawPath(ctx, kCGPathStroke);
}



- (CGPoint)getPointWithId:(int)circleId
{
    CGFloat x = kCircleLeftTopMargin+kCircleRadius+circleId%3*(kCircleRadius*2+kCircleBetweenMargin/1.2);//判断位数
    CGFloat y = ToTheTopMargin+kCircleRadius+circleId/3*(kCircleRadius*2+kCircleBetweenMargin);
    CGPoint point = CGPointMake(x, y);
    return point;
}

@end


@implementation MJPath

- (void)drawInContext:(CGContextRef)ctx
{
    if(!self.password.isTracking)
    {
        return;
    }
    
    NSArray* circleIds = self.password.trackingIds;
    self.password.pathColour= [UIColor orangeColor];
    int circleId = [[circleIds objectAtIndex:0] intValue];
    CGPoint point = [self getPointWithId:circleId];
    CGContextSetLineWidth(ctx, kPathWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColor(ctx,CGColorGetComponents(self.password.pathColour.CGColor));
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    
    for (int i = 1; i < [circleIds count]; i++)
    {
        circleId = [[circleIds objectAtIndex:i] intValue];
        point = [self getPointWithId:circleId];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    
    point = self.password.previousTouchPoint;
    CGContextAddLineToPoint(ctx, point.x, point.y);
    [self.password.pathColour setStroke];
    CGContextDrawPath(ctx, kCGPathStroke);
}


- (CGPoint)getPointWithId:(int)circleId
{
    CGFloat x = kCircleLeftTopMargin+kCircleRadius+circleId%3*(kCircleRadius*2+kCircleBetweenMarginMore*2);//判断位数
    CGFloat y = ToTopMargin+kCircleRadius+circleId/3*(kCircleRadius*2+kCircleBetweenMarginMore*2);
    CGPoint point = CGPointMake(x, y);
    return point;
}

@end
