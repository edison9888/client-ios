//
//  HotelListController.m
//  TongFubao
//
//  Created by Delpan on 14-8-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelListController.h"

@interface HotelListController ()
{
    NLProgressHUD  *_hud;
    //
    NSInteger currentHeight;
    //
    UITableView *table;
    //筛选功能按钮
    UIButton *siftBtn[3];
    //酒店信息
    NSArray *hotelInfos;
    //酒店图片
    NSMutableArray *logoImages;
    //图片队列
    dispatch_queue_t queue;
}

@property (nonatomic, weak) UIView *currentSiftView;

@end

@implementation HotelListController

@synthesize currentSiftView = _currentSiftView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.title = @"酒店列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    //获取酒店列表
    [self getListOfHotel];
    
    //初始化视图
    [self initView];
}

#pragma mark - 获取酒店列表
- (void)getListOfHotel
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    //酒店列表请求参数
    NSDictionary *dic = @{ @"cityId" : (_hotelInfo.cityId? _hotelInfo.cityId : @""),
                           @"districtId" : (_hotelInfo.districtId? _hotelInfo.districtId : @""),
                           @"zoneId" : (_hotelInfo.zoneId? _hotelInfo.zoneId : @""),
                           @"brandId" : (_hotelInfo.brandId? _hotelInfo.brandId : @""),
                           @"themeId" : (_hotelInfo.themeId? _hotelInfo.themeId : @""),
                           @"locationId" : (_hotelInfo.locationId? _hotelInfo.locationId : @""),
                           @"priceRange" : (_hotelInfo.priceRange? _hotelInfo.priceRange : @""),
                           @"starRate" : (_hotelInfo.starRate? _hotelInfo.starRate : @""),
                           @"start" : @"0",
                           @"count" : @"10" };
    
    [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiHotel" apiNameFunc:@"GetHotelList" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        
        if (data)
        {
            //酒店数据
            hotelInfos = data;
            
            [_hud hide:YES];
            
            [table reloadData];
            
            //生成图片数组
            logoImages = logoImages? logoImages : [NSMutableArray array];
            
            //生成图片队列
            queue = queue? queue : dispatch_queue_create("com.logoImage", NULL);
            
            //下载logo图片
            dispatch_async(queue, ^{
                
                for (int i = 0; i < hotelInfos.count; i++)
                {
                    @autoreleasepool
                    {
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[hotelInfos[i] objectForKey:@"imageUrl"]]];
                        
                        UIImage *image = [UIImage imageWithData:imageData];
                        [logoImages addObject:image];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [table reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:i inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
                    });
                }
            });
        }
    }];
}

#pragma mark - 初始化视图
- (void)initView
{
    if (!table)
    {
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 113) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundView = nil;
        table.backgroundColor = nil;
        table.showsVerticalScrollIndicator = NO;
        [self.view addSubview:table];
    }
    
    //筛选功能按钮
    for (int i = 0; i < 3; i++)
    {
        NSString *btnName = i == 0? @"区域" : i == 1? @"价格" : @"星级";
        
        siftBtn[i] = [UIButton buttonWithFrame:CGRectMake(SelfWidth / 3.0 * i, currentHeight - 113, SelfWidth / 3.0, 49)
                                 unSelectImage:[NLUtils createImageWithColor:[UIColor blackColor]
                                                                        rect:CGRectMake(0, 0, SelfWidth / 3.0, 49)]
                                   selectImage:[NLUtils createImageWithColor:RGBACOLOR(83, 83, 83, 1.0)
                                                                        rect:CGRectMake(0, 0, SelfWidth / 3.0, 49)]
                                           tag:3301 + i
                                    titleColor:[UIColor whiteColor]
                                         title:btnName];
        [siftBtn[i] addTarget:self action:@selector(siftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:siftBtn[i]];
    }
}

#pragma mark - 筛选功能触发
- (void)siftBtnAction:(UIButton *)sender
{
    if (self.currentSiftView)
    {
        [self.currentSiftView removeFromSuperview];
    }
    
    if (!sender.selected)
    {
        for (int i = 0; i < 3; i++)
        {
            siftBtn[i].selected = NO;
        }
        
        //区域/价格/星级
        if (sender.tag == 3301)
        {
            HotelAreaSiftTable *siftTable = [[HotelAreaSiftTable alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 113)];
            siftTable.hotelAreaSiftTableDelegate = self;
            [self.view addSubview:siftTable];
            
            self.currentSiftView = siftTable;
        }
        else
        {
            StarPriceView *starView = [[StarPriceView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 113) hotelSiftType:(sender.tag == 3302? HotelSiftSort : HotelSiftStar)];
            starView.starPriceViewDelegate = self;
            [self.view addSubview:starView];
            
            self.currentSiftView = starView;
        }
    }
    
    sender.selected = !sender.selected;
}

#pragma mark - StarPriceViewDelegate
- (void)returnWithValue:(NSString *)value hotelSiftType:(HotelSiftType)hotelSiftType
{
    siftBtn[(hotelSiftType == HotelSiftSort? 1 : 2 )].selected = NO;
    
    if (hotelSiftType == HotelSiftPrice)
    {
        
    }
    else
    {
        
    }
}

#pragma mark - HotelAreaSiftTableDelegate
- (void)returnWithValue:(NSString *)value
{
    siftBtn[0].selected = NO;
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hotelInfos.count? hotelInfos.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    HotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[HotelListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    
    //酒店图片
    cell.logoView.image = logoImages.count > indexPath.row? logoImages[indexPath.row] : nil;
    //酒店名称
    cell.hotelNameLabel.text = [hotelInfos[indexPath.row] objectForKey:@"hotelName"];
    //酒店价钱
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@", [hotelInfos[indexPath.row] objectForKey:@"minPrice"]];
    //评分
    cell.ctripRateLabel.text = [NSString stringWithFormat:@"%.1f分", [[hotelInfos[indexPath.row] objectForKey:@"ctripRate"] floatValue]];
    //地址
    cell.addressLabel.text = [hotelInfos[indexPath.row] objectForKey:@"address"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelInfoController *infoView = [[HotelInfoController alloc] init];
    
    infoView.basicInfoDic = @{ @"image" : logoImages[indexPath.row],
                               @"hotelName" : [hotelInfos[indexPath.row] objectForKey:@"hotelName"],
                               @"address" : [hotelInfos[indexPath.row] objectForKey:@"address"],
                               @"hotelCode" : [hotelInfos[indexPath.row] objectForKey:@"hotelCode"]};
    
    [self.navigationController pushViewController:infoView animated:YES];
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

- (void)dealloc
{
    NSLog(@"HotelListController内存释放");
    
    dispatch_release(queue);
}

@end
















