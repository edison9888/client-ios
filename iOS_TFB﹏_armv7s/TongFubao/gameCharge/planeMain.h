//
//  planeMain.h
//  TongFubao
//
//  Created by  俊   on 14-6-30.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface planeMain : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,assign) BOOL GOtype;

-(id)initWithInfor:(NSDictionary*)infor;

- (void)combineChanges:(void (^)(void))changes;
@end
