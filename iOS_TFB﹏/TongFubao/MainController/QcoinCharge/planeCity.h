//
//  planeCity.h
//  TongFubao
//
//  Created by  俊   on 14-7-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "CustomTable.h"

@interface planeCity : UIViewController <CustomTabelDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, copy) NSMutableArray *headViews;

@end
