//
//  BookingFlightViewController.m
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BookingFlightViewController.h"
#import "TimerButtonView.h"
#import "TicketCustomTableViewCell.h"
#import "AirFilterView.h"
#import "leftView.h"
#import "RigthView.h"
#import "ShippingSpaceChoooseViewController.h"
#import "watchTimeObject.h"
#import "AirPlayPaixuObject.h"
#import "PlayCustomActivityView.h"
@interface BookingFlightViewController ()<TimerButtonViewDelegate,leftViewDelegate,RigthViewDelegate>
{
    leftView *_leftV ;
    RigthView *_rigthV;
    BOOL selectionButton;
    BOOL rigthButton;
    AirPlayPaixuObject *_airPlayPaixu ;
    NSInteger timeInteger;
    //  筛选
    NSInteger  TIMETEGER;
    NSInteger  PMPRICETEGER;
    NSInteger  NAMETEGER;
    NSInteger  REULETEGER;
    
    PlayCustomActivityView * _activityView;
    AirFilterView *_AirView;
}

@end

@implementation BookingFlightViewController
@synthesize BookingTableView,DepartCtity,arriveCity,departDate,returnDate,searchType,HotCityArray,takeOffTimeArray,arriveTimeArray,flightArray,craftTypeArray,airLineCodeArray,priceArray,quantityArray,dPortNameArray,aPortNameArray,dPortCodeArray,aPortCodeArray,airLineNameArray,cityIDFromBookin,cityIDToBooking,PaiXuaAllArray,temporaryPaiXuaAllArray,otherAirPlayArray,CityKey,tapGesture;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // 筛选
    TIMETEGER = 0;
    PMPRICETEGER = 0;
    NAMETEGER = 0;
    REULETEGER = 0;
    // 警告框
    AlertBoxBool = YES;
    
    // 导航
    [self navigationView];
    [self allControllerView];
    // 网络请求
    [self nextWork];

    
}
-(void)nextWork
{
    _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    _activityView.center = self.view.center;
    [_activityView setTipsText:@"正在加载数据..."];
    [_activityView starActivity];
    [self.view addSubview:_activityView];

    NSString* name = [NLUtils getNameForRequest:Notify_ApigetAirline];
    REGISTER_NOTIFY_OBSERVER(self, getApigetAirline, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]getApigetAirline:self.DepartCtity arriveCityCode:self.arriveCity departDate:self.departDate returnDate:self.returnDate searchType:self.searchType];
}

-(void)getApigetAirline:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    NSString *string = response.detail;
    NSLog(@"===string===%@",string);

    
    if (error == RSP_NO_ERROR)
    {
        [self getDataWithAirline:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [self.self.PaiXuaAllArray removeAllObjects];
        [self.BookingTableView reloadData];

    }
    else if (error == RSP_TIMEOUT)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！服务数据可能错误。" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if (error == RSP_CANCEL)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！服务数据可能错误。" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if (error == RSP_HAS_EXIST)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！服务数据可能错误。" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if (error == RSP_XML_RETCODE_FAILURE)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！服务数据可能错误。" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        
        [self.PaiXuaAllArray removeAllObjects];
        [self.BookingTableView reloadData];
        
    }

    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];
}

- (void)getDataWithAirline:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        NSLog(@"errorData = %@",errorData);
        
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        [self.self.PaiXuaAllArray removeAllObjects];
        [self.BookingTableView reloadData];

    }
    else
    {
        NSMutableArray *PaiXutakeOffTimeArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXuarriveTimeArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXuairLineNameArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXuflightArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXucraftTypeArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXuairLineCodeArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXupriceArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXuquantityArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXudPortNameArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXuaPortNameArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXudPortCodeArray = [[NSMutableArray alloc]init];
        NSMutableArray *PaiXuaPortCodeArray = [[NSMutableArray alloc]init];
        NSMutableArray *combinationPaiXuaAllArray = [[NSMutableArray alloc]init];

        // 起飞时间
        self.takeOffTimeArray = [response.data find:@"msgbody/msgchild/takeOffTime"];
        for (NLProtocolData *takeOffTime  in self.takeOffTimeArray)
        {
            [PaiXutakeOffTimeArray addObject:takeOffTime.value];
        }

        // 到达时间
        self.arriveTimeArray = [response.data find:@"msgbody/msgchild/arriveTime"];
        for (NLProtocolData *arriveTime  in self.arriveTimeArray)
        {
            [PaiXuarriveTimeArray addObject:arriveTime.value];
        }

        // 航空名
        self.airLineNameArray = [response.data find:@"msgbody/msgchild/airLineName"];
        for (NLProtocolData *airLineName  in self.airLineNameArray)
        {
            [PaiXuairLineNameArray addObject:airLineName.value];
        }

        // 航班号
        self.flightArray = [response.data find:@"msgbody/msgchild/flight"];
        for (NLProtocolData *flight  in self.flightArray)
        {
            [PaiXuflightArray addObject:flight.value];
        }

        // 机型
        self.craftTypeArray = [response.data find:@"msgbody/msgchild/craftType"];
        for (NLProtocolData *craftType  in self.craftTypeArray)
        {
            [PaiXucraftTypeArray addObject:craftType.value];
        }

        // 航空公司代码
        self.airLineCodeArray = [response.data find:@"msgbody/msgchild/airLineCode"];
        for (NLProtocolData *airLineCode  in self.airLineCodeArray)
        {
            [PaiXuairLineCodeArray addObject:airLineCode.value];
        }
        
        // 机票实际价格
        self.priceArray = [response.data find:@"msgbody/msgchild/price"];
        for (NLProtocolData *price  in self.priceArray)
        {
            [PaiXupriceArray addObject:price.value];
        }

        // 剩余票量
        self.quantityArray = [response.data find:@"msgbody/msgchild/quantity"];
        for (NLProtocolData *quantity  in self.quantityArray)
        {
            [PaiXuquantityArray addObject:quantity.value];
        }
        
        // 出发机场
        self.dPortNameArray = [response.data find:@"msgbody/msgchild/dPortName"];
        for (NLProtocolData *dPortName  in self.dPortNameArray)
        {
            [PaiXudPortNameArray addObject:dPortName.value];
        }
        
        // 到达机场
        self.aPortNameArray = [response.data find:@"msgbody/msgchild/aPortName"];
        for (NLProtocolData *aPortName  in self.aPortNameArray)
        {
            [PaiXuaPortNameArray addObject:aPortName.value];
        }

        // 出发机场三字码
        self.dPortCodeArray = [response.data find:@"msgbody/msgchild/dPortCode"];
        for (NLProtocolData *dPortCode  in self.dPortCodeArray)
        {
            [PaiXudPortCodeArray addObject:dPortCode.value];
        }

        // 到达机场三字码
        self.aPortCodeArray = [response.data find:@"msgbody/msgchild/aPortCode"];
        for (NLProtocolData *aPortCode  in self.aPortCodeArray)
        {
            [PaiXuaPortCodeArray addObject:aPortCode.value];
        }

        for (int i = 0; i < [PaiXutakeOffTimeArray count]; i++)
        {
            NSMutableArray *otherObjectArray = [[NSMutableArray alloc]init];
            // 起飞时间0
            [otherObjectArray addObject:[PaiXutakeOffTimeArray objectAtIndex:i]];
            // 到达时间1
            [otherObjectArray addObject:[PaiXuarriveTimeArray objectAtIndex:i]];
            // 票价2
            [otherObjectArray addObject:[PaiXupriceArray objectAtIndex:i]];
            // 航空代号3
            [otherObjectArray addObject:[PaiXuairLineCodeArray objectAtIndex:i]];
            // 航空公司名4
            [otherObjectArray addObject:[PaiXuairLineNameArray objectAtIndex:i]];
            // 出发机场5
            [otherObjectArray addObject:[PaiXudPortNameArray objectAtIndex:i]];
            // 到达机场6
            [otherObjectArray addObject:[PaiXuaPortNameArray objectAtIndex:i]];
            // 航班号7
            [otherObjectArray addObject:[PaiXuflightArray objectAtIndex:i]];
            // 机型8
            [otherObjectArray addObject:[PaiXucraftTypeArray objectAtIndex:i]];
            // 剩余票量9
            [otherObjectArray addObject:[PaiXuquantityArray objectAtIndex:i]];
            // 出发机场三字码10
            [otherObjectArray addObject:[PaiXudPortCodeArray objectAtIndex:i]];
            // 到达机场三字码11
            [otherObjectArray addObject:[PaiXuaPortCodeArray objectAtIndex:i]];
            // 装载所有排好的对象数组12
            [combinationPaiXuaAllArray addObject:otherObjectArray];
        }
        // 筛选数据
        self.PaiXuaAllArray = combinationPaiXuaAllArray;
        self.temporaryPaiXuaAllArray = combinationPaiXuaAllArray;
//        NSLog(@"=====temporaryPaiXuaAllArray=====%@",self.temporaryPaiXuaAllArray);
    }
    
    // 活动指示器
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];

    [self.BookingTableView reloadData];
    
    /*
     右边的视图
     航空公司
     航空编号数据
     */
    NSMutableSet *valueSet = [[NSMutableSet alloc]init];
    NSMutableSet *keySet = [[NSMutableSet alloc]init];
    for (int i = 0; i < [self.airLineNameArray count]; i++)
    {
        NLProtocolData *LineName = [self.airLineNameArray objectAtIndex:i];
        NLProtocolData *LineCode = [self.airLineCodeArray objectAtIndex:i];
        NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:LineName.value,LineCode.value, nil];
        [keySet addObject:LineCode.value];
        [valueSet addObject:dictionary];
    }
    // 航空公司
    [_rigthV ariNameDictionary:valueSet AirLineKeys:keySet];
}

#pragma mark --- 航空公司选择
-(void)AirLineCode:(NSString *)newAirLineCode
{
    [UIView animateWithDuration:0.3 animations:^{
        _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
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
        _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
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
    
    [self.BookingTableView reloadData];
    
}


#pragma mark ---// 左右边导航和所有控件
-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= [NSString stringWithFormat:@"去程(%@-%@)",self.BookingDepartCity,self.BookingArriveCity];
//    [self addRightButtonItemWithTitle:@"重筛选"];
}
#pragma mark ---//选择时间按钮重新建立按钮
-(void)TimeItemClick
{
    [_leftV ButtontToRecover];
    [UIView animateWithDuration:0.3 animations:^{
        _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
        _leftV.frame = CGRectMake(-160, 64, 160, self.view.frame.size.height-109);
        selectionButton = YES;
        rigthButton = YES;
    }];
     PM = 0;
     Time = 0;
     Price = 0;
     Play = 0;
//    self.PaiXuaAllArray = temporaryPaiXuaAllArray;
//    [self.BookingTableView reloadData];
}

#pragma mark ---所有的控件
-(void)allControllerView
{
//    NSLog(@"====self.departDate===%@",self.departDate);
    // 时间差匹配得出相应timeInteger传给时间按钮
    NSString * compareString = [watchTimeObject selectionTime:self.departDate];
//    NSLog(@"====compareString===%@",compareString);
    timeInteger = [compareString integerValue];
//    NSLog(@"====timeInteger===%d",timeInteger);

    if (timeInteger > 1)
    {
        timeInteger++;
    }
    else if (timeInteger <= 0)
    {
        timeInteger = 0;
    }
    else if (timeInteger == 1)
    {
        timeInteger = 1;
    }
//    NSLog(@"====timeInteger===%d",timeInteger);

    // 时间选择按钮
    TimerButtonView *ButtonView =[[TimerButtonView alloc]initWithFrame:CGRectMake(0, 64, 320, 45)wacthTime:self.departDate shijianca:timeInteger];
    ButtonView.delegate = self;
    [self.view addSubview:ButtonView];
    
    // 视图
    self.BookingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, 320, self.view.frame.size.height-155)];
    self.BookingTableView.delegate = self;
    self.BookingTableView.dataSource = self;
    [self.view addSubview:self.BookingTableView];
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    self.tapGesture.numberOfTapsRequired = 1;
    self.tapGesture.enabled = NO;
    [self.BookingTableView addGestureRecognizer:self.tapGesture];
    //向左向右都可以
    UISwipeGestureRecognizer *Leftswipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction)];
    Leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.BookingTableView addGestureRecognizer:Leftswipe];
    UISwipeGestureRecognizer *Rightswipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(RightSwipeAction)];
    Rightswipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.BookingTableView addGestureRecognizer:Rightswipe];



    
    // 航空分类按钮
    _AirView = [[AirFilterView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-45, 320, 45)];
    _AirView.delegate = self;
    [self.view addSubview:_AirView];
    // 左视图
    _leftV = [[leftView alloc]initWithFrame:CGRectMake(-160, 64, 160, self.view.frame.size.height-109)];
    _leftV.delegate = self;
    _leftV.layer.shadowOffset = CGSizeMake(1, -1);
    _leftV.layer.shadowRadius = 2.0f;
    _leftV.layer.shadowOpacity = 0.4f;
    _leftV.layer.borderColor = [UIColor blackColor].CGColor;
    selectionButton = YES;
    [self.view addSubview:_leftV];
    // 右视图
    _rigthV = [[RigthView alloc]initWithFrame:CGRectMake(320, 64, 160, self.view.frame.size.height-109) ];
    _rigthV.delegate = self;
    _rigthV.layer.shadowOffset = CGSizeMake(-1,-1);
    _rigthV.layer.shadowRadius = 2.0f;
    _rigthV.layer.shadowOpacity = 0.4f;
    _rigthV.layer.borderColor = [UIColor blackColor].CGColor;
    rigthButton = YES;
    [self.view addSubview:_rigthV];
    
    // 排序类
    _airPlayPaixu = [[AirPlayPaixuObject alloc]init];

}

#pragma mark -- 时间选择器网络请求
-(void)returnDate:(NSString *)newDate
{
    [self TimeItemClick];
    [[NSUserDefaults standardUserDefaults] setObject:newDate forKey:@"FromTime"];
    self.departDate = newDate;
    [self nextWork];
}
#pragma mark -- 视图
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

    NSString *fromTimeData = [[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:0] substringWithRange:NSMakeRange(11, 5)];
    NSString *toTimeData = [[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:1] substringWithRange:NSMakeRange(11, 5)];
    NSString *fromtoTimeData = [[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:0] substringWithRange:NSMakeRange(8, 2)];
//    NSLog(@"====fromtoTimeData===%@",fromtoTimeData);
    NSString *chaotoTimeData = [[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:1] substringWithRange:NSMakeRange(8, 2)];
//    NSLog(@"====chaotoTimeData===%@",chaotoTimeData);
    NSString *addString ;
    if ([fromtoTimeData intValue] < [chaotoTimeData intValue])
    {
        addString= @"(次)";
    }
    else
    {
        addString = @"";
    }
    
    [cell nameTicket:[NSString stringWithFormat:@"%@-%@",[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:5],[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:6]] timeTicket:[NSString stringWithFormat:@"￥%@",[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:2]] priceTicket:@" " discountTicket:[NSString stringWithFormat:@"%@-%@%@",fromTimeData,toTimeData,addString] modelsTicket:[NSString stringWithFormat:@"%@/%@",[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:4],[[self.PaiXuaAllArray objectAtIndex:indexPath.row] objectAtIndex:7]]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
        rigthButton = YES;
        _leftV.frame = CGRectMake(-160, 64, 160, self.view.frame.size.height-109);
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

    
    ShippingSpaceChoooseViewController *shippingSpaceView = [[ShippingSpaceChoooseViewController alloc]init];
    
    // 出发城市机场
    shippingSpaceView.shipDepartCity = dPortNameData;
    // 到达城市机场
    shippingSpaceView.shipArriveCity = aPortNameData;
    // 起飞时间
    shippingSpaceView.shipTimeCity = takeOffTimeData;
    // 到达时间
    shippingSpaceView.arriveTimeShipFrom = arriveTimeData;
    // 往返时间
    shippingSpaceView.shipReturnTimeCity = self.returnDate;
    // 单返类型
    shippingSpaceView.shipSearchTypeCity = self.searchType;
    // 航空号
    shippingSpaceView.shipFlihtCity = flightData;
    // 航空公司
    shippingSpaceView.airLineNameShip =airLineNameData;
    // 出发机场三字码
    shippingSpaceView.dPortCodeship = dPortCodeData;
    // 到达机场三字码
    shippingSpaceView.aPortCodeship = aPortCodeData;
    // 剩余票量
    shippingSpaceView.quantityShip = quantityData;
    // 机票实际价格
    shippingSpaceView.priceShip = priceArrayData;
    // 机型
    shippingSpaceView.craftTypeShip = craftTypeData;
    // 航空公司代码
    shippingSpaceView.airLineCodeShip = airLineCodeData;
    // 起飞城市code
    shippingSpaceView.DepartCtityShip = self.DepartCtity;
    // 到达城市code
    shippingSpaceView.arriveCityShip = self.arriveCity;
    // 起飞城市
    shippingSpaceView.ShippingCtity = self.BookingDepartCity;
    // 到达城市
    shippingSpaceView.ShippingarriveCity = self.BookingArriveCity;
//    NSLog(@"==shipDepartCity==%@===shipArriveCity=%@",dPortNameData,aPortNameData);

    // 起飞城市id
    shippingSpaceView.ShippingFromCtityId = self.cityIDFromBookin;
    // 到达城市id
    shippingSpaceView.ShippingToArriveCityId = self.cityIDToBooking;
//    NSLog(@"====%@====%@",airLineCodeData,craftTypeData);
    [self.navigationController pushViewController:shippingSpaceView animated:YES];
}

#pragma mark---航空分类时间筛选按钮
-(void)moveLeftRightView:(NSInteger)newInteger
{
    if (newInteger == 0) {
        if (selectionButton == YES) {
            [UIView animateWithDuration:0.3 animations:^{
                _leftV.frame = CGRectMake(0, 64, 160, self.view.frame.size.height-109);
                selectionButton = NO;
                _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
                rigthButton = YES;
                self.tapGesture.enabled = YES;


            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                _leftV.frame = CGRectMake(-160, 64, 160, self.view.frame.size.height-109);
                selectionButton = YES;
                _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
                rigthButton = YES;
                self.tapGesture.enabled = NO;

            }];
        }
    }
    
    else if (newInteger == 1)
    {
        if (rigthButton == YES) {
            [UIView animateWithDuration:0.3 animations:^{
                _rigthV.frame = CGRectMake(160, 64, 160, self.view.frame.size.height-109);
                rigthButton = NO;
                _leftV.frame = CGRectMake(-160, 64, 160, self.view.frame.size.height-109);
                selectionButton = YES;
                self.tapGesture.enabled = YES;


            }];
            
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
                rigthButton = YES;
                _leftV.frame = CGRectMake(-160, 64, 160, self.view.frame.size.height-109);
                selectionButton = YES;
                self.tapGesture.enabled = NO;
            }];
        }
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
        rigthButton = YES;
        _leftV.frame = CGRectMake(-160, 64, 160, self.view.frame.size.height-109);
        selectionButton = YES;
        self.tapGesture.enabled = NO;
    }];
}
-(void)tapAction
{
    [UIView animateWithDuration:0.3 animations:^{
        _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
        rigthButton = YES;
        _leftV.frame = CGRectMake(-160, 64, 160, self.view.frame.size.height-109);
        selectionButton = YES;
        self.tapGesture.enabled = NO;
    }];
}
-(void)swipeAction
{
    [_AirView leftBackLableMove];
    [UIView animateWithDuration:0.3 animations:^{
        _rigthV.frame = CGRectMake(160, 64, 160, self.view.frame.size.height-109);
        rigthButton = YES;
        _leftV.frame = CGRectMake(-160, 64, 160, self.view.frame.size.height-109);
        selectionButton = YES;
        self.tapGesture.enabled = YES;

    }];
}
-(void)RightSwipeAction
{
    [_AirView backLableMove];
    [UIView animateWithDuration:0.3 animations:^{
        _rigthV.frame = CGRectMake(320, 64, 160, self.view.frame.size.height-109);
        rigthButton = YES;
        _leftV.frame = CGRectMake(0, 64, 160, self.view.frame.size.height-109);
        selectionButton = YES;
        self.tapGesture.enabled = YES;
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    _rigthV.hidden = YES;
    _leftV.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    _rigthV.hidden = NO;
    _leftV.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    _rigthV.hidden = YES;
    _leftV.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    _rigthV.hidden = YES;
    _leftV.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end








