//
//  AddressPAY.h
//  TongFubao
//
//  Created by  俊   on 14-5-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLKeyboardAvoid.h"

@interface AddressPAY : UIViewController<UITextFieldDelegate>

@property(nonatomic,strong)IBOutlet NLKeyboardAvoidingTableView* myTableView;

@property (assign,nonatomic) BOOL PYBankflage;

@property (strong, nonatomic) NSString *PhoneStr;

@property (strong, nonatomic) NSString *NameStr;

@property (strong, nonatomic) NSString *AllAddressStr;//详细地址

@property (strong, nonatomic) NSString *ProvinceStr;//省份

@property (strong, nonatomic) NSString *CityStr;//城市

@property (strong, nonatomic) NSString *ZoneStr;

@property (strong, nonatomic) NSString *AreaStr;//门牌号的

@property (strong, nonatomic) NSString *PatientiaAddressStr;//默认地址

@property (assign,nonatomic) BOOL payAgentFlage;

//不够买放弃返利
@property (assign,nonatomic) BOOL UpPayFlage;
@end
