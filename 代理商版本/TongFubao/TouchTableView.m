//
//  TouchTableView.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-9-1.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//


#import "TouchTableView.h"

@implementation TouchTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
cell title效果
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([self.touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)]&&[self.touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)]) {
        [self.touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if ([self.touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)]&&[self.touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)]) {
        [self.touchDelegate tableView:self touchesMoved:touches withEvent:event];
    }

}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if ([self.touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)]&&[self.touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)]) {
        [self.touchDelegate tableView:self touchesCancelled:touches withEvent:event];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if ([self.touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)]&&[self.touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)]) {
        [self.touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}
@end



