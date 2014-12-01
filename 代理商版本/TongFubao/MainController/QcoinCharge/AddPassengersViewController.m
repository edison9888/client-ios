//
//  AddPassengersViewController.m
//  TongFubao
//
//  Created by kin on 14-8-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AddPassengersViewController.h"
#import "TicketCustomTableViewCell.h"
#import "addPersonViewController.h"
#import "PlayCustomActivityView.h"

@interface AddPassengersViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AddPassengersViewController
{
    UITableView *_historicalTableView;
    NSUserDefaults *_UserDefaults;
    PlayCustomActivityView *_activityView;
}

@synthesize CellIndexArray,CellDateArray,ticketArray,teger;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    // 导航
    [self navigationView];
    [self allControllerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personMessage:) name:@"添加乘机人" object:nil];
    [self InternetDownloads];

}
-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"添加乘机人";
    [self addRightButtonItemWithTitle:@"编辑"];
}
// 回调
-(void)leftItemClick:(id)sender
{
    [self.delegate addPersonIphoneArray:self.CellDateArray];
    [self.navigationController popViewControllerAnimated:YES];
}
// 右边导航
-(void)rightItemClick:(UIBarButtonItem *)sender
{
    [super setEditing:YES animated:YES];

    if (_historicalTableView.editing == NO)
    {
        [_historicalTableView setEditing:YES animated:YES ];
    }
    else
    {
        [_historicalTableView setEditing:NO animated:YES ];
    }
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    self.CellDateArray  = [[NSMutableArray alloc]init];
//    [self InternetDownloads];
//}
#pragma mark --- 通知方法
-(void)personMessage:(NSNotificationCenter *)sender
{
    [self InternetDownloads];
}

-(void)InternetDownloads
{
    _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    _activityView.center = self.view.center;
    [_activityView setTipsText:@"正在加载数据..."];
    [_activityView starActivity];
    [self.view addSubview:_activityView];
    self.CellDateArray  = [[NSMutableArray alloc]init];
    
    NSString* name = [NLUtils getNameForRequest:Notify_GetPassenger];
    REGISTER_NOTIFY_OBSERVER(self, ReadUpPassengers, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getPassengerType:@"1"];
}
-(void)ReadUpPassengers:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getPassenger:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"===string====%@",string);
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！加载数据失败！" delegate:self cancelButtonTitle:@"请重新加载" otherButtonTitles:@"退出", nil];
        [alert show];

    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self InternetDownloads];
//        NSString* name = [NLUtils getNameForRequest:Notify_GetPassenger];
//        REGISTER_NOTIFY_OBSERVER(self, ReadUpPassengers, name);
//        [[[NLProtocolRequest alloc] initWithRegister:YES] getPassengerType:@"1"];
    }
}

- (void)getPassenger:(NLProtocolResponse *)response
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

    }
    else
    {
        
        NSMutableDictionary *worldUnmber = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1",@"身份证",@"2",@"护照",@"4",@"军人证",@"7",@"回乡证",@"8",@"台胞证",@"10",@"港澳通行证",@"11",@"国际海员证",@"20",@"外国人永久居留证",@"25",@"户口簿",@"27",@"出生证明",@"99",@"其它", nil];
        

        NSMutableArray *PassengerCardIdArray  = [[NSMutableArray alloc]init];
        NSMutableArray *PassengerCardTypeArray  = [[NSMutableArray alloc]init];
        NSMutableArray *PassengerIdArray  = [[NSMutableArray alloc]init];
        NSMutableArray *PassengerNameArray  = [[NSMutableArray alloc]init];
        NSMutableArray *PassengerTypeArray  = [[NSMutableArray alloc]init];

        NSArray *PassengerName = [response.data find:@"msgbody/msgchild/name"];
        for (NLProtocolData *PassengerNameData in PassengerName)
        {
            [PassengerNameArray addObject:PassengerNameData.value];
        }
        
        NSArray *PassengerCardType = [response.data find:@"msgbody/msgchild/cardType"];
        for (NLProtocolData *PassengerCardData in PassengerCardType)
        {
            [PassengerCardTypeArray addObject:PassengerCardData.value];
        }
        
        NSArray *PassengerCardId = [response.data find:@"msgbody/msgchild/cardId"];
        for (NLProtocolData *PassengerCardIdData in PassengerCardId)
        {
            NSLog(@"=====passengerTypeData====%@",PassengerCardIdData.value);
            [PassengerCardIdArray addObject:PassengerCardIdData.value];
        }
        
        NSArray *PassengerId = [response.data find:@"msgbody/msgchild/id"];
        for (NLProtocolData *passengerIdData in PassengerId)
        {
            [PassengerIdArray addObject:passengerIdData.value];
        }
        
        NSArray *PassengerType = [response.data find:@"msgbody/msgchild/passengerType"];
        for (NLProtocolData *passengerTypeData in PassengerType)
        {
//            NSLog(@"=====passengerTypeData====%@",passengerTypeData.value);
            [PassengerTypeArray addObject:passengerTypeData.value];
        }
        
        for (int i = 0; i < [PassengerNameArray count]; i++)
        {
            NSMutableArray *otherArray = [[NSMutableArray alloc]init];
            [otherArray addObject:[PassengerNameArray objectAtIndex:i]];
            [otherArray addObject:[PassengerCardTypeArray objectAtIndex:i]];
            [otherArray addObject:[PassengerCardIdArray objectAtIndex:i]];
            [otherArray addObject:[PassengerIdArray objectAtIndex:i]];
            [otherArray addObject:[PassengerTypeArray objectAtIndex:i]];
            [otherArray addObject:[worldUnmber objectForKey:[PassengerCardTypeArray objectAtIndex:i]]];
            [self.CellDateArray addObject:otherArray];
        }
    }
//    NSLog(@"====CellDateArray===%@",self.CellDateArray);
    for (NSString *string in self.CellDateArray)
    {
        NSLog(@"=====string====%@",string);
    }
//    NSLog(@"====ticketArray===%@",self.ticketArray);

        for (int i = 0; i < [self.CellDateArray count]; i++)
        {
            [[self.CellDateArray objectAtIndex:i] addObject:@"a"];
        }
    
    if (teger == 1)
    {
        if ([self.ticketArray count] > 0)
        {
            for (int i = 0; i < [self.CellDateArray count]; i++)
            {
                for (int j = 0; j < [self.ticketArray count]; j++)
                {
                    if ([[[self.CellDateArray objectAtIndex:i] objectAtIndex:3] intValue] ==[[[self.ticketArray objectAtIndex:j] objectAtIndex:3] intValue])
                    {
                        [[self.CellDateArray objectAtIndex:i] removeObjectAtIndex:6];
                        [[self.CellDateArray objectAtIndex:i] addObject:@"b"];
                    }
                }
            }
        }
    }
    else if(teger == 0)
    {
        self.ticketArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ticketPeson"];
        if ([self.ticketArray count] > 0)
        {
            for (int i = 0; i < [self.CellDateArray count]; i++)
            {
                for (int j = 0; j < [self.ticketArray count]; j++)
                {
                    if ([[[self.CellDateArray objectAtIndex:i] objectAtIndex:3] intValue] ==[[[self.ticketArray objectAtIndex:j] objectAtIndex:3] intValue])
                    {
                        if ([[[self.ticketArray objectAtIndex:j] objectAtIndex:6] isEqualToString:@"b"])
                        {
                            [[self.CellDateArray objectAtIndex:i] removeObjectAtIndex:6];
                            [[self.CellDateArray objectAtIndex:i] addObject:@"b"];
                        }
                    }
                }
            }
        }
    }
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];
    [_historicalTableView reloadData];
    
}

-(void)allControllerView
{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 320, 60);
    [button setImageEdgeInsets:(UIEdgeInsetsMake(15, 20, 15, 270))];
    [button setTitleEdgeInsets:(UIEdgeInsetsMake(5, 0, 5, 150))];
    [button setTitle:@"添加乘机人" forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:@"785@2x.png"] forState:(UIControlStateNormal)];
    [button setTitleColor:RGBACOLOR(210, 210, 210, 1) forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(addClik) forControlEvents:(UIControlEventTouchUpInside)];
    UIImageView *lineAccorIamge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 58, 320, 1)];
    lineAccorIamge.image = [UIImage imageNamed:@"line@2x.png"];
    [self.view addSubview:lineAccorIamge];
    [button addSubview:lineAccorIamge];
    
    _historicalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _historicalTableView.delegate = self;
    _historicalTableView.dataSource = self;
    _historicalTableView.tableHeaderView = button;
    [self.view addSubview:_historicalTableView];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete  ;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteDateSoures:indexPath.row];
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        [self.CellDateArray removeObjectAtIndex:indexPath.row];
        [_historicalTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(UITableViewRowAnimationRight)];
    }
}
// 删除数据
-(void)deleteDateSoures:(NSInteger)indexPathId
{
    _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    _activityView.center = self.view.center;
    [_activityView setTipsText:@"正在删除数据..."];
    [_activityView starActivity];
    [self.view addSubview:_activityView];


    NSString* name = [NLUtils getNameForRequest:Notify_deletePassenger];
    REGISTER_NOTIFY_OBSERVER(self, GetdeletePassengerNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getdeletcetionPassengerId:[[self.CellDateArray objectAtIndex:indexPathId] objectAtIndex:3]  deletcetionPassengerType:@"1"] ;
    
}
-(void)GetdeletePassengerNotify:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getdeletePassenger:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"===string====%@",string);
    }
}

- (void)getdeletePassenger:(NLProtocolResponse *)response
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
        // 机票实际价格
        //        self.priceArray = [response.data find:@"msgbody/msgchild/price"];
    }
    [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
    [_activityView removeFromSuperview];
    
    [_historicalTableView reloadData];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.CellDateArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(TicketCustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indefault = @"cell";
    TicketCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefault];
    if (!cell)
    {
        cell = [[TicketCustomTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:indefault];
    }
    NSArray *arraycell=[cell.contentView subviews];
    for (UILabel *coview in arraycell) {
        [coview removeFromSuperview];
    }
    for (UIButton *button in arraycell) {
        [button removeFromSuperview];
    }

    UIButton *selectionBotton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    selectionBotton.frame =  CGRectMake(280, 5, 40, 40);
    selectionBotton.tag =indexPath.row;
    NSString * Stdey = [[self.CellDateArray objectAtIndex:indexPath.row] objectAtIndex:6];

    if ([Stdey isEqualToString:@"a"])
    {
        [selectionBotton setImage:[UIImage imageNamed:@"91@2x.png"] forState:(UIControlStateNormal)];
    }
    else if ([Stdey isEqualToString:@"b"])
    {
        [selectionBotton setImage:[UIImage imageNamed:@"9@2x.png"] forState:(UIControlStateNormal)];
    }
    selectionBotton.selected = YES;
    selectionBotton.tag = indexPath.row;
    [selectionBotton addTarget:self action:@selector(btnclick:event:) forControlEvents:(UIControlEventTouchUpInside)];
    cell. accessoryView = selectionBotton;
    
    
    cell.textLabel.text = [[self.CellDateArray objectAtIndex:indexPath.row] objectAtIndex:0];
    
    UILabel *PassengerCardType = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 100, 25)];
    PassengerCardType.font = [UIFont systemFontOfSize:15];
    PassengerCardType.text = [[self.CellDateArray objectAtIndex:indexPath.row] objectAtIndex:1];
    PassengerCardType.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview: PassengerCardType];
    
    UILabel *PassengercardId = [[UILabel alloc]initWithFrame:CGRectMake(105, 25, 150, 25)];
    PassengercardId.font = [UIFont systemFontOfSize:14];
    PassengercardId.backgroundColor = [UIColor clearColor];
    PassengercardId.text = [[self.CellDateArray objectAtIndex:indexPath.row] objectAtIndex:2];
    [cell.contentView addSubview: PassengercardId];

    
    return cell;
}

#pragma mark-单选中按钮状态
-(void)btnclick:(UIButton *)sender event:(id)event1
{
    NSSet *touches =[event1 allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_historicalTableView];
    NSIndexPath *indexPath = [_historicalTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
//        [self tableView:_historicalTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        if (sender.selected == YES)
        {
            [sender setImage:[UIImage imageNamed:@"9@2x.png"] forState:(UIControlStateNormal)];
            [[self.CellDateArray objectAtIndex:sender.tag] removeObjectAtIndex:6];
            [[self.CellDateArray objectAtIndex:sender.tag] addObject:@"b"];
            sender.selected = NO;
        }
        else
        {
            [sender setImage:[UIImage imageNamed:@"91@2x.png"] forState:(UIControlStateNormal)];
            [[self.CellDateArray objectAtIndex:sender.tag] removeObjectAtIndex:6];
            [[self.CellDateArray objectAtIndex:sender.tag] addObject:@"a"];
            sender.selected = YES;
        }
    }

}
//-(void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath
//{
//}
#pragma mark======= 添加乘机人
-(void)addClik
{
    [[NSUserDefaults standardUserDefaults] setObject:self.CellDateArray forKey:@"ticketPeson"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 页面推送
    teger = 0;
    addPersonViewController *addPersonView = [[addPersonViewController alloc]init];
    [self.navigationController pushViewController:addPersonView animated:YES];
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





















