//
//  planeaddpeople.m
//  TongFubao
//
//  Created by  俊   on 14-7-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "planeaddpeoplecell.h"
@interface planeaddpeoplecell ()

@end
@implementation planeaddpeoplecell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
     
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.backgroundColor= RGBACOLOR(245, 245, 245, 1);
        [self.contentView addSubview:_bgImageView];
        
        _contentBg= [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 58)];
        _contentBg.backgroundColor = [UIColor clearColor];
        [self.contentView insertSubview:_bgImageView atIndex:0];
        [self.contentView addSubview:_contentBg];

        _BtnIson= [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnIson.frame= CGRectMake(16, 15, 30, 30);
        [_BtnIson setBackgroundImage:[UIImage imageNamed:@"91.png"] forState:UIControlStateNormal];
        _BtnIson.tag= 101;
        [_BtnIson addTarget:self action:@selector(btnIsonAciton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView insertSubview:_BtnIson atIndex:1];
        [_contentBg addSubview:_BtnIson];
        
        _BtnModification= [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnModification.frame= CGRectMake(274, 15, 30, 30);
        [_BtnModification setBackgroundImage:[UIImage imageNamed:@"85.png"] forState:UIControlStateNormal];
        [_BtnModification setBackgroundImage:[UIImage imageNamed:@"911.png"] forState:UIControlStateSelected];
        
        _BtnModification.tag= 102;
        [_BtnModification addTarget:self action:@selector(btnIsonAciton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentBg addSubview:_BtnModification];

        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(54, 20, 120, 20)];
        _name.textAlignment = UITextAlignmentLeft;
        _name.font = [UIFont fontWithName:TFB_FONT size:18];
        _name.backgroundColor = [UIColor clearColor];
        _name.textColor = [UIColor grayColor];
        [_contentBg addSubview:_name];
        
        _peopleid = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 180, 15)];
        _peopleid.textAlignment = UITextAlignmentLeft;
        _peopleid.font = [UIFont fontWithName:TFB_FONT size:13];
        _peopleid.backgroundColor = [UIColor clearColor];
        _peopleid.textColor = [UIColor grayColor];
        [_contentBg addSubview:_peopleid];

        
        _peonumber = [[UILabel alloc]initWithFrame:CGRectMake(80, 35, 260, 15)];
        _peonumber.textAlignment = UITextAlignmentLeft;
        _peonumber.font = [UIFont fontWithName:TFB_FONT size:13];
        _peonumber.backgroundColor = [UIColor clearColor];
        _peonumber.textColor = [UIColor grayColor];
        [_contentBg addSubview:_peonumber];

        
        
    }
    return self;
}

-(void)btnIsonAciton:(UIButton*)sender
{
    [_BtnIson setBackgroundImage:[UIImage imageNamed:@"9.png"] forState:UIControlStateSelected];

}

/*把对应的值传过去*/
-(void)setData:(NSDictionary *)dict
{
    
    
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
