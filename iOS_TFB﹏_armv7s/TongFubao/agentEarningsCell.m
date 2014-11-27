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
    
         self.contentView.backgroundColor= SACOLOR(245, 1.0);
        
        UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 22, 10, 10)];
        photoImgView.image= [UIImage imageNamed:@"bluedot.png"];
        self.iconCell = photoImgView;
        [self.contentView addSubview:self.iconCell];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 140, 25)];
        nameLabel.font= [UIFont systemFontOfSize:18];
        self.typeCell = nameLabel;
        self.typeCell.text = @"硬件收益";
        [self.contentView addSubview:self.typeCell];
        
        UILabel *comLable = [[UILabel alloc]initWithFrame:CGRectMake(200, 15, 80, 25)];
        comLable.font= [UIFont systemFontOfSize:18];
        self.moneyCell = comLable;
        self.moneyCell.text = @"￥800";
        [self.contentView addSubview:self.moneyCell];
        
        UIImageView *right= [[UIImageView alloc] initWithFrame:(CGRect){260,15,30,30}];
        right.image= [UIImage imageNamed:@"chosenside.png"];
        self.rightIcon = right;
        [self.contentView addSubview:self.rightIcon];

  
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
