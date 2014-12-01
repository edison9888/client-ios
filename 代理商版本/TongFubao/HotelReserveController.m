//
//  HotelReserveController.m
//  TongFubao
//
//  Created by Delpan on 14-9-12.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelReserveController.h"

@interface HotelReserveController ()
{
    NSInteger currentHeight;
    //房费实际支付总额
    UILabel *payLabel;
    //数据列表
    UITableView *table;
    //cell标题
    NSArray *cellTitles;
}

@end

@implementation HotelReserveController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    self.title = @"订单填写";
    self.view.backgroundColor = RGBACOLOR(238, 243, 245, 1.0);
    
    //初始化数据
    [self initData];
    
    //初始化视图
    [self initView];
}

#pragma mark - 初始化数据
- (void)initData
{
    cellTitles = @[ @"入住时间", @"离店时间", @"入住人名字", @"手机", @"发票" ];
}

#pragma mark - 初始化视图
- (void)initView
{
    //TableViewHead
    UIView *tableHeadView = [UIView viewWithFrame:CGRectMake(0, 0, SelfWidth, 50)];
    [self.view addSubview:tableHeadView];
    
    //房费总额
    UILabel *sumLabel = [UILabel labelWithFrame:CGRectMake(20, 15, 100, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor grayColor] text:@"房费总额" font:[UIFont systemFontOfSize:15.0]];
    [tableHeadView addSubview:sumLabel];
    
    //房费实际支付总额
    payLabel = [UILabel labelWithFrame:CGRectMake(SelfWidth - 100, 20, 100, 25) backgroundColor:[UIColor clearColor] textColor:RGBACOLOR(228, 152, 32, 1.0) text:@"$ 480" font:[UIFont systemFontOfSize:25.0]];
    [tableHeadView addSubview:payLabel];
    
    //数据列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = tableHeadView;
    [self.view addSubview:table];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cellTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 60;
    }
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 110;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    HotelHostCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[HotelHostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    
    cell.titleLabel.text = cellTitles[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
















