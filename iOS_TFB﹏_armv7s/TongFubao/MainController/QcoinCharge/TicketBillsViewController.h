//
//  TicketBillsViewController.h
//  TongFubao
//
//  Created by kin on 14-9-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketBillsViewController : UIViewController<BankPayListDelegate,VisaReaderDelegate,UIAlertViewDelegate>

@property(retain,nonatomic)NSMutableArray *allPriceBillsArray;
@property(retain,nonatomic)NSString *textString;
@property(retain,nonatomic)NSMutableArray *TicketBillFlightInformation;
@property(retain,nonatomic)NSMutableArray *sureInfoArray;

//@property(retain,nonatomic)NSMutableArray *GlobalTicketInformation;

// 生成订单ID
@property(retain,nonatomic)NSString *TicketBillId;
// 接添加乘机人对象
@property(retain,nonatomic)NSMutableArray *TicketBillsArray;
// 接添加联系人对象
@property(retain,nonatomic)NSMutableArray *TicketContactArray;
// 接添加乘机人对象id
@property(retain,nonatomic)NSMutableArray *perSonIdArray;
// 接添加联系人对象id
@property(retain,nonatomic)NSMutableArray *ContactIdArray;
// 订单号
@property(retain,nonatomic)NSString *OrderId;
// 验证码
@property(retain,nonatomic)NSString *verify;

@property(retain,nonatomic)NSString *styGoBack;

// 刷卡年月
@property(retain,nonatomic)NSString *carYearMonth;

// 去回程票id
@property(retain,nonatomic)NSString *goTicketId;
@property(retain,nonatomic)NSString *backTicketId;

@property(retain,nonatomic)NSMutableArray *goTicketArray;
@property(retain,nonatomic)NSMutableArray *backTicketArray;







@end
