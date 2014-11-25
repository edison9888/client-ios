//
//  BankCardCell.h
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-8-8.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CacheView : UIImageView
{
    BOOL loadImage;
    /*图片*/
    NSMutableArray *images;
    /*图片url*/
    NSMutableArray *urls;
}

/*下载银行卡图片logo*/
- (void)imageWitwURL:(NSString *)url;

@end

@interface BankCardCell : UITableViewCell
{
    BOOL loadImage;
}

//银行卡logo
@property (nonatomic, strong) CacheView *logoView;

//银行卡名称
@property (nonatomic, strong) UILabel *bankName;

//用户名
@property (nonatomic, strong) UILabel *masterName;

//卡号
@property (nonatomic, strong) UILabel *cardNumber;

//支付卡类型
@property (nonatomic, strong) UILabel *cardType;

//默认支付卡
@property (nonatomic, strong) UIButton *defaultCard;

//默认收款卡
@property (nonatomic, strong) UIButton *receivables;/*雨*/

//下载logo
- (void)imageWitwURL:(NSString *)url;

@end


