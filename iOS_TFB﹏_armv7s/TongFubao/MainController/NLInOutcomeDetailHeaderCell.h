//
//  NLInOutcomeDetailHeaderCell.h
//  TongFubao
//
//  Created by MD313 on 13-8-6.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLInOutcomeDetailHeaderCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UIButton* myArrowBtn;
@property(nonatomic,retain) IBOutlet UILabel* myIncomeLabel;
@property(nonatomic,retain) IBOutlet UILabel* myOutcomeLabel;
@property(nonatomic,retain) IBOutlet UILabel* myMonthLabel;
@property(nonatomic,retain) id myContainer;
@property(nonatomic,assign) BOOL myDownArrow;

@end
