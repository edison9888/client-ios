//
//  NLLogOnViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-5.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLProgressHUD.h"
#import "NLPushViewIntoNav.h"

@interface NLLogOnViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NLProgressHUDDelegate>

@property(nonatomic,assign) NLPushViewType myNextType;
@property(nonatomic,retain) NSString* myAccount;
@property(nonatomic,retain) IBOutlet UITableView* myTableView;

-(void)doSetRememberAccount:(NSString*)mobile;

@end
