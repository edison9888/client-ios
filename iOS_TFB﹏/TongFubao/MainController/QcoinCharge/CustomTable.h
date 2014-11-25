//
//  CustomTable.h
//  TongFubao
//
//  Created by Delpan on 14-7-11.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"

@class CustomTable;

@protocol CustomTabelDelegate <NSObject>

@optional

- (void)loadCitiesWithFirstLetter:(NSString *)firstLetter;

@end

@interface CustomTable : UITableView <UITableViewDataSource, UITableViewDelegate, HeadViewDelegate>
{
    @private
    
    //选择城市数组
    NSArray *changeCities;
    //列表头视图数组
    NSMutableArray *headViews;
    //城市字典
    NSMutableDictionary *cityDic;
    //当前区
    NSString *currentSection;
}

@property (nonatomic, weak) id <CustomTabelDelegate> customTabelDelegate;

- (void)returnCities:(NSArray *)cities;

@end












