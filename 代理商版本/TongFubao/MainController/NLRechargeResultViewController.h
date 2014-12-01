//
//  NLRechargeResultViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-9.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLRechargeFirstViewController.h"

@interface NLRechargeResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) NLRechargeFirstType myRechargeFirstType;
@property(nonatomic,assign) BOOL myRechargeResult;

@end
