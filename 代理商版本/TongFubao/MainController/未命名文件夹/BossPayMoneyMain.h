//
//  BossPayMoneyMain.h
//  TongFubao
//
//  Created by  俊   on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BossPayMoneyCell.h"

@interface BossPayMoneyMain : UIViewController<UIAlertViewDelegate,UINavigationControllerDelegate,BossPayMoneyCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addPeople;
@property (nonatomic,assign) BOOL pushFlag;
@end
