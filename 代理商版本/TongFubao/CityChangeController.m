//
//  CityChangeController.m
//  TongFubao
//
//  Created by Delpan on 14-8-26.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "CityChangeController.h"

@interface CityChangeController ()
{
    NLProgressHUD  *_hud;
    //当前高度
    NSInteger currentHeight;
    //城市列表
    CustomTable *table;
    //搜索输入框
    UITextField *searchText;
    //当前类型
    CustomTableType currentType;
    //是否搜索
    BOOL searchOr;
    //当前名称
    NSArray *currentNames;
    //当前ID
    NSArray *currentIDs;
}

@end

@implementation CityChangeController

@synthesize cityChangeControllerDelegate = _cityChangeControllerDelegate;

- (id)initWithCity:(CustomTableType)customTableType
{
    if (self = [super init])
    {
        currentType = customTableType;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    self.title = currentType == CustomTableCitys? @"城市选择" : @"关键字";
    
    //初始化视图
    [self initView];
}

#pragma mark - 初始化视图
- (void)initView
{
    NSArray *headViews = currentType == CustomTableCitys? @[ @"热门城市",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z" ] : @[ @"行政区", @"商业区", @"品牌", @"主题", @"机场车站", @"景点" ];
    
    UIView *searchBasicView = [UIView viewWithFrame:CGRectMake(0, 0, SelfWidth, 60)];
    searchBasicView.backgroundColor = RGBACOLOR(220, 217, 219, 1.0);
    
    UIView *leftView = [UIView viewWithFrame:CGRectMake(0, 0, 40, 40)];
    leftView.backgroundColor = [UIColor orangeColor];
    
    //搜索输入框
    searchText = [UITextField textWithFrame:CGRectMake(20, 10, 280, 40) placeholder:@"请输入入住城市名称"];
    searchText.layer.cornerRadius = 5.0;
    searchText.delegate = self;
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.leftView = leftView;
    searchText.leftViewMode = UITextFieldViewModeAlways;
    [searchText leftViewRectForBounds:CGRectMake(10, 0, 40, 40)];
    [searchBasicView addSubview:searchText];
    
    table = [[CustomTable alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 64)
                                         style:UITableViewStylePlain
                                     headInfos:headViews
                               customTableType:currentType];
    table.customTabelDelegate = self;
    table.tableHeaderView = searchBasicView;
    [self.view addSubview:table];
}

#pragma mark - CustomTableDelegate
//城市请求
- (void)loadCitiesWithFirstLetter:(NSString *)firstLetter
{
    searchOr = NO;
    
    //根据字母加载数据
    [self loadDataWithFirstLetter:firstLetter cityName:@" "];
}

#pragma mark - 关键字请求
- (void)loadDataForKeywords:(NSInteger)keywords
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    //当前类型
    currentType = keywords + 2;
    
    //APIFunc
    NSArray *funcs = @[ @"GetDistrict",
                        @"GetBusinessZone",
                        @"GetHotelBrand",
                        @"GetHotelTheme",
                        @"GetCityLocation",
                        @"GetCityLocation" ];
    
    //请求参数
    NSDictionary *dic = keywords < 2? @{ @"cityId" : self.currentCityID } : keywords == 2 || keywords == 3? @{} : @{ @"cityId" : self.currentCityID, @"locationType" : (keywords == 4? @"9" : @"7") };
    
    //数据请求
    [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiHotel" apiNameFunc:funcs[keywords] rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        
        [table returnName:data];
        [_hud hide:YES];
    }];
}

#pragma mark - 请求城市列表
- (void)loadDataWithFirstLetter:(NSString *)firstLetter cityName:(NSString *)cityName
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    
    //请求参数
    NSDictionary *dataDictionary = @{ @"firstLetter" : firstLetter, @"cityName" : cityName };
    
    //数据请求
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiHotel" apiNameFunc:@"GetCity" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
        
        [table returnName:data];
        [_hud hide:YES];
    }];
}

#pragma mark - CustomTableDelegate/BlackTableViewDelegate
- (void)returnWithDictionary:(NSDictionary *)dataDictionary
{
    //名称号
    NSInteger nameNumber = [NLUtils checkInterNum:[[dataDictionary allValues] objectAtIndex:0]]? 1 : 0;
    //id号
    NSInteger idNumber = nameNumber? 0 : 1;
    
    //数据名称
    NSString *nameData = [[dataDictionary allValues] objectAtIndex:nameNumber];
    //数据ID
    NSString *idData = [[dataDictionary allValues] objectAtIndex:idNumber];
    
    [self popToPreviousWithValue:nameData tag:idData nameKey:[[dataDictionary allKeysForObject:nameData] objectAtIndex:0] tagKey:[[dataDictionary allKeysForObject:idData] objectAtIndex:0]];
}

#pragma mark - 返回上一页面
- (void)popToPreviousWithValue:(NSString *)name tag:(NSString *)tag nameKey:(NSString *)nameKey tagKey:(NSString *)tagKey
{
    if ([self.cityChangeControllerDelegate respondsToSelector:@selector(returnWithValue:tag:nameKey:tagKey:)])
    {
        //返回数据
        [_cityChangeControllerDelegate returnWithValue:name tag:tag nameKey:nameKey tagKey:tagKey];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    //搜索城市
    [self loadDataWithFirstLetter:@" " cityName:textField.text];
    
    return YES;
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
-(void)showErrorInfo:(NSString*)detail status:(NLHUDState)status
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
    NSLog(@"CityChangeController内存释放");
}

@end




















