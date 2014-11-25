//
//  NLRegisterViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TFBRegisterVCFind,
    TFBRegisterVCRegister
} TFBRegisterVCType;

@interface NLRegisterViewController : UIViewController
@property (assign,nonatomic) BOOL UserBool;
@property(nonatomic,assign) TFBRegisterVCType myViewControllerType;

@end
