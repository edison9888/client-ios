//
//  agentEarningsCell.m
//  TongFubao
//
//  Created by 〝Cow﹏.   on 14-11-17.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "agentEarningsCell.h"

@implementation agentEarningsCell
@synthesize moneyCell,typeCell,iconCell;
- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 22, 10, 10)];
        photoImgView.image= [UIImage imageNamed:@"bluedot.png"];
        self.iconCell = photoImgView;
        [self.contentView addSubview:self.iconCell];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 100, 25)];
        self.typeCell = nameLabel;
        self.typeCell.text = @"硬件收益";
        [self.contentView addSubview:self.typeCell];
        
        UILabel *comLable = [[UILabel alloc]initWithFrame:CGRectMake(220, 15, 100, 25)];
        self.moneyCell = comLable;
        self.moneyCell.text = @"￥800";
        [self.contentView addSubview:self.moneyCell];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
