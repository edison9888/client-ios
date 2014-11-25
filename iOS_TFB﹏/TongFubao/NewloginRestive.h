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
@property (weak, nonatomic) IBOutlet BZGFormField *passwordField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordtooField;
@property(nonatomic,retain)NSString *passwordFieldStr;
@property(nonatomic,retain)NSString *passwordtooFieldStr;
@property (weak, nonatomic) IBOutlet UILabel *PhoneMoble;
@property(nonatomic,retain)NSString *PhoneStr;

@end
