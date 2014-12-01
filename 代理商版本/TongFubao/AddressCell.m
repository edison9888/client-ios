//
//  TFAgentSearchListCell.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-5-13.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell ()

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *iconName;

@property (nonatomic,strong) UIImageView *iconPhone;
@property (nonatomic,strong) UIImageView *iconAddress;
@property (nonatomic,strong) UIView *contentBg;

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *phone;
@property (nonatomic,strong) UILabel *Address;

@end

@implementation AddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        //背景
       _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(28, 14, 268, 103)];
       [self.contentView addSubview:_bgImageView];
        
        //线条
        UIImageView *lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 3, 130)];
        [lineImg setImage:[UIImage imageNamed:@"acis"]];
        [self.contentView addSubview:lineImg];
        
        //圆形按钮
        _roundView =  [[UIImageView alloc]initWithFrame:CGRectMake(14, 40, 14, 14)];
        [_roundView setImage:[UIImage imageNamed:@"dot_nomarl"]];
        [self.contentView addSubview:_roundView];
        
       _contentBg= [[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 250, 160)];
       _contentBg.backgroundColor = [UIColor clearColor];
        
      [self.contentView addSubview:_contentBg];
      
        _iconName = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 13, 19)];
        _iconPhone= [[UIImageView alloc]initWithFrame:CGRectMake(30, 40, 13, 19)];
        _iconAddress= [[UIImageView alloc]initWithFrame:CGRectMake(30, 70, 13, 19)];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(54, 10, 230, 20)];
        _name.textAlignment = UITextAlignmentLeft;
        _name.font = [UIFont fontWithName:TFB_FONT size:14];
        _name.backgroundColor = [UIColor clearColor];
        _name.textColor = [UIColor grayColor];
        _phone = [[UILabel alloc]initWithFrame:CGRectMake(54, 40, 230, 20)];
        _phone.textAlignment = UITextAlignmentLeft;
        _phone.font = [UIFont fontWithName:TFB_FONT size:14];
        _phone.backgroundColor = [UIColor clearColor];
        _phone.textColor = [UIColor grayColor];
        _Address = [[UILabel alloc]initWithFrame:CGRectMake(54, 70, 230, 20)];
        _Address.font = [UIFont fontWithName:TFB_FONT size:14];
        _Address.textAlignment = UITextAlignmentLeft;
        _Address.backgroundColor = [UIColor clearColor];
        _Address.textColor = RGBACOLOR(242, 131, 11, 1.0);
        
         self.contentView.backgroundColor = [UIColor clearColor];
        [_contentBg addSubview:_iconName];
        [_contentBg addSubview:_iconAddress];
        [_contentBg addSubview:_iconPhone];
        [_contentBg addSubview:_name];
        [_contentBg addSubview:_phone];
        [_contentBg addSubview:_Address];
        
        _bgImageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [_bgImageView addGestureRecognizer:longRecognizer];
    }
    return self;
}

//长按
-(void)longPress:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state== UIGestureRecognizerStateBegan) {
        if (self.listCellDelegate&&[self.listCellDelegate respondsToSelector:@selector(longPressCell:)]) {
            [self.listCellDelegate longPressCell:self];
        }
    }
}

- (void)awakeFromNib
{
    // Initialization code
}


-(void)setData:(NSDictionary *)dict withRow:(NSInteger )row
{
    _name.text = [NSString stringWithFormat:@"%@",dict[KEY_SKQPAY_AddressName]];
    _phone.text = [NSString stringWithFormat:@"%@",dict[KEY_SKQPAY_AddressPhone]];
    _Address.text = [NSString stringWithFormat:@"%@",dict[KEY_SKQPAY_AllAddress]];
    
    switch (row) {
        case 0:
            [_bgImageView setImage:[UIImage imageNamed:@"blue_textfield"]];
            [_iconName setImage:[UIImage imageNamed:@"blue_name@2x"]];
            [_iconPhone setImage:[UIImage imageNamed:@"blue_phone@2x"]];
            [_iconAddress setImage:[UIImage imageNamed:@"blue_posittion_@2x"]];
            
            break;
            
        case 1:
            [_bgImageView setImage:[UIImage imageNamed:@"lgreen_textfield"]];
            [_iconName setImage:[UIImage imageNamed:@"lgreen_name@2x"]];
            [_iconPhone setImage:[UIImage imageNamed:@"Lgreen_phone@2x"]];
            [_iconAddress setImage:[UIImage imageNamed:@"lgreen_position@2x"]];

            break;
            
        case 2:
            [_bgImageView setImage:[UIImage imageNamed:@"Dgreen_textfield"]];
            [_iconName setImage:[UIImage imageNamed:@"Dgreen_name@2x"]];
            [_iconPhone setImage:[UIImage imageNamed:@"Dgreen_phone@2x"]];
            [_iconAddress setImage:[UIImage imageNamed:@"Dgreen_position@2x"]];
            break;
            
        default:
            break;
    }
}

@end


@interface PayPeopleCellList ()

@property (nonatomic,strong) UIImageView *bgImageView;
@end

@implementation PayPeopleCellList

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (_HeadViewFlag==YES) {
            
            _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 320, 90)];
            _bgImageView.backgroundColor= [UIColor redColor];
            [self.contentView addSubview:_bgImageView];
            
            _lableText= [[UILabel alloc]initWithFrame:CGRectMake(16, 15, 300, 15)];
            _lableText.text= [NSString stringWithFormat:@"总共%@名员工，发放总额%@元",@"15",@"19800.00"];
            [_bgImageView addSubview:_lableText];
     
            UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(10, 47, 300, 2)];
            img.image= [UIImage imageNamed:@"dashed_line.png"];
            [_bgImageView addSubview:img];
            
            UILabel *lable= [[UILabel alloc]initWithFrame:CGRectMake( 15, 65, 300, 17)];
            lable.text= [NSString stringWithFormat:@"手机号               姓名          本月工资"];
            [_bgImageView addSubview:lable];
            
            UIImageView *backImg= [[UIImageView alloc]initWithFrame:CGRectMake(280, 7.5, 30, 30)];
            backImg.image=  [UIImage imageNamed: @"chosenside.png"];
            [_bgImageView addSubview:backImg];
            
            
        }else{
            //背景
            _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 320, 30)];
            [self.contentView addSubview:_bgImageView];
            
            _LbPhone = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 110, 20)];
            _LbPhone.textAlignment = UITextAlignmentLeft;
            _LbPhone.font = [UIFont fontWithName:TFB_FONT size:13];
            _LbPhone.backgroundColor = [UIColor clearColor];
            _LbPhone.textColor = [UIColor grayColor];
            
            _LbName = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 60, 20)];
            _LbName.textAlignment = UITextAlignmentLeft;
            _LbName.font = [UIFont fontWithName:TFB_FONT size:16];
            _LbName.backgroundColor = [UIColor clearColor];
            _LbName.textColor = [UIColor grayColor];
            
            _LbMoney = [[UILabel alloc]initWithFrame:CGRectMake(220, 5, 120, 20)];
            _LbMoney.textAlignment = UITextAlignmentLeft;
            _LbMoney.font = [UIFont fontWithName:TFB_FONT size:16];
            _LbMoney.backgroundColor = [UIColor clearColor];
            _LbMoney.textColor = [UIColor grayColor];
            
            [_bgImageView addSubview:_LbPhone];
            [_bgImageView addSubview:_LbName];
            [_bgImageView addSubview:_LbMoney];

        }
    }
    return self;
}

-(void)setData:(NSDictionary *)dict withRow:(NSInteger )row
{
    if (_HeadViewFlag==NO) {
        
        _LbName.text = [NSString stringWithFormat:@"%@",dict[PAY_PEOPLE_NAME]];
        _LbPhone.text = [NSString stringWithFormat:@"%@",dict[PAY_PEOPLE_PHONE]];
        _LbMoney.text = [NSString stringWithFormat:@"￥%@",dict[PAY_PEOPLE_MONEY]];
    }else{
      /*几名 总共发放*/
    }
}

@end
