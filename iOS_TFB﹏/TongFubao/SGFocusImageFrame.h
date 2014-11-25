//
//  SGFocusImageFrame.h
//  VideoPlayer
//
//  Created by 〝Cow﹏. on 13-10-19.
//  Copyright (c) 2013年 〝Cow﹏.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SGFocusImageItem;
@class SGFocusImageFrame;
@protocol SGFocusImageFrameDelegate <NSObject>

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item;

@end

@interface SGFocusImageFrame : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)items, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, assign) id<SGFocusImageFrameDelegate> delegate;

@end

