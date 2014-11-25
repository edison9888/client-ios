//
//  NLAppDelegate.h
//  TongFubao
//
//  Created by MD313 on 13-8-1.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@class FeedController;

@interface NLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *feedController;
@property (strong, nonatomic) UIViewController *leftController;

@property (nonatomic,strong) NSString *authorid;

//回到主界面
-(void)backToMain;

-(void)backToMainToTabe1;

-(void)backToTFAgent;

-(void)backToTFAgentTable1;

- (BOOL)firstPhonePayView;

@end

