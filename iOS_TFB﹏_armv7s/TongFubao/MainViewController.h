//
//  MainViewController.h
//  NT
//
//  Created by 〝Cow﹏. on 14-11-17.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
+ (id)singleton;
-(void)reloadtable;
@end
