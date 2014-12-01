//
//  MJPassword.h
//  TongFubao
//
//  Created by  俊   on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPasswordViewSideLength 420.0
#define kCircleRadius 35.0
#define kCircleLeftTopMargin 30.0
#define kCircleBetweenMarginMore 12.0
#define ToTopMargin 174
#define kMinPasswordLength 1

@class MJPassword;

@protocol MJPassTooDelegate <NSObject>

/** 密码输入完毕回调 */
- (void)passwordView:(MJPassword*)passwordView withPassword:(NSString*)password;

@end

@interface MJPassword : UIView

/** 代理 */
@property (nonatomic,assign) id<MJPassTooDelegate> delegate;

/*Normal普通状态*/
@property (nonatomic,retain) UIColor* circleFillColour;
@property (nonatomic,retain) UIColor* circleFillColourHighlighted;
@property (nonatomic,retain) UIColor* LocktouchColor;
@property (nonatomic,retain) UIColor* pathColour;
@property (nonatomic,assign) CGPoint previousTouchPoint;
@property (nonatomic,assign) BOOL isTracking;
@property (nonatomic,retain) NSMutableArray* circleLayers;
@property (nonatomic,retain) NSMutableArray* trackingIds;



@end
