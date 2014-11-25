//
//  GestureToLogin.h
//  TongFubao
//
//  Created by  俊   on 14-5-6.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPasswordView.h"

@interface GestureToLogin : UIViewController<UIAlertViewDelegate,MJPasswordDelegate>
@property (nonatomic,assign) ePasswordSate state;
@property (nonatomic,assign) BOOL settingFlag;
@property (weak, nonatomic) IBOutlet UIButton *gestAgainBtn;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,copy)   NSString* authorid;
@property (nonatomic,copy)   NSString* agentidLogin;
@property (nonatomic,copy)   NSString* agentidtypeLogin;
@property (nonatomic,copy)   NSString* oldPWlogin;
@end
