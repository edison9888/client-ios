//
//  ACTwoAgentsCell.h
//  TFB_代理商界面
//
//  Created by 湘郎 on 14-11-25.
//  Copyright (c) 2014年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACTwoAgentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *twoAgentsLogo;//代理商LOGO
@property (weak, nonatomic) IBOutlet UILabel *agentsNo;//代理商号
@property (weak, nonatomic) IBOutlet UILabel *profitContribution;//分润贡献
@property (weak, nonatomic) IBOutlet UILabel *thePercentageOfProfit;//分润百分比
@end
