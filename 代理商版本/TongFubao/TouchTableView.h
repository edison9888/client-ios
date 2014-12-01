//
//  TouchTableView.h
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-9-1.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchTableViewDelegate.h"
@protocol TouchTableViewDelegate;
@interface TouchTableView : UITableView
@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;
@end
