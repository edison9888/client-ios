//
//  NLHistoricalAccountCell.m
//  TongFubao
//
//  Created by jiajie on 13-12-30.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "NLHistoricalAccountCell.h"

@implementation NLHistoricalAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
       UIImageView *_bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 45)];
        self.bgimage= _bgImageView;
        [self.contentView addSubview:_bgImageView];
     
        UILabel *phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(6, 11, 106, 21)];
        phoneLable.font= [UIFont systemFontOfSize:16];
        self.myCardNumberLabel = phoneLable;
        [self.contentView addSubview:self.myCardNumberLabel];
        
        UILabel *comLable = [[UILabel alloc]initWithFrame:CGRectMake(106, 11, 106, 21)];
        comLable.textAlignment= NSTextAlignmentCenter;
        comLable.font= [UIFont systemFontOfSize:16];
        self.myCardBankLabel = comLable;
        [self.contentView addSubview:self.myCardBankLabel];
        
        UILabel *cardLable = [[UILabel alloc]initWithFrame:CGRectMake(213, 11, 106, 21)];
        cardLable.font= [UIFont systemFontOfSize:16];
        cardLable.textAlignment= NSTextAlignmentCenter;
        self.myCardNameLabel = cardLable;
        [self.contentView addSubview:self.myCardNameLabel];

        //线条
        UIImageView *lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, 1)];
        [lineImg setImage:[UIImage imageNamed:@"line1_pla.png"]];
        [self.contentView addSubview:lineImg];
        
        _bgImageView.userInteractionEnabled = YES;

        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longCell:)];
        [self.bgimage addGestureRecognizer:longRecognizer];
    }
    return self;
}

//长按
-(void)longCell:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state== UIGestureRecognizerStateBegan) {
        if (self.listlongDelegate&&[self.listlongDelegate respondsToSelector:@selector(longCell:)]) {
            [self.listlongDelegate longCell:self];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
