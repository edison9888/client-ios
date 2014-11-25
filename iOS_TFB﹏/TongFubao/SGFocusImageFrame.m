//
//  SGFocusImageFrame.m
//  VideoPlayer
//
//  Created by 〝Cow﹏. on 13-10-19.
//  Copyright (c) 2013年 〝Cow﹏.. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import <objc/runtime.h>

@interface SGFocusImageFrame ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

- (void)setupViews;
- (void)switchFocusImageItems;
@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"com.tfb.sgfocusitems";

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 2.0; //switch interval time

@implementation SGFocusImageFrame
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSMutableArray *imageItems = [NSMutableArray array];  
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {                                  
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);       
            while((eachItem = va_arg(argumentList, SGFocusImageItem *)))
            {
                [imageItems addObject: eachItem];            
            }
            va_end(argumentList);
        }
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setupViews];
        [self setDelegate:delegate]; 
    }
    return self;
}

- (void)dealloc
{
    objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [_scrollView release];
//    [_pageControl release];
//    [super dealloc];
}

#pragma mark - private methods
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    CGSize size = CGSizeMake(120, 50);
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width *.5 - size.width *.5 + 120, 0, size.width, size.height)];
  
    /*
     _scrollView.layer.cornerRadius = 10;
     _scrollView.layer.borderWidth = 1 ;
     _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _pageControl.numberOfPages = imageItems.count;
    _pageControl.currentPage = 0;
    _scrollView.delegate = self;
    [self addSubview:_pageControl];
    [self addSubview:_scrollView];
   
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * imageItems.count, _scrollView.frame.size.height);
    for (int i = 0; i < imageItems.count; i++)
    {
        SGFocusImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imageView.image = item.image;
        [_scrollView addSubview:imageView];
      //  [imageView release];
    }
   // [tapGestureRecognize release];
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
   // NSLog(@"%s", __FUNCTION__);
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count)
    {
        SGFocusImageItem *item = [imageItems objectAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)])
        {
            [self.delegate foucusImageFrame:self didSelectItem:item];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
   // NSLog(@"moveToTargetPosition : %f" , targetX);
    if (targetX >= _scrollView.contentSize.width)
    {
        targetX = 0.0;
    }
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    _pageControl.currentPage = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
}

@end

