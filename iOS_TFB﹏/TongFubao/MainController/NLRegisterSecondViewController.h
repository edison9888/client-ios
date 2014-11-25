//
//  NLRegisterSecondViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-23.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLRegisterViewController.h"

@interface NLRegisterSecondViewController : UIViewController

@property(nonatomic,retain) NSString* myPhoneNumber;
@property(nonatomic,retain) NSString* myVerifyCode;
@property(nonatomic,assign) TFBRegisterVCType myViewControllerType;
@end
