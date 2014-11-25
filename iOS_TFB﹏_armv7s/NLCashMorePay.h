//
//  NLCashMorePay.h
//  TongFubao
//
//  Created by  俊   on 14-8-25.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ResultOrderQueryPay_Web = 0,
    ResultOrderQueryPay_Table
} NLResultOrderQueryTypePay;

@interface NLCashMorePay : UIViewController<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign)NLResultOrderQueryTypePay myType;
@property (nonatomic, strong) NSArray* myArray;
@property (nonatomic, strong) NSDictionary* myDictionary;
@property (strong, nonatomic) NSString *weburl;
@property (strong, nonatomic) NSString *bknordernumber;
@property (strong, nonatomic) NSString *couponmoneyStr;
@end
