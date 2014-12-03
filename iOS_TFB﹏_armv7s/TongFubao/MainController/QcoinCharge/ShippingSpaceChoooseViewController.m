//
//  ShippingSpaceChoooseViewController.m
//  TongFubao
//
//  Created by kin on 14-8-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ShippingSpaceChoooseViewController.h"
#import "TicketCustomTableViewCell.h"
#import "TicketInfoImationViewController.h"
#import "PlayCustomActivityView.h"

@interface ShippingSpaceChoooseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    PlayCustomActivityView *activityView;
    UIButton *_button;
    
}
@end

@implementation ShippingSpaceChoooseViewController

@synthesize quantityShip,priceShip,airLineNameShip,airLineCodeShip,craftTypeShip,aPortCodeship,dPortCodeship,shipFlihtCity,shipSearchTypeCity,shipReturnTimeCity,shipTimeCity,shipArriveCity,arriveTimeShipFrom,shipDepartCity,DepartCtityShip,arriveCityShip;


@synthesize priceArray,msgchildArray,standardPriceArray,oilFeeArray,taxArray,standardPriceForChildArray,oilFeeForChildArray,taxForChildArray,standardPriceForBabyArray,oilFeeForBabyArray,taxForBabyArray,quantityArray ,rerNoteArray ,endNoteArray,refNoteArray,classArray,historicalTableView,infoTextView,ShippingCtity,ShippingarriveCity,priceDetailsIdArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self allControllerView];
    
    // 网络请求
    [self nextWork];
    // 导航
    [self navigationView];
    
    
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    // 网络请求
//    [self nextWork];
//}
-(void)nextWork
{
//    NSLog(@"==qwqwqw====%@===%@===%@===%@===%@===%@====",self.DepartCtityShip,self.arriveCityShip,self.shipTimeCity,self.shipReturnTimeCity,self.shipSearchTypeCity,self.shipFlihtCity);
    
    activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    activityView.center = self.view.center;
    [activityView setTipsText:@"正在加载数据..."];
    [activityView starActivity];
    [self.view addSubview:activityView];
    
    
    NSString* name = [NLUtils getNameForRequest:Notify_GetAirlineDetail];
    REGISTER_NOTIFY_OBSERVER(self, GetAirlineDetail, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]departCityCode:self.DepartCtityShip arriveCityCode:self.arriveCityShip departTime:self.shipTimeCity returnTime:self.shipReturnTimeCity searchType:self.shipSearchTypeCity flight:self.shipFlihtCity returnFlight:@""];
}

-(void)GetAirlineDetail:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
//    NSString *string = response.detail;
//    NSLog(@"===string====%@",string);
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataWithAirline:response];
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
    else if (error == RSP_XML_RETTYPE_FAILURE)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！服务数据可能错误。" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if (error == RSP_XML_RESULT_FAILURE)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！服务数据可能错误。" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if (error == RSP_XML_RETCODE_FAILURE)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！服务数据可能错误。" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    [activityView performSelector:@selector(endActivity) withObject:activityView afterDelay:0.7];
    [activityView removeFromSuperview];

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
        [activityView performSelector:@selector(endActivity) withObject:activityView afterDelay:0.7];
        [activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！本日期没有航班" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];

    }
    else
    {
        
        // 机票价格id
        self.priceDetailsIdArray = [response.data find:@"msgbody/msgchild/id"];
        //        NSLog(@"====priceDetailsIdArray======%@",self.priceDetailsIdArray);
        
        // 机票实际价格
        self.priceArray = [response.data find:@"msgbody/msgchild/price"];
        //        NSLog(@"====priceArray======%@",self.priceArray);
        
        // 航班
        self.msgchildArray = [response.data find:@"msgbody/msgchild/msgchild"];
        //        NSLog(@"====priceArray======%@",self.msgchildArray);
        
        // 机票原始价
        self.standardPriceArray = [response.data find:@"msgbody/msgchild/standardPrice"];
        //        NSLog(@"====priceArray======%@",self.standardPriceArray);
        
        
        // 燃油附加费
        self.oilFeeArray = [response.data find:@"msgbody/msgchild/oilFee"];
        //        NSLog(@"====priceArray======%@",self.oilFeeArray);
        
        // 成人税
        self.taxArray = [response.data find:@"msgbody/msgchild/tax"];
        //        NSLog(@"====priceArray======%@",self.taxArray);
        
        
        // 儿童标准价
        self.standardPriceForChildArray = [response.data find:@"msgbody/msgchild/standardPriceForChild"];
        //        NSLog(@"====standardPriceForChildArray======%@",self.standardPriceForChildArray);
        
        
        // 儿童燃油费用
        self.oilFeeForChildArray = [response.data find:@"msgbody/msgchild/oilFeeForChild"];
        //        NSLog(@"====oilFeeForChildArray======%@",self.oilFeeForChildArray);
        
        // 儿童税
        self.taxForChildArray = [response.data find:@"msgbody/msgchild/taxForChild"];
        //        NSLog(@"====taxForChildArray======%@",self.taxForChildArray);
        
        // 婴儿标准价
        self.standardPriceForBabyArray = [response.data find:@"msgbody/msgchild/standardPriceForBaby"];
        //        NSLog(@"====standardPriceForBabyArray======%@",self.standardPriceForBabyArray);
        
        
        // 婴儿燃油费用
        self.oilFeeForBabyArray = [response.data find:@"msgbody/msgchild/oilFeeForBaby"];
        // 婴儿税
        self.taxForBabyArray = [response.data find:@"msgbody/msgchild/taxForBaby"];
        // 剩余票量
        self.quantityArray = [response.data find:@"msgbody/msgchild/quantity"];
        
        // 更改政策说明
        self.rerNoteArray = [response.data find:@"msgbody/msgchild/rerNote"];
//        NSLog(@"====rerNoteArray======%@",self.rerNoteArray);
        
        // 改签政策说明
        self.endNoteArray = [response.data find:@"msgbody/msgchild/endNote"];
//        NSLog(@"====endNoteArray======%@",self.endNoteArray);
        
        // 退票政策说明
        self.refNoteArray = [response.data find:@"msgbody/msgchild/refNote"];
//        NSLog(@"====refNoteArray======%@",self.refNoteArray);
        
        // 舱位等级
        self.classArray = [response.data find:@"msgbody/msgchild/class"];
        // 有数据显示
        self.historicalTableView.tableFooterView = _button;
    }
    //    NSLog(@"====classArray======%@",self.classArray);
    [activityView performSelector:@selector(endActivity) withObject:activityView afterDelay:0.7];
    [activityView removeFromSuperview];
    [self.historicalTableView reloadData];
    
}

-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= [NSString stringWithFormat:@"舱位(%@-%@)",self.ShippingCtity,self.ShippingarriveCity];
}
-(void)allControllerView
{
    _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button.frame = CGRectMake(0, 0, 320, 60);
    _button.layer.borderWidth = 0.3;
    [_button setImage:[UIImage imageNamed:@"wow@2x.png"] forState:(UIControlStateNormal)];
    [_button setImageEdgeInsets:(UIEdgeInsetsMake(20, 70, 20, 230))];
    [_button setTitle:@"非成人购票说明" forState:(UIControlStateNormal)];
    [_button setTitleColor:RGBACOLOR(57, 175, 237, 1) forState:(UIControlStateNormal)];
    [_button addTarget:self action:@selector(buttonClik) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.historicalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,self.view.frame.size.height)];
    self.historicalTableView.delegate = self;
    self.historicalTableView.dataSource = self;
    [self.view addSubview:self.historicalTableView];
    
    
    self.infoTextView = [[UITextView alloc]initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    self.infoTextView.text =@"\v儿童票须知：\n1、使用儿童票的乘客：登机当天应满2周岁但未满12周岁。\v2、购买儿童票可优先使用：户口簿、身份证、护照。\n3、登机时出示的证件号码，应与订票时所填证件号码一致。\v4、儿童票为全价票的50%，机场建设费免收，燃油税减半。\v\v退改签说明：\v套餐退订：起飞前2小时以外需收取票面价5%的退票费，起飞前2小时（含）以内及起飞后需收取票面价10％的退票费（婴儿、儿童免收退票费）。套餐更改：起飞前2小时以外同等舱位免费更改，起飞前2小时（含）以内及起飞后需收取票面价5％的更改费。改期费与升舱费同时发生时，需同时收取。\v\v婴儿票须知：\v1、使用婴儿票的乘客：登机当天应满14天但未满2周岁，未满14天的婴儿不能乘机。\v2、购买婴儿票可优先使用：出生证明、户口簿、身份证、护照。\v3、登机时出示的证件号码，应与订票时所填证件号码一致。\v4、婴儿票为全价票的10%，机场建设费和燃油税免收。";
    self.infoTextView.editable = NO;
    self.infoTextView.backgroundColor = RGBACOLOR(10, 10, 10, 0.9);
    self.infoTextView.font = [UIFont systemFontOfSize:18];
    self.infoTextView.textColor = [UIColor whiteColor];
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveView)];
    swipe.direction=UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft;
    [self.infoTextView addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveView)];
    TapGestureRecognizer.numberOfTapsRequired = 1;
    [self.infoTextView addGestureRecognizer:TapGestureRecognizer];
    self.navigationController.view.backgroundColor =RGBACOLOR(3, 198, 230, 0.9);
    [self.navigationController.view addSubview:self.infoTextView ];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.priceDetailsIdArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(TicketCustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indefault = @"cell";
    TicketCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefault];
    if (!cell) {
        cell = [[TicketCustomTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:indefault];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *backviewcell=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backviewcell.backgroundColor=RGBACOLOR(165, 238, 255, 1);
    cell.selectedBackgroundView = backviewcell;
    
    NLProtocolData *craftTypeData = [self.classArray objectAtIndex:indexPath.row];
    NLProtocolData *priceArrayData = [self.priceArray objectAtIndex:indexPath.row];
    NLProtocolData *quantityArrayData = [self.quantityArray objectAtIndex:indexPath.row];
    
    [cell shipTitleLable:craftTypeData.value discountShipLable:@"" endorseLable:[NSString stringWithFormat:@"票数：%@张",quantityArrayData.value] endMoneyLable:[NSString stringWithFormat:@"￥%@",priceArrayData.value]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 机票实际价格
    NLProtocolData *priceData = [self.priceArray objectAtIndex:indexPath.row];
    
    // 航班
    NLProtocolData *msgchildData = [self.msgchildArray objectAtIndex:indexPath.row];
    
    // 机票原始价
    NLProtocolData *standardPriceData = [self.standardPriceArray objectAtIndex:indexPath.row];
    
    // 燃油附加费
    NLProtocolData *oilFeeData = [self.oilFeeArray objectAtIndex:indexPath.row];
    
    // 成人税
    NLProtocolData *taxData = [self.taxArray objectAtIndex:indexPath.row];
    
    // 儿童标准价
    NLProtocolData *standardPriceForChildData = [self.standardPriceForChildArray objectAtIndex:indexPath.row];
    
    // 儿童燃油费用
    NLProtocolData *oilFeeForChildData = [self.oilFeeForChildArray objectAtIndex:indexPath.row];
    
    // 儿童税
    NLProtocolData *taxForChildData = [self.taxForChildArray objectAtIndex:indexPath.row];
    
    // 婴儿标准价
    NLProtocolData *standardPriceForBabyData = [self.standardPriceForBabyArray objectAtIndex:indexPath.row];
    
    // 婴儿燃油费用
    NLProtocolData *oilFeeForBabyData = [self.oilFeeForBabyArray objectAtIndex:indexPath.row];
    
    // 婴儿税
    NLProtocolData *taxForBabyData = [self.taxForBabyArray objectAtIndex:indexPath.row];
    
    // 剩余票量
    NLProtocolData *quantityData = [self.quantityArray objectAtIndex:indexPath.row];
    
    // 更改政策说明
    NLProtocolData *rerNoteData = [self.rerNoteArray objectAtIndex:indexPath.row];
    NSLog(@"====rerNoteData======%@",rerNoteData.value);
    
    
    // 改签政策说明
    NLProtocolData *endNoteData = [self.endNoteArray objectAtIndex:indexPath.row];
    NSLog(@"====endNoteData======%@",endNoteData.value);
    
    
    // 退票政策说明
    NLProtocolData *refNoteData = [self.refNoteArray objectAtIndex:indexPath.row];
    NSLog(@"====refNoteData======%@",refNoteData.value);
    
    
    // 舱位等级
    NLProtocolData *classData = [self.classArray objectAtIndex:indexPath.row];
    
    
    TicketInfoImationViewController *ticketInfoImationView  = [[TicketInfoImationViewController alloc]init];
    
    ticketInfoImationView.priceTicket = priceData.value;
    ticketInfoImationView.msgchildTicket = msgchildData.value;
    ticketInfoImationView.standardPriceTicket = standardPriceData.value;
    ticketInfoImationView.oilFeeTicket = oilFeeData.value;
    ticketInfoImationView.taxTicket = taxData.value;
    ticketInfoImationView.standardPriceChirldTicket = standardPriceForChildData.value;
    ticketInfoImationView.oilFeeChirldTicket = oilFeeForChildData.value;
    ticketInfoImationView.taxForTicket = taxForChildData.value;
    ticketInfoImationView.standardPricebadyTicket = standardPriceForBabyData.value;
    ticketInfoImationView.oilFeeForBabyTicket = oilFeeForBabyData.value;
    ticketInfoImationView.taxForBabyTicket = taxForBabyData.value;
    ticketInfoImationView.quantityTicket = quantityData.value;
    ticketInfoImationView.rerNoteTicket = rerNoteData.value;
    ticketInfoImationView.endNoteTicket = endNoteData.value;
    ticketInfoImationView.refNoteTicket = refNoteData.value;
    ticketInfoImationView.classTicket = classData.value;
    ticketInfoImationView.TicketArriveCode  = self.DepartCtityShip;
    ticketInfoImationView.TicketDepartCode = self.arriveCityShip;
    ticketInfoImationView.TicketDeTimeFrom = self.shipTimeCity;
    ticketInfoImationView.TicketArriveTimeTo = self.arriveTimeShipFrom;
    ticketInfoImationView.TicketArrivePlay= self.shipArriveCity ;
    ticketInfoImationView.TicketDepartPlay= self.shipDepartCity;
    ticketInfoImationView.TicketInfoDepartCtity = self.ShippingCtity;
    ticketInfoImationView.TicketInfoArriveCity  = self.ShippingarriveCity;
    ticketInfoImationView.playName = self.airLineNameShip;
    ticketInfoImationView.TicketFlihtCity = self.shipFlihtCity;
    
    ticketInfoImationView.TicketdPortCodeship= self.dPortCodeship;
    ticketInfoImationView.TicketaPortCodeship= self.aPortCodeship;
    ticketInfoImationView.TicketdFromCtityId= self.ShippingFromCtityId;
    ticketInfoImationView.TicketdToArriveCityId= self.ShippingToArriveCityId;
    
    
    // 生成订单字段
    //    NSMutableArray *AllFlightInformation = [[NSMutableArray alloc]initWithObjects: self.ShippingFromCtityId,self.ShippingToArriveCityId,self.dPortCodeship,self.aPortCodeship,self.airLineCodeShip,self.shipFlihtCity,classData.value,self.shipTimeCity,self.arriveTimeShipFrom,nil];
    //    NSLog(@"=======AllFlightInformation=====%@",AllFlightInformation);
    //    ticketInfoImationView.TicketdAllFlightInformation = AllFlightInformation;
    //
    //    for (NLProtocolData *price  in self.priceDetailsIdArray)
    //    {
    //        NSLog(@"=====price====%@",price.value);
    //    }
    // 对象id来获得订单号
    NLProtocolData *priceId = [self.priceDetailsIdArray objectAtIndex:indexPath.row];
    ticketInfoImationView.TicketdPicedId = priceId.value;
    
    // 单返类型
    ticketInfoImationView.FlightType = @"S";
    [self.navigationController pushViewController:ticketInfoImationView animated:YES];
    
}

-(void)buttonClik
{
    [UIView animateWithDuration:0.3 animations:^{
        self.infoTextView .frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}
-(void)moveView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.infoTextView .frame = CGRectMake(320, 0, 320, self.view.frame.size.height);
    }];
    
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






















