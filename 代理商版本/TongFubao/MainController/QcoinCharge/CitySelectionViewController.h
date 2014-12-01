//
//  CitySelectionViewController.h
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonView.h"

@protocol CitySelectionViewControllerdelegate <NSObject>

-(void)changVuleFrome:(NSString *)newFrome andTo:(NSString *)newTo;

@end

@interface CitySelectionViewController : UIViewController<ButtonViewdelegate>
{
    BOOL notityTion;
}

@property (retain,nonatomic) id<CitySelectionViewControllerdelegate>delegate;
@property (assign,nonatomic) BOOL FROMTO;
@property (retain,nonatomic) NSArray *HotCityArray;
@property (retain,nonatomic) NSMutableDictionary *cityCodeDictionary;
@property (retain,nonatomic) NSMutableDictionary *LetterSelectionDictionary;
@property (retain,nonatomic) NSMutableDictionary *cityIdDictionary;
@property (retain,nonatomic) NSArray *numberArray;
@property (retain,nonatomic) NSMutableArray *LetterSelectionArray;
@property (retain,nonatomic) NSMutableSet *LetterSelectionSet;
@property (retain,nonatomic) NSArray *SortArray;
@property (retain,nonatomic) NSArray *allCity ;
@property (retain,nonatomic) UITableView *citySelectionTableView;
@property (retain,nonatomic) NSString *fromSelectionCity;
@property (retain,nonatomic) NSString *toSelectionCity;
// ButtonViewArray搜索按钮的状态
@property (retain,nonatomic) NSMutableArray *ButtonViewArray;






@end













