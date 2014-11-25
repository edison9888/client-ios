//
//  MJPasswordView.h
//  MJPasswordView
//
//  Created by  俊   on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPasswordViewSideLength 420.0
#define kCircleRadius 35.0
#define kCircleLeftTopMargin 30.0
#define kCircleBetweenMargin 32.0
#define ToTheTopMargin 120

#define littleRadius 18
#define toTheSideMargin 128
#define toTheSIdeBetween 6
#define kPathWidth 6.0
#define kMinPasswordLength 1

//密码状态
typedef enum ePasswordSate {
    ePasswordUnset,//未设置
    ePasswordRepeat,//重复输入
    ePasswordExist//密码设置成功
}ePasswordSate;

@class MJPasswordView;

@protocol MJPasswordDelegate <NSObject>

/** 密码输入完毕回调 */
- (void)passwordView:(MJPasswordView*)passwordView withPassword:(NSString*)password;

@end

@interface MJPasswordView : UIView

/** 代理 */
@property (nonatomic,assign) id<MJPasswordDelegate> delegate;

//Normal
@property (nonatomic,retain) UIColor* circleFillColour;
@property (nonatomic,retain) UIColor* circleFillColourHighlighted;
@property (nonatomic,retain) UIColor* LocktouchColor;
@property (nonatomic,retain) UIColor* pathColour;

@property (nonatomic,assign) CGPoint previousTouchPoint;

@property (nonatomic,assign) BOOL isTracking;

@property (nonatomic,retain) NSMutableArray* circleLayers;
@property (nonatomic,retain) NSMutableArray* trackingIds;



@end
