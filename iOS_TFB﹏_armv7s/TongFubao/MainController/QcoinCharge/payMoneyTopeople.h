//
//  payMoneyTopeople.h
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payMoneyPeopleMore.h"
#import "watchTimeObject.h"
#import "UPPayPlugin.h"
#import "CustomTable.h"

@interface payMoneyTopeople : UIViewController<UPPayPluginDelegate,UITextFieldDelegate,CustomTabelDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSDictionary *dic;

@property (retain,nonatomic) NSString *departDate;

@property (weak, nonatomic) IBOutlet UIButton *backTobtn;
@property (weak, nonatomic) IBOutlet UIButton *NotPayBtn;
@property (weak, nonatomic) IBOutlet UILabel *LableText;
@property (nonatomic,assign) BOOL URLpaymonthwage;/*支付工资*/
@property (nonatomic,assign) BOOL URLreadwagelists;/*读取工资*/
@property (nonatomic,assign) BOOL dissFlag;
@end
