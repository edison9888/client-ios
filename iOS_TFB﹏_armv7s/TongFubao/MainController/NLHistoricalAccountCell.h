//
//  NLHistoricalAccountCell.h
//  TongFubao
//
//  Created by jiajie on 13-12-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NLHistoricalAccountCell;
@protocol NLHistoricalAccountCellDelegate <NSObject>
@optional
-(void)longCell:(NLHistoricalAccountCell*)cell;
@end

@interface NLHistoricalAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgimage;
@property (strong, nonatomic) IBOutlet UILabel *myCardNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *myCardBankLabel;
@property (strong, nonatomic) IBOutlet UILabel *myCardNameLabel;
@property (nonatomic, weak) id<NLHistoricalAccountCellDelegate>  listlongDelegate;

@end
