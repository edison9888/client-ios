//
//  TicketCustomTableViewCell.m
//  TongFubao
//
//  Created by kin on 14-8-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TicketCustomTableViewCell.h"

@implementation TicketCustomTableViewCell
@synthesize nameTicket,timeTicket,priceTicket,discountTicket,modelsTicket,cellImage,titleLable,addNameLable,moneyLable,wacthTimeLable,historTimeLable,historTitleLable,shipTitleLable,endMoneyLable,endorseLable,discountShipLable,PassengerName,PassengerCardType,PassengercardId,selectionBotton,delectionBotton,contactName,contactIphone,infoTextField,savingNameLable,cardImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 机票查询
        self.nameTicket = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 20)];
        self.nameTicket.font = [UIFont systemFontOfSize:16.0];
        self.nameTicket.textColor = [UIColor grayColor];
        [self addSubview:self.nameTicket];
        
        self.priceTicket  = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 20)];
        self.priceTicket.textColor = [UIColor orangeColor];
        self.priceTicket.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:self.priceTicket];
        
        self.discountTicket = [[UILabel alloc]initWithFrame:CGRectMake(260, 10, 30, 20)];
        self.discountTicket.font = [UIFont systemFontOfSize:12];
        self.discountTicket.textColor = [UIColor grayColor];
        [self addSubview:self.discountTicket];
        
        self.timeTicket = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 180, 20)];
        self.timeTicket.textColor = RGBACOLOR(0, 183, 238, 1);
        self.timeTicket.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:self.timeTicket];
        
        self.modelsTicket = [[UILabel alloc]initWithFrame:CGRectMake(200, 35, 100, 20)];
        self.modelsTicket.font = [UIFont systemFontOfSize:10.0];
        self.modelsTicket.textColor = [UIColor grayColor];
        [self addSubview:self.modelsTicket];
        
        self.cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self addSubview:self.cellImage];
        
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, 120, 40)];
        self.titleLable.font = [UIFont systemFontOfSize:20];
        self.titleLable.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLable];
        
        // 历史记录
        self.addNameLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 40)];
        self.addNameLable.font = [UIFont systemFontOfSize:15];
        self.addNameLable.textColor = [UIColor grayColor];
        [self addSubview:self.addNameLable];
        self.moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 90, 40)];
        self.moneyLable.font = [UIFont systemFontOfSize:15];
        self.moneyLable.textColor = [UIColor grayColor];
        [self addSubview:self.moneyLable];
        self.wacthTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(230, 10, 90, 40)];
        self.wacthTimeLable.font = [UIFont systemFontOfSize:15];
        self.wacthTimeLable.textColor = [UIColor grayColor];
        [self addSubview:self.wacthTimeLable];
        
        // 历史详情
        self.historTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 40)];
        self.historTitleLable.font = [UIFont systemFontOfSize:20];
        self.historTitleLable.textColor = RGBACOLOR(19, 193, 245, 1);
        [self addSubview:self.historTitleLable];
        
        self.historTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 150, 40)];
        self.historTimeLable.font = [UIFont systemFontOfSize:16];
        self.historTimeLable.textColor = [UIColor grayColor];
        [self addSubview:self.historTimeLable];
        
        // 舱位选择
        self.shipTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 40)];
        self.shipTitleLable.font = [UIFont systemFontOfSize:15];
        self.shipTitleLable.textColor = [UIColor grayColor];
        [self addSubview:self.shipTitleLable];
        
        self.discountShipLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 40, 40)];
        self.discountShipLable.font = [UIFont systemFontOfSize:12];
        self.discountShipLable.textColor = [UIColor orangeColor];
        [self addSubview:self.discountShipLable];
        
        self.endorseLable = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 40)];
        self.endorseLable.font = [UIFont systemFontOfSize:15];
        self.endorseLable.textColor = [UIColor grayColor];
        [self addSubview:self.endorseLable];
        
        self.endMoneyLable = [[UILabel alloc]initWithFrame:CGRectMake(235, 10, 85, 40)];
        self.endMoneyLable.font = [UIFont systemFontOfSize:18];
        self.endMoneyLable.textColor = [UIColor orangeColor];
        [self addSubview:self.endMoneyLable];
        
        // 添加乘机人
        self.PassengerName = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
        self.PassengerName.font = [UIFont systemFontOfSize:18];
        self.PassengerName.textColor = [UIColor grayColor];
        self.PassengerName.backgroundColor = [UIColor clearColor];
        [self addSubview:self.PassengerName];
        
        self.PassengerCardType = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 100, 25)];
        self.PassengerCardType.font = [UIFont systemFontOfSize:15];
        self.PassengerCardType.textColor = [UIColor grayColor];
        self.PassengerCardType.backgroundColor = [UIColor clearColor];
        [self addSubview:self.PassengerCardType];
        
        self.PassengercardId = [[UILabel alloc]initWithFrame:CGRectMake(105, 25, 150, 25)];
        self.PassengercardId.font = [UIFont systemFontOfSize:15];
        self.PassengercardId.backgroundColor = [UIColor clearColor];
        self.PassengercardId.textColor = [UIColor grayColor];
        [self addSubview:self.PassengercardId];
        
        // 添加乘机人
        self.contactName = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
        self.contactName.font = [UIFont systemFontOfSize:18];
        self.contactName.textColor = [UIColor grayColor];
        self.contactName.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contactName];
        
        self.contactIphone = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 100, 50)];
        self.contactIphone.font = [UIFont systemFontOfSize:15];
        self.contactIphone.textColor = [UIColor grayColor];
        self.contactIphone.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contactIphone];
        // 付临门
        self.savingNameLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 80, 60)];
        self.savingNameLable.font = [UIFont boldSystemFontOfSize:18];
        self.savingNameLable.textColor = [UIColor grayColor];
        [self addSubview:self.savingNameLable];
        
        self.infoTextField =[[UITextField alloc]initWithFrame:CGRectMake(80, 0, 200, 60)];
        self.infoTextField.font = [UIFont systemFontOfSize:16];
        self.infoTextField.hidden = YES;
        self.infoTextField.delegate = self;
        [self addSubview:self.infoTextField];
        
        self.cardImageView =[[UIImageView alloc]initWithFrame:CGRectMake(280, 10, 30, 40)];
        [self addSubview:self.cardImageView];
        
        
        
    }
    return self;
}

-(void)selectionButtonHidde
{
    
    self.selectionBotton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.selectionBotton.frame = CGRectMake(10, 10, 30, 30);
    [self.selectionBotton setImage:[UIImage imageNamed:@"91@2x.png"] forState:(UIControlStateNormal)];
    self.selectionBotton.selected = YES;
    [self.selectionBotton addTarget:self action:@selector(selectionPasseng:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.selectionBotton];
    
    self.delectionBotton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.delectionBotton.frame = CGRectMake(280, 10, 30, 30);
    [self.delectionBotton setImage:[UIImage imageNamed:@"delete2@2x.png"] forState:(UIControlStateNormal)];
    self.delectionBotton.selected = YES;
    [self.delectionBotton addTarget:self action:@selector(delectionPasseng:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.delectionBotton];
    
}

// 航空查询
-(void)nameTicket:(NSString *)newName timeTicket:(NSString *)newTimeTiceket priceTicket:(NSString *)newPriceTicket discountTicket:(NSString *)newDiscountTicket modelsTicket:(NSString *)newModelsTicket
{
    self.nameTicket.text = newName;
    self.priceTicket.text = newTimeTiceket;
    self.discountTicket.text = newPriceTicket;
    self.timeTicket.text = newDiscountTicket;
    self.modelsTicket.text = newModelsTicket;
    
}

// 航空公司
-(void)titleLable:(NSString *)newTileLable  cellImage:(NSString*)newImage
{
    self.titleLable.text = newTileLable;
    self.cellImage.image = [UIImage imageNamed:newImage];
    self.cellImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"9play@2x.png"]];
}

// 历史记录
-(void)addNameLable:(NSString *)newaddNameLable moneyLable:(NSString *)newmoneyLable wacthTimeLable:(NSString *)newwacthTimeLable
{
    self.addNameLable.text = newaddNameLable;
    self.moneyLable.text = newmoneyLable;
    self.wacthTimeLable.text = newwacthTimeLable;
    
}
// 历史详请
-(void)historTitleLable:(NSString *)newhistorTitleLable historTimeLable:(NSString *)newhistorTimeLable
{
    self.historTitleLable.text = newhistorTitleLable;
    self.historTimeLable.text = newhistorTimeLable;
    
}
// 舱位选择
-(void)shipTitleLable:(NSString *)newshipTitleLable discountShipLable:(NSString *)newdiscountShipLable  endorseLable:(NSString *)newendorseLable  endMoneyLable:(NSString *)newendMoneyLable
{
    self.shipTitleLable.text = newshipTitleLable;
    self.discountShipLable.text = newdiscountShipLable;
    self.endMoneyLable.text = newendMoneyLable;
    self.endorseLable.text = newendorseLable;
    
}
//// 添加乘机人
//-(void)addPassengerName:(NSString *)newPassengerName addPassengerCardType:(NSString *)newPassengerCardType addPassengercardId:(NSString *)newPassengercardId
//{
//    self.PassengerName.text = newPassengerName;
//    self.PassengerCardType.text =newPassengerCardType;
//    self.PassengercardId.text = newPassengercardId;
//}
// 添加联系人
//-(void)contactName:(NSString *)newContactName  contactIphone:(NSString *)newContactIphone
//{
//    self.contactName.text = newContactName;
//    self.contactIphone.text = newContactIphone;
//}


// 添加乘机人
-(void)selectionPasseng:(UIButton *)sender
{
    UIButton *passengButton = (UIButton *)sender;
    if (passengButton.selected == YES )
    {
        [passengButton setImage:[UIImage imageNamed:@"9@2x.png"] forState:(UIControlStateNormal)];
        passengButton.selected = NO;
    }
    else
    {
        [passengButton setImage:[UIImage imageNamed:@"91@2x.png"] forState:(UIControlStateNormal)];
        passengButton.selected = YES;
    }
}
// 删除乘机人
-(void)delectionPasseng:(UIButton *)sender
{
    UIButton *passengButton = (UIButton *)sender;
    if (passengButton.selected == YES )
    {
        [passengButton setImage:[UIImage imageNamed:@"delete2_selected@2x.png"] forState:(UIControlStateNormal)];
        passengButton.selected = NO;
    }
    else
    {
        [passengButton setImage:[UIImage imageNamed:@"delete2@2x.png"] forState:(UIControlStateNormal)];
        passengButton.selected = YES;
    }
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





























