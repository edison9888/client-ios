//
//  BlackTableView.h
//  TongFubao
//
//  Created by Delpan on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaSelectView.h"

@protocol BlackTableViewDelegate <NSObject>

@optional

- (void)returnWithDictionary:(NSDictionary *)dataDictionary;

@end

@interface BlackTableView : UIView <RemoveViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    //数据列表
    UITableView *table;
    //数据源
    NSArray *datas;
    //数据源ID
    NSArray *dataIDs;
}

@property (nonatomic, weak) id <BlackTableViewDelegate> blackTableViewDelegate;

- (id)initWithFrame:(CGRect)frame datas:(NSArray *)data ids:(NSArray *)ids;


@end













