//
//  RoundTriprReservationViewController.m
//  TongFubao
//
//  Created by kin on 14-9-17.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "RoundTriprReservationViewController.h"
#import "TripTicketView.h"
#import "watchTimeObject.h"
#import "PlayCustomActivityView.h"
#import "BackTripTicketView.h"
#import "ToChooseShippingSpaceViewController.h"


@interface RoundTriprReservationViewController ()
{
    TripTicketView *_ticketView;
    PlayCustomActivityView *_activityView;
    BackTripTicketView *_BackticketView;
    TimerButtonView *_ButtonView;
}

@end

@implementation RoundTriprReservationViewController

@synthesize DepartCodeCtity,arriveCodeCity,departFromTime,returnToTime,cityIDFrom,cityIDTo,searchType,HotCityArray,takeOffTimeArray,arriveTimeArray,flightArray,craftTypeArray,airLineCodeArray,priceArray,quantityArray,dPortNameArray,aPortNameArray,dPortCodeArray,aPortCodeArray,airLineNameArray,TripFromTimeArray,firstPlayInfoArray,seconPlayInfoArray,RoundArriveCity,RoundDepartCity;



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
    // 是否推送页面
    PageSwitching =NO;
    // 生成警告框
    AlertBoxBool = YES;
    // 导航
    [self navigationView];
    [self allControllerView];
    // 网络请求
    [self nextWork];

}

-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"行程机票";
    //    [self addRightButtonItemWithImage:[UIImage imageNamed:@"sugust"]];
}
// 回调
-(void)leftItemClick:(id)sender
{
    if (PageSwitching == YES)
    {
 
        TimeSwitch = NO;
        // 重新计时间
        NSString * compareString = [watchTimeObject selectionTime:self.departFromTime];
        timeInteger = [compareString integerValue];
        if (timeInteger > 0)
        {
            timeInteger++;
        }
        [_ButtonView selectionDateTime:self.departFromTime  goTime:[watchTimeObject changeTime]  shijianca:timeInteger];
        _ticketView.hidden = NO;
        self.title= @"行程机票";
        [_ticketView ShowInterfaceTripTicketView];
        PageSwitching = NO;
        // 将回程页面左右页面初始化位置隐藏
        [_BackticketView leftItemClickNavigation];
        _BackticketView.hidden = YES;
    }
    else if (PageSwitching == NO)
    {
        [self.navigationController popViewControllerAnimated:YES];
 
    }
}


-(void)nextWork
{
    
    _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    _activityView.center = self.view.center;
    [_activityView setTipsText:@"正在加载数据..."];
    [_activityView starActivity];
    [self.view addSubview:_activityView];

    NSLog(@"===departFromTime====%@======returnToTime====%@===",self.departFromTime,self.returnToTime);
    NSString* name = [NLUtils getNameForRequest:Notify_ApigetAirline];
    REGISTER_NOTIFY_OBSERVER(self, getApigetAirline, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]getApigetAirline:self.DepartCodeCtity arriveCityCode:self.arriveCodeCity departDate:self.departFromTime returnDate:self.returnToTime searchType:self.searchType];
}
-(void)getApigetAirline:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataWithAirline:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        [_ticketView tripTicketTableViewdataSource];
        [_BackticketView BackTripTableViewdataSource];

        return ;
    }
    else
    {
        // 没有数据
        NSString *string = response.detail;
        NSLog(@"=======string=======%@",string);
        
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        [_ticketView tripTicketTableViewdataSource];
        [_BackticketView BackTripTableViewdataSource];

        if (AlertBoxBool == YES)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲!本日期没有航班!" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
            [alert show];
            AlertBoxBool = NO;
        }
        
    }
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
        [_ticketView tripTicketTableViewdataSource];
        [_BackticketView BackTripTableViewdataSource];

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
        NSMutableArray *PaiXuaCityCodeArray = [[NSMutableArray alloc]init];

        // 组成新对象
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
        NSArray  *dCityCodeArray = [response.data find:@"msgbody/msgchild/dCityCode"];

        
        // 到达机场三字码
        self.aPortCodeArray = [response.data find:@"msgbody/msgchild/aPortCode"];
        for (NLProtocolData *aPortCode  in self.aPortCodeArray)
        {
            [PaiXuaPortCodeArray addObject:aPortCode.value];
        }
        
        // 出发城市
        for (NLProtocolData *dPortCode  in dCityCodeArray)
        {
            [PaiXuaCityCodeArray addObject:dPortCode.value];
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
            // 到达机场三字码11
            [otherObjectArray addObject:[PaiXuaCityCodeArray objectAtIndex:i]];
            
            // 装载所有排好的对象数组12
            [combinationPaiXuaAllArray addObject:otherObjectArray];
        }
        // 筛选数据行程数据和返程数据
        NSMutableArray *FromObjectArray = [[NSMutableArray alloc]init];
        NSMutableArray *ToObjectArray = [[NSMutableArray alloc]init];
        // 行程回程飞机名
        NSMutableArray *FromNameArray = [[NSMutableArray alloc]init];
        NSMutableArray *ToNameArray = [[NSMutableArray alloc]init];
        // 行程回程飞机code
        NSMutableArray *FromCodeArray = [[NSMutableArray alloc]init];
        NSMutableArray *ToCodeArray = [[NSMutableArray alloc]init];



        for (int i = 0; i < [combinationPaiXuaAllArray count]; i++)
        {
            NSString * cityString = [[combinationPaiXuaAllArray objectAtIndex:i] objectAtIndex:12];
            
            if ([cityString isEqualToString:self.DepartCodeCtity])
            {
                [FromObjectArray addObject:[combinationPaiXuaAllArray objectAtIndex:i]];
                [FromNameArray addObject:[[combinationPaiXuaAllArray objectAtIndex:i] objectAtIndex:4]];
                [FromCodeArray addObject:[[combinationPaiXuaAllArray objectAtIndex:i] objectAtIndex:3]];
            }
            else if ([cityString isEqualToString:self.arriveCodeCity])
            {
                [ToObjectArray addObject:[combinationPaiXuaAllArray objectAtIndex:i]];
                [ToNameArray addObject:[[combinationPaiXuaAllArray objectAtIndex:i] objectAtIndex:4]];
                [ToCodeArray addObject:[[combinationPaiXuaAllArray objectAtIndex:i] objectAtIndex:3]];
            }
        }
//        NSLog(@"=====ToNameArray=====%@",ToNameArray);
//        NSLog(@"=====ToCodeArray=====%@",ToCodeArray);
//        NSLog(@"=====FromNameArray=====%@",FromNameArray);
//        NSLog(@"=====FromCodeArray=====%@",FromCodeArray);
//        self.TripFromTimeArray = FromObjectArray;
        
        
        // 数据刷新
        [_ticketView  TripDataSource:FromObjectArray rigthTicketName:FromNameArray rigthTicketCode:FromCodeArray];
        [_BackticketView BackTripDataSource:ToObjectArray BackRigthTicketName:ToNameArray BackRigthTicketCode:ToCodeArray];
    }
    
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];
    
}

#pragma mark---- 控件
-(void)allControllerView
{
    // 时间差匹配得出相应timeInteger传给时间按钮
    NSString * compareString = [watchTimeObject selectionTime:self.departFromTime];
    timeInteger = [compareString integerValue];
    if (timeInteger > 0)
    {
        timeInteger++;
    }
    NSLog(@"====timeInteger===%d",timeInteger);

    // 时间选择按钮
    _ButtonView = [[TimerButtonView alloc]initWithFrame:CGRectMake(0, 64, 320, 45)wacthTime:self.departFromTime shijianca:timeInteger];
    _ButtonView.delegate = self;
    [self.view addSubview:_ButtonView];
    
    
    // 回程票
    _BackticketView = [[BackTripTicketView alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height-110)];
    _BackticketView.delegata = self;
    [self.view addSubview:_BackticketView];

    
    // 行程票
    _ticketView = [[TripTicketView alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height-110)];
    _ticketView.delegata = self;
    [self.view addSubview:_ticketView];

}

#pragma mark -- 时间选择器网络请求
-(void)returnDate:(NSString *)newDate
{
    if (TimeSwitch == YES )
    {
        self.returnToTime = newDate;
    }
    else
    {
        self.departFromTime = newDate;
        NSComparisonResult comparison = [self.departFromTime compare:self.returnToTime];
        if (comparison == NSOrderedAscending)
        {
            NSLog(@"====departFromTime====%@",self.departFromTime);
        }
        else
        {
            NSLog(@"====returnToTime====%@",self.returnToTime);
            self.returnToTime = self.departFromTime;
        }
    }
    // 时间重新展示
    [[NSUserDefaults standardUserDefaults] setObject:self.departFromTime forKey:@"FromTime"];
    [[NSUserDefaults standardUserDefaults] setObject:self.returnToTime forKey:@"ToTime"];
    
    [self nextWork];
}

#pragma mark ==== 第一次选票返回代理数据
-(void)TripTicketViewAirLineInfoArray:(NSMutableArray *)newairLineInfoArray
{
    // 获取第一页数据
    self.firstPlayInfoArray = newairLineInfoArray;
    
    // 字符串对比来控制回程时间转换
    NSComparisonResult comparison = [self.departFromTime compare:self.returnToTime];
    if (comparison == NSOrderedAscending)
    {
        NSLog(@"====departFromTime====%@",self.departFromTime);
    }
    else
    {
        NSLog(@"====returnToTime====%@",self.returnToTime);
        self.returnToTime = self.departFromTime;
    }
    // 重新计时间
    NSString * compareString = [watchTimeObject selectionTime:self.returnToTime];
    timeInteger = [compareString integerValue];
    if (timeInteger > 0)
    {
        timeInteger++;
    }
    [_ButtonView selectionDateTime:self.returnToTime  goTime:self.departFromTime  shijianca:timeInteger];
    
    
    // 当yes时候时间转换回程时间控制选择
    TimeSwitch = YES;
    // 隐藏起程页面
    _ticketView.hidden = 0;
    [_ticketView HiddenInterfaceTripTicketView];
    // 显示回程页
    _BackticketView.hidden = NO;
    // 控制是否推送页面
    PageSwitching = YES;
    self.title= @"回程机票";

}
#pragma mark ==== 第二次选票返回代理数据
-(void)BackTripTicketViewAirLineInfoArray:(NSMutableArray *)newairLineInfoArray
{
    self.seconPlayInfoArray = newairLineInfoArray;

    ToChooseShippingSpaceViewController *ShippingSpaceView = [[ToChooseShippingSpaceViewController alloc]init];
    // 去回程cell对象
    ShippingSpaceView.ShippFirstPlayInfoArray = self.firstPlayInfoArray;
    ShippingSpaceView.ShippSeconPlayInfoArray = self.seconPlayInfoArray;
    // 城市code
    ShippingSpaceView.ShippingDepartCodeCtity = self.DepartCodeCtity;

    ShippingSpaceView.ShippingArriveCodeCity = self.arriveCodeCity;
    // 时间
    ShippingSpaceView.ShippingDepartFromTime = self.departFromTime;
    ShippingSpaceView.ShippingReturnToTime = self.returnToTime;
    // 城市id
    ShippingSpaceView.ShippingCityIDFrom = self.cityIDFrom;
    ShippingSpaceView.ShippingCityIDTo = self.cityIDTo;
    // 城市
    ShippingSpaceView.ShippingRoundDepartCity = self.RoundDepartCity;
    ShippingSpaceView.ShippingRoundArriveCity = self.RoundArriveCity;
    // 往返类型
    ShippingSpaceView.ShippingSearchType = self.searchType;
    [self.navigationController pushViewController:ShippingSpaceView animated:YES];

}


-(void)viewWillAppear:(BOOL)animated
{
    _ticketView.hidden = YES;
    _BackticketView.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    _ticketView.hidden = NO;
    _BackticketView.hidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated
{
    _ticketView.hidden = YES;
    _BackticketView.hidden = YES;

}
-(void)viewDidDisappear:(BOOL)animated
{
    _ticketView.hidden = YES;
    _BackticketView.hidden = YES;
    
    TimeSwitch = NO;
    // 重新计时间
    NSString * compareString = [watchTimeObject selectionTime:self.departFromTime];
    timeInteger = [compareString integerValue];
    if (timeInteger > 0)
    {
        timeInteger++;
    }
    [_ButtonView selectionDateTime:self.departFromTime  goTime:[watchTimeObject changeTime]  shijianca:timeInteger];
    _ticketView.hidden = NO;
    self.title= @"行程机票";
    [_ticketView ShowInterfaceTripTicketView];
    PageSwitching = NO;
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






























