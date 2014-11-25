//
//  peopleHadMoneyCell.h
//  TongFubao
//
//  Created by  俊   on 14-10-11.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@class peopleHadMoneyCell;

@protocol peopleHadMoneyCellDelegate <NSObject>

@optional

- (void)delCell:(peopleHadMoneyCell*)cell;

@end

@interface peopleHadMoneyCell : UITableViewCell
@property (nonatomic, weak) id<peopleHadMoneyCellDelegate>  peopleHadMoneyCellDelegate;
@property (weak, nonatomic) IBOutlet UIButton *onbtnClick;
@property (weak, nonatomic) IBOutlet UILabel *onMoney;

- (IBAction)btnSelectAction:(id)sender;
@end
