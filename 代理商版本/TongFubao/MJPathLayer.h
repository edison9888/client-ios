//
//  MJPathLayer.h
//  MJPasswordView
//
//  Created by  俊   on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class MJPasswordView;

@interface MJPathLayer : CALayer

@property (nonatomic,assign) MJPasswordView* passwordView;

@end

@class MJPassword;

@interface MJPath : CALayer

@property (nonatomic,assign) MJPassword* password;

@end