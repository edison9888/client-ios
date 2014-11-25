//
//  StarPriceView.m
//  TongFubao
//
//  Created by Delpan on 14-8-25.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "StarPriceView.h"

@implementation StarPriceView

#pragma mark - 酒店筛选初始化
- (id)initWithFrame:(CGRect)frame hotelSiftType:(HotelSiftType)hotelSiftType
{
    if (self = [super init])
    {
        self.frame = frame;
        self.opaque = YES;
        
        currentType = hotelSiftType;
        
        //半透明黑底
        CALayer *backLayer = [CALayer layer];
        backLayer.bounds = frame;
        backLayer.position = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        backLayer.backgroundColor = [UIColor blackColor].CGColor;
        backLayer.opacity = 0.5;
        [self.layer addSublayer:backLayer];
        
        //内容底图
        contentView = [UIView viewWithFrame:CGRectMake(0, frame.size.height - 280, frame.size.width, 280)];
        contentView.opaque = YES;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        //取消/确定按钮
        for (int i = 0; i < 2; i++)
        {
            NSString *buttonString = i == 0? @"取消" : @"确定";
            
            functionBtn[i] = [UIButton buttonWithFrame:CGRectMake(10 + 260 * i, 10, 40, 40)
                                         unSelectImage:nil
                                           selectImage:nil
                                                   tag:100000
                                            titleColor:RGBACOLOR(0, 174, 216, 1.0)
                                                 title:buttonString];
            [functionBtn[i] addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:functionBtn[i]];
        }
        
        if (hotelSiftType == HotelSiftStar)
        {
            //初始化星级视图
            [self initStarViewWithFrame:frame];
        }
        else
        {
            //初始化价格视图
            [self initPriceViewWithFrame:frame hotelSiftType:hotelSiftType];
        }
    }
    
    return self;
}

#pragma mark - 初始化星级视图
- (void)initStarViewWithFrame:(CGRect)frame
{
    NSArray *stars = @[ @"不限", @"二星级以下", @"四星级/高档", @"快捷连锁", @"三星级/舒适", @"五星级/豪华" ];
    
    currentValue = stars[0];
    
    for (int i = 0, j = 0; i < 2; i++)
    {
        for (int k = 0; k < 3; k++)
        {
            starBtn[j] = [UIButton buttonWithFrame:CGRectMake(10 + (frame.size.width / 2 + 10) * i, 80 + 60 * k, frame.size.width / 2 - 30, 40)
                                     unSelectImage:[NLUtils createImageWithColor:[UIColor grayColor]
                                                                            rect:CGRectMake(0, 0, 140, 40)]
                                       selectImage:[NLUtils createImageWithColor:RGBACOLOR(50, 180, 217, 1.0)
                                                                            rect:CGRectMake(0, 0, 140, 40)]
                                               tag:3101 + j
                                        titleColor:[UIColor whiteColor]
                                             title:stars[j]];
            starBtn[j].selected = j == 0? YES : NO;
            [starBtn[j] addTarget:self action:@selector(starBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:starBtn[j]];
            
            j++;
        }
    }
}

#pragma mark - 初始化价格视图
- (void)initPriceViewWithFrame:(CGRect)frame hotelSiftType:(HotelSiftType)hotelSiftType
{
    priceSorts = hotelSiftType == HotelSiftPrice? @[ @"100 - 300", @"300 - 450", @"450 - 600", @"600 - 750", @"750 - 900" ] : @[ @"价格由高到低", @"价格由低到高" ];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(10, 80, 300, 180) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    [contentView addSubview:table];
}

#pragma mark - TabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return priceSorts.count;
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
    
    cell.textLabel.text = priceSorts[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentValue = priceSorts[indexPath.row];
}

#pragma mark - 取消/确定按钮触发
- (void)functionBtnAction:(UIButton *)sender
{
    if (sender == functionBtn[1])
    {
        if ([self.starPriceViewDelegate respondsToSelector:@selector(returnWithValue:hotelSiftType:)])
        {
            [self.starPriceViewDelegate returnWithValue:currentValue hotelSiftType:currentType];
        }
    }
    
    [self removeFromSuperview];
}

#pragma mark - 星级按钮触发
- (void)starBtnAction:(UIButton *)sender
{
    if (!sender.selected)
    {
        for (int i = 0; i < 6; i++)
        {
            starBtn[i].selected = NO;
        }
        
        sender.selected = YES;
        
        currentValue = sender.titleLabel.text;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

#pragma mark - RemoveViewDelegate
- (void)removeView
{
    [self removeFromSuperview];
}

#pragma mark - 酒店相片初始化
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    if (self = [super init])
    {
        self.frame = frame;
        self.opaque = YES;
        
        //半透明黑底
        RemoveView *removeView = [[RemoveView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height + 30)];
        removeView.alpha = 0.5;
        removeView.backgroundColor = [UIColor blackColor];
        removeView.removeViewDelegate = self;
        [self addSubview:removeView];
        
        //酒店相片
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, frame.size.width - 100, frame.size.width - 100)];
        photoView.userInteractionEnabled = YES;
        photoView.opaque = YES;
        photoView.image = image;
        [self addSubview:photoView];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"StarPriceView内存释放");
}

@end
























