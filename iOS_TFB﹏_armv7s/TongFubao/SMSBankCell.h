//
//  SMSBankCell.h
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSBankCell : UITableViewCell

/*
{
    BOOL loadImage;
}

//下载银行卡图片logo
- (void)imageWitwURL:(NSString *)url;
*/
 
@property (weak, nonatomic) IBOutlet UIImageView *bankLOGO;//银行LOGO
@property (weak, nonatomic) IBOutlet UILabel *bank;//银行名称
@property (weak, nonatomic) IBOutlet UILabel *name;//用户名称
@property (weak, nonatomic) IBOutlet UILabel *tailNumber;//银行尾号
@property (weak, nonatomic) IBOutlet UILabel *bankCard;//银行卡类型
@property (weak, nonatomic) IBOutlet UILabel *receivablesPayment;//收款/支付
@property (weak, nonatomic) IBOutlet UIImageView *receivablesPaymentImageView;//收款/支付背景颜色





@end
