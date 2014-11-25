//
//  SignOnMain.h
//  TongFubao
//
//  Created by  俊   on 14-9-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payMoneyHistory.h"
#import "NLMyBankCardViewController.h"
#import "peopleHadMoneyCell.h"

@interface SignOnMain : UIViewController<UIAlertViewDelegate,UINavigationControllerDelegate,peopleHadMoneyCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lableMoney;
@property (weak, nonatomic) IBOutlet UILabel *lableText;
@property (weak, nonatomic) IBOutlet UIButton *btnOnClick;
@property (weak, nonatomic) IBOutlet UITableView *mytable;
@property (weak, nonatomic) IBOutlet UILabel *lableHeard;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBG;

@end
