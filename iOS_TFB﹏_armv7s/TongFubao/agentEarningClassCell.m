//
//  agentEarningClassCell.m
//  TongFubao
//
//  Created by 〝Cow﹏.   on 14-11-17.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "agentEarningClassCell.h"

@implementation agentEarningClassCell
@synthesize moneycell,typecell,iconcell;

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(43, 18, 10, 10)];
        photoImgView.image= [UIImage imageNamed:@"yellowdot.png"];
        self.iconcell = photoImgView;
        [self.contentView addSubview:self.iconcell];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(63, 10, 100, 25)];
        nameLabel.textColor= [UIColor lightGrayColor];
        nameLabel.backgroundColor= [UIColor clearColor];
        self.typecell = nameLabel;
        self.typecell.text = @"手机收益";
        [self.contentView addSubview:self.typecell];
        
        UILabel *comLable = [[UILabel alloc]initWithFrame:CGRectMake(220, 10, 100, 25)];
        comLable.textColor= [UIColor lightGrayColor];
        self.moneycell = comLable;
        self.moneycell.text = @"￥800";
        [self.contentView addSubview:self.moneycell];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
