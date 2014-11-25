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
#import "TouchTableView.h"
#import "TouchTableViewDelegate.h"
#import "Meal.h"
#import "ShopCell.h"
#import "OrderInstance.h"

@interface planeCity : UIViewController <CustomTabelDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,TouchTableViewDelegate>

@property(strong,nonatomic)TouchTableView *myTableView;/*cell效果*/
@property(strong,nonatomic)NSMutableArray *marr;

@property (nonatomic, copy) NSMutableArray *headViews;

@end
