//
//  SMSPaymentHistoryCell.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-10.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSPaymentHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *phone;//电话
@property (weak, nonatomic) IBOutlet UILabel *transactionDtae;//交易日期
@property (weak, nonatomic) IBOutlet UILabel *amountOfMoney;//金额
@property (weak, nonatomic) IBOutlet UILabel *transactionState;//交易状态


@end
