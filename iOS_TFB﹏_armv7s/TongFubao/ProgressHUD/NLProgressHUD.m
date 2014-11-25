//
//  NLProgressHUD.m
//  NLUitlsLib
//
//  Created by MD313 on 13-8-14.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLProgressHUD.h"
#import "MBRoundProgressView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>


#if NS_BLOCKS_AVAILABLE
typedef void (^MBProgressHUDCompletionBlock)();
#endif


#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp) exp
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#endif


static const CGFloat kPadding = 4.f;
static const CGFloat kLabelFontSize = 16.f;
static const CGFloat kDetailsLabelFontSize = 12.f;

@interface RNCloseButton : UIButton
{
    BOOL _isBorder;
    UIColor* _color;
    UIColor* _borderColor;
}

- (id)initWithBorder:(BOOL)isBorder color:(UIColor*)color borderColor:(UIColor*)borderColor;

@end


@interface NLProgressHUD ()
{
    RNCloseButton *_dismissButton;
}

+ (NLProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 * Finds the top-most HUD subview and hides it. The counterpart to this method is showHUDAddedTo:animated:.
 *
 * @param view The view that is going to be searched for a HUD subview.
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @return YES if a HUD was found and removed, NO otherwise.
 *
 * @see showHUDAddedTo:animated:
 * @see animationType
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 * Finds the top-most HUD subview and returns it.
 *
 * @param view The view that is going to be searched.
 * @return A reference to the last HUD subview discovered.
 */
+ (NLProgressHUD *)HUDForView:(UIView *)view;

/**
 * Finds all HUD subviews and returns them.
 *
 * @param view The view that is going to be searched.
 * @return All found HUD views (array of MBProgressHUD objects).
 */
+ (NSArray *)allHUDsForView:(UIView *)view;

/**
 * A convenience constructor that initializes the HUD with the window's bounds. Calls the designated constructor with
 * window.bounds as the parameter.
 *
 * @param window The window instance that will provide the bounds for the HUD. Should be the same instance as
 * the HUD's superview (i.e., the window that the HUD will be added to).
 */
- (id)initWithWindow:(UIWindow *)window;

/**
 * A convenience constructor that initializes the HUD with the view's bounds. Calls the designated constructor with
 * view.bounds as the parameter
 *
 * @param view The view instance that will provide the bounds for the HUD. Should be the same instance as
 * the HUD's superview (i.e., the view that the HUD will be added to).
 */
- (id)initWithView:(UIView *)view;

/**
 * Display the HUD. You need to make sure that the main thread completes its run loop soon after this method call so
 * the user interface can be updated. Call this method when your task is already set-up to be executed in a new thread
 * (e.g., when using something like NSOperation or calling an asynchronous call like NSURLRequest).
 *
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 *
 * @see animationType
 */
//- (void)show:(BOOL)animated;

/**
 * Hide the HUD. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 *
 * @see animationType
 */
//- (void)hide:(BOOL)animated;

/**
 * Hide the HUD after a delay. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @param delay Delay in secons until the HUD is hidden.
 *
 * @see animationType
 */
//- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/**
 * Shows the HUD while a background task is executing in a new thread, then hides the HUD.
 *
 * This method also takes care of autorelease pools so your method does not have to be concerned with setting up a
 * pool.
 *
 * @param method The method to be executed while the HUD is shown. This method will be executed in a new thread.
 * @param target The object that the target method belongs to.
 * @param object An optional object to be passed to the method.
 * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will not use
 * animations while (dis)appearing.
 */
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

#if NS_BLOCKS_AVAILABLE

/**
 * Shows the HUD while a block is executing on a background queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completion:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block;

/**
 * Shows the HUD while a block is executing on a background queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completion:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * Shows the HUD while a block is executing on the specified dispatch queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completion:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue;

/**
 * Shows the HUD while a block is executing on the specified dispatch queue, executes completion block on the main queue, and then hides the HUD.
 *
 * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will
 * not use animations while (dis)appearing.
 * @param block The block to be executed while the HUD is shown.
 * @param queue The dispatch queue on which the block should be execouted.
 * @param completion The block to be executed on completion.
 *
 * @see completionBlock
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
     completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * A block that gets called after the HUD was completely hiden.
 */
@property (atomic, copy) MBProgressHUDCompletionBlock completionBlock;

#endif

/**
 * The opacity of the HUD window. Defaults to 0.8 (80% opacity).
 */
@property (atomic, assign) float opacity;

/**
 * The x-axis offset of the HUD relative to the centre of the superview.
 */
@property (atomic, assign) float xOffset;

/**
 * The y-ayis offset of the HUD relative to the centre of the superview.
 */
@property (atomic, assign) float yOffset;

/*
 * Grace period is the time (in seconds) that the invoked method may be run without
 * showing the HUD. If the task finishes before the grace time runs out, the HUD will
 * not be shown at all.
 * This may be used to prevent HUD display for very short tasks.
 * Defaults to 0 (no grace time).
 * Grace time functionality is only supported when the task status is known!
 * @see taskInProgress
 */
@property (atomic, assign) float graceTime;

/**
 * The minimum time (in seconds) that the HUD is shown.
 * This avoids the problem of the HUD being shown and than instantly hidden.
 * Defaults to 0 (no minimum show time).
 */
@property (atomic, assign) float minShowTime;

/**
 * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
 * If you don't set a graceTime (different than 0.0) this does nothing.
 * This property is automatically set when using showWhileExecuting:onTarget:withObject:animated:.
 * When threading is done outside of the HUD (i.e., when the show: and hide: methods are used directly),
 * you need to set this property when your task starts and completes in order to have normal graceTime
 * functionality.
 */
@property (atomic, assign) BOOL taskInProgress;


/**
 * Font to be used for the details label. Set this property if the default is not adequate.
 */
@property (atomic, MB_STRONG) UIFont* detailsLabelFont;

/**
 * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
 */
@property (atomic, assign) CGSize minSize;

/**
 * Force the HUD dimensions to be equal if possible.
 */
@property (atomic, assign, getter = isSquare) BOOL square;

///**
// * The UIView (e.g., a UIImageView) to be shown when the HUD is in MBProgressHUDModeCustomView.
// * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds).
// */
//@property (atomic, MB_STRONG) UIView *customView;

///**
// * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
// */
//@property (atomic, assign) float progress;
//
///**
// * An optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
// * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
// * set to @"", then no message is displayed.
// */
//@property (atomic, copy) NSString *labelText;
//
///**
// * An optional details message displayed below the labelText message. This message is displayed only if the labelText
// * property is also set and is different from an empty string (@""). The details text can span multiple lines.
// */
//@property (atomic, copy) NSString *detailsLabelText;
///**
// * MBProgressHUD operation mode. The default is MBProgressHUDModeIndeterminate.
// *
// * @see MBProgressHUDMode
// */
//@property (atomic, assign) MBProgressHUDMode mode;
///**
// * Cover the HUD background view with a radial gradient.
// */
//@property (atomic, assign) BOOL dimBackground;
///**
// * The color of the HUD window. Defaults to black. If this property is set, color is set using
// * this UIColor and the opacity property is not used.  using retain because performing copy on
// * UIColor base colors (like [UIColor greenColor]) cause problems with the copyZone.
// */
//@property (atomic, MB_STRONG) UIColor *color;
///**
// * The HUD delegate object.
// *
// * @see NLProgressHUDDelegate
// */
//@property (atomic, MB_WEAK) id<NLProgressHUDDelegate> delegate;
///**
// * The animation type that should be used when the HUD is shown and hidden.
// *
// * @see MBProgressHUDAnimation
// */
//@property (atomic, assign) MBProgressHUDAnimation animationType;

/**
 * 是否显示进度百分比
 */
@property (atomic, assign) BOOL showProgressPercentage;

- (void)setupLabels;
- (void)registerForKVO;
- (void)unregisterFromKVO;
- (NSArray *)observableKeypaths;
- (void)registerForNotifications;
- (void)unregisterFromNotifications;
- (void)updateUIForKeypath:(NSString *)keyPath;
- (void)hideUsingAnimation:(BOOL)animated;
- (void)showUsingAnimation:(BOOL)animated;
- (void)done;
- (void)updateIndicators;
- (void)handleGraceTimer:(NSTimer *)theTimer;
- (void)handleMinShowTimer:(NSTimer *)theTimer;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (void)cleanUp;
- (void)launchExecution;
- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)hideDelayed:(NSNumber *)animated;

@property (atomic, MB_STRONG) UIView *indicator;
@property (atomic, MB_STRONG) NSTimer *graceTimer;
@property (atomic, MB_STRONG) NSTimer *minShowTimer;
@property (atomic, MB_STRONG) NSDate *showStarted;
@property (atomic, assign) CGSize size;

@end


@implementation NLProgressHUD {
	BOOL useAnimation;
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	UILabel *label;
	UILabel *detailsLabel;
	BOOL isFinished;
	CGAffineTransform rotationTransform;
}

#pragma mark - Properties

@synthesize animationType;
@synthesize delegate;
@synthesize opacity;
@synthesize color;
@synthesize labelFont;
@synthesize detailsLabelFont;
@synthesize indicator;
@synthesize xOffset;
@synthesize yOffset;
@synthesize minSize;
@synthesize square;
@synthesize margin;
@synthesize dimBackground;
@synthesize graceTime;
@synthesize minShowTime;
@synthesize graceTimer;
@synthesize minShowTimer;
@synthesize taskInProgress;
@synthesize removeFromSuperViewOnHide;
@synthesize customView;
@synthesize showStarted;
@synthesize mode;
@synthesize labelText;
@synthesize detailsLabelText;
@synthesize progress;
@synthesize size;
#if NS_BLOCKS_AVAILABLE
@synthesize completionBlock;
#endif

#pragma mark - Class methods

+ (NLProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
	NLProgressHUD *hud = [[NLProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	[hud show:animated];
	return MB_AUTORELEASE(hud);
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
	NLProgressHUD *hud = [NLProgressHUD HUDForView:view];
	if (hud != nil) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
		return YES;
	}
	return NO;
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
	NSArray *huds = [self allHUDsForView:view];
	for (NLProgressHUD *hud in huds) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
	}
	return [huds count];
}

+ (NLProgressHUD *)HUDForView:(UIView *)view {
	NLProgressHUD *hud = nil;
	NSArray *subviews = view.subviews;
	Class hudClass = [NLProgressHUD class];
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:hudClass]) {
			hud = (NLProgressHUD *)aView;
		}
	}
	return hud;
}

+ (NSArray *)allHUDsForView:(UIView *)view {
	NSMutableArray *huds = [NSMutableArray array];
	NSArray *subviews = view.subviews;
	Class hudClass = [NLProgressHUD class];
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:hudClass]) {
			[huds addObject:aView];
		}
	}
	return [NSArray arrayWithArray:huds];
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Set default values for properties
		self.animationType = NLProgressHUDAnimationFade;
		self.mode = NLProgressHUDModeIndeterminate;
		self.labelText = nil;
		self.detailsLabelText = nil;
		self.opacity = 0.8f;
        self.color = nil;
		self.labelFont = [UIFont boldSystemFontOfSize:kLabelFontSize];
		self.detailsLabelFont = [UIFont boldSystemFontOfSize:kDetailsLabelFontSize];
		self.xOffset = 0.0f;
		self.yOffset = 0.0f;
		self.dimBackground = NO;
		self.margin = 20.0f;
		self.graceTime = 0.0f;
		self.minShowTime = 0.0f;
		self.removeFromSuperViewOnHide = NO;
		self.minSize = CGSizeZero;
		self.square = NO;
        self.isBorder = NO;
        self.borderColor = nil;
        self.isClose = NLProgressHUDCloseBtnMode_None;
        self.showProgressPercentage = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
		// Transparent background
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		// Make it invisible for now
		self.alpha = 0.0f;
		
		taskInProgress = NO;
		rotationTransform = CGAffineTransformIdentity;
		
		[self setupLabels];
		[self updateIndicators];
		[self registerForKVO];
		[self registerForNotifications];
	}
	return self;
}

- (id)initWithView:(UIView *)view {
	NSAssert(view, @"View must not be nil.");
	id me = [self initWithFrame:view.bounds];
	// We need to take care of rotation ourselfs if we're adding the HUD to a window
	if ([view isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:NO];
	}
	return me;
}

- (id)initWithWindow:(UIWindow *)window {
	return [self initWithView:window];
}

- (void)dealloc {
	[self unregisterFromNotifications];
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[color release];
	[indicator release];
	[label release];
	[detailsLabel release];
	[labelText release];
	[detailsLabelText release];
	[graceTimer release];
	[minShowTimer release];
	[showStarted release];
	[customView release];
#if NS_BLOCKS_AVAILABLE
	[completionBlock release];
#endif
	[super dealloc];
#endif
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated {
	useAnimation = animated;
	// If the grace time is set postpone the HUD display
	if (self.graceTime > 0.0) {
		self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime target:self
                                                         selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
	}
	// ... otherwise show the HUD imediately
	else {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

-(void)dismissButtonClicked
{
    self.isClose = NLProgressHUDCloseBtnMode_Clicked;
    if ([delegate respondsToSelector:@selector(onClickedCloseBtn:)])
    {
		[delegate performSelector:@selector(onClickedCloseBtn:) withObject:self];
	}
    //[self hide:YES];
    //[self cleanUp];
}

- (void)hide:(BOOL)animated
{
	useAnimation = animated;
	// If the minShow time is set, calculate how long the hud was shown,
	// and pospone the hiding operation if necessary
	if (self.minShowTime > 0.0 && showStarted)
    {
		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
		if (interv < self.minShowTime)
        {
			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv)
                                                                 target:self
                                                               selector:@selector(handleMinShowTimer:)
                                                               userInfo:nil
                                                                repeats:NO];
			return;
		}
	}
	// ... otherwise hide the HUD immediately
	[self hideUsingAnimation:useAnimation];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
	[self hide:[animated boolValue]];
}

#pragma mark - Timer callbacks

- (void)handleGraceTimer:(NSTimer *)theTimer {
	// Show the HUD only if the task is still running
	if (taskInProgress) {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
	[self hideUsingAnimation:useAnimation];
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
	self.alpha = 0.0f;
	if (animated && animationType == NLProgressHUDAnimationZoomIn) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
	} else if (animated && animationType == NLProgressHUDAnimationZoomOut) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
	}
	self.showStarted = [NSDate date];
	// Fade in
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		self.alpha = 1.0f;
		if (animationType == NLProgressHUDAnimationZoomIn || animationType == NLProgressHUDAnimationZoomOut) {
			self.transform = rotationTransform;
		}
		[UIView commitAnimations];
	}
	else {
		self.alpha = 1.0f;
	}
}

- (void)hideUsingAnimation:(BOOL)animated {
	// Fade out
	if (animated && showStarted) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
		// 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
		// in the done method
		if (animationType == NLProgressHUDAnimationZoomIn) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
		} else if (animationType == NLProgressHUDAnimationZoomOut) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
		}
        
		self.alpha = 0.02f;
		[UIView commitAnimations];
	}
	else {
		self.alpha = 0.0f;
		[self done];
	}
	self.showStarted = nil;
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
	[self done];
}

- (void)done {
	isFinished = YES;
	self.alpha = 0.0f;
	if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
		[delegate performSelector:@selector(hudWasHidden:) withObject:self];
	}
#if NS_BLOCKS_AVAILABLE
	if (self.completionBlock) {
		self.completionBlock();
		self.completionBlock = NULL;
	}
#endif
	if (removeFromSuperViewOnHide) {
		[self removeFromSuperview];
	}
}

#pragma mark - Threading

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	methodForExecution = method;
	targetForExecution = MB_RETAIN(target);
	objectForExecution = MB_RETAIN(object);
	// Launch execution in new thread
	self.taskInProgress = YES;
	[NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
	// Show HUD view
	[self show:animated];
}

#if NS_BLOCKS_AVAILABLE

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue {
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue	completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
	 completionBlock:(MBProgressHUDCompletionBlock)completion {
	self.taskInProgress = YES;
	self.completionBlock = completion;
	dispatch_async(queue, ^(void) {
        block();
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self cleanUp];
        });
    });
    [self show:animated];
}

#endif

- (void)launchExecution {
	@autoreleasepool {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		// Start executing the requested task
		[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
#pragma clang diagnostic pop
		// Task completed, update view in main thread (note: view operations should
		// be done only in the main thread)
		[self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
	}
}

- (void)cleanUp {
	taskInProgress = NO;
	self.indicator = nil;
#if !__has_feature(objc_arc)
	[targetForExecution release];
	[objectForExecution release];
#endif
	[self hide:useAnimation];
}

#pragma mark - UI

- (void)setupLabels {
	label = [[UILabel alloc] initWithFrame:self.bounds];
	label.adjustsFontSizeToFitWidth = NO;
	label.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = self.labelFont;
	label.text = self.labelText;
	[self addSubview:label];
	
	detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.adjustsFontSizeToFitWidth = NO;
	detailsLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
	detailsLabel.opaque = NO;
	detailsLabel.backgroundColor = [UIColor clearColor];
	detailsLabel.textColor = [UIColor whiteColor];
	detailsLabel.numberOfLines = 0;
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.text = self.detailsLabelText;
	[self addSubview:detailsLabel];
}

- (void)updateIndicators {
	
	BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
	BOOL isRoundIndicator = [indicator isKindOfClass:[MBRoundProgressView class]];
	
	if (mode == NLProgressHUDModeIndeterminate &&  !isActivityIndicator) {
		// Update to indeterminate indicator
		[indicator removeFromSuperview];
		self.indicator = MB_AUTORELEASE([[UIActivityIndicatorView alloc]
										 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
		[(UIActivityIndicatorView *)indicator startAnimating];
		[self addSubview:indicator];
	}
	else if (mode == NLProgressHUDModeDeterminate || mode == NLProgressHUDModeAnnularDeterminate) {
		if (!isRoundIndicator) {
			// Update to determinante indicator
			[indicator removeFromSuperview];
			self.indicator = MB_AUTORELEASE([[MBRoundProgressView alloc] initWithLable:self.showProgressPercentage]);
			[self addSubview:indicator];
		}
		if (mode == NLProgressHUDModeAnnularDeterminate) {
			[(MBRoundProgressView *)indicator setAnnular:YES];
		}
	}
	else if (mode == MBProgressHUDModeCustomView && customView != indicator) {
		// Update custom view indicator
		[indicator removeFromSuperview];
		self.indicator = customView;
		[self addSubview:indicator];
	} else if (mode == NLProgressHUDModeText) {
		[indicator removeFromSuperview];
		self.indicator = nil;
	}
}

#pragma mark - Layout

- (void)layoutSubviews {
	
	// Entirely cover the parent view
	UIView *parent = self.superview;
	if (parent) {
		self.frame = parent.bounds;
	}
	CGRect bounds = self.bounds;
	
	// Determine the total widt and height needed
	CGFloat maxWidth = bounds.size.width - 4 * margin;
	CGSize totalSize = CGSizeZero;
	
	CGRect indicatorF = indicator.bounds;
	indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
	totalSize.width = MAX(totalSize.width, indicatorF.size.width);
	totalSize.height += indicatorF.size.height;
	
	CGSize labelSize = [label.text sizeWithFont:label.font];
	labelSize.width = MIN(labelSize.width, maxWidth);
	totalSize.width = MAX(totalSize.width, labelSize.width);
	totalSize.height += labelSize.height;
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		totalSize.height += kPadding;
	}
    
	CGFloat remainingHeight = bounds.size.height - totalSize.height - kPadding - 4 * margin;
	CGSize maxSize = CGSizeMake(maxWidth, remainingHeight);
	CGSize detailsLabelSize = [detailsLabel.text sizeWithFont:detailsLabel.font
                                            constrainedToSize:maxSize lineBreakMode:detailsLabel.lineBreakMode];
	totalSize.width = MAX(totalSize.width, detailsLabelSize.width);
	totalSize.height += detailsLabelSize.height;
	if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
		totalSize.height += kPadding;
	}
	
	totalSize.width += 2 * margin;
	totalSize.height += 2 * margin;
	
	// Position elements
	CGFloat yPos = roundf(((bounds.size.height - totalSize.height) / 2)) + margin + yOffset;
	CGFloat xPos = xOffset;
	indicatorF.origin.y = yPos;
	indicatorF.origin.x = roundf((bounds.size.width - indicatorF.size.width) / 2) + xPos;
	indicator.frame = indicatorF;
	yPos += indicatorF.size.height;
	
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		yPos += kPadding;
	}
	CGRect labelF;
	labelF.origin.y = yPos;
	labelF.origin.x = roundf((bounds.size.width - labelSize.width) / 2) + xPos;
	labelF.size = labelSize;
	label.frame = labelF;
	yPos += labelF.size.height;
	
	if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
		yPos += kPadding;
	}
	CGRect detailsLabelF;
	detailsLabelF.origin.y = yPos;
	detailsLabelF.origin.x = roundf((bounds.size.width - detailsLabelSize.width) / 2) + xPos;
	detailsLabelF.size = detailsLabelSize;
	detailsLabel.frame = detailsLabelF;
	
	// Enforce minsize and quare rules
	if (square) {
		CGFloat max = MAX(totalSize.width, totalSize.height);
		if (max <= bounds.size.width - 2 * margin) {
			totalSize.width = max;
		}
		if (max <= bounds.size.height - 2 * margin) {
			totalSize.height = max;
		}
	}
	if (totalSize.width < minSize.width) {
		totalSize.width = minSize.width;
	}
	if (totalSize.height < minSize.height) {
		totalSize.height = minSize.height;
	}
	
	self.size = totalSize;
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    
	if (self.dimBackground) {
		//Gradient colours
		size_t gradLocationsNum = 2;
		CGFloat gradLocations[2] = {0.0f, 1.0f};
		CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
		CGColorSpaceRelease(colorSpace);
		//Gradient center
		CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		//Gradient radius
		float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
		//Gradient draw
		CGContextDrawRadialGradient (context, gradient, gradCenter,
									 0, gradCenter, gradRadius,
									 kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}
    
    // Set background rect color
    if (self.color) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
    } else {
        CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    }
    
	
	// Center HUD
	CGRect allRect = self.bounds;
    
    CGRect boxRect1 = CGRectMake(roundf((allRect.size.width - size.width) / 2) -2,
                                 roundf((allRect.size.height - size.height) / 2) -2 , size.width+4, size.height+4);
     float radius = 10.0f;
    
    if (self.isBorder)
    {
        //Draw border
        CGRect boxRect1 = CGRectMake(roundf((allRect.size.width - size.width) / 2) -2,
                                     roundf((allRect.size.height - size.height) / 2) -2 , size.width+4, size.height+4);
        
        UIView* v = MB_AUTORELEASE([[UIView alloc] initWithFrame:boxRect1]);
        v.backgroundColor = [UIColor clearColor];
        v.layer.borderWidth = 3.f;
        if (self.borderColor)
        {
            v.layer.borderColor = self.borderColor.CGColor;
        }
        else
        {
            v.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        
        v.layer.cornerRadius = 10.f;
        [self addSubview:v];
    }
     
	// Draw rounded HUD backgroud rect
	CGRect boxRect = CGRectMake(roundf((allRect.size.width - size.width) / 2) + self.xOffset,
								roundf((allRect.size.height - size.height) / 2) + self.yOffset, size.width, size.height);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
	CGContextClosePath(context);
	CGContextFillPath(context);
    
    if (NLProgressHUDCloseBtnMode_Show == self.isClose)
    {
        _dismissButton = MB_AUTORELEASE([[RNCloseButton alloc] initWithBorder:self.isBorder color:self.color borderColor:self.borderColor]);
        _dismissButton.center = CGPointZero;
        [_dismissButton addTarget:self action:@selector(dismissButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        if (self.isBorder)
        {
            boxRect = boxRect1;
        }
        _dismissButton.center = boxRect.origin;
        [self addSubview:_dismissButton];
    }
    
	UIGraphicsPopContext();
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"mode", @"customView", @"labelText", @"labelFont",
			@"detailsLabelText", @"detailsLabelFont", @"progress", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateUIForKeypath:keyPath];
	}
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"mode"] || [keyPath isEqualToString:@"customView"]) {
		[self updateIndicators];
	} else if ([keyPath isEqualToString:@"labelText"]) {
		label.text = self.labelText;
	} else if ([keyPath isEqualToString:@"labelFont"]) {
		label.font = self.labelFont;
	} else if ([keyPath isEqualToString:@"detailsLabelText"]) {
		detailsLabel.text = self.detailsLabelText;
	} else if ([keyPath isEqualToString:@"detailsLabelFont"]) {
		detailsLabel.font = self.detailsLabelFont;
	} else if ([keyPath isEqualToString:@"progress"]) {
		if ([indicator respondsToSelector:@selector(setProgress:)]) {
			[(id)indicator setProgress:progress];
		}
		return;
	}
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else if ([superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; }
		else { radians = (CGFloat)M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; }
		else { radians = 0; }
	}
	rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}



- (id)initWithParentView:(UIView *)parentView
{
    id me = [self initWithView:parentView];
    [parentView addSubview:me];
    return me;
}

- (void)showSimple:(id<NLProgressHUDDelegate>)del
            target:(id)target
            action:(SEL)action
{
    self.delegate = del;
    [self showWhileExecuting:action onTarget:target withObject:nil animated:YES];
}

- (void)showWithLabel:(id<NLProgressHUDDelegate>)del
               target:(id)target
               action:(SEL)action
            labelText:(NSString*)labelTex
{
    self.delegate = del;
	self.labelText = labelTex;
	
	[self showWhileExecuting:action onTarget:target withObject:nil animated:YES];
}

- (void)showWithDetailsLabel:(id<NLProgressHUDDelegate>)del
                      target:(id)target
                      action:(SEL)action
                   labelText:(NSString*)labelTex
             detailLabelText:(NSString*)detailLabelText
{
    self.delegate = del;
	self.labelText = labelTex;
    self.detailsLabelText = detailLabelText;
	self.square = YES;
	
	[self showWhileExecuting:action onTarget:target withObject:nil animated:YES];
}

- (void)showWithLabelDeterminate:(id<NLProgressHUDDelegate>)del
                          target:(id)target
                          action:(SEL)action
                       labelText:(NSString*)labelTex
{
    self.mode = NLProgressHUDModeDeterminate;
	
	self.delegate = del;
	self.labelText = labelTex;
	
	// myProgressTask uses the HUD instance to update progress
	[self showWhileExecuting:action onTarget:target withObject:nil animated:YES];
}

- (void)showWIthLabelAnnularDeterminate:(id<NLProgressHUDDelegate>)del
                                 target:(id)target
                                 action:(SEL)action
                              labelText:(NSString*)labelTex
{
    self.mode = NLProgressHUDModeAnnularDeterminate;
	
	self.delegate = del;
	self.labelText = labelTex;
	
	// myProgressTask uses the HUD instance to update progress
	[self showWhileExecuting:action onTarget:target withObject:nil animated:YES];
}

- (void)showWithCustomView:(NSString*)labelTex
                     image:(UIImage*)image
                afterDelay:(NSTimeInterval)delay
{
    self.customView = [[UIImageView alloc] initWithImage:image] ;
	
	// Set custom view mode
	self.mode = MBProgressHUDModeCustomView;
	
	self.labelText = labelTex;
	
	[self show:YES];
	[self hide:YES afterDelay:delay];
}

- (void)showWithLabelMixed:(id<NLProgressHUDDelegate>)del
                    target:(id)target
                    action:(SEL)action
                 labelText:(NSString*)labelTex
{
    self.delegate = del;
	self.labelText = labelTex;
	self.minSize = CGSizeMake(135.f, 135.f);
	
	// myProgressTask uses the HUD instance to update progress
	[self showWhileExecuting:action onTarget:target withObject:nil animated:YES];
}

- (void)showUsingBlocks:(NSString*)labelTex
    whileExecutingBlock:(dispatch_block_t)block
        completionBlock:(void (^)())completion
{
    self.labelText = labelTex;
    [self showAnimated:YES whileExecutingBlock:block completionBlock:completion];
}

- (void)showOnWindow:(id<NLProgressHUDDelegate>)del
              target:(id)target
              action:(SEL)action
           labelText:(NSString*)labelTex
{
    self.delegate = del;
    self.labelText = labelTex;
    [self showWhileExecuting:action onTarget:target withObject:nil animated:YES];
}

@end

@implementation RNCloseButton

- (id)initWithBorder:(BOOL)isBorder color:(UIColor*)color borderColor:(UIColor*)borderColor
{
    if(!(self = [super initWithFrame:(CGRect){0, 0, 32, 32}])){
        return nil;
    }
    _isBorder = isBorder;
    _color = color;
    _borderColor = borderColor;
    static UIImage *closeButtonImage;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        closeButtonImage = [self closeButtonImage];
    });
    [self setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    return self;
}

- (id)init{
    if(!(self = [super initWithFrame:(CGRect){0, 0, 32, 32}])){
        return nil;
    }
    static UIImage *closeButtonImage;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        closeButtonImage = [self closeButtonImage];
    });
    [self setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    return self;
}

- (UIImage *)closeButtonImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor *topGradient = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:0.9];
    UIColor *bottomGradient = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.9];
    if (_color)
    {
        topGradient = _color;
        bottomGradient = _color;
    }
    
    //// Gradient Declarations
    NSArray *gradientColors = @[(id)topGradient.CGColor,
                                (id)bottomGradient.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 3;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(0, 1);
    CGFloat shadow2BlurRadius = 0;
    
    
    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 3, 24, 24)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 3), CGPointMake(16, 27), 0);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    
    if (_isBorder)
    {
        if (_borderColor)
        {
            [_borderColor setStroke];
        }
        else
        {
            [[UIColor whiteColor] setStroke];
        }
        ovalPath.lineWidth = 2;
        [ovalPath stroke];
        CGContextRestoreGState(context);
    }
    
    
    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(18.83, 15)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(16, 17.83)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(13.17, 15)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(16, 12.17)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

