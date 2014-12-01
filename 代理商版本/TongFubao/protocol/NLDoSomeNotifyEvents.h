//
//  NLDoSomeNotifyEvents.h
//  TongFubao
//
//  Created by MD313 on 13-8-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NLDoSomeNotifyEvents : NSObject<UIAlertViewDelegate>

+(id)shareDoSomeNotifyEvents;

-(void)doCheckAppVersionNotify:(NSString*)appnewversion
                clearoldinfo:(BOOL)clearoldinfo
                  appdownurl:(NSString*)appdownurl
               appnewcontent:(NSString*)appnewcontent
                  appstrupdate:(BOOL)appstrupdate;

@end
