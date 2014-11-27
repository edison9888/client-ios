//
//  Gesture.h
//  TongFubao
//
//  Created by  俊   on 14-5-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPassword.h"

@interface Gesture : UIViewController <UIAlertViewDelegate, MJPassTooDelegate>

@property (nonatomic,assign) BOOL flagIsOn;
@property (nonatomic,assign) BOOL loginFlage;//用户名输入手势密码登陆
@property (nonatomic,assign) BOOL changeFlage;//账户管理修改登陆密码 手势密码修改
@property (nonatomic,copy) NSString* authorid;
@property (nonatomic,copy) NSString *payPasswd;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *loginMobile;

//超时相关
@property (nonatomic,copy) NSString *timeOutType;
@property (nonatomic,strong) UIViewController *currentVC;
@property (nonatomic,copy) NSArray *ctrArr;

@end
