//
//  ShippingSpaceChoooseViewController.h
//  TongFubao
//
//  Created by kin on 14-8-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingSpaceChoooseViewController : UIViewController
{
    UIImage *blurredImage;
    UIImageView *backGroundImage;
    UIImage *screenShotImage;
    UIImageView *screenShotView;

}

@property (retain,nonatomic) UITableView *historicalTableView;
// textFile
@property (retain,nonatomic) UITextView *infoTextView;
// 起飞地点机场
@property (retain,nonatomic) NSString *shipDepartCity;
// 到达时间
@property (retain,nonatomic) NSString *arriveTimeShipFrom;
// 到达地点机场
@property (retain,nonatomic) NSString *shipArriveCity;
// 起程时间
@property (retain,nonatomic) NSString *shipTimeCity;
// 返程时间
@property (retain,nonatomic) NSString *shipReturnTimeCity;
// 单返
@property (retain,nonatomic) NSString *shipSearchTypeCity;
// 航班号
@property (retain,nonatomic) NSString *shipFlihtCity;
// 出发机场三字码
@property (retain,nonatomic) NSString *dPortCodeship;
// 到达机场三字码
@property (retain,nonatomic) NSString *aPortCodeship;
// 机型
@property (retain,nonatomic) NSString *craftTypeShip;
// 航空公司代码
@property (retain,nonatomic) NSString *airLineCodeShip;
// 航空名
@property (retain,nonatomic) NSString *airLineNameShip;
// 机票实际价格
@property (retain,nonatomic) NSString *priceShip;
// 剩余票量
@property (retain,nonatomic) NSString *quantityShip;
// 起飞城市code
@property (retain,nonatomic) NSString *DepartCtityShip;
// 到达城市code
@property (retain,nonatomic) NSString *arriveCityShip;
// 起飞城市
@property (retain,nonatomic) NSString *ShippingCtity;
// 到达城市
@property (retain,nonatomic) NSString *ShippingarriveCity;
// 起飞城市ID
@property (retain,nonatomic) NSString *ShippingFromCtityId;
// 到达城市ID
@property (retain,nonatomic) NSString *ShippingToArriveCityId;

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

@end
