//
//  planeaddtable.h
//  TongFubao
//
//  Created by  俊   on 14-7-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@class planeaddtable;

@protocol planeaddtableDelegate <NSObject>

@optional
- (void)areaChange:(BOOL)change;

@end

@interface planeaddtable : UIView<UITableViewDataSource, UITableViewDelegate>
{
@private
    //地区
    NSArray *areas;
    //地区变化按扭
    UIButton *areaButton;
    
}

@property (nonatomic,copy) UITableView *table;
@property (nonatomic, weak) id <planeaddtableDelegate> planeaddtableDelegate;
- (void)loadDataWith:(NSArray *)data button:(UIButton *)button;

@end
