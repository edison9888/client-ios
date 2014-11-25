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

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style headInfos:(NSArray *)headInfos customTableType:(CustomTableType)customTableType
{
    if (self = [super initWithFrame:frame style:style])
    {
        //生成选择城市
        changeCities = headInfos;
        
        currentType = customTableType;
        
        //生成列表头视图
        [self initTableViewHead];
        
        //换行线颜色
//        self.separatorColor = [UIColor clearColor];
//        self.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
        //分割线
//        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

#pragma mark - 生成列表头视图
- (void)initTableViewHead
{
    //生成列表头视图
    headViews = [NSMutableArray array];
    
    for(int i = 0; i < changeCities.count; i++)
    {
		HeadView *headView = [[HeadView alloc] init];
        headView.delegate = self;
		headView.section = i;
        headView.titleLabel.text = changeCities[i];
		[headViews addObject:headView];
	}
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
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

//返回区头开关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HeadView *headView = headViews[section];
    
    return headView.backBtn.selected? [[nameDictionary objectForKey:changeCities[headView.section]] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    
    //获取当前cell的城市数据
    NSDictionary *dataDictionary = [[nameDictionary objectForKey:changeCities[indexPath.section]] objectAtIndex:indexPath.row];
    
    //名称号
    NSInteger nameNumber = [NLUtils checkInterNum:[[dataDictionary allValues] objectAtIndex:0]]? 1 : 0;
    
    NSString *cellName = [[dataDictionary allValues] objectAtIndex:nameNumber];
    
    cell.textLabel.text = cellName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_customTabelDelegate respondsToSelector:@selector(returnWithDictionary:)])
    {
        //获取当前cell的城市数据
        NSDictionary *dataDictionary = [[nameDictionary objectForKey:changeCities[indexPath.section]] objectAtIndex:indexPath.row];
        
        [_customTabelDelegate returnWithDictionary:dataDictionary];
    }
}

#pragma mark - HeadViewDelegate
- (void)selectedWith:(HeadView *)view
{
    nameDictionary = nameDictionary? nameDictionary : [NSMutableDictionary dictionary];
    
    view.backBtn.selected = !view.backBtn.selected;
    
    //判断当前是否有缓存的数据
    if (view.backBtn.selected)
    {
        if (![nameDictionary objectForKey:changeCities[view.section]])
        {
            //保存key
            currentSection = changeCities[view.section];
            
            //城市/关键字请求
            if (currentType == CustomTableCitys)
            {
                //热门城市字段为空
                if ([self.customTabelDelegate respondsToSelector:@selector(loadCitiesWithFirstLetter:)])
                {
                    [_customTabelDelegate loadCitiesWithFirstLetter:([currentSection isEqualToString:@"热门城市"]? @" " : currentSection)];
                }
            }
            else
            {
                if ([self.customTabelDelegate respondsToSelector:@selector(loadDataForKeywords:)])
                {
                    [self.customTabelDelegate loadDataForKeywords:view.section];
                }
            }
            
            return ;
        }
    }
    
    [self reloadData];
}

#pragma mark - 添加并显示数据
- (void)returnName:(NSArray *)name
{
    //保存当前数据
    if (![nameDictionary objectForKey:currentSection])
    {
        [nameDictionary setObject:name forKey:currentSection];
    }
    
    [self reloadData];
}

@end












