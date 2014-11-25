//
//  FirstLeadView.h
//  TongFubao
//
//  Created by  俊   on 14-11-7.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLNavigationControllerDelegate.h"

@interface FirstLeadView : UIViewController
{
    CLNavigationControllerDelegate * delegate;
}
@property (assign,nonatomic) CGPoint mPoint;
@end
