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
}YiBaoPayType;

#import <UIKit/UIKit.h>

@interface planePay : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *paymoney;
@property (weak, nonatomic) IBOutlet UILabel *paycard;

@property (weak, nonatomic) IBOutlet UITextField *payYZM;
@property (weak, nonatomic) IBOutlet UITextField *payPhone;
@property (weak, nonatomic) IBOutlet UITextField *payName;
@property (weak, nonatomic) IBOutlet UITextField *payId;

@property (strong, nonatomic)  NSString *paymoneyStr;
@property (strong, nonatomic)  NSString *paycardStr;
@property (strong, nonatomic)  NSString *payRechamoneyStr;
@property (strong, nonatomic)  NSString *payphoneNumber;
@property (strong, nonatomic)  NSString *payCard;
@property (strong, nonatomic)  NSString *AddressStr;

/*转账--刷卡器id*/
@property (strong, nonatomic)  NSString *fucardmobile;
@property (strong, nonatomic)  NSString *fucardman;
/*付款卡号*/
@property (strong, nonatomic)  NSString *sendBankCardId;
/*刷卡器id*/
@property (strong, nonatomic)  NSString *cardReaderId;

/*数据字典*/
@property(nonatomic,strong) NSDictionary *myDictionary;
@property(nonatomic,strong) NSArray *arraydic;
@property(nonatomic,assign) YiBaoPayType myViewYiBaoType;

/*区分掌上银行和便民服务的*/
@property (assign, nonatomic)  BOOL typePayYIBao;

@end
