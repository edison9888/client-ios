//
//  MJCircleLayer.h
//  MJCircleView
//
//  Created by  俊   on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class MJPasswordView;
@class MJPassword;

@interface MJCircleLayer : CALayer

@property (nonatomic,assign) BOOL highlighted;
@property (nonatomic,assign) MJPasswordView* passwordView;
@property (nonatomic,assign) MJPassword *password;

@end
