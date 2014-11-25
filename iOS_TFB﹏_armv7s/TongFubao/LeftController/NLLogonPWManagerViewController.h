//
//  NLLogonPWManagerViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLContants.h"

@interface NLLogonPWManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,assign) TFBPasswordType myPasswordModifyVCType;
@property(nonatomic,assign) BOOL myBackToLogon;
@property(nonatomic,assign) BOOL gesturFlag;/*使用手势密码修改和密保修改的统一flag*/
@property(nonatomic,retain) NSString *mobile;

@end
