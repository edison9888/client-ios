//
//  TFAgentAddgoodsCell.m
//  TongFubao
//
//  Created by ec on 14-5-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFAgentAddgoodsCell.h"

@interface TFAgentAddgoodsCell()

@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel *num;
@property (nonatomic,strong) UILabel *sendState;
@property (nonatomic,strong) UIButton *receiveState;

@end

@implementation TFAgentAddgoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        _time = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 55, 25)];
        _time.textColor = [UIColor grayColor];
        _time.font = [UIFont fontWithName:TFB_FONT size:13];
        _time.backgroundColor = [UIColor clearColor];
        
        _num = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 130, 25)];
        _num.textColor = [UIColor grayColor];
        _num.textAlignment = UITextAlignmentRight;
        _num.font = [UIFont fontWithName:TFB_FONT size:13];
        _num.backgroundColor = [UIColor clearColor];
        
        _sendState = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 55, 25)];
        _sendState.textColor = RGBACOLOR(237, 132, 11, 1.0);
        _sendState.font = [UIFont fontWithName:TFB_FONT size:13];
        _sendState.backgroundColor = [UIColor clearColor];
        
        _receiveState = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveState.frame = CGRectMake(265, 10, 45, 26);
        _receiveState.titleLabel.font = [UIFont fontWithName:TFB_FONT size:13];
        [_receiveState addTarget:self action:@selector(cellClickReceive) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_time];
        [self.contentView addSubview:_num];
        [self.contentView addSubview:_sendState];
        [self.contentView addSubview:_receiveState];
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
    _time.text = dict[KEY_AGENT_ORDER_TIME];
    _num.text = [NSString stringWithFormat:@"%@", dict[KEY_AGENT_ORDER_NUM]];

    if ([dict[KEY_AGENT_ORDER_SENDSTATE]integerValue] == 0)
    {
        _sendState.text = @"未发货";
        
        _receiveState.userInteractionEnabled = NO;
        [_receiveState setTitleColor:RGBACOLOR(170, 173, 179, 1.0) forState:UIControlStateNormal];
        [_receiveState setBackgroundImage:[UIImage imageNamed:@"unnabe_gray_btn"] forState:UIControlStateNormal];
        [_receiveState setTitle:@"收货" forState:UIControlStateNormal];
        
    }
    else
    {
        _sendState.text = @"已发货";
        
        if ([dict[KEY_AGENT_ORDER_RECEIVESTATE]integerValue] == 0)
        {
            _receiveState.userInteractionEnabled = YES;
            [_receiveState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_receiveState setTitle:@"收货" forState:UIControlStateNormal];
            [_receiveState setBackgroundImage:[UIImage imageNamed:@"goods_small_btn_normal"] forState:UIControlStateNormal];
            [_receiveState setBackgroundImage:[UIImage imageNamed:@"goods_small_btn_selected"] forState:UIControlStateHighlighted];
        }
        else
        {
            _receiveState.userInteractionEnabled = NO;
            [_receiveState setTitle:@"已收" forState:UIControlStateNormal];
            [_receiveState setTitleColor:RGBACOLOR(67, 194, 237, 1.0) forState:UIControlStateNormal];
            [_receiveState setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    
}

-(void)cellClickReceive
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickReceive:)])
    {
        [self.delegate cellClickReceive:self];
    }
}


@end















