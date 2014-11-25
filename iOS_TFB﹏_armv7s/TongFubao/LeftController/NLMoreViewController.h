//
//  NLMoreViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-26.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLMoreViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,assign) BOOL agentFlag;
@property(nonatomic,assign) BOOL settingFlag;
@end
