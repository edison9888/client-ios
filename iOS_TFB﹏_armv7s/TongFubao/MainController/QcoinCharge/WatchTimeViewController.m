//
//  WatchTimeViewController.m
//  TongFubao
//
//  Created by kin on 14-8-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "WatchTimeViewController.h"
#import "CKCalendarView.h"
@interface WatchTimeViewController ()<CKCalendarDelegate>
{
    BOOL SELECTION;
}

@end

@implementation WatchTimeViewController
@synthesize watchLogo;

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
    SELECTION = NO;
    self.view.backgroundColor = RGBACOLOR(3, 198, 230, 1);

    // 导航
    [self navigationView];
    // 控件
    [self allViewControl];
}
-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"订票日历";
}
-(void)allViewControl
{
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    calendar.frame = CGRectMake(10, 130, 300, self.view.frame.size.height);
    calendar.delegate  = self;
    [self.view addSubview:calendar];
    self.view.backgroundColor = [UIColor whiteColor];

}
-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    SELECTION = YES;
    //天的时间
    //        NSTimeInterval secondsper=24*60*60*1;
    //        NSDate * giveDate = [date dateByAddingTimeInterval:+secondsper];
    //        NSLog(@"=====date=====%@",giveDate);
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    //当前的时间格式
    NSString * newDateOne = [dateformat stringFromDate:date];
    NSLog(@"=====newDateOne=====%@",newDateOne);
    [self.delegate returnTime:newDateOne seletionWatchLogo:watchLogo];
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 回调
-(void)leftItemClick:(id)sender
{
    if (SELECTION == NO)
    {
        NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [NSDate date];
        //当前的时间格式
        NSString * newDateOne = [dateformat stringFromDate:date];
        [self.delegate returnTime:newDateOne seletionWatchLogo:watchLogo];
        [self.navigationController popViewControllerAnimated:YES];

    }
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














