//
//  WaterElecSelCity.m
//  TongFubao
//
//  Created by ec on 14-5-29.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "WaterElecSelCity.h"

@interface WaterElecSelCity ()

{
    NLProgressHUD* _hud;
}

@property (nonatomic, strong) UISearchBar                       *searchBar;
@property (nonatomic, strong) UITableView                       *table;
@property (nonatomic, strong) UISearchDisplayController         *searchCtrl;

@property (nonatomic, strong) NSMutableArray                    *resultList;
@property (nonatomic, strong) NSMutableArray                    *cityIndex;

@property (nonatomic, strong) NSMutableArray                    *headTitle;
@property (nonatomic, strong) NSMutableArray                    *netHeadTitle;

@property (nonatomic,strong) NSMutableArray                     *dataArray;
@property (nonatomic,strong) NSMutableArray                     *netDataArray;

@end

@implementation WaterElecSelCity

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
    // Do any additional setup after loading the view.
    
    
    [self UIInit];

    [self performSelector:@selector(getProductList) withObject:nil afterDelay:0.1];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NLUtils enableSliderViewController:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NLUtils enableSliderViewController:YES];
}

-(void)UIInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    _resultList = [NSMutableArray array];
    
    _cityIndex = [NSMutableArray array];
    _headTitle = [NSMutableArray array];
    _netHeadTitle = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _netDataArray = [NSMutableArray array];
    
    NSArray *localCityData = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_CITY_DATA];
    if (localCityData.count>0) {
        _dataArray = [NSMutableArray arrayWithArray:localCityData];
    }
    
    NSArray *localCityHeadData = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_CITY_HEAD_DATA];
    if (localCityHeadData.count>0) {
        _headTitle = [NSMutableArray arrayWithArray:localCityHeadData];
    }

    NSArray *arrIndex = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    [_cityIndex addObjectsFromArray:arrIndex];
    
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    viewHead.backgroundColor = [UIColor clearColor];
    
    //搜索栏
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.delegate = self;
    [viewHead addSubview:_searchBar];
    
    //tableview
    CGRect rect = self.view.bounds;
    rect.size.height = [NLUtils getCtrHeight];
    _table = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    if (IOS7_OR_LATER) {
        _table.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    _table.tableHeaderView = viewHead;
    [self.view addSubview:_table];
    
    //search display ctrl
    _searchCtrl = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchCtrl.delegate = self;
    _searchCtrl.searchResultsDelegate = self;
    _searchCtrl.searchResultsDataSource = self;

}

#pragma mark - table view datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _table) {
        return [_dataArray count];
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _table) {
        NSArray *arrCitys = [_dataArray objectAtIndex:section];
        return [arrCitys count];
    }else{
        return [_resultList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strCellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (tableView == _table) {
        NSArray *cityArr = [_dataArray objectAtIndex:[indexPath section]];
        NSDictionary *cityDict = [cityArr objectAtIndex:[indexPath row]];
        cell.textLabel.text = cityDict[@"cityName"];
    }else{
        NSDictionary *cityDict  = [_resultList objectAtIndex:[indexPath row]];
        cell.textLabel.text = cityDict[@"cityName"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *cityDict;
    if (tableView == _table) {
        NSArray *cityArr = [_dataArray objectAtIndex:[indexPath section]];
        cityDict = [cityArr objectAtIndex:[indexPath row]];
        
    }else{
        cityDict = [_resultList objectAtIndex:[indexPath row]];
    }
    
    if (cityDict !=nil) {
        //内存缓存
        [TFData getTempData][SELECT_CITY_FLAG] = cityDict;
        
        //本地缓存
        [[NSUserDefaults standardUserDefaults]setObject:cityDict forKey:LOCAL_CITY_SELECT_DATA];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _table) {
        return _cityIndex;
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView == _table) {
        return [_headTitle indexOfObject:title];
    }else{
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([_searchCtrl isActive]) {
        return nil;
    }
    return [_headTitle objectAtIndex:section];
}

#pragma mark - search bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

#pragma mark - search display delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
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
    
    [_resultList removeAllObjects];
    
    for (NSArray *searchArr in _dataArray) {
        for (NSDictionary *seachDic in searchArr) {
            NSString *resultCity = seachDic[@"cityName"];
            if (NSNotFound != [resultCity rangeOfString:searchString].location) {
                [_resultList addObject:seachDic];
            }
        }
    }

    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{

}


//获取水电煤产品信息
-(void)getProductList
{
    NSString* name = [NLUtils getNameForRequest:Notify_waterEle_getProductList];
    REGISTER_NOTIFY_OBSERVER(self, getProductListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readWaterEleProductList];
}


-(void)getProductListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self doReadWaterEleclistNotify:response];
        });
        
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    else
    {
        [_hud hide:YES];
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

-(void)doReadWaterEleclistNotify:(NLProtocolResponse*)response
{
    
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }else{
        
        NSArray *provinceNameArr = [response.data find:@"msgbody/msgchild/provinceName"];
        NSArray *cityArr = [response.data find:@"msgbody/msgchild/city"];
        NSString *provinceNameStr = nil;
        NSString *cityStr = nil;
        NSString *singleCity = nil;
        
        for (int i = 0 ; i<provinceNameArr.count; i++) {
            
            NLProtocolData* data = [provinceNameArr objectAtIndex:i];
            provinceNameStr = data.value;
            data = [cityArr objectAtIndex:i];
            cityStr = data.value;
            
            NSString *cityName = [cityStr componentsSeparatedByString:@"#@#"][0];
            cityName = [cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([provinceNameStr isEqualToString:cityName]) {
                singleCity = provinceNameStr;
            }else{
                singleCity = [NSString stringWithFormat:@"%@%@",provinceNameStr,cityName];
            }
            
            NSString *firtCh = [NLUtils getNamePinYingWithName:provinceNameStr];
            unsigned char ch = [firtCh characterAtIndex:0];
            if (ch>=65 && ch<=90) {
                
                //按首字母得到数组结构
                if ([_netHeadTitle count]==0||![_netHeadTitle containsObject:firtCh]) {
                    
                     [_netHeadTitle addObject:firtCh];
                }
            }
        }
        
         //构建数据结构
        _netHeadTitle = [NSMutableArray arrayWithArray:[_netHeadTitle sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2){
            return [str1 compare:str2];
        }]];
        
        for (int i =0; i<_netHeadTitle.count; i++) {
            NSMutableArray *singleChArr = [NSMutableArray array];
            [_netDataArray addObject:singleChArr];
        }
        
        for (int i = 0 ; i<provinceNameArr.count; i++) {
            
            NLProtocolData* data = [provinceNameArr objectAtIndex:i];
            provinceNameStr = data.value;
            data = [cityArr objectAtIndex:i];
            cityStr = data.value;
            
            NSString *cityName = [cityStr componentsSeparatedByString:@"#@#"][0];
            cityName = [cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([provinceNameStr isEqualToString:cityName]) {
                singleCity = provinceNameStr;
            }else{
                singleCity = [NSString stringWithFormat:@"%@%@",provinceNameStr,cityName];
            }
            
            NSString *firtCh = [NLUtils getNamePinYingWithName:provinceNameStr];
            unsigned char ch = [firtCh characterAtIndex:0];
            if (ch>=65 && ch<=90) {
                NSInteger index = [_netHeadTitle indexOfObject:firtCh];
                NSMutableArray *singleChArr = _netDataArray[index];
                [singleChArr addObject:@{@"cityName":singleCity,@"cityDict":cityStr}];
            }
        }

        [self getDataFinish];
    }
    
}

//获取数据后操作
-(void)getDataFinish
{
    if(self.view.window) {
      
        if (_netDataArray.count>0) {
            NSArray *localCityData = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_CITY_DATA];
            if (!localCityData.count>0) {
                _dataArray = _netDataArray;
                _headTitle = _netHeadTitle;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [_table reloadData];
                });
            }
            [[NSUserDefaults standardUserDefaults]setObject:_netDataArray forKey:LOCAL_CITY_DATA];
            [[NSUserDefaults standardUserDefaults]setObject:_netHeadTitle forKey:LOCAL_CITY_HEAD_DATA];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }else{
        _resultList = nil;
        
        _cityIndex = nil;
        _headTitle = nil;
        _netHeadTitle = nil;
        _dataArray = nil;
        _netDataArray = nil;

    }
}

//超时
- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
    
}

#pragma showErrorInfo
//判断信息是否正确
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView:self.view];
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.detailsLabelText = detail;
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            
            _hud.mode = MBProgressHUDModeCustomView;
            
            [_hud show:YES];
            
            [_hud hide:YES afterDelay:2];
            
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.labelText = detail;
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            
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
            
        default:
            break;
    }
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
