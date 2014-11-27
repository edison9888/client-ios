//
//  HistoricalRecordViewController.m
//  TongFubao
//
//  Created by kin on 14-8-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HistoricalRecordViewController.h"
#import "TicketCustomTableViewCell.h"
#import "RecordDetailsViewController.h"
#import "PlayCustomActivityView.h"


@interface HistoricalRecordViewController ()
{
    PlayCustomActivityView *_activityView;
    NSDictionary *dictionary;
}

@end

@implementation HistoricalRecordViewController
@synthesize OrderdAllArray,historicalTableView,buttonView,OrderdSet;

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
    self.OrderdAllArray = [[NSMutableArray alloc]init];
    self.OrderdSet = [[NSMutableSet alloc]init];
    dictionary = @{@"W":@"未处理",@"P":@"处理中",@"S":@"已成交",@"C":@"已取消",@"R":@"全部退票",@"T":@"部分退票",@"U":@"未提交"};
    // 控件
    [self allViewControl];
    // 网络请求
    [self nextWork];
    [self navigationView];
    
}

-(void)nextWork
{
    _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    _activityView.center = self.view.center;
    [_activityView setTipsText:@"正在加载数据..."];
    [_activityView starActivity];
    [self.view addSubview:_activityView];


    NSString* name = [NLUtils getNameForRequest:Notify_getOrderHistory];
    REGISTER_NOTIFY_OBSERVER(self, getOrderHistory, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]getOrderHistoryMsgstart:@"0" getOrderHistoryMsgdisplay:@"20"];
}

-(void)getOrderHistory:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getDataOrderHistory:response];
        
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
    NSString *string = response.detail;
    NSLog(@"===string====%@",string);
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];


}
- (void)getDataOrderHistory:(NLProtocolResponse *)response
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
    }
    else
    {
        
        
        
        NSMutableArray *OrderdepartCityArray= [[NSMutableArray alloc]init];
        NSMutableArray *OrderdarriveCityArray = [[NSMutableArray alloc]init];
        NSMutableArray *OrderdcreateOrderTimeArray = [[NSMutableArray alloc]init];
        NSMutableArray *OrderdtakeOffTimeArray = [[NSMutableArray alloc]init];
        NSMutableArray *OrderdflightArray = [[NSMutableArray alloc]init];
        NSMutableArray *OrderdcraftTypeArray = [[NSMutableArray alloc]init];
        NSMutableArray *OrderdtotalPriceArray = [[NSMutableArray alloc]init];
        NSMutableArray *OrderdstatusArray = [[NSMutableArray alloc]init];
        // 机票实际价格
        NSArray *departCityArray = [response.data find:@"msgbody/msgchild/departCity"];
        
        if ([departCityArray count] > 0)
        {
            

        for (NLProtocolData *departCityData  in departCityArray)
        {
            [OrderdepartCityArray addObject:departCityData.value];
        }
        NSArray *arriveCityArray = [response.data find:@"msgbody/msgchild/arriveCity"];
        for (NLProtocolData *arriveCityData  in arriveCityArray)
        {
            [OrderdarriveCityArray addObject:arriveCityData.value];
        }

        NSArray *createOrderTimeArray = [response.data find:@"msgbody/msgchild/createOrderTime"];
        for (NLProtocolData *createOrderTimeData  in createOrderTimeArray)
        {
            [OrderdcreateOrderTimeArray addObject:createOrderTimeData.value];
        }

        NSArray *takeOffTimeCityArray = [response.data find:@"msgbody/msgchild/takeOffTime"];
        for (NLProtocolData *takeOffTimeData  in takeOffTimeCityArray)
        {
            [OrderdtakeOffTimeArray addObject:takeOffTimeData.value];
        }

        NSArray *flightCityArray = [response.data find:@"msgbody/msgchild/flight"];
        for (NLProtocolData *flightData  in flightCityArray)
        {
            [OrderdflightArray addObject:flightData.value];
        }

        NSArray *craftTypeArray = [response.data find:@"msgbody/msgchild/craftType"];
        for (NLProtocolData *craftTypeData  in craftTypeArray)
        {
            [OrderdcraftTypeArray addObject:craftTypeData.value];
        }

        NSArray *totalPriceCityArray = [response.data find:@"msgbody/msgchild/totalPrice"];
        for (NLProtocolData *totalPriceData  in totalPriceCityArray)
        {
            [OrderdtotalPriceArray addObject:totalPriceData.value];
        }

        NSArray *statusCityArray = [response.data find:@"msgbody/msgchild/orderProcess"];
        for (NLProtocolData *statusData  in statusCityArray)
        {
            NSString *dic;
            NSLog(@"======statusData=====%@",statusData.value);
            if (statusData.value == nil) {
                dic =@"未处理";
            }else{
                dic = [dictionary objectForKey:statusData.value];
                NSLog(@"======statusData=====%@",dic);
             }

            [OrderdstatusArray addObject:dic];
        }
        
        
        for (int i = 0; i < [departCityArray count]; i++)
        {
            NSMutableArray *otherObjectArray = [[NSMutableArray alloc]init];
            [otherObjectArray addObject:[OrderdepartCityArray objectAtIndex:i]];
            [otherObjectArray addObject:[OrderdarriveCityArray objectAtIndex:i]];
            [otherObjectArray addObject:[OrderdcreateOrderTimeArray objectAtIndex:i]];
            [otherObjectArray addObject:[OrderdtakeOffTimeArray objectAtIndex:i]];
            [otherObjectArray addObject:[OrderdcraftTypeArray objectAtIndex:i]];
            [otherObjectArray addObject:[OrderdcraftTypeArray objectAtIndex:i]];
            [otherObjectArray addObject:[OrderdtotalPriceArray objectAtIndex:i]];
            [otherObjectArray addObject:[OrderdstatusArray objectAtIndex:i]];
            if (![self.OrderdAllArray containsObject:otherObjectArray])
            {
                [self.OrderdAllArray addObject:otherObjectArray];
            }
        }

    }
    NSLog(@"=====OrderdAllArray====%@",self.OrderdAllArray);
    if ([self.OrderdAllArray count] > 5)
    {
        self.historicalTableView.tableFooterView = self.buttonView;
    }
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    
    [_activityView removeFromSuperview];
    [self.historicalTableView reloadData];
    }
    
}



-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"历史记录";
}
-(void)allViewControl
{
    self.buttonView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.buttonView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UIButton * loadButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    loadButton.frame = CGRectMake(30, 10, 260, 40);
    loadButton.layer.cornerRadius = 5;
    loadButton.layer.masksToBounds = YES;
    loadButton.layer.borderWidth = 0.5;
    loadButton.backgroundColor = RGBACOLOR(3, 198, 230, 1);
    [loadButton addTarget:self action:@selector(loadDataButton) forControlEvents:(UIControlEventTouchUpInside)];
    [loadButton setTitle:@"点击加载更多数据" forState:UIControlStateNormal];
    [self.buttonView addSubview:loadButton];
    
    self.historicalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,self.view.frame.size.height)];
    self.historicalTableView.delegate = self;
    self.historicalTableView.dataSource = self;
    [self.view addSubview:self.historicalTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.OrderdAllArray count];
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
    
    if ([self.OrderdAllArray count] > 0)
    {
    NSString *string =[[self.OrderdAllArray objectAtIndex:indexPath.row] objectAtIndex:0];
    NSString *string1 =[[self.OrderdAllArray objectAtIndex:indexPath.row] objectAtIndex:1];
    NSLog(@"=====%@=====%@===",string,string1);
    
    NSString *fromTime = [[[self.OrderdAllArray objectAtIndex:indexPath.row]objectAtIndex:2] substringToIndex:10];

    [cell addNameLable:[NSString stringWithFormat:@"%@-%@",[[self.OrderdAllArray objectAtIndex:indexPath.row] objectAtIndex:0],[[self.OrderdAllArray objectAtIndex:indexPath.row]objectAtIndex:1]] moneyLable:[NSString stringWithFormat:@"￥%@",[[self.OrderdAllArray objectAtIndex:indexPath.row]objectAtIndex:6]] wacthTimeLable:fromTime];

    }
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordDetailsViewController *recordDetailsView = [[RecordDetailsViewController alloc]init];
    recordDetailsView.RecordDetailsArray = [self.OrderdAllArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:recordDetailsView animated:YES];
}

-(void)loadDataButton
{
    _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    _activityView.center = self.view.center;
    [_activityView setTipsText:@"正在加载数据..."];
    [_activityView starActivity];
    [self.view addSubview:_activityView];

    NSString* name = [NLUtils getNameForRequest:Notify_getOrderHistory];
    REGISTER_NOTIFY_OBSERVER(self, getOrderHistory, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]getOrderHistoryMsgstart:@"0" getOrderHistoryMsgdisplay:[NSString stringWithFormat:@"%d",[self.OrderdAllArray count]]];
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






















