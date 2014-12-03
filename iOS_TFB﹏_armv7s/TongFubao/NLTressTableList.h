//
//  NLTressTableList.h
//  TongFubao
//
//  Created by  俊   on 14-9-5.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLHistoricalAccountCell.h"
//显示类型
typedef enum
{
    NLTressTableListNone = 0,
    /*发工资*/
    NLTressTableListPayMoney,
    
}NLTressTableListType;

@class NLTressTableList;

@protocol NLTressTableListDelegate <NSObject>

@optional

- (void)loadCitiesWithFirstLetter:(NSString *)firstLetter;

- (void)returnWithObject:(NSString *)object;

@end

@interface NLTressTableList : UITableView<UITableViewDataSource, UITableViewDelegate, HeadViewDelegate,NLHistoricalAccountCellDelegate>
{
@private
    
    BOOL flagCell;
    //cell数据数组
    NSArray *listArr;
    //列表头视图数组
    NSMutableArray *headViews;
    //字典
    NSMutableDictionary *listDic;
    //当前选中
    NSString *currentlist;
    //当前类型
    NLTressTableListType currentType;
    
    NSMutableArray *cirtArr;
    int tagbtn;
    BOOL btnFlag;
    BOOL flagLast;
    
    UIButton       *select;
 
}
@property (nonatomic,assign) BOOL flagQian;/*签收工资*/
@property (nonatomic,strong) NSMutableArray *dataCell;
@property (nonatomic,strong) NSString       *PeopleNum;
@property (nonatomic,strong) UIImageView    *bgImageView;
@property (nonatomic,strong) NSString       *MoneyNum;
@property (nonatomic,strong) UIView         *CellView;
@property (nonatomic,strong) NSDictionary   *dic;
@property (nonatomic, weak) id <NLTressTableListDelegate> NLTressTableListDelegate;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style headInfos:(NSArray *)headInfos customTableType:(NLTressTableListType)customTableType flag:(BOOL)flag;

- (void)returnCities:(NSArray *)cities;

@end
