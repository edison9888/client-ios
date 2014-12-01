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
    TFBRegisterVCRegister,
    TFBRegisterVCFind
} TFBRegisterVCType;

@interface NLRegisterViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (assign,nonatomic) BOOL UserBool;
@property(nonatomic,assign) TFBRegisterVCType myViewControllerType;

@end
