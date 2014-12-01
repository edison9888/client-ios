//
//  HotelAreaSiftTable.m
//  TongFubao
//
//  Created by Delpan on 14-9-1.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelAreaSiftTable.h"

@implementation HotelAreaSiftTable

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //筛选名称底图
        siftTitleView = [UIView viewWithFrame:CGRectMake(0, 0, frame.size.width / 3, frame.size.height)];
        siftTitleView.backgroundColor = RGBACOLOR(109, 192, 238, 1.0);
        [self addSubview:siftTitleView];
        
        //筛选名称
        NSArray *siftTitles = @[ @"商业区", @"机场车站", @"行政区", @"地铁线", @"景点" ];
        
        //筛选名称按钮
        for (int i = 0; i < siftTitles.count; i++)
        {
            siftTitleBtn[i] = [UIButton buttonWithFrame:CGRectMake(0, 50 * i, frame.size.width / 3, 50)
                                          unSelectImage:[NLUtils createImageWithColor:RGBACOLOR(109, 192, 238, 1.0)
                                                                                 rect:CGRectMake(0, 0, frame.size.width / 3, 50)]
                                            selectImage:[NLUtils createImageWithColor:RGBACOLOR(157, 214, 244, 1.0)
                                                                                 rect:CGRectMake(0, 0, frame.size.width / 3, 50)]
                                                    tag:3401 + i
                                             titleColor:[UIColor whiteColor]
                                                  title:siftTitles[i]];
            [siftTitleBtn[i] addTarget:self action:@selector(siftTitleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [siftTitleView addSubview:siftTitleBtn[i]];
        }
        
        //筛选名称列表
        siftInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width / 3, 0, frame.size.width / 3 * 2, frame.size.height) style:UITableViewStylePlain];
        siftInfoTable.delegate = self;
        siftInfoTable.dataSource = self;
        siftInfoTable.showsVerticalScrollIndicator = NO;
        [self addSubview:siftInfoTable];
    }
    
    return self;
}

#pragma mark - 筛选名称触发
- (void)siftTitleBtnAction:(UIButton *)sender
{
    if (!sender.selected)
    {
        for (int i = 0; i < 5; i++)
        {
            siftTitleBtn[i].selected = NO;
        }
        
        sender.selected = !sender.selected;
    }
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.hotelAreaSiftTableDelegate respondsToSelector:@selector(returnWithValue:)])
    {
        [self.hotelAreaSiftTableDelegate returnWithValue:nil];
    }
    
    [self removeFromSuperview];
}

@end



















