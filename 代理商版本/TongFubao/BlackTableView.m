//
//  BlackTableView.m
//  TongFubao
//
//  Created by Delpan on 14-9-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BlackTableView.h"

@implementation BlackTableView

- (id)initWithFrame:(CGRect)frame datas:(NSArray *)data ids:(NSArray *)ids
{
    if (self = [super init])
    {
        self.frame = frame;
        
        datas = data;
        dataIDs = ids;
        
        RemoveView *removeView = [[RemoveView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height + 30)];
        removeView.alpha = 0.5;
        removeView.backgroundColor = [UIColor blackColor];
        removeView.removeViewDelegate = self;
        [self addSubview:removeView];
        
        //加载数据列表
        table = [[UITableView alloc] initWithFrame:CGRectMake(30, 30, 260, frame.size.height - 90) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
    }
    
    return self;
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    
    //城市名
    NLProtocolData *cityNameData = datas[indexPath.row];
    
    cell.textLabel.text = cityNameData.value;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.blackTableViewDelegate respondsToSelector:@selector(returnWithDictionary:)])
    {
        //数据名称
        NLProtocolData *data = datas[indexPath.row];
        //数据id
        NLProtocolData *dataID = dataIDs[indexPath.row];
        
//        [self.blackTableViewDelegate returnWithName:data.value id_:dataID.value];
    }
    
    [self removeView];
}

#pragma mark - RemoveViewDelegate
- (void)removeView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end













