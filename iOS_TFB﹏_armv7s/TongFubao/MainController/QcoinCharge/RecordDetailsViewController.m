//
//  RecordDetailsViewController.m
//  TongFubao
//
//  Created by kin on 14-8-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "RecordDetailsViewController.h"
#import "TicketCustomTableViewCell.h"
@interface RecordDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titleArray;
    NSArray *_otherArray;
}

@end

@implementation RecordDetailsViewController
@synthesize RecordDetailsArray;
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
    _titleArray = @[@"出发时间",@"到达时间",@"行程",@"航班",@"总价",@"订单日期",@"处理状态"];
    NSString *fromTime = [self.RecordDetailsArray objectAtIndex:2];
    NSString *toTime = [self.RecordDetailsArray objectAtIndex:3];
    NSString *fromToCity = [NSString stringWithFormat:@"%@-%@",[self.RecordDetailsArray objectAtIndex:0],[self.RecordDetailsArray objectAtIndex:1]];
    NSString *toleStirng= [NSString stringWithFormat:@"￥%@",[self.RecordDetailsArray objectAtIndex:6]];

    _otherArray = @[fromTime,toTime,fromToCity,[self.RecordDetailsArray objectAtIndex:5],toleStirng,fromTime,[self.RecordDetailsArray objectAtIndex:7]];
    
//    for (NSString *string in self.RecordDetailsArray) {
//        NSLog(@"====string======%@",string);
//    }
    
    [super viewDidLoad];
    [self navigationView];
    // 控件
    [self allViewControl];
}
-(void)navigationView
{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"历史记录";
}
-(void)allViewControl
{
    UITableView *historicalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    historicalTableView.delegate = self;
    historicalTableView.dataSource = self;
    [self.view addSubview:historicalTableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
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
    
    UIView *backviewcell=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backviewcell.backgroundColor=RGBACOLOR(165, 238, 255, 1);
    cell.selectedBackgroundView = backviewcell;

    [cell historTitleLable:[_titleArray objectAtIndex:indexPath.row] historTimeLable:[_otherArray objectAtIndex:indexPath.row]];
    return cell;
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
