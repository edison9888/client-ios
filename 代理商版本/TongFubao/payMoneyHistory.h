//
//  payMoneyHistory.h
//  TongFubao
//
//  Created by  俊   on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"

@interface payMoneyHistory : UIViewController<UITextFieldDelegate,HeadViewDelegate>

@property (weak, nonatomic) IBOutlet UIView   *ViewA;
@property (weak, nonatomic) IBOutlet UILabel  *LableText;
@property (nonatomic,assign) BOOL flagSingOn;
@property (nonatomic,strong) NSString         *LBName;
@property (nonatomic,strong) NSString         *LBMoney;
@property (nonatomic,strong) NSString         *LBPhone;
@property (nonatomic,strong) NSDictionary     *dic;
@property (nonatomic,strong) NSMutableArray   *MainArray;
@property (nonatomic,strong) NSMutableArray   *pictypenames;
@end
