//
//  NLRegisterSecondViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-23.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLRegisterViewController.h"

@interface NLRegisterSecondViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property(nonatomic,retain) NSString* myPhoneNumber;
@property(nonatomic,retain) NSString* myVerifyCode;
@property(nonatomic,assign) TFBRegisterVCType myViewControllerType;


@property (weak, nonatomic) IBOutlet UIButton    *btnLost;
@property (weak, nonatomic) IBOutlet UITextField *yzmTF;
@property (weak, nonatomic) IBOutlet UILabel     *Laphone;
@end
