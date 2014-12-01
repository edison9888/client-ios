//
//  HotelInfoController.m
//  TongFubao
//
//  Created by Delpan on 14-8-28.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "HotelInfoController.h"
#import "HotelSynopsisController.h"
#import "HotelPhotoCell.h"
#import "HotelPhotoController.h"
#import "HotelRoomCell.h"
#import "StarPriceView.h"

@interface HotelInfoController ()
{
    NLProgressHUD  *_hud;
    
    NSInteger currentHeight;
    //房型/评论/照片列表
    UITableView *table[2];
    //房型/评论/照片按钮
    UIButton *changeBtn[3];
    //酒店详情信息底图
    UIView *infoBasicView;
    //酒店信息
    NSMutableDictionary *hotelInfoDic;
    //图片队列
    dispatch_queue_t queue;
    //酒店房间图片
    NSMutableArray *roomImages;
    //酒店设置图片
    NSMutableArray *photoImages;
    //当前数据类型
    NSString *currentType;
}

@end

@implementation HotelInfoController

- (void)viewWillAppear:(BOOL)animated
{
    if (!infoBasicView)
    {
        infoBasicView = [UIView viewWithFrame:CGRectMake(0, 0, SelfWidth, 100)];
        
        //logo
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 100, 80)];
        logoView.opaque = YES;
        logoView.image = [_basicInfoDic objectForKey:@"image"];
        [infoBasicView addSubview:logoView];
        
        //酒店名称
        UILabel *hotelNameLabel = [UILabel labelWithFrame:CGRectMake(120, 25, 110, 40)
                                          backgroundColor:[UIColor clearColor]
                                                textColor:[UIColor grayColor]
                                                     text:[_basicInfoDic objectForKey:@"hotelName"]
                                                     font:[UIFont systemFontOfSize:17.0]];
        hotelNameLabel.numberOfLines = 0;
        [infoBasicView addSubview:hotelNameLabel];
        
        //酒店地址
        UILabel *hotelAddress = [UILabel labelWithFrame:CGRectMake(120, 75, 115, 20)
                                        backgroundColor:[UIColor clearColor]
                                              textColor:[UIColor grayColor]
                                                   text:[_basicInfoDic objectForKey:@"address"]
                                                   font:[UIFont systemFontOfSize:14.0]];
        [infoBasicView addSubview:hotelAddress];
        
        //简介按钮
        UIButton *synopsisBtn = [UIButton buttonWithFrame:CGRectMake(SelfWidth - 90, 30, 80, 35)
                                            unSelectImage:imageName(@"samll_btn_selected@2x", @"png")
                                              selectImage:nil
                                                      tag:10000
                                               titleColor:[UIColor whiteColor]
                                                    title:@"简介"];
        [synopsisBtn addTarget:self action:@selector(synopsisBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [infoBasicView addSubview:synopsisBtn];
    }
    
    [self.view addSubview:infoBasicView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    self.title = @"酒店详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //当前数据类型
    currentType = @"room";
    
    //初始化数据
    [self initData];
    
    //初始化视图
    [self initView];
}

#pragma mark - 初始化数据
- (void)initData
{
    BOOL room = [currentType isEqualToString:@"room"]? YES : NO;
    
    //apiFunc类型
    NSString *apiFunc = room? @"GetGuestRoom" : @"GetHotelImage";
    
    //解析路径
    NSArray *rolePaths = room? @[ @"//operation_response/msgbody/msgchild", @"//operation_response/msgbody/msgchild/roomImage/msgchild" ] : @[ @"//operation_response/msgbody/msgchild" ];
    //解析类型
    NSArray *types = room? @[ [NSNumber numberWithInt:PublicList], [NSNumber numberWithInt:PublicList] ] : @[ [NSNumber numberWithInt:PublicList] ];
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    [LoadDataWithASI loadDataWithMsgbody:@{ @"hotelCode" : [_basicInfoDic objectForKey:@"hotelCode"] } apiName:@"ApiHotel" apiNameFunc:apiFunc rolePaths:rolePaths types:types completionBlock:^(id data, NSError *error) {
        
        if (data)
        {
            //酒店房间图片
            roomImages = roomImages? roomImages : [NSMutableArray array];
            //酒店设置图片
            photoImages = photoImages? photoImages : [NSMutableArray array];
            
            hotelInfoDic = hotelInfoDic? hotelInfoDic : [NSMutableDictionary dictionary];
            //保存酒店信息数据
            [hotelInfoDic setObject:[data objectAtIndex:0] forKey:currentType];
            
            //数据分解
            NSArray *datas = room? data[1] : data[0];
            
            //图片队列
            queue = queue? queue : dispatch_queue_create("com.hotelImage", NULL);
            
            //每个房型的数据
            __block NSMutableDictionary *dic = nil;
            
            //下载logo图片
            dispatch_async(queue, ^{
                
                for (int i = 0; i < datas.count; i++)
                {
                    @autoreleasepool
                    {
                        //保存图片数据
                        if (i % 3 == 0)
                        {
                            dic = [NSMutableDictionary dictionary];
                            
                            if (room)
                            {
                                [roomImages addObject:dic];
                            }
                            else
                            {
                                [photoImages addObject:dic];
                            }
                        }
                        
                        NSString *imageName = i % 3 == 0? @"firstName" : i % 3 == 1? @"secondName" : @"thirdName";
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[datas[i] objectForKey:(room? @"text" : @"url")]]];
                        
                        UIImage *image = [UIImage imageWithData:imageData];
                        [dic setObject:image forKey:imageName];
                    }
                    
                    //刷新列表
                    if (i == datas.count - 1)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            int type = room? 0 : 1;
                            
                            [_hud hide:YES];
                            
                            [table[type] reloadData];
                        });
                    }
                }
            });
        }
    }];
}

#pragma mark - 初始化视图
- (void)initView
{
    //房型/评论/照片按钮
    for (int i = 0; i < 2; i++)
    {
        NSString *btnName = i == 0? @"房型" : @"照片";
        
        changeBtn[i] = [UIButton buttonWithFrame:CGRectMake(0 + SelfWidth / 2 * i, 120, SelfWidth / 2, 35)
                                          unSelectImage:[NLUtils createImageWithColor:[UIColor grayColor]
                                                                                 rect:CGRectMake(0, 0, SelfWidth / 2, 35)]
                                            selectImage:[NLUtils createImageWithColor:RGBACOLOR(192, 192, 192, 1.0)
                                                                                 rect:CGRectMake(0, 0, SelfWidth / 2, 35)]
                                                    tag:3201 + i
                                             titleColor:[UIColor whiteColor]
                                                  title:btnName];
        changeBtn[i].selected = i == 0? YES : NO;
        [changeBtn[i] addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:changeBtn[i]];
    }
    
    //房型列表
    table[0] = [[UITableView alloc] initWithFrame:CGRectMake(0, 155, SelfWidth, currentHeight - 224) style:UITableViewStylePlain];
    table[0].delegate = self;
    table[0].dataSource = self;
    table[0].showsVerticalScrollIndicator = NO;
    [self.view addSubview:table[0]];
}

#pragma mark - 简介触发
- (void)synopsisBtnAction:(UIButton *)sender
{
    [infoBasicView removeFromSuperview];
    
    HotelSynopsisController *synopsisView = [[HotelSynopsisController alloc] init];
    synopsisView.infoBasicView = infoBasicView;
    [self.navigationController pushViewController:synopsisView animated:YES];
}

#pragma mark - 列表切换触发
- (void)changeBtnAction:(UIButton *)sender
{
    if (!sender.selected)
    {
        currentType = sender.tag == 3201? @"room" : @"photo";
        
        if (![hotelInfoDic objectForKey:currentType])
        {
            [self initData];
        }
        
        //隐藏/显示相应列表
        for (int i = 0; i < 2; i++)
        {
            table[i].hidden = YES;
            changeBtn[i].selected = NO;
        }
        
        table[sender.tag - 3201].hidden = !table[sender.tag - 3201].hidden;
        sender.selected = !sender.selected;
        
        if (!table[1])
        {
            table[1] = [[UITableView alloc] initWithFrame:CGRectMake(0, 155, SelfWidth, currentHeight - 224) style:UITableViewStylePlain];
            table[1].delegate = self;
            table[1].dataSource = self;
            table[1].showsVerticalScrollIndicator = NO;
            [self.view addSubview:table[1]];
        }
    }
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 0;
    
    if ([hotelInfoDic objectForKey:currentType])
    {
        rowNumber = [[hotelInfoDic objectForKey:currentType] count];
        rowNumber = [currentType isEqualToString:@"room"]? rowNumber : (rowNumber / 3.0 > rowNumber / 3? rowNumber / 3 +1 : rowNumber / 3);
    }
    
    return rowNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280 / 4.0 + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    __weak HotelInfoController *thisView = self;
    
    //酒店房型/照片
    if (tableView == table[0])
    {
        HotelRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[HotelRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        }
        
        //当前高度
        NSInteger cellHeight = currentHeight;
        
        //酒店房型照片
        [cell.logoBtn setBackgroundImage:(roomImages.count > indexPath.row? [roomImages[indexPath.row] objectForKey:@"firstName"] : nil) forState:UIControlStateNormal];
        
        __weak NSArray *thisImages = roomImages;
        
        //查看酒店照片
        cell.photoBlock = ^
        {
            StarPriceView *starView = [[StarPriceView alloc] initWithFrame:CGRectMake(0, 0, thisView.view.frame.size.width, cellHeight - 64) image:[thisImages[indexPath.row] objectForKey:@"firstName"]];
            [thisView.view addSubview:starView];
        };
        
        //酒店预订
        cell.reserveBlock = ^
        {
            ReserveHotelController *reserveView = [[ReserveHotelController alloc] initWithType:HotelReserveType];
            [thisView.navigationController pushViewController:reserveView animated:YES];
        };
        
        return cell;
    }
    else
    {
        HotelPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[HotelPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        }
        
        [cell.firstBtn setBackgroundImage:[photoImages[indexPath.row] objectForKey:@"firstName"] forState:UIControlStateNormal];
        [cell.secondBtn setBackgroundImage:[photoImages[indexPath.row] objectForKey:@"secondName"] forState:UIControlStateNormal];
        [cell.thirdBtn setBackgroundImage:[photoImages[indexPath.row] objectForKey:@"thirdName"] forState:UIControlStateNormal];
        
        //查看酒店照片
        cell.photoBlock = ^(UIButton *currentBtn)
        {
            HotelPhotoController *photoView = [[HotelPhotoController alloc] initWithImage:[currentBtn currentBackgroundImage]];
            [thisView.navigationController pushViewController:photoView animated:YES];
        };
        
        return cell;
    }
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
}

- (void)dealloc
{
    NSLog(@"HotelInfoController内存释放");
    
    dispatch_release(queue);
}

@end






















