//
//  GoShippingSpaceView.m
//  TongFubao
//
//  Created by kin on 14-9-19.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "GoShippingSpaceView.h"
#import "PlayCustomActivityView.h"
#import "TicketCustomTableViewCell.h"
#import "TicketInfoImationViewController.h"
@implementation GoShippingSpaceView

@synthesize activityView,historicalTableView,infoTextView,button,GoShippingDataArray;

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self allControllerView];
    }
    return self;
}
-(void)allControllerView
{
    self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.button.frame = CGRectMake(0, 0, 320, 60);
    self.button.layer.borderWidth = 0.3;
    [self.button setImage:[UIImage imageNamed:@"wow@2x.png"] forState:(UIControlStateNormal)];
    [self.button setImageEdgeInsets:(UIEdgeInsetsMake(20, 70, 20, 230))];
    [self.button setTitle:@"非成人购票说明" forState:(UIControlStateNormal)];
    [self.button setTitleColor:RGBACOLOR(57, 175, 237, 1) forState:(UIControlStateNormal)];
    [self.button addTarget:self action:@selector(buttonClik) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.historicalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,self.frame.size.height)];
    self.historicalTableView.delegate = self;
    self.historicalTableView.dataSource = self;
    [self addSubview:self.historicalTableView];
    
}
-(void)GoShippingdata:(NSMutableArray *)newGoShippingdata
{
    self.GoShippingDataArray = newGoShippingdata;
    self.historicalTableView.tableFooterView = self.button;
    [self.historicalTableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.GoShippingDataArray count];
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
    
    [cell shipTitleLable:[[self.GoShippingDataArray objectAtIndex:indexPath.row] objectAtIndex:1] discountShipLable:@"" endorseLable:[NSString stringWithFormat:@"票数：%@张",[[self.GoShippingDataArray objectAtIndex:indexPath.row] objectAtIndex:5]] endMoneyLable:[NSString stringWithFormat:@"￥%@",[[self.GoShippingDataArray objectAtIndex:indexPath.row] objectAtIndex:15]]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate GoShippingSpaceView:[self.GoShippingDataArray objectAtIndex:indexPath.row]];
}
//详情
-(void)buttonClik
{
    [self.delegate IllustrateByPlane];
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

























































