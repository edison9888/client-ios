//
//  SelectSeatViewController.m
//  TongFubao
//
//  Created by Delpan on 14-7-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SelectSeatViewController.h"
#import "SelectSeatCell.h"
#import "BillViewController.h"

@interface SelectSeatViewController ()
{
    NSInteger currentHeight;
    
    UITableView *table;
}

@end

@implementation SelectSeatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.title = @"舱位选择";
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    //初始化视图
    [self initView];
}

- (void)initView
{
    if (!table)
    {
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
    }
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    SelectSeatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[SelectSeatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillViewController *billView = [[BillViewController alloc] init];
    [self.navigationController pushViewController:billView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}








@end
