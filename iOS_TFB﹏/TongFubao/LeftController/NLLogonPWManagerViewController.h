//
//  NLLogonPWManagerViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLContants.h"

@interface NLLogonPWManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) TFBPasswordType myPasswordModifyVCType;
@property(nonatomic,assign) BOOL myBackToLogon;
@property(nonatomic,assign) BOOL PushFlag;
@property(nonatomic,assign) BOOL gesturFlag;
@property(nonatomic,retain) NSString *mobile;

@end
