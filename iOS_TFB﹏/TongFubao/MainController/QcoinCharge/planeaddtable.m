//
//  planeaddtable.m
//  TongFubao
//
//  Created by  俊   on 14-7-24.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "planeaddtable.h"

@implementation planeaddtable

@synthesize planeaddtableDelegate = _planeaddtableDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //半透明黑图层
        CALayer *blackLayer = [CALayer layer];
        blackLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height+260);
        blackLayer.position = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        blackLayer.opacity = 0.5;
        blackLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:blackLayer];
        
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"  " forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cell.textLabel.text = [areas objectAtIndex:indexPath.row];
    cell.accessoryView = btn;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [areaButton setTitle:[areas objectAtIndex:indexPath.row] forState:UIControlStateNormal];

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)loadDataWith:(NSArray *)data button:(UIButton *)button
{
    //获取当前数据
    areas = data;
    //获取须改变的按扭
    areaButton = button;
    [_table reloadData];
}

@end
