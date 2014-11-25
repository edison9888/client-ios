
//
//  NLAppDelegate.m
//  TongFubao
//
//  Created by MD313 on 13-8-1.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLAppDelegate.h"
#import "FeedController.h"
#import "LeftController.h"
#import "NLSlideBroadsideController.h"
#import "NLContants.h"
#import "GestureToLogin.h"
#import "TFAgentMainCtr.h"
#import "PaySKQ.h"
#import "FirstPhonePay.h"
#import "PushViewController.h"

@implementation NLAppDelegate

@synthesize window;
@synthesize feedController;
@synthesize leftController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];//注册一个通知监听网络状态的变化
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    //读取本地的手势输入次数
    
    [self customNavigationBar];
    
    /*
    FirstPhonePay *new= [[FirstPhonePay alloc]initWithNibName:@"FirstPhonePay" bundle:nil];
    self.window.rootViewController= new;
    [self.window makeKeyAndVisible];
     暂停当前的首页充值
     */
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"newMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self firstPhonePayView];
   
    return YES;
}

//bar定制
-(void)customNavigationBar
{
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:imageName(@"navigationLeftBtnBack2@2x", @"png") forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    if (IOS_7)
    {
        [[UINavigationBar appearance] setBarTintColor:NAV_COLOR];
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
       
         /*
        shadow.shadowColor = [UIColor colorWithPatternImage:[NLUtils stretchImage:[UIImage imageNamed:@"bg2.jpg"] edgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)]]; */
    
        shadow.shadowOffset = CGSizeMake(0, -0.5);
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                                               shadow, NSShadowAttributeName,
                                                               [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    else
    {
        [UINavigationBar appearance].tintColor = NAV_COLOR;
    }

}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability*reach=[note object];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus status=[reach currentReachabilityStatus];//判断当前网络连接状态
    NSString*message;
    if (status==NotReachable)
    {
        message=@"当前无网络连接";
    }
    else if (status==ReachableViaWiFi)
    {
        message=@"使用wifi网络连接";
    }
    else if (status==ReachableViaWWAN)
    {
        message=@"使用3g网络连接";
    }
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft |   UIInterfaceOrientationMaskLandscapeRight;
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
     NSLog(@"应用程序进入非活跃状态（接听电话）");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[TFDBManager shareInstance] saveContext];
   
    NSLog(@"进入后台(Home)");
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void)applicationGuangGao:(UIButton*)newButton
{
    NSLog(@"广告之后马上回来！");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"进入前台");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
      NSLog(@"应用程序启动（重启）");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
     NSLog(@"应用程序终止时");
   
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma 代理商进入
-(void)backToTFAgent
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SlideBroadFlag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    UIViewController *newLeftController = [[LeftController alloc] init];
    
    feedController = (UIViewController *)[[TFAgentMainCtr alloc] initWithNibName:@"TFAgentMainCtr" bundle:nil] ;
    
//    UIViewController * newrightSideDrawerViewController = nil;

    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:feedController];

//    NLSlideBroadsideController* root = [[NLSlideBroadsideController alloc] initWithCenterViewController:navigationController
//                                                                               leftDrawerViewController:newLeftController
//                                                                              rightDrawerViewController:newrightSideDrawerViewController
//                                                                                              leftWidth:240
//                                                                                             rightWidth:0];
    
    [UIView
     transitionWithView:window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         self.window.rootViewController = (UIViewController*)navigationController;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}

/*tab类型的*/
-(void)tabarMainViewController{
  /*
    FirstViewController *firstView = [[FirstViewController alloc] init];
    
    SecondViewController *secondView = [[SecondViewController alloc] init];
    secondView.view.backgroundColor = [UIColor orangeColor];
    UINavigationController *secondNavigation = [[UINavigationController alloc] initWithRootViewController:secondView];
    
    ThirdViewController *thirdView = [[ThirdViewController alloc] init];
    thirdView.view.backgroundColor = [UIColor grayColor];
    UINavigationController *thirdNavigation = [[UINavigationController alloc] initWithRootViewController:thirdView];
    
    MoreViewController *moreView = [[MoreViewController alloc] init];
    moreView.view.backgroundColor = [UIColor blackColor];
    UINavigationController *moreNavigation = [[UINavigationController alloc] initWithRootViewController:moreView];
    
    tabViewController *tabBarView = [[tabViewController alloc] initWithViewControllers:@[ firstView, secondNavigation, thirdNavigation, moreNavigation]];
  
    tabBarView.controllerFont = [UIFont systemFontOfSize:15.0];
    tabBarView.controllerColor = [UIColor blackColor];
    self.window.rootViewController = tabBarView;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    */
}

 /*主页抽屉版本*/
-(void)lockerMainViewController{
    UIViewController *newLeftController = [[LeftController alloc] init];
    FeedController *feed = [[FeedController alloc] initWithNibName:@"FeedController" bundle:nil] ;
    UIViewController * newrightSideDrawerViewController = nil;
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:feed];
    NLSlideBroadsideController* root = [[NLSlideBroadsideController alloc] initWithCenterViewController:navigationController
                                                                               leftDrawerViewController:newLeftController
                                                                              rightDrawerViewController:newrightSideDrawerViewController
                                                                                              leftWidth:240
                                                                                             rightWidth:0];
    
    [UIView
     transitionWithView:window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         self.window.rootViewController = (UIViewController*)root;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
   
}

-(void)tabBtnView
{
    PushViewController *push= [[PushViewController alloc]initWithNibName:@"PushViewController" bundle:nil];
    
    [UIView
     transitionWithView:window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         self.window.rootViewController = push;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}

-(void)backToTFAgentTable1
{
    UIViewController *newLeftController = [[LeftController alloc] init];
    
    TFAgentMainCtr *feed = [[TFAgentMainCtr alloc] initWithNibName:@"TFAgentMainCtr" bundle:nil] ;
    
    UIViewController * newrightSideDrawerViewController = nil;
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:feed];
    
    NLSlideBroadsideController* root = [[NLSlideBroadsideController alloc] initWithCenterViewController:navigationController
                                                                               leftDrawerViewController:newLeftController
                                                                              rightDrawerViewController:newrightSideDrawerViewController
                                                                                              leftWidth:0
                                                                                             rightWidth:0];
    
    [UIView
     transitionWithView:window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         self.window.rootViewController = (UIViewController*)root;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}

-(void)backToMainToTabe1
{
    
    UIViewController *newLeftController = [[LeftController alloc] init];
    
    FeedController *feed = [[FeedController alloc] initWithNibName:@"FeedController" bundle:nil] ;
    
    UIViewController * newrightSideDrawerViewController = nil;
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:feed];
    
    NLSlideBroadsideController* root = [[NLSlideBroadsideController alloc] initWithCenterViewController:navigationController
                                                                               leftDrawerViewController:newLeftController
                                                                              rightDrawerViewController:newrightSideDrawerViewController
                                                                                              leftWidth:0
                                                                                             rightWidth:0];
    
    [UIView
     transitionWithView:window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         self.window.rootViewController = (UIViewController*)root;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}

#pragma 普通进入
-(void)backToMain
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SlideBroadFlag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    /*主页tab类型*/
    //    [self tabarMainViewController];
    /*按钮类型*/
      [self tabBtnView];
    /*主页locker类型*/
//    [self lockerMainViewController];
}


#pragma 首次充值页面

- (BOOL)firstPhonePayView{
    
    NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_RECORD_GESTURE_NUM];
    
    NSArray *DLArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"DLarray"];
    
    _authorid= [[DLArr valueForKey:@"authoridDL"]objectAtIndex:0];
    
    if ([numStr intValue]==1) {
        
        NewLoginView *new= [[NewLoginView alloc]initWithNibName:@"NewLoginView" bundle:nil];
        
        self.window.rootViewController= new;
        
        [self.window makeKeyAndVisible];
        
        return YES;
    }
    
    if ([TFData getTempData][MAIN_IS_ON_GESTURESE]!=nil) {
        // 刷钱前移除所有数据
        
        [[TFData getTempData]removeObjectForKey:MAIN_IS_ON_GESTURESE];
        
    }else
        if (_authorid==nil) {
            
            NewLoginView *new= [[NewLoginView alloc]initWithNibName:@"NewLoginView" bundle:nil];
            
            self.window.rootViewController= new;
            
            [self.window makeKeyAndVisible];
            
            return YES;
            
        }else{
            if ([TFData getTempData][MAIN_IS_ON_NEWLOGINGESTURE]==nil) {
                
                Gesture *ges= [[Gesture alloc]init];
                
                self.window.rootViewController= ges;
                
                [self.window makeKeyAndVisible];
                
                return YES;
            }
        }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma transition
-(void)clickBack
{
    [CATransaction begin];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.duration=0.8f;
    transition.fillMode=kCAFillModeForwards;
    transition.removedOnCompletion=YES;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    [CATransaction commit];
}
@end
