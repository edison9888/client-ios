//
//  SavingsCardViewController.h
//  TongFubao
//
//  Created by kin on 14/10/21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisaReader.h"

typedef enum
{
    TableViewHistoricalAccountRowType = 0,
    TableViewCardNunberRowType,
    TableViewCardBankRowType,
    TableViewCardNameRowType,
    TableViewCardMobileRowType,
    TableViewPayMoneyRowType
} CreditCardTableViewRowType;

@interface SavingsCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,VisaReaderDelegate,UITextFieldDelegate>


@property(retain,nonatomic)UITableView *SavingsCardTableView;
@property(retain,nonatomic)NSArray *titleArray;


@end
