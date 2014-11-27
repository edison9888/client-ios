//
//  BackTripTicketView.m
//  TongFubao
//
//  Created by kin on 14-9-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BackTripTicketView.h"
#import "watchTimeObject.h"
#import "TimerButtonView.h"
#import "AirFilterView.h"
#import "TicketCustomTableViewCell.h"

#define STATABLEHIETH 45
#define MOVEHIETH -50

@implementation BackTripTicketView

@synthesize BackTripTicketTableView,leftTicket,rigthTicket,PaiXuaAllArray,temporaryPaiXuaAllArray,CityKey,tapGesture;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // 筛选
        
        
        // 筛选
        PM = 0;
        Time = 0;
        Price = 0;
        Play = 0;
        self.backgroundColor = [UIColor redColor];
        
        
        
        // 视图
        self.BackTripTicketTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-STATABLEHIETH)];
        self.BackTripTicketTableView.delegate = self;
        self.BackTripTicketTableView.dataSource = self;
        [self addSubview:self.BackTripTicketTableView];
        self.tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        self.tapGesture.numberOfTapsRequired = 1;
        self.tapGesture.enabled = NO;
        [self.BackTripTicketTableView addGestureRecognizer:self.tapGesture];
        //向左向右都可以
        UISwipeGestureRecognizer *Leftswipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction)];
        Leftswipe.direction=UISwipeGestureRecognizerDirectionLeft;
        [self.BackTripTicketTableView addGestureRecognizer:Leftswipe];
        UISwipeGestureRecognizer *Rightswipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(RightSwipeAction)];
        Rightswipe.direction=UISwipeGestureRecognizerDirectionRight;
        [self.BackTripTicketTableView addGestureRecognizer:Rightswipe];
        
        

        
        // 左视图
        self.leftTicket = [[leftView alloc]initWithFrame:CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5)];
        self.leftTicket.delegate = self;
        self.leftTicket.layer.shadowOffset = CGSizeMake(3, -3);
        self.leftTicket.layer.shadowRadius = 2.0f;
        self.leftTicket.layer.shadowOpacity = 0.4f;
        self.leftTicket.layer.borderColor = [UIColor blackColor].CGColor;
        selectionButton = YES;
        [self addSubview:self.leftTicket];
        // 右视图
        self.rigthTicket = [[RigthView alloc]initWithFrame:CGRectMake(320, MOVEHIETH, 160, self.frame.size.height+5) ];
        self.rigthTicket.delegate = self;
        self.rigthTicket.layer.shadowOffset = CGSizeMake(-3,-3);
        self.rigthTicket.layer.shadowRadius = 2.0f;
        self.rigthTicket.layer.shadowOpacity = 0.4f;
        self.rigthTicket.layer.borderColor = [UIColor blackColor].CGColor;
        rigthButton = YES;
        [self addSubview:self.rigthTicket];
        
        
        // 航空分类按钮
        _AirView = [[AirFilterView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-STATABLEHIETH, 320, STATABLEHIETH)];
        _AirView.delegate = self;
        [self addSubview:_AirView];
        
        // 排序类
        _airPlayPaixu = [[AirPlayPaixuObject alloc]init];
        
        
    }
    return self;
}
// 传出列表数据和航空数据
-(void)BackTripDataSource:(NSMutableArray *)newTripDataSource BackRigthTicketName:(NSArray *)newrigthTicket BackRigthTicketCode:(NSArray *)newrigthTicketCode;
{
    self.PaiXuaAllArray = newTripDataSource;
    self.temporaryPaiXuaAllArray = newTripDataSource;
    
    NSMutableSet *valueSet = [[NSMutableSet alloc]init];
    NSMutableSet *keySet = [[NSMutableSet alloc]init];
    for (int i = 0; i < [newrigthTicket count]; i++)
    {
        NSString *LineName = [newrigthTicket objectAtIndex:i];
        NSString *LineCode = [newrigthTicketCode objectAtIndex:i];
        NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:LineName,LineCode, nil];
        [keySet addObject:LineCode];
        [valueSet addObject:dictionary];
    }
    // 航空公司
    [self.rigthTicket ariNameDictionary:valueSet AirLineKeys:keySet];
    
    [self.BackTripTicketTableView reloadData];
    
    
}
// 没有数据时清除内存
-(void)BackTripTableViewdataSource
{
    [self.PaiXuaAllArray removeAllObjects];
    [self.BackTripTicketTableView reloadData];
}

#pragma mark---表视图代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.PaiXuaAllArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(TicketCustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indenfault = @"cell";
    TicketCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenfault];
    if (!cell)
    {
        cell = [[TicketCustomTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:indenfault];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *backviewcell=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backviewcell.backgroundColor=RGBACOLOR(165, 238, 255, 1);
    cell.selectedBackgroundView = backviewcell;

    if ([self.PaiXuaAllArray count] > 0) {
    NSString *fromTimeData = [[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:0] substringWithRange:NSMakeRange(11, 5)];
    NSString *toTimeData = [[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:1] substringWithRange:NSMakeRange(11, 5)];
    NSString *chaotoTimeData = [[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:1] substringWithRange:NSMakeRange(11, 1)];
    //    NSLog(@"====chaotoTimeData===%@",chaotoTimeData);
    NSString *addString ;
    if ([chaotoTimeData isEqualToString:@"0"])
    {
        addString= @"(次)";
    }
    else
    {
        addString = @"";
    }
    
    [cell nameTicket:[NSString stringWithFormat:@"%@-%@",[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:5],[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:6]] timeTicket:[NSString stringWithFormat:@"￥%@",[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:2]] priceTicket:@" " discountTicket:[NSString stringWithFormat:@"%@-%@%@",fromTimeData,toTimeData,addString] modelsTicket:[NSString stringWithFormat:@"%@/%@",[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:7]]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.rigthTicket.frame = CGRectMake(320,MOVEHIETH, 160, self.frame.size.height+5);
        rigthButton = YES;
        self.leftTicket.frame = CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5);
        selectionButton = YES;
    }];

    // 机型
    NSString *craftTypeData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:8];
    // 航空公司代码
    NSString *airLineCodeData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:3];
    // 剩余票量
    NSString *quantityData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:9];
    // 出发机场三字码
    NSString *dPortCodeData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:10];
    // 到达机场三字码
    NSString *aPortCodeData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:11];
    // 出发机场
    NSString *dPortNameData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:5];
    // 到达机场
    NSString *aPortNameData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:6];
    // 机票实际价格
    NSString *priceArrayData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:2];
    // 起飞时间
    NSString *takeOffTimeData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:0];
    // 到达时间
    NSString *arriveTimeData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:1];
    // 航班号
    NSString *flightData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:7];
    // 航空公司
    NSString *airLineNameData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:4];
    // 判断往返码
    NSString *airLineCodeTagData = [[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:12];
    
    NSMutableArray *airLineInfoArray = [[NSMutableArray alloc]initWithObjects:takeOffTimeData,arriveTimeData,priceArrayData,airLineCodeData,airLineNameData,dPortNameData,aPortNameData,flightData,craftTypeData,quantityData,dPortCodeData,aPortCodeData,airLineCodeTagData,nil];
    NSLog(@"======airLineInfoArray=====%@",airLineInfoArray);

    [self.delegata BackTripTicketViewAirLineInfoArray:airLineInfoArray];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rigthTicket.frame = CGRectMake(320,MOVEHIETH, 160, self.frame.size.height+5);
        rigthButton = YES;
        self.leftTicket.frame = CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5);
        selectionButton = YES;
        self.tapGesture.enabled = NO;
    }];
}
// 手势
-(void)tapAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rigthTicket.frame = CGRectMake(320,MOVEHIETH, 160, self.frame.size.height+5);
        rigthButton = YES;
        self.leftTicket.frame = CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5);
        selectionButton = YES;
    }];
    self.tapGesture.enabled = NO;
    
}
-(void)swipeAction
{
    [_AirView leftBackLableMove];
    [UIView animateWithDuration:0.3 animations:^{
        self.rigthTicket.frame = CGRectMake(160,MOVEHIETH, 160, self.frame.size.height+5);
        rigthButton = YES;
        self.leftTicket.frame = CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5);
        selectionButton = YES;
        self.tapGesture.enabled = YES;
        
    }];
}
-(void)RightSwipeAction
{
    [_AirView backLableMove];
    [UIView animateWithDuration:0.3 animations:^{
        self.rigthTicket.frame = CGRectMake(320,MOVEHIETH, 160, self.frame.size.height+5);
        rigthButton = YES;
        self.leftTicket.frame = CGRectMake(0, MOVEHIETH, 160, self.frame.size.height+5);
        selectionButton = YES;
        self.tapGesture.enabled = YES;
        
    }];
}
-(void)leftItemClickNavigation
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rigthTicket.frame = CGRectMake(320,MOVEHIETH, 160, self.frame.size.height+5);
        rigthButton = YES;
        self.leftTicket.frame = CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5);
        selectionButton = YES;
    }];
    self.tapGesture.enabled = NO;
    
}


#pragma mark --- 航空公司选择
-(void)AirLineCode:(NSString *)newAirLineCode
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rigthTicket.frame = CGRectMake(320,MOVEHIETH, 160, self.frame.size.height+5);
        rigthButton = YES;
    }];
    if ([newAirLineCode isEqualToString:@"KEY"])
    {
        Play = 0;
    }
    else
    {
        Play = 13;
        self.CityKey = newAirLineCode;
    }

    [self ButtonToTtrigger];
}
-(void)ClearData
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rigthTicket.frame = CGRectMake(320,MOVEHIETH, 160, self.frame.size.height+5);
        rigthButton = YES;
    }];
    
    Play = 0;
    [self ButtonToTtrigger];
}
// 触发代理方法
-(void)SelectButtonAction:(UIButton *)sender
{
    if (sender.tag < 3)
    {
        PM = 10;
        PMTag = sender.tag;
    }
    else if (sender.tag > 2 && sender.tag < 5)
    {
        Time = 11;
        Price = 0;
        TimeTag = sender.tag;
    }
    else
    {
        Price = 12;
        Time = 0;
        PriceTag = sender.tag;
    }
    [self ButtonToTtrigger];
}

// 触发代理方法
-(void)DonChooseButtonEvents:(UIButton *)sender
{
    if (sender.tag < 3)
    {
        PM  = 0;
        PMTag = sender.tag;
        
    }
    else if (sender.tag > 2 && sender.tag < 5)
    {
        Time = 0;
        TimeTag = sender.tag;
        
    }
    else
    {
        Price = 0;
        PriceTag = sender.tag;
        
    }
    [self ButtonToTtrigger];
}

# pragma mark ===  筛选方法
-(void)ButtonToTtrigger
{
    NSInteger AndAllCases = PM + Time + Price + Play;
    switch (AndAllCases)
    {
        case 10:
        {
            self.PaiXuaAllArray  = [_airPlayPaixu pmTimePaiXiuDescending:self.temporaryPaiXuaAllArray timeTager:PMTag];
        }
            break;
            
        case 11:
        {
            self.PaiXuaAllArray = [_airPlayPaixu timePaiXiuDescending:self.temporaryPaiXuaAllArray timeTager:TimeTag-3];
        }
            break;
            
        case 12:
        {
            self.PaiXuaAllArray = [_airPlayPaixu pricePaiXiuDescending:self.temporaryPaiXuaAllArray priceTager:PriceTag-5];
        }
            break;
            
        case 13:
        {
            
            self.PaiXuaAllArray  = [_airPlayPaixu airLineNamePaiXiuDescending:self.temporaryPaiXuaAllArray airCode:self.CityKey];
        }
            break;
            
        case 21:
        {
            NSMutableArray *FilterArray  = [_airPlayPaixu pmTimePaiXiuDescending:self.temporaryPaiXuaAllArray timeTager:PMTag];
            self.PaiXuaAllArray = [_airPlayPaixu timePaiXiuDescending:FilterArray timeTager:TimeTag-3];
            
        }
            break;
            
        case 22:
        {
            NSMutableArray *FilterArray = [_airPlayPaixu pmTimePaiXiuDescending:self.temporaryPaiXuaAllArray timeTager:PMTag];
            self.PaiXuaAllArray = [_airPlayPaixu pricePaiXiuDescending:FilterArray priceTager:PriceTag-5];
            
        }
            break;
            
        case 23:
        {
            NSMutableArray *FilterArray = [_airPlayPaixu pmTimePaiXiuDescending:self.temporaryPaiXuaAllArray timeTager:PMTag];
            self.PaiXuaAllArray  = [_airPlayPaixu airLineNamePaiXiuDescending:FilterArray airCode:self.CityKey];
        }
            break;
            
        case 24:
        {
            NSMutableArray *FilterArray = [_airPlayPaixu timePaiXiuDescending:self.temporaryPaiXuaAllArray timeTager:TimeTag-3];
            self.PaiXuaAllArray  = [_airPlayPaixu airLineNamePaiXiuDescending:FilterArray airCode:self.CityKey];
        }
            break;
            
        case 25:
        {
            NSMutableArray *FilterArray = [_airPlayPaixu pricePaiXiuDescending:self.temporaryPaiXuaAllArray priceTager:PriceTag-5];
            self.PaiXuaAllArray  = [_airPlayPaixu airLineNamePaiXiuDescending:FilterArray airCode:self.CityKey];
            
        }
            break;
            
        case 34:
        {
            NSMutableArray *FilterArray  = [_airPlayPaixu pmTimePaiXiuDescending:self.temporaryPaiXuaAllArray timeTager:PMTag];
            NSMutableArray *FilterArray1 = [_airPlayPaixu timePaiXiuDescending:FilterArray timeTager:TimeTag-3];
            self.PaiXuaAllArray  = [_airPlayPaixu airLineNamePaiXiuDescending:FilterArray1 airCode:self.CityKey];
            
        }
            break;
            
        case 35:
        {
            NSMutableArray *FilterArray  = [_airPlayPaixu pmTimePaiXiuDescending:self.temporaryPaiXuaAllArray timeTager:PMTag];
            NSMutableArray *FilterArray1  = [_airPlayPaixu pricePaiXiuDescending:FilterArray priceTager:PriceTag-5];
            self.PaiXuaAllArray  = [_airPlayPaixu airLineNamePaiXiuDescending:FilterArray1 airCode:self.CityKey];
        }
            break;
            
        case 0:
        {
            self.PaiXuaAllArray = self.temporaryPaiXuaAllArray;
        }
            break;
            
        default:
            break;
    }
    
    [self.BackTripTicketTableView reloadData];
    
}



#pragma mark ====分类航空筛选按钮
-(void)moveLeftRightView:(NSInteger)newInteger
{
    if (newInteger == 0) {
        if (selectionButton == YES)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.leftTicket.frame = CGRectMake(0, MOVEHIETH, 160, self.frame.size.height+5);
                selectionButton = NO;
                self.rigthTicket.frame = CGRectMake(320, MOVEHIETH, 160, self.frame.size.height+5);
                rigthButton = YES;
                self.tapGesture.enabled = YES;

            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.leftTicket.frame = CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5);
                selectionButton = YES;
                self.rigthTicket.frame = CGRectMake(320, MOVEHIETH, 160, self.frame.size.height+5);
                rigthButton = YES;
                self.tapGesture.enabled = NO;


            }];
        }
    }
    
    else if (newInteger == 1)
    {
        if (rigthButton == YES)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.rigthTicket.frame = CGRectMake(160, MOVEHIETH, 160, self.frame.size.height+5);
                rigthButton = NO;
                self.leftTicket.frame = CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5);
                selectionButton = YES;
                self.tapGesture.enabled = YES;


            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.rigthTicket.frame = CGRectMake(320,MOVEHIETH, 160, self.frame.size.height+5);
                rigthButton = YES;
                self.leftTicket.frame = CGRectMake(-160, MOVEHIETH, 160, self.frame.size.height+5);
                selectionButton = YES;
                self.tapGesture.enabled = NO;
            }];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
