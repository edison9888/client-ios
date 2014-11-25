//
//  WatchTimeViewController.h
//  TongFubao
//
//  Created by kin on 14-8-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WatchTimeViewControllerdelegate <NSObject>

-(void)returnTime:(NSString*)newTime seletionWatchLogo:(NSInteger)newWatchLogo;

@end


@interface WatchTimeViewController : UIViewController

@property(retain,nonatomic)id<WatchTimeViewControllerdelegate>delegate;
@property(assign,nonatomic)NSInteger watchLogo;

@end
