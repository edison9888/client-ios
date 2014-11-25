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
#import "CLNavigationControllerDelegate.h"

@class FeedController;

@interface NLAppDelegate : UIResponder <UIApplicationDelegate>
{
     CLNavigationControllerDelegate * delegate;
}

@property(strong,nonatomic)UIAlertView *alertView;
@property (strong,nonatomic) UINavigationController * mNavCtrl;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *feedController;
@property (strong, nonatomic) UIViewController *leftController;

/*引导需要的*/
@property (assign,nonatomic) CGPoint mTouchPoint;
@property (strong,nonatomic) UIView * mTouchView;

//回到主界面
-(void)backToMain;

-(void)backToMainToTabe1;

-(void)backToTFAgent;

-(void)backToTFAgentTable1;

- (BOOL)firstPhonePayView;

@end

