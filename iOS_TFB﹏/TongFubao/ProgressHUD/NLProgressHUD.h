//
//  NLProgressHUD.h
//
//  Created by NatLiu on 13-5-8.
//  Copyright (c) 2013年 HTJF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef MB_STRONG
#if __has_feature(objc_arc)
#define MB_STRONG strong
#else
#define MB_STRONG retain
#endif
#endif

#ifndef MB_WEAK
#if __has_feature(objc_arc_weak)
#define MB_WEAK weak
#elif __has_feature(objc_arc)
#define MB_WEAK unsafe_unretained
#else
#define MB_WEAK assign
#endif
#endif

typedef enum
{
	/** Progress is shown using an UIActivityIndicatorView. This is the default. */
	NLProgressHUDModeIndeterminate,
	/** Progress is shown using a round, pie-chart like, progress view. */
	NLProgressHUDModeDeterminate,
	/** Progress is shown using a ring-shaped progress view. */
	NLProgressHUDModeAnnularDeterminate,
	/** Shows a custom view */
	MBProgressHUDModeCustomView,
	/** Shows only labels */
	NLProgressHUDModeText
} NLProgressHUDMode;

typedef enum {
	/** Opacity animation */
	NLProgressHUDAnimationFade,
	/** Opacity + scale animation */
	NLProgressHUDAnimationZoom,
	NLProgressHUDAnimationZoomOut = NLProgressHUDAnimationZoom,
	NLProgressHUDAnimationZoomIn
} NLProgressHUDAnimation;

typedef enum
{
	NLProgressHUDCloseBtnMode_None = 0,
    NLProgressHUDCloseBtnMode_Show,
    NLProgressHUDCloseBtnMode_Clicked
} NLProgressHUDCloseBtnMode;

@class NLProgressHUD;

@protocol NLProgressHUDDelegate <NSObject>

@optional

/**
 * Called after the HUD was fully hidden from the screen.
 */
- (void)hudWasHidden:(NLProgressHUD *)hud;
- (void)onClickedCloseBtn:(NLProgressHUD *)hud;

@end


@interface NLProgressHUD : UIView
/**
 * The HUD delegate object.
 *
 * @see NLProgressHUDDelegate
 */

+ (NLProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 * Finds all the HUD subviews and hides them.
 *
 * @param view The view that is going to be searched for HUD subviews.
 * @param animated If set to YES the HUDs will disappear using the current animationType. If set to NO the HUDs will not use
 * animations while disappearing.
 * @return the number of HUDs found and removed.
 *
 * @see hideAllHUDForView:animated:
 * @see animationType
 */
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

@property (atomic, assign) id<NLProgressHUDDelegate> delegate;
/**
 * The animation type that should be used when the HUD is shown and hidden.
 *
 * @see MBProgressHUDAnimation
 */
@property (atomic, assign) NLProgressHUDAnimation animationType;

/**
 * 进度百分比,从0.0到1.0,默认为0.0
 */
@property (atomic, assign) float progress;

/**
 *要显示的字符串,会自动适配字符串的长度，如果太长，以“...”结尾,只能显示一行
 */
@property (atomic, copy) NSString *labelText;

/**
 * Font to be used for the main label. Set this property if the default is not adequate.
 */
@property (atomic, MB_STRONG) UIFont* labelFont;

/**
 * The amounth of space between the HUD edge and the HUD elements (labels, indicators or custom views).
 * Defaults to 20.0
 */
@property (atomic, assign) float margin;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to NO.
 */
@property (atomic, assign) BOOL removeFromSuperViewOnHide;

/**
 *要显示的详细细节字符串,只有在labelText被设置了的时候才会显示详细细节字符串，可多行显示
 */
@property (atomic, copy) NSString *detailsLabelText;
/**
 * hud类型,默认为MBProgressHUDModeIndeterminate
 *
 * @see MBProgressHUDMode
 */

@property (atomic, assign) NLProgressHUDMode mode;
/**
 * 是否暗化背景
 */
@property (atomic, assign) BOOL dimBackground;
/**
 * 设置hud背景颜色.
 */
@property (atomic, strong) UIColor *color;

/**
 * The UIView (e.g., a UIImageView) to be shown when the HUD is in MBProgressHUDModeCustomView.
 * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds).
 */
@property (atomic, strong) UIView *customView;
/**
 * 是否显示关闭按钮
 */
@property (atomic, assign) NLProgressHUDCloseBtnMode isClose;
/**
 * 是否显示边框
 */
@property (atomic, assign) BOOL isBorder;
/**
 * 设置hud边框颜色.
 */
@property (atomic, strong) UIColor *borderColor;


- (id)initWithParentView:(UIView *)parentView;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)showSimple:(id<NLProgressHUDDelegate>)del
            target:(id)target
            action:(SEL)action;
- (void)showWithLabel:(id<NLProgressHUDDelegate>)del
               target:(id)target
               action:(SEL)action
            labelText:(NSString*)labelTex;
- (void)showWithDetailsLabel:(id<NLProgressHUDDelegate>)del
                      target:(id)target
                      action:(SEL)action
                   labelText:(NSString*)labelTex
             detailLabelText:(NSString*)detailLabelText;
- (void)showWithLabelDeterminate:(id<NLProgressHUDDelegate>)del
                          target:(id)target
                          action:(SEL)action
                       labelText:(NSString*)labelTex;
- (void)showWIthLabelAnnularDeterminate:(id<NLProgressHUDDelegate>)del
                                 target:(id)target
                                 action:(SEL)action
                              labelText:(NSString*)labelTex;
- (void)showWithCustomView:(NSString*)labelTex
                     image:(UIImage*)image
                afterDelay:(NSTimeInterval)delay;
- (void)showWithLabelMixed:(id<NLProgressHUDDelegate>)del
                    target:(id)target
                    action:(SEL)action
                 labelText:(NSString*)labelTex;
- (void)showUsingBlocks:(NSString*)labelTex
    whileExecutingBlock:(dispatch_block_t)block
        completionBlock:(void (^)())completion;
- (void)showOnWindow:(id<NLProgressHUDDelegate>)del
              target:(id)target
              action:(SEL)action
           labelText:(NSString*)labelTex;

@end




