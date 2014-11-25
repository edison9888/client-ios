//
//  LoginCell.m
//  TongFubao
//
//  Created by  俊   on 14-5-27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.bgImageView= [[UIImageView alloc]initWithFrame:CGRectMake(16, 15, 298, 50)];
        self.bgImageView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_field"]];
        [self.contentView addSubview:self.bgImageView];
        
        self.Icon= [[UIImageView alloc]initWithFrame:CGRectMake(15.5, 5, 20, 20)];
        self.Icon.image= [UIImage imageNamed:@"lock"];
        self.TextView= [[UIImageView alloc]initWithFrame:CGRectMake(40, 5, 298, 40)];
        
        self.textfiled= [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 280, 30)];
        self.textfiled.userInteractionEnabled= YES;
        [self.bgImageView addSubview:self.Icon];
        [self.bgImageView addSubview:self.textfiled];
        [self.bgImageView addSubview:self.TextView];
        
    }
    return self;
}

-(void)setData{
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
