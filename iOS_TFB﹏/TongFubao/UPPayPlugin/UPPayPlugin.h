//
//  UPPayPlugin.h
//  UPPayPlugin
//
//  Created by liwang on 13-1-8.
//  Copyright (c) 2013年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UPPayPluginDelegate.h"

@interface UPPayPlugin : NSObject
+ (BOOL)startPay:(NSString*)tn mode:(NSString*)mode viewController:(UIViewController*)viewController delegate:(id<UPPayPluginDelegate>)delegate;

@end
