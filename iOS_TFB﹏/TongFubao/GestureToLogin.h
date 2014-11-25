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
@property (nonatomic,assign) BOOL flagIsOn;
@property (nonatomic,copy) NSString* authorid;
@property (nonatomic,strong) NSString *mobile;
@end
