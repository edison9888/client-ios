//
//  HistoricalRecordViewController.h
//  TongFubao
//
//  Created by kin on 14-8-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoricalRecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(retain,nonatomic) NSMutableArray *OrderdAllArray;
@property(retain,nonatomic) UITableView *historicalTableView;
@property(retain,nonatomic) UIView *buttonView;
@property(retain,nonatomic) NSMutableSet *OrderdSet;




@end
