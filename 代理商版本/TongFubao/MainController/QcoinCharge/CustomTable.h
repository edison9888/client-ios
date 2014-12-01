//
//  CustomTable.h
//  TongFubao
//
//  Created by Delpan on 14-7-11.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"

//显示类型
typedef enum
{
    //城市选择
    CustomTableCitys = 0,
    //关键字
    CustomTableKeywords,
    //行政区
    CustomTableDistrict,
    //商业区
    CustomTableBusinessZone,
    //品牌
    CustomTableBrand,
    //主题
    CustomTableCharacteristic,
    //机场车站
    CustomTableStation,
    //景点
    CustomTableScenery,
    /*发工资*/
    CustomTablePayMoney,

}CustomTableType;

@class CustomTable;

@protocol CustomTabelDelegate <NSObject>

@optional

//城市请求
- (void)loadCitiesWithFirstLetter:(NSString *)firstLetter;
//关键字请求
- (void)loadDataForKeywords:(NSInteger)keywords;

- (void)returnWithDictionary:(NSDictionary *)dataDictionary;

@end

@interface CustomTable : UITableView <UITableViewDataSource, UITableViewDelegate, HeadViewDelegate>
{
    @private
    
    //选择城市数组
    NSArray *changeCities;
    //列表头视图数组
    NSMutableArray *headViews;
    //数据名称
    NSMutableDictionary *nameDictionary;
    //当前区
    NSString *currentSection;
    //当前类型
    CustomTableType currentType;
}

@property (nonatomic, weak) id <CustomTabelDelegate> customTabelDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style headInfos:(NSArray *)headInfos customTableType:(CustomTableType)customTableType;

//添加并显示数据
- (void)returnName:(NSArray *)name;

@end












