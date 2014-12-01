//
//  NewLogin.h
//  TongFubao
//
//  Created by  俊   on 14-5-5.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLProgressHUD.h"
#import "NLPushViewIntoNav.h"
#import "BZGFormField.h"

@protocol BZGFormFieldDelegate;

@interface NewLoginView : UIViewController<UITableViewDataSource,UITableViewDelegate,NLProgressHUDDelegate,BZGFormFieldDelegate,UITextFieldDelegate>

@property(nonatomic,assign) NLPushViewType myNextType;

@property(nonatomic,retain) NSString *LoginMobile;
@property (nonatomic,assign) BOOL myNextTypeBool;

-(void)doSetRememberAccount:(NSString*)mobile;

@end
