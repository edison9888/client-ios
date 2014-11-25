//
//  CustomTable.m
//  TongFubao
//
//  Created by Delpan on 14-7-11.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "CustomTable.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CustomTable

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        //生成列表头视图
        [self initTableViewHead];
        self.separatorColor = [UIColor clearColor];
        self.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - 生成列表头视图
- (void)initTableViewHead
{
    //生成选择城市
    changeCities = @[ @"          热门城市",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z" ];
    
    //生成列表头视图
    headViews = [NSMutableArray array];
    
    for(int i = 0; i < changeCities.count; i++)
    {
		HeadView *headView = [[HeadView alloc] init];
        headView.delegate = self;
		headView.section = i;
        [headView.backBtn setTitle:[NSString stringWithFormat:@"%@",changeCities[i]] forState:UIControlStateNormal];
        [headView.backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -270, 0, 0)];
		[headViews addObject:headView];
	}
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headViews[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return changeCities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HeadView *headView = headViews[section];
    
    return headView.backBtn.selected? [[cityDic objectForKey:changeCities[headView.section]] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //获取当前cell的城市数据
    NSDictionary *dataDic = [[cityDic objectForKey:changeCities[indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dataDic objectForKey:@"cityNameCh"];
    
    return cell;
}

#pragma mark - HeadViewDelegate
- (void)selectedWith:(HeadView *)view
{
    if (!cityDic)
    {
        cityDic = [NSMutableDictionary dictionary];
    }
    
    view.backBtn.selected = !view.backBtn.selected;
    
    if (view.backBtn.selected)
    {
        if (![cityDic objectForKey:changeCities[view.section]])
        {
            currentSection = changeCities[view.section];
            
            [_customTabelDelegate loadCitiesWithFirstLetter:currentSection];
            
            return ;
        }
    }
    
    [self reloadData];
}

#pragma mark - 添加数据
- (void)returnCities:(NSArray *)cities
{
    if (![cityDic objectForKey:currentSection])
    {
        [cityDic setObject:cities forKey:currentSection];
    }
    
    [self reloadData];
}

@end
