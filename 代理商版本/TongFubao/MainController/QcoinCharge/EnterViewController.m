//
//  EnterViewController.m
//  TongFubao
//
//  Created by Delpan on 14-7-14.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "EnterViewController.h"
#import "PlaneCheakCell.h"
#import "SelectSeatViewController.h"

@interface EnterViewController ()
{
    NSInteger currentHeight;
    
    UITableView *table;
    //排序视图
    SortView *sortView;
    //航空公司视图
    PlaneCompanyView *planeView;
}

@end

@implementation EnterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    //初始化视图
    [self initView];
}

- (void)initView
{
    //生成日期按扭与底视图
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, 44)];
    headView.opaque = YES;
    
    for (int i = 0; i < 3; i++)
    {
        NSString *btnName = nil;
        if (i == 0)
        {
            btnName = @"前一天";
        }
        else if (i == 1)
        {
            btnName = @"日期";
        }
        else
        {
            btnName = @"后一天";
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SelfWidth / 3 * i, 0, SelfWidth / 3, 44);
        btn.tag = 101 + i;
        [btn setTitle:btnName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnWithDateAction:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
    }
    
    if (!table)
    {
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 108) style:UITableViewStyleGrouped];
        table.tableHeaderView = headView;
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
    }
    
    //生成功能按扭与底视图
    UIView *basicView = [[UIView alloc] initWithFrame:CGRectMake(0, currentHeight - 108, SelfWidth, 44)];
    basicView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:basicView];
    
    for (int i = 0; i < 2; i++)
    {
        NSString *btnName = nil;
        
        if (i == 0)
        {
            btnName = @"分类筛选";
        }
        else
        {
            btnName = @"航空公司";
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SelfWidth / 2 * i, 0, SelfWidth / 2, 44);
        btn.tag = 104 + i;
        [btn setTitle:btnName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(functionAction:) forControlEvents:UIControlEventTouchUpInside];
        [basicView addSubview:btn];
    }
}

#pragma mark - 日期按触发
- (void)btnWithDateAction:(UIButton *)sender
{
    
}

#pragma mark - 功能触发
- (void)functionAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.tag ==104)
    {
        [self sortDataWithButton:sender];
    }
    else
    {
        [self planeCompanyWithButton:sender];
    }
}

#pragma mark - 排序触发
- (void)sortDataWithButton:(UIButton *)sender
{
    if (sender.selected)
    {
        if (!sortView)
        {
            sortView = [[SortView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth / 2, 460)];
            sortView.backgroundColor = [UIColor blackColor];
            sortView.sortViewDelegate = self;
        }
        
        [self.view addSubview:sortView];
    }
    else
    {
        [sortView removeFromSuperview];
    }
}

#pragma mark - 排序视图代理
- (void)sortViewDidTouch:(UIButton *)sender
{
    
}

#pragma mark - 航空公司触发
- (void)planeCompanyWithButton:(UIButton *)sender
{
    if (sender.selected)
    {
        if (!planeView)
        {
            planeView = [[PlaneCompanyView alloc] initWithFrame:CGRectMake(SelfWidth / 2, 0, SelfWidth / 2, 460)];
            planeView.backgroundColor = [UIColor blackColor];
        }
        
        [self.view addSubview:planeView];
    }
    else
    {
        [planeView removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    PlaneCheakCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[PlaneCheakCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectSeatViewController *selectSeatView = [[SelectSeatViewController alloc] init];
    [self.navigationController pushViewController:selectSeatView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end










