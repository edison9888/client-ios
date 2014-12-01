//
//  NLPassWordManagerViewController.h
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLPassWordManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,assign) BOOL myBackToLogon;
@property(nonatomic,retain) NSString* myMobile;

-(void)getNLPassWordIspaypwd;

@end
