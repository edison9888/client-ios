//
//  NewloginRestive.h
//  TongFubao
//
//  Created by  俊   on 14-6-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZGFormField.h"
#import "NLProgressHUD.h"
#import "NLPushViewIntoNav.h"

@protocol BZGFormFieldDelegate;

@interface NewloginRestive : UIViewController<NLProgressHUDDelegate,BZGFormFieldDelegate,UITextFieldDelegate>
{
    NSString *MobileStr;
}
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordtooField;
@property (weak, nonatomic) IBOutlet UILabel *PhoneMoble;

@property(nonatomic,retain)NSString *PhoneStr;

@end
