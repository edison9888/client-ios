//
//  ToChooseShippingSpaceViewController.h
//  TongFubao
//
//  Created by kin on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoShippingSpaceView.h"
#import "BackShippingSpaceView.h"
#import "BackShippingSpaceView.h"
#import "PlayCustomActivityView.h"

@interface ToChooseShippingSpaceViewController : UIViewController<GoShippingSpaceViewDelegate,BackShippingSpaceViewDelegate>
{
    BOOL PageSwitching;
    BOOL TimeSwitch;
    //    BOOL backPage;
}
@property (retain,nonatomic)BackShippingSpaceView *BackShipping;
@property (retain,nonatomic)GoShippingSpaceView *GoSpaceView;
@property (retain,nonatomic)UILabel *selectionLable;


// 城市code
@property (retain,nonatomic) NSString *ShippingDepartCodeCtity;
@property (retain,nonatomic) NSString *ShippingArriveCodeCity;
// 时间
@property (retain,nonatomic) NSString *ShippingDepartFromTime;
@property (retain,nonatomic) NSString *ShippingReturnToTime;
// 城市id
@property (retain,nonatomic) NSString *ShippingCityIDFrom;
@property (retain,nonatomic) NSString *ShippingCityIDTo;
// 城市
@property (retain,nonatomic) NSString *ShippingRoundDepartCity;
@property (retain,nonatomic) NSString *ShippingRoundArriveCity;
// 往返类型
@property (retain,nonatomic) NSString *ShippingSearchType;


@property (retain,nonatomic) UITextView *infoTextView;

@property (retain,nonatomic)PlayCustomActivityView *activityView;

/*
 网络请求对接数据
 */
// 机票id
@property (retain,nonatomic) NSArray *priceDetailsIdArray;
// 机票实际价格
@property (retain,nonatomic) NSArray *priceArray;
// 航班
@property (retain,nonatomic) NSArray *msgchildArray;
// 机票原始价
@property (retain,nonatomic) NSArray *standardPriceArray;
// 燃油附加费
@property (retain,nonatomic) NSArray *oilFeeArray;
// 成人税
@property (retain,nonatomic) NSArray *taxArray;
// 儿童标准价
@property (retain,nonatomic) NSArray *standardPriceForChildArray;
// 儿童燃油费用
@property (retain,nonatomic) NSArray *oilFeeForChildArray;
// 儿童税
@property (retain,nonatomic) NSArray *taxForChildArray;
// 婴儿标准价
@property (retain,nonatomic) NSArray *standardPriceForBabyArray;
// 婴儿燃油费用
@property (retain,nonatomic) NSArray *oilFeeForBabyArray;
// 婴儿税

@property (retain,nonatomic) NSArray *taxForBabyArray;
// 剩余票量
@property (retain,nonatomic) NSArray *quantityArray ;
// 更改政策说明
@property (retain,nonatomic) NSArray *rerNoteArray ;
// 改签政策说明
@property (retain,nonatomic) NSArray *endNoteArray;
// 退票政策说明
@property (retain,nonatomic) NSArray *refNoteArray;
// 舱位等级
@property (retain,nonatomic) NSArray *classArray;
@property (retain,nonatomic) NSArray *flightArray;



// 往返传对象
@property (retain,nonatomic) NSMutableArray *firstPaiXuaAllArray;
@property (retain,nonatomic) NSMutableArray *secondPaiXuaAllArray;
// 去程代理cell返回数据
@property (retain,nonatomic) NSMutableArray *goFirstPaiXuaAllArray;
// 回程代理cell返回数据
@property (retain,nonatomic) NSMutableArray *returnSecondPaiXuaArray;


// 去回程选择cell对象信息
@property (retain,nonatomic) NSMutableArray *ShippFirstPlayInfoArray;
@property (retain,nonatomic) NSMutableArray *ShippSeconPlayInfoArray;



@end








