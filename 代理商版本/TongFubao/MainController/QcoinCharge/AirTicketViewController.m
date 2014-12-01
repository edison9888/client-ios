//
//  AirTicketViewController.m
//  TongFubao
//
//  Created by kin on 14-8-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AirTicketViewController.h"
#import "CitySelectionViewController.h"
#import "BookingFlightViewController.h"
#import "WatchTimeViewController.h"
#import "HistoricalRecordViewController.h"
#import "watchTimeObject.h"
#import "RoundTriprReservationViewController.h"

@interface AirTicketViewController ()

@end

@implementation AirTicketViewController
{
    UIButton *_selectButton;
    UIImageView *_moveImage;
    NSMutableArray *_buttonArray;
    NSMutableArray *_timeArray;
    NSMutableArray *_allButtonImage;
    BOOL fromTo;
    NSMutableArray *_fromeToArray;
    NSInteger fromToNumber;
    NSString *_searType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
// 查询选择时间后同步
-(void)viewWillAppear:(BOOL)animated
{
    NSString *fromDeaults = [[NSUserDefaults standardUserDefaults] objectForKey:@"FromTime"];
    NSString *toDeaults = [[NSUserDefaults standardUserDefaults] objectForKey:@"ToTime"];
    
    NSString *_dateString = [watchTimeObject changeTime];
    NSString *nowTimeString = [_dateString stringByReplacingOccurrencesOfString :@"-" withString:@""];
    NSString * selectionTime = [fromDeaults stringByReplacingOccurrencesOfString :@"-" withString:@""];
//    NSLog(@"====nowTimeString====%@",nowTimeString);
//    NSLog(@"====selectionTime====%@",selectionTime);

    if ([fromDeaults length] > 0)
    {
        UIButton *button0 = [_timeArray objectAtIndex:0];
    if ([selectionTime integerValue] >= [nowTimeString integerValue])
    {
        [button0 setTitle:fromDeaults forState:(UIControlStateNormal)];
    }
    else
    {
        [button0 setTitle:@"请选择行程日期" forState:(UIControlStateNormal)];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FromTime"];
    }
        
    }
    
    if ([toDeaults length] > 0)
    {
        
    UIButton *button1 = [_timeArray objectAtIndex:1];
    NSComparisonResult comparison = [fromDeaults compare:toDeaults];
    if (comparison == NSOrderedAscending || comparison == NSOrderedSame)
    {
        [button1 setTitle:toDeaults forState:(UIControlStateNormal)];
    }
    else
    {
        [button1 setTitle:@"请选择返程日期" forState:(UIControlStateNormal)];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ToTime"];

    }

    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    _searType = @"S";
    _buttonArray = [[NSMutableArray alloc]init];
    _timeArray = [[NSMutableArray alloc]init];
    _allButtonImage = [[NSMutableArray alloc]init];
    _fromeToArray = [[NSMutableArray alloc]init];
    // 导航
    [self navigationView];
    // 控件
    [self allViewControl];
}
-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"机票预订";
    //    [self addRightButtonItemWithImage:[UIImage imageNamed:@"wow@2x.png"]];
    [self addRightButtonItemWithTitle:@"历史记录"];
}
// 右边导航
-(void)rightItemClick:(id)sender
{
    HistoricalRecordViewController *historicalView = [[HistoricalRecordViewController alloc]init];
    [self.navigationController pushViewController:historicalView animated:YES];
}

-(void)allViewControl
{
    // 背景色
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
    for (int i = 0; i < 2; i++)
    {
        _selectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _selectButton.frame = CGRectMake(15+145*i, 102, 145, 45);
        _selectButton.tag = i;
        if (_selectButton.tag == 0)
        {
            [_selectButton setBackgroundImage:[UIImage imageNamed:@"left_selected_button.png"] forState:(UIControlStateNormal)];
            _selectButton.titleLabel.text = @"单 程";
            _selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [_selectButton setTitle:_selectButton.titleLabel.text forState:(UIControlStateNormal)];
        }
        if (_selectButton.tag == 1)
        {
            [_selectButton setBackgroundImage:[UIImage imageNamed:@"right_normal_button.png"] forState:(UIControlStateNormal)];
            _selectButton.titleLabel.text = @"往 返";
            _selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [_selectButton setTitle:_selectButton.titleLabel.text forState:(UIControlStateNormal)];
            [_selectButton setTitleColor:RGBACOLOR(3, 198, 230, 1) forState:UIControlStateNormal];
        }
        [_selectButton addTarget:self action:@selector(selectorClik:) forControlEvents:(UIControlEventTouchUpInside)];
        [_buttonArray addObject:_selectButton];
        [self.view addSubview:_selectButton];
    }
    // 移动图标
    _moveImage =  [[UIImageView alloc]initWithFrame:CGRectMake(78, 146, 12, 6)];
    [_moveImage setImage:[UIImage imageNamed:@"triangle.png"]];
    [self.view addSubview:_moveImage];
    
    
    NSString *firstCtiy = [[NSUserDefaults standardUserDefaults] objectForKey:@"FromCity"];
    NSString *seconCtiy = [[NSUserDefaults standardUserDefaults] objectForKey:@"ToCity"];
    // 城市选择按钮
    for (int j = 0; j < 2; j++)
    {
        UIButton *timeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        timeButton.frame = CGRectMake(16+154*j,165, 130, 40);
        [timeButton setBackgroundImage:[UIImage imageNamed:@"text1.png"] forState:(UIControlStateNormal)];
        timeButton.tag = j;
        [timeButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        if (timeButton.tag == 0)
        {
            [timeButton setTitle:firstCtiy !=nil ?firstCtiy:@"出发" forState:(UIControlStateNormal)];
        }
        if (timeButton.tag == 1)
        {
            [timeButton setTitle:seconCtiy != nil ?seconCtiy:@"到达" forState:(UIControlStateNormal)];
        }
        [timeButton addTarget:self action:@selector(ClikCityButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [_fromeToArray addObject:timeButton];
        [self.view addSubview:timeButton];
    }
    NSString *firsTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"FromTime"];
    NSString *seconTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"ToTime"];

    // 时间选择按钮
    NSArray * fromToArray = @[@"请选择出发日期",@"请选择返程日期",@"查 询"];
    for (int t = 0; t < 3; t++)
    {
        UIButton *timeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        timeButton.tag = t;
        if (timeButton.tag < 2 )
        {
            if (timeButton.tag == 0) {
            [timeButton setTitle:firsTime != nil ? firsTime:[fromToArray objectAtIndex:t] forState:(UIControlStateNormal)];
            }
            else if (timeButton.tag == 1)
            {
                [timeButton setTitle:seconTime != nil ? seconTime:[fromToArray objectAtIndex:t] forState:(UIControlStateNormal)];

            }
            [timeButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
            timeButton.frame = CGRectMake(16, 230+72*t, 288, 41);
            [timeButton setBackgroundImage:[UIImage imageNamed:@"input_fieldside.png"] forState:(UIControlStateNormal)];
            if (timeButton.tag == 1)
            {
                timeButton.hidden = YES;
            }
        }
        else
        {
            timeButton.titleLabel.text = [fromToArray objectAtIndex:t];
            timeButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
            [timeButton setTitle:timeButton.titleLabel.text forState:(UIControlStateNormal)];
            timeButton.frame = CGRectMake(16, 230+72, 288, 45);
            [timeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [timeButton setBackgroundImage:[UIImage imageNamed:@"change_btn_normal.png"] forState:(UIControlStateNormal)];
        }
        [timeButton addTarget:self action:@selector(timeButtonClik:) forControlEvents:(UIControlEventTouchUpInside)];
        [_timeArray addObject:timeButton];
        [self.view addSubview:timeButton];
    }
    // 时间和查询的图片
    NSArray *imageArray = @[@"start.png",@"to.png",@"arrived.png",@"to.png",@"calendar.png",@"to.png",@"calendar.png",@"to.png"];
    for (int k = 0; k < 8; k++)
    {
        UIImageView *buttonImage = [[UIImageView alloc]init];
        buttonImage.tag = k;
        buttonImage.image = [UIImage imageNamed:[imageArray objectAtIndex:k]];
        if (buttonImage.tag == 0)
        {
            buttonImage.frame = CGRectMake(26, 176, 29, 18);
        }
        else if (buttonImage.tag == 1)
        {
            buttonImage.frame = CGRectMake(120, 173, 16, 21);
        }
        else if (buttonImage.tag == 2)
        {
            buttonImage.frame = CGRectMake(180, 176, 29, 18);
        }
        else if (buttonImage.tag == 3)
        {
            buttonImage.frame = CGRectMake(274, 173, 16, 21);
        }
        else if (buttonImage.tag == 4)
        {
            buttonImage.frame = CGRectMake(26 , 239, 26, 24);
        }
        else if (buttonImage.tag == 5)
        {
            buttonImage.frame = CGRectMake(274 , 240, 16, 21);
        }
        else if (buttonImage.tag == 6)
        {
            buttonImage.frame = CGRectMake(26, 310, 26, 24);
            buttonImage.hidden = YES;
        }
        else if (buttonImage.tag == 7)
        {
            buttonImage.frame = CGRectMake(274, 311, 16, 21);
            buttonImage.hidden = YES;
        }
        [_allButtonImage addObject:buttonImage];
        [self.view addSubview:buttonImage];
    }
}
#pragma mark ------  单返按钮事件
-(void)selectorClik:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == [_buttonArray objectAtIndex:button.tag])
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            _moveImage.frame = CGRectMake(78+145*button.tag, 146, 12, 6);
            if (button.tag == 0)
            {
                _searType = @"S";
                UIButton *timeBt = [_timeArray objectAtIndex:2];
                timeBt.frame = CGRectMake(16, 296, 288, 45);
                [[_timeArray objectAtIndex:1] setHidden:YES];
                for (int h = 6; h < 8; h++)
                {
                    [[_allButtonImage objectAtIndex:h] setHidden:YES];
                }
            }
            else if (button.tag == 1)
            {
                _searType = @"D";
                UIButton *timeBt = [_timeArray objectAtIndex:2];
                timeBt.frame = CGRectMake(16, 376, 288, 45);
                [self.view bringSubviewToFront:timeBt];
                [[_timeArray objectAtIndex:1] setHidden:NO];
                for (int h = 6; h < 8; h++)
                {
                    [[_allButtonImage objectAtIndex:h] setHidden:NO];
                }
            }
        }];
    }
    for (int i = 0; i < 2; i++)
    {
        if (button != [_buttonArray objectAtIndex:i])
        {
            if (button.tag == 0)
            {
                [[_buttonArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"right_normal_button.png"] forState:(UIControlStateNormal)];
                [[_buttonArray objectAtIndex:i] setTitleColor:RGBACOLOR(3, 198, 230, 1) forState:UIControlStateNormal];
            }
            else if (button.tag == 1)
            {
                [[_buttonArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"left_normal_button.png"] forState:(UIControlStateNormal)];
                [[_buttonArray objectAtIndex:i] setTitleColor:RGBACOLOR(3, 198, 230, 1) forState:UIControlStateNormal];
            }
        }
        else if (button == [_buttonArray objectAtIndex:i])
        {
            if (button.tag == 0)
            {
                [[_buttonArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"left_selected_button.png"] forState:(UIControlStateNormal)];
                [[_buttonArray objectAtIndex:i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else if (button.tag == 1)
            {
                [[_buttonArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"right_t_selected_button.png"] forState:(UIControlStateNormal)];
                [[_buttonArray objectAtIndex:i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
}
#pragma mark -- 推送到城市选择
-(void)ClikCityButton:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        fromTo = YES;
    }
    else if (sender.tag == 1)
    {
        fromTo =NO;
    }
    CitySelectionViewController *citySelectionView = [[CitySelectionViewController alloc]init];
    citySelectionView.delegate = self;
    citySelectionView.FROMTO = fromTo;
    citySelectionView.fromSelectionCity =[[NSUserDefaults standardUserDefaults] objectForKey:@"FromCity"];
    citySelectionView.toSelectionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"ToCity"];
    [self.navigationController pushViewController:citySelectionView animated:YES];
}
#pragma mark -- 选择城市协议
-(void)changVuleFrome:(NSString *)newFrome andTo:(NSString *)newTo
{
    if (newFrome != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:newFrome forKey:@"FromCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[_fromeToArray objectAtIndex: 0] setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"FromCity"] forState:(UIControlStateNormal)];
    }
    if (newTo != nil)
    {
        [[NSUserDefaults standardUserDefaults ]setObject:newTo forKey:@"ToCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        [[_fromeToArray objectAtIndex:1] setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"ToCity"] forState:(UIControlStateNormal)];
    }
}


#pragma mark --机票查询
-(void)timeButtonClik:(UIButton *)sender
{
    if (sender.tag == 0 || sender.tag == 1)
    {
        WatchTimeViewController *watchTimeView = [[WatchTimeViewController alloc]init];
        fromToNumber = sender.tag;
        watchTimeView.watchLogo = fromToNumber;
        watchTimeView.delegate = self;
        [self.navigationController pushViewController:watchTimeView animated:YES];
    }
    else if (sender.tag == 2)
    {
        if ([_searType isEqualToString:@"S"])
        {
//            NSLog(@"========ccf==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityCodeFrom"] );
//            NSLog(@"========cct==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityCodeTo"] );
//            NSLog(@"========ft==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FromTime"] );
//            NSLog(@"========tc==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ToCity"] );

            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cityCodeFrom"] != nil &&  [[NSUserDefaults standardUserDefaults] objectForKey:@"cityCodeTo"] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"FromTime"] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"FromCity"] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"ToCity"] != nil)
            {
                BookingFlightViewController *BookingFlightView = [[BookingFlightViewController alloc]init];
                BookingFlightView.DepartCtity = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityCodeFrom"];
                BookingFlightView.departDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"FromTime"];
                
                BookingFlightView.arriveCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityCodeTo"];
                BookingFlightView.returnDate = @"";
                BookingFlightView.searchType = _searType;
                
                BookingFlightView.cityIDFromBookin = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityIdFrom"];
                BookingFlightView.cityIDToBooking = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityIdTo"];

                
                BookingFlightView.BookingDepartCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"FromCity"];
                BookingFlightView.BookingArriveCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"ToCity"];
                
//                NSLog(@"====00000==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityIdFrom"]);
//                NSLog(@"===11111===%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityIdTo"]);
                
                [self.navigationController pushViewController:BookingFlightView animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"message:@"请检查信息是否填写完整?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        else
        {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cityCodeFrom"] != nil &&  [[NSUserDefaults standardUserDefaults] objectForKey:@"cityCodeTo"]!= nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"FromTime"]!= nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"ToTime"]!= nil&& [[NSUserDefaults standardUserDefaults] objectForKey:@"FromCity"] !=nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"ToCity"] !=nil)
            {
                RoundTriprReservationViewController *RoundTriprReservationView = [[RoundTriprReservationViewController alloc]init];
                
                RoundTriprReservationView.DepartCodeCtity = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityCodeFrom"];
                RoundTriprReservationView.departFromTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"FromTime"];
                
                RoundTriprReservationView.arriveCodeCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityCodeTo"];
                RoundTriprReservationView.returnToTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"ToTime"];
                
                RoundTriprReservationView.cityIDFrom = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityIdFrom"];
                RoundTriprReservationView.cityIDTo = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityIdTo"];
                
                RoundTriprReservationView.RoundDepartCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"FromCity"];
                RoundTriprReservationView.RoundArriveCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"ToCity"];
                
                RoundTriprReservationView.searchType = _searType;
                
                [self.navigationController pushViewController:RoundTriprReservationView animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请检查是否信息填写不完整！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }
    }
}
#pragma mark -- 日历
-(void)returnTime:(NSString *)newTime seletionWatchLogo:(NSInteger)newWatchLogo
{
//    NSString *_dateString = [watchTimeObject changeTime];
//    NSString *nowTimeString = [_dateString stringByReplacingOccurrencesOfString :@"-" withString:@""];
//    NSString * selectionTime = [newTime stringByReplacingOccurrencesOfString :@"-" withString:@""];
//    if ([selectionTime integerValue] >= [nowTimeString integerValue])
//    {
//    
//    NSString *_fromTime ;
//    NSString *_toTime ;
//    
    if (newWatchLogo == 0)
    {

            [[NSUserDefaults standardUserDefaults] setObject:newTime forKey:@"FromTime"];
    }
    else if(newWatchLogo == 1)
    {
            [[NSUserDefaults standardUserDefaults] setObject:newTime forKey:@"ToTime"];
    }
//    _fromTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"FromTime"];
//    _toTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"ToTime"];
//    
//    if (_fromTime == nil && _toTime != nil)
//    {
//        UIButton *button = [_timeArray objectAtIndex:1];
//        [button setTitle:_toTime forState:(UIControlStateNormal)];
//    }
//    else if (_toTime == nil && _fromTime != nil)
//    {
//        UIButton *button = [_timeArray objectAtIndex:0];
//        [button setTitle:_fromTime forState:(UIControlStateNormal)];
//    }
//    else if (_toTime != nil && _fromTime != nil)
//    {
//        NSComparisonResult result = [_fromTime compare:_toTime];
//        if (result == NSOrderedAscending)
//        {
//            UIButton *button0 = [_timeArray objectAtIndex:0];
//            [button0 setTitle:_fromTime forState:(UIControlStateNormal)];
//            UIButton *button = [_timeArray objectAtIndex:1];
//            [button setTitle:_toTime forState:(UIControlStateNormal)];
//        }
//        else if (result == NSOrderedSame)
//        {
//            UIButton *button0 = [_timeArray objectAtIndex:0];
//            [button0 setTitle:_fromTime forState:(UIControlStateNormal)];
//            UIButton *button1 = [_timeArray objectAtIndex:1];
//            [button1 setTitle:_toTime forState:(UIControlStateNormal)];
//        }
//        else if (result == NSOrderedDescending)
//        {
//            UIButton *button0 = [_timeArray objectAtIndex:0];
//            [button0 setTitle:_fromTime forState:(UIControlStateNormal)];
//            UIButton *button1 = [_timeArray objectAtIndex:1];
//            [button1 setTitle:@"请选择返程日期" forState:(UIControlStateNormal)];
//        }
//     }
//    }
//    else
//    {
//        if (newWatchLogo == 0)
//        {
//            UIButton *button0 = [_timeArray objectAtIndex:0];
//            [button0 setTitle:@"请选择行程日期" forState:(UIControlStateNormal)];
//        }
//        else if(newWatchLogo == 1)
//        {
//            UIButton *button1 = [_timeArray objectAtIndex:1];
//            [button1 setTitle:@"请选择返程日期" forState:(UIControlStateNormal)];
//        }
//        
//    }
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



















