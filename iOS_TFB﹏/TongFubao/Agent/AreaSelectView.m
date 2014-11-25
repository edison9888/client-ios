//
//  AreaSelectView.m
//  UIText
//
//  Created by Delpan on 14-7-21.
//  Copyright (c) 2014年 Delpan. All rights reserved.
//

#import "AreaSelectView.h"

@implementation RemoveView

@synthesize removeViewDelegate = _removeViewDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_removeViewDelegate removeView];
}

@end


@implementation AreaSelectView

@synthesize areaSelectViewDelegate = _areaSelectViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        RemoveView *removeView = [[RemoveView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height + 30)];
        removeView.alpha = 0.5;
        removeView.backgroundColor = [UIColor blackColor];
        removeView.removeViewDelegate = self;
        [self addSubview:removeView];
        
        if (!_table)
        {
            _table = [[UITableView alloc] initWithFrame:CGRectMake(30, 30, 260, frame.size.height - 90) style:UITableViewStylePlain];
            _table.delegate = self;
            _table.dataSource = self;
            [self addSubview:_table];
        }
    }
    
    return self;
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (areas)
    {
        return areas.count;
    }
    
    return 0;
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
    
    if (bankView)
    {
        NSDictionary *dictionary = areas[indexPath.row];
        cell.textLabel.text = [dictionary objectForKey:@"text"];
    }
    else
    {
        if (NLData)
        {
            NLProtocolData *data = [areas objectAtIndex:indexPath.row];
            cell.textLabel.text = data.value;
        }
        else
        {
            cell.textLabel.text = areas[indexPath.row];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!bankView)
    {
        NSString *dataString = nil;
        
        if (NLData)
        {
            NLProtocolData *data = [areas objectAtIndex:indexPath.row];
            dataString = data.value;
        }
        else
        {
            dataString = areas[indexPath.row];
        }
        
        NSString *string = [areaButton titleForState:UIControlStateNormal];
        
        if (![dataString isEqualToString:string])
        {
            [areaButton setTitle:dataString forState:UIControlStateNormal];
            
            [_areaSelectViewDelegate areaChange:YES btn:areaButton];
        }
    }
    else
    {
        [_areaSelectViewDelegate bankTagWith:indexPath.row];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 返回
- (void)removeView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)loadDataWith:(NSArray *)data button:(UIButton *)button dictionary:(BOOL)dictionary NLData:(BOOL)NLdata
{
    //获取当前数据
    areas = data;
    //获取须改变的按扭
    areaButton = button;
    
    bankView = dictionary;
    
    NLData = NLdata;
    
    [_table reloadData];
}

@end










