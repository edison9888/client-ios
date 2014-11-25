//
//  NLInOutcomeDetailCell.h
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLInOutcomeDetailCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UILabel* myTypeLabel;
@property(nonatomic,retain) IBOutlet UILabel* myDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* myAmountLabel;
@property(nonatomic,retain) IBOutlet UILabel* myResultLabel;
@property(nonatomic,retain) IBOutlet UIImageView* myBackImageView;

@end
