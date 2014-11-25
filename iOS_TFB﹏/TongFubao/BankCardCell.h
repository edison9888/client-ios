//
//  BankCardCell.h
//  TongFubao
//
//  Created by Delpan on 14-8-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardCell : UITableViewCell

//银行卡logo
@property (nonatomic, strong) UIImageView *logoView;

//银行卡名称
@property (nonatomic, strong) UILabel *bankName;

//用户名
@property (nonatomic, strong) UILabel *masterName;

//卡号
@property (nonatomic, strong) UILabel *cardNumber;

//支付卡类型
@property (nonatomic, strong) UILabel *cardType;

//默认卡
@property (nonatomic, strong) UILabel *defaultCard;

@end
