//
//  TicketInfoImationViewController.h
//  TongFubao
//
//  Created by kin on 14-9-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TicketInfoImationViewController : UIViewController

// 单返类型
@property (retain,nonatomic) NSString *FlightType;

// 机票实际价格
@property (retain,nonatomic) NSString *priceTicket;

// 航班
@property (retain,nonatomic) NSString *msgchildTicket;

// 机票原始价
@property (retain,nonatomic) NSString *standardPriceTicket;

// 燃油附加费
@property (retain,nonatomic) NSString *oilFeeTicket;

// 成人税
@property (retain,nonatomic) NSString *taxTicket;

// 儿童标准价
@property (retain,nonatomic) NSString *standardPriceChirldTicket;

// 儿童油费用
@property (retain,nonatomic) NSString *oilFeeChirldTicket;

// 儿童税
@property (retain,nonatomic) NSString *taxForTicket;

// 婴儿标准价
@property (retain,nonatomic) NSString *standardPricebadyTicket;

// 婴儿油费用
@property (retain,nonatomic) NSString *oilFeeForBabyTicket;

// 婴儿税
@property (retain,nonatomic) NSString *taxForBabyTicket;

// 剩余票量
@property (retain,nonatomic) NSString *quantityTicket;

// 更改政策说明
@property (retain,nonatomic) NSString *rerNoteTicket;

// 改签政策说明
@property (retain,nonatomic) NSString *endNoteTicket;

// 退票政策说明
@property (retain,nonatomic) NSString *refNoteTicket;

// 舱位等级
@property (retain,nonatomic) NSString *classTicket;

// 起程城市机场
@property (retain,nonatomic) NSString *TicketDepartPlay;

// 到达城市机场
@property (retain,nonatomic) NSString *TicketArrivePlay;

// 起飞时间
@property (retain,nonatomic) NSString *TicketDeTimeFrom;

// 到达时间
@property (retain,nonatomic) NSString *TicketArriveTimeTo;

// 起程城市code
@property (retain,nonatomic) NSString *TicketDepartCode;

// 到达城市code
@property (retain,nonatomic) NSString *TicketArriveCode;

// 起飞城市
@property (retain,nonatomic) NSString *TicketInfoDepartCtity;

// 到达城市
@property (retain,nonatomic) NSString *TicketInfoArriveCity;

// 航空名
@property (retain,nonatomic) NSString *playName;

// 航班号
@property (retain,nonatomic) NSString *TicketFlihtCity;

// 出发机场三字码
@property (retain,nonatomic) NSString *TicketdPortCodeship;

// 到达机场三字码
@property (retain,nonatomic) NSString *TicketaPortCodeship;

// 起飞城市ID
@property (retain,nonatomic) NSString *TicketdFromCtityId;

// 到达城市ID
@property (retain,nonatomic) NSString *TicketdToArriveCityId;

//// 订单票接口字段
//@property (retain,nonatomic) NSMutableArray *TicketdAllFlightInformation;







// 装所有信息
@property (retain,nonatomic) NSMutableArray *infoArray;

// 添加乘机人信息
@property (retain,nonatomic) NSMutableArray *ticketPersonArray;

// 添联系人信息
@property (retain,nonatomic) NSMutableArray *AddContactPersonAdrray;

// 飞机单价税费油费
@property (retain,nonatomic) NSMutableArray *AllPriceArray;

// 生成订单号传的id
@property (retain,nonatomic) NSString *TicketdPicedId;



// 往返的机票订单信息
@property (retain,nonatomic) NSMutableArray *firstTicketArray;
@property (retain,nonatomic) NSMutableArray *seconedTicketArray;
// 订单数组
@property (retain,nonatomic) NSMutableArray *allPlayInfo;
@property (retain,nonatomic) NSString *classTicketFist;
@property (retain,nonatomic) NSString *classTicketSecond;
@property (retain,nonatomic) NSMutableArray *airPlayInfoArray;

// 回程票价油税
@property (retain,nonatomic) NSMutableArray *fromTicketPriceArray;
@property (retain,nonatomic) NSMutableArray *backTicketPrice;
// 机票id
@property (retain,nonatomic) NSString *fromPriceTicketId;
@property (retain,nonatomic) NSString *backPriceTicketId;

@property (retain,nonatomic) UITextView *infoTextView;


@end



