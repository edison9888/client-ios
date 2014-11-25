//
//  MobileRechangeHistoryCell.m
//  TongFubao
//
//  Created by ec on 14-4-27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "MobileRechangeHistoryCell.h"

@interface MobileRechangeHistoryCell ()

@property (nonatomic,strong) UILabel *firstLabel;
@property (nonatomic,strong) UILabel *secondLabel;
@property (nonatomic,strong) UILabel *thirdLabel;

@end

@implementation MobileRechangeHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 30)];
        _firstLabel.font = [UIFont systemFontOfSize:14];
        _firstLabel.textAlignment = NSTextAlignmentCenter;
        _firstLabel.backgroundColor = [UIColor clearColor];
        _firstLabel.textColor = [UIColor grayColor];
        
        _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 100, 30)];
        _secondLabel.font = [UIFont systemFontOfSize:14];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.backgroundColor = [UIColor clearColor];
        _secondLabel.textColor = [UIColor grayColor];
        
        _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 120, 30)];
        _thirdLabel.font = [UIFont systemFontOfSize:14];
        _thirdLabel.textAlignment = NSTextAlignmentCenter;
        _thirdLabel.backgroundColor = [UIColor clearColor];
        _thirdLabel.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:_firstLabel];
        [self.contentView addSubview:_secondLabel];
        [self.contentView addSubview:_thirdLabel];
    }
    return self;
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

-(void)setData:(NSDictionary *)dict
{
    _firstLabel.text = dict[@"rechamobile"];
    _secondLabel.text = dict[@"rechamoney"];
    _thirdLabel.text = dict[@"rechadatetime"];
}

-(void)setQcoinData:(NSDictionary *)dict
{
    _firstLabel.text = dict[@"rechamobile"];
    _secondLabel.text = dict[@"rechamoney"];
    _thirdLabel.text = dict[@"rechadatetime"];
}

-(void)setSKQData:(NSDictionary *)dict
{
    _firstLabel.text = dict[@"orderprodurename"];
    _secondLabel.text = dict[@"ordermoney"];
    _thirdLabel.text = dict[@"ordershman"];
}

-(void)setWaterElecData:(NSDictionary *)dict
{
    _firstLabel.text = dict[@"bkntno"];
    _secondLabel.text = dict[@"payNumber"];
    _thirdLabel.text = dict[@"completeTime"];
}

-(void)setGameChargeData:(NSDictionary *)dict
{
    _firstLabel.text = dict[@"gamename"];
    _secondLabel.text = dict[@"totalPrice"];
    _thirdLabel.text = dict[@"completeTime"];
}

@end
