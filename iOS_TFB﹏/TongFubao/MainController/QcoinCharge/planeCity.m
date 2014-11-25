//
//  planeCity.m
//  TongFubao
//
//  Created by  俊   on 14-7-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "planeCity.h"
#import "UIViewController+NavigationItem.h"
#import "planeChage.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface planeCity ()
{
    NLProgressHUD *hud;
    CustomTable *customTable;
    NSInteger currentHeight;
}
@property (nonatomic, strong) UISearchBar                       *searchBar;
@property (nonatomic, strong) UISearchDisplayController         *searchCtrl;
@end

@implementation planeCity

- (void)dealloc
{
    Release(customTable)
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    /*生成列表*/
    [self initTableView];
}

- (void)initTableView
{
    /*布局啊*/
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    viewHead.backgroundColor = [UIColor clearColor];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.delegate = self;
    [viewHead addSubview:_searchBar];
    
    customTable = [[CustomTable alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 108) style:UITableViewStyleGrouped];
    customTable.customTabelDelegate = self;
    customTable.tableHeaderView= viewHead;
    [self.view addSubview:customTable];
    
    _searchCtrl = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchCtrl.delegate = self;
    _searchCtrl.searchResultsDelegate = self;
    _searchCtrl.searchResultsDataSource = self;

}

#pragma mark - customTableViewDelegate
- (void)loadCitiesWithFirstLetter:(NSString *)firstLetter
{
    //创建通知名
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAirticket];
    //创建通知
    REGISTER_NOTIFY_OBSERVER(self, getApiAirticketNotify, name);
    //请求并返回数据
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAirticket:firstLetter cityName:@""];
}

#pragma mark - 检测返回信息
- (void)getApiAirticketNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    //判断信息是否正确
    if (error == RSP_NO_ERROR)
    {
        [self dogetApiAirticketNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        
    }
    else
    {
        
    }
}

#pragma mark - 获取数据
- (void)dogetApiAirticketNotify:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"%@",errorData);
    }
    else
    {
        //城市信息数组
        NSMutableArray *cityDatas = [NSMutableArray array];
        
        //城市code数组
        NSArray *cityCodes = [response.data find:@"msgbody/msgchild/cityCode"];
        //城市ID数组
        NSArray *cityIDs = [response.data find:@"msgbody/msgchild/cityId"];
        //城市名数组
        NSArray *cityNames = [response.data find:@"msgbody/msgchild/cityNameCh"];
        
        //城市code
        NLProtocolData *codeData = nil;
        //城市ID
        NLProtocolData *idData = nil;
        //城市名
        NLProtocolData *nameData = nil;
        //城市信息
        NSDictionary *cityDic = nil;
        
        for (int i = 0; i < cityCodes.count; i++)
        {
            //获取城市code
            codeData = [cityCodes objectAtIndex:i];
            //获取城市ID
            idData = [cityIDs objectAtIndex:i];
            //获取城市名
            nameData = [cityNames objectAtIndex:i];
            //综合城市信息
            cityDic = @{ @"cityCode" : codeData.value, @"cityId" : idData.value, @"cityNameCh" : nameData.value };
            
            [cityDatas addObject:cityDic];
        }
        
        [customTable returnCities:cityDatas];
    }
}

//#pragma mark - 飞机票城市选择
//-(void)loadCitiesWithFirstLetter:(NSString *)firstLetter
//{
//    NSString* name = [NLUtils getNameForRequest:Notify_ApiAirticket];
//    REGISTER_NOTIFY_OBSERVER(self, getApiAirticketNotify, name);
//    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAirticket:@"A" cityName:@""];
//}
//
//#pragma mark - 飞机票的接口
//-(void)getApiAirticketNotify:(NSNotification*)notify
//{
//    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
//    int error = response.errcode;
//    
//    if (RSP_NO_ERROR == error)
//    {
//        [hud hide:YES];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self dogetApiAirticketNotify:response];
//        });
//    }
//    else if (error == RSP_TIMEOUT)
//    {
////        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
//        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
//        
//        return ;
//    }
//    else
//    {
//        [hud hide:YES];
//        
//        NSString *detail = response.detail;
//        
//        if (!detail || detail.length <= 0)
//        {
//            detail = @"系统维护当中";
//        }
//        
////        [self showErrorInfo:detail status:NLHUDState_Error];
//    }
//}
//
//#pragma mark - 飞机票城市查询
//-(void)dogetApiAirticketNotify:(NLProtocolResponse*)response
//{
//    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
//    NSString *result = data.value;
//    NSRange range = [result rangeOfString:@"succ"];
//    if (range.length <= 0)
//    {
//        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
//        
//        NSString* value = data.value;
//        
////        [self showErrorInfo:value status:NLHUDState_Error];
//    }
//    else
//    {
//        _myArray= [NSMutableArray array];
//        
//        NSArray *cityCodeArr = [response.data find:@"msgbody/msgchild/cityCode"];
//        NSArray *cityIdArr = [response.data find:@"msgbody/msgchild/cityId"];
//        NSArray *cityNameChArr = [response.data find:@"msgbody/msgchild/cityNameCh"];
//        
//        NSString *cityCodeStr = nil;
//        NSString *cityIdStr = nil;
//        NSString *cityNameChStr= nil;
//        
//        
//        for (int i = 0 ; i<cityNameChArr.count; i++) {
//            
//            NLProtocolData* data = [cityIdArr objectAtIndex:i];
//            cityIdStr = data.value;
//            
//            data = [cityNameChArr objectAtIndex:i];
//            cityNameChStr = data.value;
//            
//            data = [cityCodeArr objectAtIndex:i];
//            cityCodeStr = data.value;
//            
//            [_myArray addObject:@{@"cityId":cityIdStr,@"cityNameCh":cityNameChStr,@"cityCode":cityCodeStr}];
//            
//        }
//        
//        NSArray *arrayCity= [[NSUserDefaults standardUserDefaults]objectForKey:@"myarray"];
//        
//        if (arrayCity.count==0)
//        {
//            
////            [self CityOnDock:YES];
//            
//        }
//        else
//        {
////            [self CityOnDock:NO];
//        }
//        
//        [[NSUserDefaults standardUserDefaults]setObject:_myArray forKey:@"myarray"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//}
//
//-(void)CityOnDock:(BOOL)first
//{
//    
//}
//
//#pragma mark - 界面重置
//- (void)reset
//{
//    for(int i = 0;i<[self.headViews count];i++)
//    {
//        HeadView *head = [self.headViews objectAtIndex:i];
//        
//        if(head.section == _currentSection)
//        {
//            head.open = YES;
//            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
//            
//        }else {
//            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
//            
//            head.open = NO;
//        }
//        
//    }
//    
//    [_tableView reloadData];
//}
//
//#pragma mark - 超时
//- (void)doPush
//{
//    [hud hide:YES];
//    [NLUtils popToLogonVCByHTTPError:(UIViewController*)[[[self nextResponder] nextResponder] nextResponder] feedOrLeft:1];
//}
//
//#pragma showErrorInfo
////判断信息是否正确
//-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
//{
//    [hud hide:YES];
//    hud = [[NLProgressHUD alloc] initWithParentView:self.view];
//    
//    switch (status)
//    {
//        case NLHUDState_Error:
//        {
//            hud.detailsLabelText = detail;
//            
//            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
//            
//            hud.mode = MBProgressHUDModeCustomView;
//            
//            [hud show:YES];
//            
//            [hud hide:YES afterDelay:2];
//            
//        }
//            break;
//            
//        case NLHUDState_NoError:
//        {
//            hud.labelText = detail;
//            
//            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
//            
//            hud.mode = MBProgressHUDModeCustomView;
//            [hud show:YES];
//            
//            [hud hide:YES afterDelay:2];
//            
//        }
//            break;
//            
//        case NLHUDState_None:
//        {
//            hud.labelText = detail;
//            
//            [hud show:YES];
//        }
//            
//        default:
//            break;
//    }
//    return;
//}

#pragma mark - search bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

#pragma mark - search display delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    /*
    //TF8编码：汉字占3个字节，英文字符占1个字节
    BOOL beZWSearch = NO;//搜索词含有中文
    
    for (int i=0; i < [searchString length]; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [searchString substringWithRange:range];
        const char *cString = [subStr UTF8String];
        if (3 == strlen(cString)) {
            beZWSearch = YES;
            break;
        }
    }
    
    searchString = [searchString uppercaseString];
    
//    [_resultList removeAllObjects];
    
    //本地搜索对比
    
    for (NSArray *searchArr in _dataArray) {
        for (NSDictionary *seachDic in searchArr) {
            NSString *resultGame = seachDic[@"cityNameCh"];
            if (NSNotFound != [resultGame rangeOfString:searchString].location) {
                [_resultList addObject:seachDic];
            }
        }
    }
    
    */
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    
    
}

@end
