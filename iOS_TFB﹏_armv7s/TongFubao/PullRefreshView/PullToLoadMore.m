//
//  PullToLoadMoreView.m
//  Grant Paul (chpwn)
//
//  (based on EGORefreshTableHeaderView)
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PullToLoadMore.h"

#define TEXT_COLOR	 [UIColor colorWithRed:(87.0/255.0) green:(108.0/255.0) blue:(137.0/255.0) alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface PullToLoadMore (Private)

@property (nonatomic, assign) PullToLoadMoreViewState state;

@end

@implementation PullToLoadMore
@synthesize delegate, scrollView;

- (void)showActivity:(BOOL)shouldShow animated:(BOOL)animated {
    if (shouldShow) [activityView startAnimating];
    else [activityView stopAnimating];
    
    [UIView animateWithDuration:(animated ? 0.1f : 0.0) animations:^{
        arrowImage.opacity = (shouldShow ? 0.0 : 1.0);
    }];
}

- (void)setImageFlipped:(BOOL)flipped {
    [UIView animateWithDuration:0.1f animations:^{
        arrowImage.transform = (flipped ? CATransform3DMakeRotation(M_PI * 2, 0.0f, 0.0f, 1.0f) : CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f));
    }];
}

- (id)initWithScrollView:(UIScrollView *)scroll {
    lastScrollHeight = MAX(scrollView.bounds.size.height,scrollView.contentSize.height);
    CGRect frame = CGRectMake(0.0f, lastScrollHeight, scrollView.bounds.size.width, scrollView.bounds.size.height);

    if ((self = [super initWithFrame:frame])) {
        scrollView = scroll;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

		lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, self.frame.size.width, 20.0f)];
		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		lastUpdatedLabel.textColor = TEXT_COLOR;
		lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:lastUpdatedLabel];
        
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 12.0f, self.frame.size.width, 20.0f)];
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		statusLabel.textColor = TEXT_COLOR;
		statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:statusLabel];
        
		arrowImage = [[CALayer alloc] init];
		arrowImage.frame = CGRectMake(10.0f, 0, 24.0f, 52.0f);
		arrowImage.contentsGravity = kCAGravityResizeAspect;
		//arrowImage.contents = (id) [UIImage imageNamed:@"arrow"].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			arrowImage.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[self.layer addSublayer:arrowImage];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake(10.0f, 22.0f, 20.0f, 20.0f);
		[self addSubview:activityView];
        
		[self setState:PullToLoadMoreViewStateNormal];
    }
    
    return self;
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    NSDate *date = [NSDate date];
    
	if ([delegate respondsToSelector:@selector(PullToLoadMoreViewLastUpdated:)])
		date = [delegate PullToLoadMoreViewLastUpdated:self];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新时间: %@", [formatter stringFromDate:date]];
}

- (void)setState:(PullToLoadMoreViewState)state_ {
    state = state_;
    
	switch (state) {
		case PullToLoadMoreViewStateReady:
			statusLabel.text = @"松开即可加载更多...";
			[self showActivity:NO animated:NO];
            [self setImageFlipped:YES];
			break;
		case PullToLoadMoreViewStateNormal:
			statusLabel.text = @"上拉可以加载更多...";
			[self showActivity:NO animated:NO];
            [self setImageFlipped:NO];
			[self refreshLastUpdatedDate];
			break;
		case PullToLoadMoreViewStateLoading:
			statusLabel.text = @"加载中...";
			[self showActivity:YES animated:YES];
            [self setImageFlipped:NO];
			break;
            
		default:
			break;
	}
}

#pragma mark -
#pragma mark UIScrollView

- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) inScrollView
{
    CGFloat scrollAreaContenHeight = inScrollView.contentSize.height;
    
    if (scrollAreaContenHeight != lastScrollHeight) {
        lastScrollHeight = MAX(scrollView.bounds.size.height,scrollView.contentSize.height);
        self.frame = CGRectMake(0.0f, 0.0f + lastScrollHeight, scrollView.bounds.size.width, scrollView.bounds.size.height);
    }
    
    CGFloat visibleTableHeight = MIN(inScrollView.bounds.size.height, scrollAreaContenHeight);
    CGFloat scrolledDistance = inScrollView.contentOffset.y + visibleTableHeight; // If scrolled all the way down this should add upp to the content heigh.
    
    CGFloat normalizedOffset = scrolledDistance - scrollAreaContenHeight ;
    
    return normalizedOffset;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (scrollView.isDragging) {
            self.hidden = NO;
            
//            if (arrowImage.contents==nil) {
                // 箭头图像初始化摆在这里，由于摆在init函数中会导致出现bug在view的顶部
                // arrowImage.contents = (id) [UIImage imageNamed:@"arrowDown"].CGImage;
//            }
            
            CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];

            if (state == PullToLoadMoreViewStateReady) {
                if (bottomOffset < 65.0f && bottomOffset > 0.0f) {
                    [self setState:PullToLoadMoreViewStateNormal];
                }
                    
            } else if (state == PullToLoadMoreViewStateNormal) {
                if (bottomOffset > 65.0f)
                    [self setState:PullToLoadMoreViewStateReady];
            } else if (state == PullToLoadMoreViewStateLoading) {
                if (bottomOffset <= 0)
                    scrollView.contentInset = UIEdgeInsetsZero;
                else
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, MIN(scrollView.contentOffset.y, 60.0f), 0);
            }
        } else {
            if (state == PullToLoadMoreViewStateReady) {
                [UIView animateWithDuration:0.2f animations:^{
                    [self setState:PullToLoadMoreViewStateLoading];
                }];
                
                if ([delegate respondsToSelector:@selector(PullToLoadMoreViewShouldRefresh:)])
                    [delegate PullToLoadMoreViewShouldRefresh:self];
            }
        }

        self.frame = CGRectMake(scrollView.contentOffset.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)finishedLoading {
    if (state == PullToLoadMoreViewStateLoading) {
        [UIView animateWithDuration:0.3f animations:^{
            [self setState:PullToLoadMoreViewStateNormal];
            if (self) {
//                CGRect rect = self.frame;
//                rect.origin.y = -300;
//                self.frame = rect;
                self.hidden = YES;
            }
        }];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[scrollView removeObserver:self forKeyPath:@"contentOffset"];
	scrollView = nil;
}

@end
