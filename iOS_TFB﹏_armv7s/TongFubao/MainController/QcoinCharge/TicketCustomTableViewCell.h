//
//  TicketCustomTableViewCell.h
//  TongFubao
//
//  Created by kin on 14-8-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketCustomTableViewCell : UITableViewCell<UITextFieldDelegate>
@property(retain,nonatomic)UILabel *nameTicket;
@property(retain,nonatomic)UILabel *timeTicket;
@property(retain,nonatomic)UILabel *priceTicket;
@property(retain,nonatomic)UILabel *discountTicket;
@property(retain,nonatomic)UILabel *modelsTicket;

@property(retain,nonatomic)UILabel *titleLable;
@property(retain,nonatomic)UIImageView *cellImage;

// 历史记录
@property(retain,nonatomic)UILabel *addNameLable;
@property(retain,nonatomic)UILabel *moneyLable;
@property(retain,nonatomic)UILabel *wacthTimeLable;

// 历史详情
@property (retain,nonatomic)UILabel *historTitleLable;
@property (retain,nonatomic)UILabel *historTimeLable;

// 舱位选择
@property (retain,nonatomic)UILabel *shipTitleLable;
@property (retain,nonatomic)UILabel *discountShipLable;
@property (retain,nonatomic)UILabel *endorseLable;
@property (retain,nonatomic)UILabel *endMoneyLable;

// 添加乘机人
@property (retain,nonatomic)UILabel *PassengerName;
@property (retain,nonatomic)UILabel *PassengerCardType;
@property (retain,nonatomic)UILabel *PassengercardId;
@property (retain,nonatomic)UIButton *selectionBotton;
@property (retain,nonatomic)UIButton *delectionBotton;


// 添加联系人
@property (retain,nonatomic)UILabel *contactName;
@property (retain,nonatomic)UILabel *contactIphone;


// 付临门
@property(retain,nonatomic)UITextField *infoTextField;
@property (retain,nonatomic)UILabel *savingNameLable;
@property (retain,nonatomic)UIImageView *cardImageView;




// 查询订票
-(void)nameTicket:(NSString *)newName timeTicket:(NSString *)newTimeTiceket priceTicket:(NSString *)newPriceTicket discountTicket:(NSString *)newDiscountTicket modelsTicket:(NSString *)newModelsTicket;

// 航空公司
-(void)titleLable:(NSString *)newTileLable  cellImage:(NSString*)newImage;

// 历史记录
-(void)addNameLable:(NSString *)newaddNameLable moneyLable:(NSString *)newmoneyLable wacthTimeLable:(NSString *)newwacthTimeLable;

// 历史详情
-(void)historTitleLable:(NSString *)newhistorTitleLable historTimeLable:(NSString *)newhistorTimeLable;

// 舱位选择
-(void)shipTitleLable:(NSString *)newshipTitleLable discountShipLable:(NSString *)民newdiscountShipLable  endorseLable:(NSString *)newendorseLable  endMoneyLable:(NSString *)newendMoneyLable;

// 添加乘机人
//-(void)addPassengerName:(NSString *)newPassengerName addPassengerCardType:(NSString *)newPassengerCardType addPassengercardId:(NSString *)newPassengercardId;
//-(void)selectionButtonHidde;

// 添加联系人
//-(void)contactName:(NSString *)newContactName  contactIphone:(NSString *)newContactIphone;


@end






















