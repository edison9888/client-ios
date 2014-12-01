//
//  StarPriceView.h
//  TongFubao
//
//  Created by Delpan on 14-8-25.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HotelSiftStar = 0,
    HotelSiftPrice = 1,
    HotelSiftSort = 3
}HotelSiftType;

@protocol StarPriceViewDelegate <NSObject>

@optional

- (void)returnWithValue:(NSString *)value hotelSiftType:(HotelSiftType)hotelSiftType;

@end

@interface StarPriceView : UIView <UITableViewDataSource, UITableViewDelegate, RemoveViewDelegate>
{
    UIView *contentView;
    //取消/确定按钮
    UIButton *functionBtn[2];
    //当前选择值
    NSString *currentValue;
    //星级选择
    UIButton *starBtn[6];
    //价格
    NSArray *priceSorts;
    //当前类型
    HotelSiftType currentType;
}

@property (nonatomic, weak) id <StarPriceViewDelegate> starPriceViewDelegate;

//酒店筛选初始化
- (id)initWithFrame:(CGRect)frame hotelSiftType:(HotelSiftType)hotelSiftType;

//酒店相片初始化
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end


















