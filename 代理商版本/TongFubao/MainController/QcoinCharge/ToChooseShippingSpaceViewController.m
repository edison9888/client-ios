//
//  ToChooseShippingSpaceViewController.m
//  TongFubao
//
//  Created by kin on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ToChooseShippingSpaceViewController.h"
#import "GoShippingSpaceView.h"
#import "TicketInfoImationViewController.h"



@interface ToChooseShippingSpaceViewController ()

@end

@implementation ToChooseShippingSpaceViewController

@synthesize ShippingDepartCodeCtity,ShippingArriveCodeCity,ShippingDepartFromTime,ShippingReturnToTime,ShippingCityIDFrom,ShippingCityIDTo,ShippingRoundDepartCity,ShippingRoundArriveCity,ShippingSearchType,BackShipping,GoSpaceView,infoTextView,selectionLable,goFirstPaiXuaAllArray,returnSecondPaiXuaArray;

@synthesize activityView,priceDetailsIdArray,priceArray,msgchildArray,standardPriceArray,oilFeeArray,taxArray,standardPriceForChildArray,oilFeeForChildArray,taxForChildArray,standardPriceForBabyArray,oilFeeForBabyArray,taxForBabyArray,quantityArray ,rerNoteArray ,endNoteArray,refNoteArray,classArray,flightArray,firstPaiXuaAllArray,secondPaiXuaAllArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"舱位选择";

//    NSLog(@"=====ShippFirstPlayInfoArray========%@",self.ShippFirstPlayInfoArray);
//    NSLog(@"=====ShippSeconPlayInfoArray========%@",self.ShippSeconPlayInfoArray);
    
    
    self.infoTextView = [[UITextView alloc]initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    self.infoTextView.text =@"\v儿童票须知：\n1、使用儿童票的乘客：登机当天应满2周岁但未满12周岁。\v2、购买儿童票可优先使用：户口簿、身份证、护照。\n3、登机时出示的证件号码，应与订票时所填证件号码一致。\v4、儿童票为全价票的50%，机场建设费免收，燃油税减半。\v\v退改签说明：\v套餐退订：起飞前2小时以外需收取票面价5%的退票费，起飞前2小时（含）以内及起飞后需收取票面价10％的退票费（婴儿、儿童免收退票费）。套餐更改：起飞前2小时以外同等舱位免费更改，起飞前2小时（含）以内及起飞后需收取票面价5％的更改费。改期费与升舱费同时发生时，需同时收取。\v\v婴儿票须知：\v1、使用婴儿票的乘客：登机当天应满14天但未满2周岁，未满14天的婴儿不能乘机。\v2、购买婴儿票可优先使用：出生证明、户口簿、身份证、护照。\v3、登机时出示的证件号码，应与订票时所填证件号码一致。\v4、婴儿票为全价票的10%，机场建设费和燃油税免收。";
    self.infoTextView.editable = NO;
    self.infoTextView.backgroundColor = RGBACOLOR(3, 198, 230, 0.9);
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
    
    NSArray *PersonArray = @[@"行程舱",@"回程舱"];
    UILabel *backLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 320, 45)];
    backLable.backgroundColor = RGBACOLOR(204, 225, 152, 1);
    [self.view addSubview:backLable];
    self.selectionLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 320/2, 45)];
    self.selectionLable.backgroundColor = RGBACOLOR(143, 195, 31, 1);
    [self.view addSubview:self.selectionLable];
    for (int i = 0; i < 2; i++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(320/2*i, 64, 320/2, 45);
        [button setTitle:[PersonArray objectAtIndex:i] forState:(UIControlStateNormal)];
        button.tag = i;
        button.selected = YES;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(ClikButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.view addSubview:button];
    }

    self.GoSpaceView = [[GoShippingSpaceView alloc]initWithFrame:CGRectMake(0, 109, 320, self.view.frame.size.height-109)];
    self.GoSpaceView.delegate = self;
    [self.view addSubview:self.GoSpaceView];
    
    self.BackShipping = [[BackShippingSpaceView alloc]initWithFrame:CGRectMake(0, 109, 320, self.view.frame.size.height-109)];
    self.BackShipping.delegate = self;
    self.BackShipping.hidden = YES;
    [self.view addSubview:self.BackShipping];

    // 网络请求
    [self nextWork];
    
}

-(void)nextWork
{
    self.activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    self.activityView .center = self.view.center;
    [self.activityView  setTipsText:@"正在加载数据..."];
    [self.activityView  starActivity];
    [self.view addSubview:activityView];


    NSString* name = [NLUtils getNameForRequest:Notify_GetAirlineDetail];
    REGISTER_NOTIFY_OBSERVER(self, GetAirlineDetail, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES] departCityCode:self.ShippingDepartCodeCtity arriveCityCode:self.ShippingArriveCodeCity departTime:[self.ShippFirstPlayInfoArray objectAtIndex:0] returnTime:[self.ShippSeconPlayInfoArray objectAtIndex:0] searchType:@" " flight:[self.ShippFirstPlayInfoArray objectAtIndex:7] returnFlight:[self.ShippSeconPlayInfoArray objectAtIndex:7]];
}


-(void)GetAirlineDetail:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataWithAirline:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        [activityView performSelector:@selector(endActivity) withObject:activityView afterDelay:0.7];
        [activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！本日期没有航班" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"===string====%@",string);
        [activityView performSelector:@selector(endActivity) withObject:activityView afterDelay:0.7];
        [activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！本日期没有航班" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
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
        [activityView performSelector:@selector(endActivity) withObject:activityView afterDelay:0.7];
        [activityView removeFromSuperview];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！服务数据可能错误。" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        // 机票价格id
        self.priceDetailsIdArray = [response.data find:@"msgbody/msgchild/id"];
        NSMutableArray *priceDetailsId = [[NSMutableArray alloc]init];
        for (NLProtocolData *priceDetailsData in self.priceDetailsIdArray)
        {
            [priceDetailsId addObject:priceDetailsData.value];
        }
        

        // 机票实际价格
        self.priceArray = [response.data find:@"msgbody/msgchild/price"];
        NSMutableArray *price = [[NSMutableArray alloc]init];
        for (NLProtocolData *priceData in self.priceArray)
        {
            [price addObject:priceData.value];
        }
        // 机票原始价
        self.standardPriceArray = [response.data find:@"msgbody/msgchild/standardPrice"];
        NSMutableArray *standardPrice = [[NSMutableArray alloc]init];
        for (NLProtocolData *standardPriceData in self.standardPriceArray)
        {
            [standardPrice addObject:standardPriceData.value];
        }
        
        // 燃油附加费
        self.oilFeeArray = [response.data find:@"msgbody/msgchild/oilFee"];
        NSMutableArray *oilFee = [[NSMutableArray alloc]init];
        for (NLProtocolData *oilFeeData in self.oilFeeArray)
        {
            [oilFee addObject:oilFeeData.value];
        }

        // 成人税
        self.taxArray = [response.data find:@"msgbody/msgchild/tax"];
        NSMutableArray *tax = [[NSMutableArray alloc]init];
        for (NLProtocolData *taxData in self.taxArray)
        {
            [tax addObject:taxData.value];
        }

        // 儿童标准价
        self.standardPriceForChildArray = [response.data find:@"msgbody/msgchild/standardPriceForChild"];
        NSMutableArray *standardPriceForChild = [[NSMutableArray alloc]init];
        for (NLProtocolData *standardPriceForChildData in self.standardPriceForChildArray)
        {
            [standardPriceForChild addObject:standardPriceForChildData.value];
        }
        
        // 儿童燃油费用
        self.oilFeeForChildArray = [response.data find:@"msgbody/msgchild/oilFeeForChild"];
        NSMutableArray *oilFeeForChild = [[NSMutableArray alloc]init];
        for (NLProtocolData *oilFeeForChildData in self.oilFeeForChildArray)
        {
            [oilFeeForChild addObject:oilFeeForChildData.value];
        }
        

        // 儿童税
        self.taxForChildArray = [response.data find:@"msgbody/msgchild/taxForChild"];
        NSMutableArray *taxForChild = [[NSMutableArray alloc]init];
        for (NLProtocolData *taxForChildData in self.taxForChildArray)
        {
            [taxForChild addObject:taxForChildData.value];
        }

        // 婴儿标准价
        self.standardPriceForBabyArray = [response.data find:@"msgbody/msgchild/standardPriceForBaby"];
        NSMutableArray *standardPriceForBaby = [[NSMutableArray alloc]init];
        for (NLProtocolData *standardPriceForBabyData in self.standardPriceForBabyArray)
        {
            [standardPriceForBaby addObject:standardPriceForBabyData.value];
        }
        
        // 婴儿燃油费用
        self.oilFeeForBabyArray = [response.data find:@"msgbody/msgchild/oilFeeForBaby"];
        NSMutableArray *oilFeeForBaby = [[NSMutableArray alloc]init];
        for (NLProtocolData *oilFeeForBabyData in self.oilFeeForBabyArray)
        {
            [oilFeeForBaby addObject:oilFeeForBabyData.value];
        }
        

        // 婴儿税
        self.taxForBabyArray = [response.data find:@"msgbody/msgchild/taxForBaby"];
        NSMutableArray *taxForBaby = [[NSMutableArray alloc]init];
        for (NLProtocolData *taxForBabyData in self.taxForBabyArray)
        {
            [taxForBaby addObject:taxForBabyData.value];
        }

        // 剩余票量
        self.quantityArray = [response.data find:@"msgbody/msgchild/quantity"];
        NSMutableArray *quantity = [[NSMutableArray alloc]init];
        for (NLProtocolData *quantityData in self.quantityArray)
        {
            [quantity addObject:quantityData.value];
        }
        
        // 更改政策说明
        self.rerNoteArray = [response.data find:@"msgbody/msgchild/rerNote"];
        NSMutableArray *rerNote = [[NSMutableArray alloc]init];
        for (NLProtocolData *rerNoteData in self.rerNoteArray)
        {
            [rerNote addObject:rerNoteData.value];
        }
        
        // 改签政策说明
        self.endNoteArray = [response.data find:@"msgbody/msgchild/endNote"];
        NSMutableArray *endNote = [[NSMutableArray alloc]init];
        for (NLProtocolData *endNoteData in self.endNoteArray)
        {
            [endNote addObject:endNoteData.value];
        }

        // 退票政策说明
        self.refNoteArray = [response.data find:@"msgbody/msgchild/refNote"];
        NSMutableArray *refNote = [[NSMutableArray alloc]init];
        for (NLProtocolData *refNoteData in self.refNoteArray)
        {
            [refNote addObject:refNoteData.value];
        }

        // 舱位等级
        self.classArray = [response.data find:@"msgbody/msgchild/class"];
        NSMutableArray *classA = [[NSMutableArray alloc]init];
        for (NLProtocolData *classAData in self.classArray)
        {
            [classA addObject:classAData.value];
        }

        // 航班号
        self.flightArray = [response.data find:@"msgbody/msgchild/flight"];
        NSMutableArray *flight = [[NSMutableArray alloc]init];
        for (NLProtocolData *flightData in self.flightArray)
        {
            [flight addObject:flightData.value];
        }

        NSMutableArray *allObjectArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [flight count]; i++)
        {
            NSMutableArray *otherObjectArray = [[NSMutableArray alloc]init];

           [otherObjectArray addObject:[flight objectAtIndex:i]];
           [otherObjectArray addObject:[classA objectAtIndex:i]];
           [otherObjectArray addObject:[refNote objectAtIndex:i]];
            
            [otherObjectArray addObject:[endNote objectAtIndex:i]];
            [otherObjectArray addObject:[rerNote objectAtIndex:i]];
            
            [otherObjectArray addObject:[quantity objectAtIndex:i]];
            [otherObjectArray addObject:[taxForBaby objectAtIndex:i]];
            [otherObjectArray addObject:[oilFeeForBaby objectAtIndex:i]];
            
            [otherObjectArray addObject:[standardPriceForBaby objectAtIndex:i]];
            [otherObjectArray addObject:[taxForChild objectAtIndex:i]];
            [otherObjectArray addObject:[oilFeeForChild objectAtIndex:i]];
            
            [otherObjectArray addObject:[standardPriceForChild objectAtIndex:i]];
            [otherObjectArray addObject:[tax objectAtIndex:i]];
            [otherObjectArray addObject:[oilFee objectAtIndex:i]];
            
            [otherObjectArray addObject:[standardPrice objectAtIndex:i]];
            [otherObjectArray addObject:[price objectAtIndex:i]];
            [otherObjectArray addObject:[priceDetailsId objectAtIndex:i]];
            
            [allObjectArray addObject:otherObjectArray];
        }
        
        NSMutableArray *ShippFirstObjectArray = [[NSMutableArray alloc]init];
        NSMutableArray *ShippSeconObjectArray = [[NSMutableArray alloc]init];

        for (int i = 0 ; i < [allObjectArray count]; i++)
        {
            if ([[self.ShippFirstPlayInfoArray objectAtIndex:7] isEqualToString:[[allObjectArray objectAtIndex:i] objectAtIndex:0]])
            {
                [ShippFirstObjectArray addObject:[allObjectArray objectAtIndex:i]];
            }
            else if([[self.ShippSeconPlayInfoArray objectAtIndex:7] isEqualToString:[[allObjectArray objectAtIndex:i] objectAtIndex:0]])
            {
                [ShippSeconObjectArray addObject:[allObjectArray objectAtIndex:i]];
            }
        }
        self.firstPaiXuaAllArray = ShippFirstObjectArray;
        self.secondPaiXuaAllArray = ShippSeconObjectArray;
        NSLog(@"====self.firstPaiXuaAllArray====%@",self.firstPaiXuaAllArray);
        NSLog(@"====self.secondPaiXuaAllArray====%@",self.secondPaiXuaAllArray);
    }
    
    [activityView performSelector:@selector(endActivity) withObject:activityView afterDelay:0.7];
    [activityView removeFromSuperview];
    [self.GoSpaceView GoShippingdata:self.firstPaiXuaAllArray];
    [self.BackShipping BackShippingdata:self.secondPaiXuaAllArray];
    
}
#pragma mark --- 代理方法舱位选择
-(void)GoShippingSpaceView:(NSMutableArray *)newGoShippingSpaceArray
{
    NSLog(@"=======newGoShippingSpaceArray========%@",newGoShippingSpaceArray);
    self.goFirstPaiXuaAllArray = newGoShippingSpaceArray;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionLable.frame = CGRectMake(320/2, 64, 320/2, 45);
    }];
    self.GoSpaceView.hidden = YES;
    self.BackShipping.hidden = NO;
}
-(void)BackShippingSpaceView:(NSMutableArray *)newBackShippingSpaceArray
{

    self.returnSecondPaiXuaArray = newBackShippingSpaceArray;
    
    if ([self.goFirstPaiXuaAllArray count] > 0 && [self.returnSecondPaiXuaArray count] > 0)
    {
        TicketInfoImationViewController *TicketInfoImationView = [[TicketInfoImationViewController alloc] init];
        // 单返类型
        TicketInfoImationView.FlightType = @"D";
        // 第一页cell面信息
        TicketInfoImationView.firstTicketArray = self.ShippFirstPlayInfoArray;
        // 第二页cell面信息
        TicketInfoImationView.seconedTicketArray = self.ShippSeconPlayInfoArray;
        
        // 城市
        TicketInfoImationView.TicketInfoDepartCtity= self.ShippingRoundDepartCity;
        TicketInfoImationView.TicketInfoArriveCity = self.ShippingRoundArriveCity;
        // 舱位
        TicketInfoImationView.classTicketFist = [self.goFirstPaiXuaAllArray objectAtIndex:1];
        TicketInfoImationView.classTicketSecond = [self.returnSecondPaiXuaArray objectAtIndex:1];
        
        /* 订单参考*/
        // 实际票价
        TicketInfoImationView.priceTicket= [self.goFirstPaiXuaAllArray objectAtIndex:15] ;
        // 燃油
        TicketInfoImationView.oilFeeTicket= [self.goFirstPaiXuaAllArray objectAtIndex:13];
        // 成人税
        TicketInfoImationView.taxTicket= [self.goFirstPaiXuaAllArray objectAtIndex:12];
        
        NSMutableArray *fromTicketInfo = [[NSMutableArray alloc]initWithObjects:[self.goFirstPaiXuaAllArray objectAtIndex:15],[self.goFirstPaiXuaAllArray objectAtIndex:13],[self.goFirstPaiXuaAllArray objectAtIndex:12],[self.goFirstPaiXuaAllArray objectAtIndex:11],[self.goFirstPaiXuaAllArray objectAtIndex:10],[self.goFirstPaiXuaAllArray objectAtIndex:9],[self.goFirstPaiXuaAllArray objectAtIndex:8],[self.goFirstPaiXuaAllArray objectAtIndex:7],[self.goFirstPaiXuaAllArray objectAtIndex:6], nil];
    
        TicketInfoImationView.fromTicketPriceArray = fromTicketInfo;
        NSLog(@"====fromTicketInfo====%@",fromTicketInfo);
        // 回程的价，油，税
        NSMutableArray *backTicketInfo = [[NSMutableArray alloc]initWithObjects:[self.returnSecondPaiXuaArray objectAtIndex:15],[self.returnSecondPaiXuaArray objectAtIndex:13],[self.returnSecondPaiXuaArray objectAtIndex:12],[self.returnSecondPaiXuaArray objectAtIndex:11],[self.returnSecondPaiXuaArray objectAtIndex:10],[self.returnSecondPaiXuaArray objectAtIndex:9],[self.returnSecondPaiXuaArray objectAtIndex:8],[self.returnSecondPaiXuaArray objectAtIndex:7],[self.returnSecondPaiXuaArray objectAtIndex:6], nil];
        TicketInfoImationView.backTicketPrice = backTicketInfo;
        NSLog(@"====backTicketInfo====%@",backTicketInfo);
        
        // 去回程票id
        TicketInfoImationView.fromPriceTicketId = [self.goFirstPaiXuaAllArray objectAtIndex:16];
        TicketInfoImationView.backPriceTicketId = [self.returnSecondPaiXuaArray objectAtIndex:16];
        
        [self.navigationController pushViewController:TicketInfoImationView animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionLable.frame = CGRectMake(0, 64, 320/2, 45);
    }];
    self.GoSpaceView.hidden = NO;
    self.BackShipping.hidden = YES;
}
-(void)moveView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.infoTextView .frame = CGRectMake(320, 0, 320, self.view.frame.size.height);
    }];
}
-(void)IllustrateByPlane
{
    [UIView animateWithDuration:0.3 animations:^{
        self.infoTextView .frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}
#pragma mark --- 选择舱位
-(void)ClikButton:(UIButton *)sender
{
    UIButton *senderButton = (UIButton *)sender;
    [UIView animateWithDuration:0.3 animations:^{
         self.selectionLable.frame = CGRectMake(320/2*senderButton.tag, 64, 320/2, 45);
    }];
    if (senderButton.tag == 0)
    {
        self.GoSpaceView.hidden = NO;
        self.BackShipping.hidden = YES;
    }
    else if (senderButton.tag == 1)
    {
        self.GoSpaceView.hidden = YES;
        self.BackShipping.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
