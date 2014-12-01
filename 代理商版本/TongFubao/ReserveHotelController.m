//
//  ReserveHotelController.m
//  TongFubao
//
//  Created by Delpan on 14-8-22.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ReserveHotelController.h"
#import "HotelHostCell.h"

@interface ReserveHotelController ()
{
    NLProgressHUD  *_hud;
    //当前高度
    NSInteger currentHeight;
    //当前类型
    HotelCurrentType currentType;
    
    UITableView *table;
    //cell标题
    NSArray *cellTitles;
    //cell信息
    NSArray *cellInfos;
    //当前区
    NSIndexPath *currentIndexPath;
    //酒店信息
    HotelInfo *hotelInfo;
    //房费实际支付总额
    UILabel *payLabel;
}

@end

@implementation ReserveHotelController

- (id)initWithType:(HotelCurrentType)type
{
    if (self = [super init])
    {
        currentType = type;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    if (currentType == HotelMainType)
    {
        [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    }
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    self.title = currentType == HotelMainType? @"酒店预订" : currentType == HotelReserveType? @"订单填写" : @"发票填写";
    self.view.backgroundColor = RGBACOLOR(238, 243, 245, 1.0);
    
    //初始化数据
    [self initData];
    //初始化视图
    [self initView];
}

#pragma mark - 初始化数据
- (void)initData
{
    //cell标题
    cellTitles = currentType == HotelMainType? @[ @"入往城市", @"入住日期", @"关键字", @"价格", @"星级" ] : currentType == HotelReserveType? @[ @"入住时间", @"离店时间", @"入住人名字", @"手机", @"发票" ] : @[ @"发票抬头", @"发票明细", @"收件人地址", @"收件人电话", @"配送方式" ];
    
    //cell信息
    cellInfos = currentType == HotelMainType? @[ @"城市", @"2014/8/26", @"位置/品牌/酒店名称", @"不限", @"不限" ] : currentType == HotelReserveType? @[ @"2014/09/15", @"2014/09/15", @"入住人名字", @"手机", @"不需要" ] : @[ @"请输入发票抬头", @"请输入待订房费", @"请选择发票寄送地址", @"方便快递联系您", @"请选择配送方式" ];
}

#pragma mark - 初始化视图
- (void)initView
{
    //数据列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    
    if (currentType == HotelReserveType)
    {
        //TableViewHead
        UIView *tableHeadView = [UIView viewWithFrame:CGRectMake(0, 0, SelfWidth, 50)];
        [self.view addSubview:tableHeadView];
        
        //房费总额
        UILabel *sumLabel = [UILabel labelWithFrame:CGRectMake(20, 15, 100, 15)
                                    backgroundColor:[UIColor clearColor]
                                          textColor:[UIColor grayColor]
                                               text:@"房费总额"
                                               font:[UIFont systemFontOfSize:15.0]];
        [tableHeadView addSubview:sumLabel];
        
        //房费实际支付总额
        payLabel = [UILabel labelWithFrame:CGRectMake(SelfWidth - 100, 20, 100, 25)
                           backgroundColor:[UIColor clearColor]
                                 textColor:RGBACOLOR(228, 152, 32, 1.0)
                                      text:@"$ 480"
                                      font:[UIFont systemFontOfSize:25.0]];
        [tableHeadView addSubview:payLabel];
        
        table.tableHeaderView = tableHeadView;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.0;
    
    if (section == 4)
    {
        height = currentType == HotelMainType? 60 : currentType == HotelReserveType? 110 : 0.0;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 15.0;
    
    if (section == 2)
    {
        height = currentType != HotelInvoiceType? 60.0 : 15.0;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBasicView = nil;
    
    if (section == 2)
    {
        if (currentType == HotelMainType)
        {
            headerBasicView = [UIView viewWithFrame:CGRectMake(0, 0, SelfWidth, 60)];
            
            UILabel *dayLabel = [UILabel labelWithFrame:CGRectMake(20, 20, 40, 20)
                                        backgroundColor:[UIColor clearColor]
                                              textColor:RGBACOLOR(153, 153, 153, 1.0)
                                                   text:@"天数"
                                                   font:[UIFont systemFontOfSize:18.0]];
            [headerBasicView addSubview:dayLabel];
            
            NSDate *date = [NSDate date];
            
            NSDateFormatter *matterDate = [[NSDateFormatter alloc] init];
            matterDate.dateFormat = @"yyyy/MM/dd";
            
            NSString *currentDate = [matterDate stringFromDate:date];
            
            //日期
            UILabel *dateLabel = [UILabel labelWithFrame:CGRectMake(80, 20, 100, 20)
                                         backgroundColor:[UIColor clearColor]
                                               textColor:RGBACOLOR(6, 175, 215, 1.0)
                                                    text:currentDate
                                                    font:[UIFont systemFontOfSize:18.0]];
            [headerBasicView addSubview:dateLabel];
        }
        else if (currentType == HotelReserveType)
        {
            
        }
    }
    return headerBasicView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerBasicView = nil;
    
    if (section == 4)
    {
        footerBasicView = [UIView viewWithFrame:CGRectMake(0, 0, SelfWidth, 60)];
        
        //按扭名称
        NSString *btnName = currentType == HotelMainType? @"查询" : currentType == HotelReserveType? @"前往支付界面" : @"确定";
        
        //查询按钮
        UIButton *checkBtn = [UIButton buttonWithFrame:CGRectMake(10, 20, SelfWidth - 20, 40)
                                         unSelectImage:imageName(@"yellow_button@2x", @"png")
                                           selectImage:nil
                                                   tag:100000
                                            titleColor:[UIColor whiteColor]
                                                 title:btnName];
        [checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerBasicView addSubview:checkBtn];
    }
    
    return footerBasicView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    HotelHostCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[HotelHostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //当前类型
    if (currentType == HotelMainType)
    {
        if (indexPath.section < 3)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            cellImage.image = imageName(@"chosenside@2x", @"png");
            cell.accessoryView = cellImage;
        }
    }
    else if (currentType == HotelReserveType)
    {
        cell.accessoryType = indexPath.section < 2 || indexPath.section == 4? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = indexPath.section == 4? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    }
    
    //标题
    cell.titleLabel.text = cellTitles[indexPath.section];
    //信息
    cell.infoLabel.text = cellInfos[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    //当前类型
    if (currentType == HotelMainType)
    {
        if (!hotelInfo)
        {
            hotelInfo = [[HotelInfo alloc] init];
        }
        
        //选择城市/品牌
        if (indexPath.section == 0 || indexPath.section == 2)
        {
            CustomTableType cityOr = indexPath.section == 0? CustomTableCitys : CustomTableKeywords;
            
            if (cityOr == CustomTableKeywords && hotelInfo.cityId == nil)
            {
                [self showErrorInfo:@"请选择城市" status:NLHUDState_Error];
                return ;
            }
            
            CityChangeController *cityView = [[CityChangeController alloc] initWithCity:cityOr];
            cityView.cityChangeControllerDelegate = self;
            cityView.currentCityID = hotelInfo.cityId;
            [self.navigationController pushViewController:cityView animated:YES];
        }
        
        //选择星级/价格
        if (indexPath.section > 2)
        {
            HotelSiftType star = indexPath.section == 3? HotelSiftPrice : HotelSiftStar;
            
            StarPriceView *starView = [[StarPriceView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64) hotelSiftType:star];
            starView.starPriceViewDelegate = self;
            [self.view addSubview:starView];
        }
    }
    else if (currentType == HotelReserveType)
    {
        if (indexPath.section == 2 || indexPath.section == 3)
        {
            
        }
        if (indexPath.section == 4)
        {
            ReserveHotelController *reserveView = [[ReserveHotelController alloc] initWithType:HotelInvoiceType];
            [self.navigationController pushViewController:reserveView animated:YES];
        }
    }
    else
    {
        
    }
}

#pragma mark - StarPriceViewDelegate
- (void)returnWithValue:(NSString *)value hotelSiftType:(HotelSiftType)hotelSiftType
{
    HotelHostCell *cell = (HotelHostCell *)[table cellForRowAtIndexPath:currentIndexPath];
    cell.infoLabel.text = value;
    
    //星级/价格范围
    if (hotelSiftType == HotelSiftStar)
    {
        hotelInfo.starRate = @"3";
    }
    else if (hotelSiftType == HotelSiftPrice)
    {
        hotelInfo.priceRange = value;
    }
}

#pragma mark - CityChangeControllerDelegate
- (void)returnWithValue:(NSString *)name tag:(NSString *)tag nameKey:(NSString *)nameKey tagKey:(NSString *)tagKey
{
    HotelHostCell *cell = (HotelHostCell *)[table cellForRowAtIndexPath:currentIndexPath];
    cell.infoLabel.text = name;
    
    [hotelInfo setValue:name forKey:nameKey];
    [hotelInfo setValue:tag forKey:tagKey];
}

#pragma mark - 查询触发
- (void)checkBtnAction:(UIButton *)sender
{
    HotelListController *listView = [[HotelListController alloc] init];
    listView.hotelInfo = hotelInfo;
    [self.navigationController pushViewController:listView animated:YES];
}

#pragma showErrorInfo
- (void)showError:(NSString *)detail
{
    if (detail)
    {
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
    else
    {
        [self showErrorInfo:@"服务器繁忙，请稍候再试" status:NLHUDState_Error];
    }
}

//判断信息是否正确
-(void)showErrorInfo:(NSString *)detail status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]];
            
            _hud.mode = MBProgressHUDModeCustomView;
            
            [_hud show:YES];
            
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
            
            _hud.mode = MBProgressHUDModeCustomView;
            [_hud show:YES];
            
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = detail;
            
            [_hud show:YES];
        }
            break;
    }
    
    return ;
}

@end






















