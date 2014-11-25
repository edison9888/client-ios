//
//  BossPayMoneyCell.h
//  TongFubao
//
//  Created by  俊   on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BossPayMoneyCell;

@protocol BossPayMoneyCellDelegate <NSObject>

@optional

- (void)delCell:(BossPayMoneyCell*)cell;

@end

@interface BossPayMoneyCell : UITableViewCell

@property (nonatomic, weak) id<BossPayMoneyCellDelegate>  BossPayMoneyCellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *LaManId;
@property (weak, nonatomic) IBOutlet UILabel *LaPhone;
@property (weak, nonatomic) IBOutlet UILabel *LabaleName;
@property (weak, nonatomic) IBOutlet UILabel *LableMoney;
@property (weak, nonatomic) IBOutlet UILabel *LableIsOn;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@property(nonatomic,assign) BOOL myDownArrow;

@end
