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
    UIButton *carButton;/*测试按钮*/
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
    /*布局啊 孙子布局
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    viewHead.backgroundColor = [UIColor clearColor];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.delegate = self;
    [viewHead addSubview:_searchBar];
    
    customTable = [[CustomTable alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, currentHeight - 108) style:UITableViewStyleGrouped headInfos:@[ @"测试", @"还是测试", @"就是测试", @"真的测试", @"测试来的", @"这是测试", @"呔 测试啊" ] city:YES];
    customTable.customTabelDelegate = self;
    customTable.tableHeaderView= viewHead;
    [self.view addSubview:customTable];
     */
    
    _searchCtrl = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchCtrl.delegate = self;
    _searchCtrl.searchResultsDelegate = self;
    _searchCtrl.searchResultsDataSource = self;
    
    /*自己对于title和到达 返回按钮自己写*/
    self.myTableView=[[TouchTableView alloc]initWithFrame:CGRectMake(0, 40, 320, 390) style:UITableViewStylePlain];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.touchDelegate=self;
    [self.view addSubview:self.myTableView];
    [self sentRequest];
    /*替换的文字 自己写*/
    [self loadMyBottonView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indifier=@"HomeCell";
    ShopCell *cell=[tableView dequeueReusableCellWithIdentifier:indifier];
    if (cell==nil) {
        cell=[[ShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indifier];
    }
    Meal *meal=[self.marr objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    BOOL buyed=[[OrderInstance sharedInstance]hasOredr:[meal.mId intValue]];
    /*这里没啥用 看下面效果行了*/
    [cell setInfoTitle:meal.title andPrice:[NSString stringWithFormat:@"测试第%@数据",meal.price] andNum:meal.num andImageUrl:[NSString stringWithFormat:@"%@%@",@"测试",@"大概"] andBuyed: buyed];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTaped:)];
    tap.numberOfTapsRequired=1;
    [cell.contentView addGestureRecognizer:tap];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(void)loadMyBottonView{

    /*自己对于到达返航的按钮实现*/
    carButton = [UIButton buttonWithType:UIButtonTypeCustom];
    carButton.opaque = YES;
    carButton.frame = CGRectMake( 0, 0, 160, 40);
    [carButton setTitle:@"" forState:UIControlStateNormal];
    [carButton setBackgroundColor:[UIColor whiteColor]];
    [carButton setTintColor:[UIColor whiteColor]];
    carButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:carButton];
    
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point=[[touches anyObject]locationInView:self.myTableView];
    int b=(int)(point.y/70);
    Meal *meal=[self.marr objectAtIndex:b];
    BOOL buyed=[[OrderInstance sharedInstance]hasOredr:[meal.mId intValue]];
    NSIndexPath *path=[NSIndexPath indexPathForRow:b inSection:0];
    ShopCell *cell=(ShopCell *)[tableView cellForRowAtIndexPath:path];
    
    if (buyed) {
        /*可要可不要 选中和非选中效果*/
        [[OrderInstance sharedInstance]deleOrder:meal];
        [cell notbuyAnimation];
    }else{
        [[OrderInstance sharedInstance]addOrder:meal];
        [cell buyAnimation];
    }
    
    if (!buyed) {
        //该部分动画 以self.view为参考系进行
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gesture_node_normal"]];
        imageView.contentMode=UIViewContentModeScaleToFill;
        imageView.frame=CGRectMake(0, 0, 66, 66);
        imageView.hidden=YES;
        CGPoint point=[[touches anyObject]locationInView:self.myTableView];
        imageView.center=point;
        CALayer *layer=[[CALayer alloc]init];
        layer.contents=imageView.layer.contents;
        layer.frame=imageView.frame;
        layer.opacity=1;
        [self.view.layer addSublayer:layer];
        
        CGPoint point1=carButton.center;
        CGPoint endpoint=[self.view convertPoint:point1 fromView:self.view];
        UIBezierPath *path=[UIBezierPath bezierPath];

        CGPoint startPoint=[self.view convertPoint:point fromView:self.myTableView];
        [path moveToPoint:startPoint];
        
        /*贝塞尔曲线中间点*/
        float sx=startPoint.x;
        float sy=startPoint.y;
        float ex=endpoint.x;
        float ey=endpoint.y;
        float x=sx+(ex-sx)/3;
        float y=sy+(ey-sy)*0.5+400;
        CGPoint centerPoint=CGPointMake(x,y);
        [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
        
        CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = path.CGPath;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.duration=0.8;
        animation.autoreverses= NO;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [layer addAnimation:animation forKey:@"text"];
    }
}

-(void)sentRequest{
    
    self.marr=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<10; i++) {
        Meal *meal=[[Meal alloc]initWithID:[NSString stringWithFormat:@"%d",i+1] andTitle:[NSString stringWithFormat:@"测试来的%d",i+1] andOther:@"这是测试文字" andImageUrl:@"bank13" andPrice:@"45.0" andPoint:@"4.5" andNum:i+100];
        [self.marr addObject:meal];
        
    }
    [self.myTableView reloadData];
    
}


-(void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)move:(CALayer *)layer{
    [layer removeFromSuperlayer];
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    id a=[anim valueForKey:@"text"];
    NSLog(@"%@",a);
    
}

/*接口不用看了 就效果*/

#pragma mark - customTableViewDelegate
- (void)loadCitiesWithFirstLetter:(NSString *)firstLetter
{
    //创建通知名
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAirticket];
   
    //创建通知
    REGISTER_NOTIFY_OBSERVER(self, planeNotify, name);
    //请求并返回数据
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAirticket:firstLetter cityName:@""];
}

#pragma mark - 检测返回信息
- (void)planeNotify:(NSNotification *)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)//正确的话
    {
        [self dogetApiAirticketMoreNotify:response];
    }
    else
    {
       
    }
}

#pragma mark - 获取数据
- (void)dogetApiAirticketMoreNotify:(NLProtocolResponse *)response
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
        REMOVE_NOTIFY_OBSERVER_FOR_NAME(self, Notify_ApiAirticket);
        
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
