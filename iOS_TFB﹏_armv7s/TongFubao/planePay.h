//
//  planePay.h
//  TongFubao
//
//  Created by  俊   on 14-7-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

/*易宝充值接口类型*/
typedef enum {
    YiBaoPayType_None = 0,
    YiBaoPayType_phone,
    YiBaoPayType_ZhuanZhang,        /*转账类型*/
    YiBaoPayType_Game,
    YiBaoPayType_CreditCardPayments,/*信用卡还款*/
    YiBaoPayType_Qcoin,
    YiBaoPayType_Merchantsgathering,/*商户收款*/
    YibaoPlayTicket,                /*飞机票*/
    YiBaoPayType_payMonyPeople,     /*发工资*/
    YiBaoPayType_agentorderPayrq ,
}YiBaoPayType;

#import <UIKit/UIKit.h>
#import "CardInfo.h"

@interface planePay : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UITextFieldDelegate,NLBankLisDelegate,UIAlertViewDelegate>

//银行卡信息
@property (nonatomic, strong) CardInfo *cardInfo;

@property (weak, nonatomic) IBOutlet UILabel *paymoney;
@property (weak, nonatomic) IBOutlet UILabel *paycard;

// 验证码payYZM
@property (weak, nonatomic) IBOutlet UITextField *payYZM;
@property (weak, nonatomic) IBOutlet UITextField *payPhone;
// 卡人payName
// 证件号payId

@property (weak, nonatomic) IBOutlet UITextField *payName;
// 证件号payId
@property (weak, nonatomic) IBOutlet UITextField *payId;
@property (weak, nonatomic) IBOutlet UIButton    *bankList;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UIImageView *bankAcces;

@property (weak, nonatomic) IBOutlet UIView *secondViewBank;
@property (weak, nonatomic) IBOutlet UIView *thirdViewBank;
@property (weak, nonatomic) IBOutlet UIView *firstTFView;
@property (weak, nonatomic) IBOutlet UIView *secondTFView;
@property (weak, nonatomic) IBOutlet UILabel *lableText;

@property (weak, nonatomic) IBOutlet UIImageView *FirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *SecondImage;

@property (weak, nonatomic) IBOutlet UITextField *monthTF;
@property (weak, nonatomic) IBOutlet UITextField *yearTF;

@property (weak, nonatomic) IBOutlet UIImageView *bankhelpView;
@property (weak, nonatomic) IBOutlet UIImageView *bankCvvHelp;

@property (strong, nonatomic)  NSString *paymoneyStr;
@property (strong, nonatomic)  NSString *paycardStr;
@property (strong, nonatomic)  NSString *payphoneNumber;
@property (strong, nonatomic)  NSString *payCard;
@property (strong, nonatomic)  NSString *AddressStr;

@property (strong, nonatomic)  NSString *payRechamoneyStr;
/*转账--刷卡器id*/
@property (strong, nonatomic)  NSString *fucardmobile;
@property (strong, nonatomic)  NSString *fucardman;
/*付款卡号*/
@property (strong, nonatomic)  NSString *sendBankCardId;
/*刷卡器id*/
@property (strong, nonatomic)  NSString *cardReaderId;
/*银行卡名*/
@property (strong, nonatomic)  NSString *bankname;
//优惠券id
@property (strong, nonatomic) NSString *couponid;

/*数据字典*/
@property(nonatomic,strong) NSDictionary *myDictionary;
@property(nonatomic,strong) NSDictionary *agent_Dictionary;

@property(nonatomic,strong) NSArray *arraydic;
@property(nonatomic,strong) NSArray *bankNameArr;

@property(nonatomic,assign) YiBaoPayType myViewYiBaoType;

/*类型*/
@property (strong, nonatomic)  NSString *paytype_check;
/*merReserved*/
@property (strong, nonatomic)  NSString *merReserved;

/*区分掌上银行和便民服务的*/
@property (assign, nonatomic)  BOOL typePayYIBao;
/*机票*/
//乘机人，联系人
@property (retain,nonatomic) NSMutableArray *PayperSonIdArray;
@property (retain,nonatomic) NSMutableArray *PayContactIdArray;
// 单往返票id
@property (retain,nonatomic) NSString *PayTicketBillId;
@property (retain,nonatomic) NSString *playBackTicketId;
// 账号
@property (retain,nonatomic) NSString *PayCarTextString;
// 总价钱
@property (assign,nonatomic) int PayPriceOilTax;

// 订单号
@property(retain,nonatomic)NSString *OrderId;
// 验证码
@property(retain,nonatomic)NSString *verify;
// 类型
@property(retain,nonatomic)NSString *playStyGoBack;

//所属银行
@property (nonatomic, copy) NSString *fucardbank;
//所属银行
@property (nonatomic, copy) NSString *bankID;
@property (nonatomic, assign) int planePayCTT;
@property (nonatomic, copy) NSString *Bankctt;




@end
