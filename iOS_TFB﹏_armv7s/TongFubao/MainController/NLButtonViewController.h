//
//  NLButtonViewController.h
//  TongFubao
//
//  Created by MD313 on 13-9-25.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NLButtonViewController;

@protocol NLButtonViewControllerDelegate <NSObject>

-(void)onNLButtonClicked:(UIButton*)button;

@end

@interface NLButtonViewController : UIViewController

@property(nonatomic, assign)id<NLButtonViewControllerDelegate> myDelegate;

-(id)initWithTitle:(NSString*)title image:(UIImage*)image tag:(int)tag;

@end
