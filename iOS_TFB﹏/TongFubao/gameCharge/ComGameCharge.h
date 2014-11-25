//
//  ComGameCharge.h
//  TongFubao
//
//  Created by ec on 14-6-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComGameCharge : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(assign,nonatomic)BOOL planeType;

-(void)getComGameList;

@end
