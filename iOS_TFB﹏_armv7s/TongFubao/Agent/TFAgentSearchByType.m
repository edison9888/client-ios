//
//  TFAgentSearchByDay.m
//  TongFubao
//
//  Created by ec on 14-6-16.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFAgentSearchByType.h"
#import "MainViewController.h"

@interface TFAgentSearchByType ()

{
    NLProgressHUD* _hud;
}

@property (nonatomic,assign) TFAgentSearchType searchType;

@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,strong) UIScrollView *contentScroll;
@property (nonatomic,strong) MainViewController*mainView;

@end

@implementation TFAgentSearchByType

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithType:(TFAgentSearchType )type
{
    self = [super init];
    
    if (type)
    {
        _searchType = type;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UIInit];
}

-(void)UIInit
{
    _isFirst = YES;
    
    CGFloat ctrH = [NLUtils getCtrHeight];
    CGFloat scrollH = IOS7_OR_LATER == YES? (ctrH - 60 - 64) : (ctrH - 60);
    
    CGRect rect = self.view.bounds;
    rect.size.height = scrollH;
    self.view.frame = rect;
    
    /*图片拉伸*/
    UIImageView *searchInputBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 290, 40)];
    searchInputBg.userInteractionEnabled = YES;
    [searchInputBg setImage:[[UIImage imageNamed:@"input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 4, 6, 4) resizingMode:UIImageResizingModeStretch]];
    [self.view addSubview:searchInputBg];
    
    UIButton *searchBt = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBt.frame = CGRectMake(0 ,0, 290, 40);
    /*箭头*/
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(255, 5, 30, 30)];
    [searchImg setImage:[UIImage imageNamed:@"down_gray_arrow"]];
    [searchBt addSubview:searchImg];
    [searchBt addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchInputBg addSubview:searchBt];
    
    _searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 270, 40)];
    _searchField.textColor = [UIColor grayColor];
    _searchField.placeholder = @"请选择查询时间";
    _searchField.userInteractionEnabled = NO;
    [searchInputBg addSubview:_searchField];
    
    _contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, 320, scrollH - 50)];
    _contentScroll.backgroundColor= SACOLOR(245,1.0);
    [self.view addSubview:_contentScroll];
   
    /*没写查询收益功能 我擦 还要我重做*/
    /*功能年月头*/
    //    UILabel *lable= [UILabel labelWithFrame:CGRectMake(0, 150, 200, 20) backgroundColor:[UIColor clearColor] textColor:[UIColor lightGrayColor] text:_searchField font:15];
    
    /*界面收益功能显示*/
    _mainView= [[MainViewController alloc]init];
    _mainView.view.frame=  CGRectMake(0, 250, 320, SelfHeight-250);
    _mainView.view.backgroundColor= SACOLOR(245,1.0);
    [self.view addSubview:_mainView.view];
}

/*url 功能重新写*/
-(void)AgentfenrunListURL:(NSString *)time searchType:(NSString *)searchType
{
    /*查询类型 Data/month/year 查询值 2014/2014-06/2014-06-18*/
     NSMutableArray *appfunArr = [NSMutableArray array];
    
    NSDictionary *dataDictionary = @{ @"querytype" : searchType,   @"querywhere" : time , };
    /*注册接口写法*/
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiAgentInfo" apiNameFunc:@"payagentfenrunlist" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSDictionary *data, NSError *error) {
        NSLog(@"data %@",data);
        
        if (![data[@"result"] isEqualToString:@"success"])
        {
            [appfunArr addObject:@{@"appfunName": @"总收益",@"appfunEarn":[NSString stringWithFormat:@"%f",0.00]}];
         
            [self setContentUI:appfunArr];
     
        }else
        {
            [appfunArr addObject:@{@"appfunName": data[@"appfunName"],@"appfunEarn":data[@"appfunEarn"]}];
            
            dispatch_async(dispatch_get_main_queue(), ^void(){
                if (_isCurrent) {
                    [self setContentUI:appfunArr];
                }
            });
        }
    }];
}

/*显示年月时间*/
-(void)clickType
{
 
    [self performSelector:@selector(searchData) withObject:nil afterDelay:0.1];
 
}

-(void)searchData
{
    if (_searchType == SearchTypeDay)
    {
        NSInteger year  = [[NLUtils componentsOfDate:[NSDate date]] year];
        NSInteger month  = [[NLUtils componentsOfDate:[NSDate date]] month];
        NSInteger day = [[NLUtils componentsOfDate:[NSDate date]] day];
        NSString *tempMonth = [NSString stringWithFormat:@"%d",month];
        
        if (month < 10)
        {
            tempMonth = [NSString stringWithFormat:@"0%d",month];
        }
        
        NSString *tempDay = [NSString stringWithFormat:@"%d",day];
        
        if (day < 10)
        {
            tempDay = [NSString stringWithFormat:@"0%d",day];
        }
        
        NSString *dayStr = [NSString stringWithFormat:@"%d-%@-%@",year,tempMonth,tempDay];
        _recordTime = [NSString stringWithFormat:@"%d年%@月%@日",year,tempMonth,tempDay];
        [self getAgentfenrunList:dayStr searchType:@"date"];
    }
    else if (_searchType == SearchTypeMonth)
    {
        NSInteger year  = [[NLUtils componentsOfDate:[NSDate date]] year];
        NSInteger month  = [[NLUtils componentsOfDate:[NSDate date]] month];
        NSString *tempMonth = [NSString stringWithFormat:@"%d",month];
        
        if (month < 10)
        {
            tempMonth = [NSString stringWithFormat:@"0%d",month];
        }
        
        NSString *monthStr = [NSString stringWithFormat:@"%d-%@",year,tempMonth];
        _recordTime = [NSString stringWithFormat:@"%d年%@月",year,tempMonth];
        [self getAgentfenrunList:monthStr searchType:@"month"];
    }
    else
    {
        NSInteger year  = [[NLUtils componentsOfDate:[NSDate date]] year];
        NSString *yearStr = [NSString stringWithFormat:@"%d",year];
        _recordTime = [NSString stringWithFormat:@"%d年",year];
        [self getAgentfenrunList:yearStr searchType:@"year"];
    }
//    (CGRect){12,129,296,20}
    /*显示布局*/
    [self setContentUI:nil];
}

-(void)clickSearch
{
    if ([self.delegate respondsToSelector:@selector(clickSearchBt:)])
    {
        [self.delegate clickSearchBt:_searchType];
    }
}

-(void)searchByTime:(NSString *)time
{
    if (_searchType == SearchTypeDay)
    {
        [self getAgentfenrunList:time searchType:@"date"];
        _recordTime = [NSString stringWithFormat:@"%@",time];
    }
    else if (_searchType == SearchTypeMonth)
    {
        [self getAgentfenrunList:time searchType:@"month"];
        _recordTime = [NSString stringWithFormat:@"%@",time];
    }
    else if (_searchType == SearchTypeDay)
    {
        [self getAgentfenrunList:time searchType:@"year"];
        _recordTime = [NSString stringWithFormat:@"%@",time];
    }
}


/*界面布局*/
-(void)setContentUI:(NSMutableArray *)array
{
    for (UIView *subView in _contentScroll.subviews)
    {
        [subView removeFromSuperview];
    }
    
    UIImageView *lineOne = [[UIImageView alloc]initWithFrame:CGRectMake(16, 23, 64, 2)];
    [lineOne setImage:[UIImage imageNamed:@"decorationLine"]];
    [_contentScroll addSubview:lineOne];
    
    UIImageView *lineTwo = [[UIImageView alloc]initWithFrame:CGRectMake(235, 23, 64, 2)];
    [lineTwo setImage:[UIImage imageNamed:@"decorationLine"]];
    [_contentScroll addSubview:lineTwo];
    
    UIImageView *squareOne = [[UIImageView alloc]initWithFrame:CGRectMake(85, 18, 12, 12)];
    [squareOne setImage:[UIImage imageNamed:@"decorationSquare"]];
    [_contentScroll addSubview:squareOne];
    
    UIImageView *squareTwo = [[UIImageView alloc]initWithFrame:CGRectMake(218, 18, 12, 12)];
    [squareTwo setImage:[UIImage imageNamed:@"decorationSquare"]];
    [_contentScroll addSubview:squareTwo];
    
    UILabel *timeFlag = [[UILabel alloc]initWithFrame:CGRectMake(100, 14, 120, 20)];
    timeFlag.font = [UIFont systemFontOfSize:14];
    timeFlag.text = _recordTime;
    timeFlag.textAlignment = UITextAlignmentCenter;
    timeFlag.textColor = RGBACOLOR(144, 145, 147, 1.0);
    timeFlag.backgroundColor = [UIColor clearColor];
    [_contentScroll addSubview:timeFlag];
    
    for (int i = 0; i < array.count; i++)
    {
        UIImageView *dotImg = [[UIImageView alloc]initWithFrame:CGRectMake(18, 47 + 35 * i, 7, 7)];
        [_contentScroll addSubview:dotImg];
        
        NSDictionary *singleDict = array[i];
        UILabel *earnName = [[UILabel alloc]initWithFrame:CGRectMake(30, 40 + 35 * i, 70, 20)];
        earnName.text = singleDict[@"appfunName"];
        earnName.textColor = [UIColor grayColor];
        earnName.backgroundColor = [UIColor clearColor];
        [_contentScroll addSubview:earnName];
        
        UILabel *earn = [[UILabel alloc]initWithFrame:CGRectMake(200, 40 + 35 * i, 70, 20)];
        earn.text = [NSString stringWithFormat:@"¥ %@",singleDict[@"appfunEarn"]];
        earn.textColor = [UIColor grayColor];
        earn.backgroundColor = [UIColor clearColor];
        [_contentScroll addSubview:earn];
        
        if (i == array.count - 1)
        {
            [dotImg setImage:[UIImage imageNamed:@"yellowdot"]];
            earn.textColor = RGBACOLOR(253, 154, 14, 1.0);
            //分割线
            UIImageView *lineA = [[UIImageView alloc]initWithFrame:CGRectMake(17, 32 + 35 * i, 286,2)];
            [lineA setImage:[UIImage imageNamed:@"dashed_line"]];
            [_contentScroll addSubview:lineA];
        }
        else
        {
            [dotImg setImage:[UIImage imageNamed:@"bluedot"]];
        }
    }
}


//超时
- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:(UIViewController*)[[[self nextResponder] nextResponder] nextResponder]feedOrLeft:1];
    
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

#pragma 呔 旧接口 历史收益
-(void)getAgentfenrunList:(NSString *)time searchType:(NSString *)searchType
{
    NSString* name = [NLUtils getNameForRequest:Notify_payagentfenrunlist];
    REGISTER_NOTIFY_OBSERVER(self, payagentfenrunlistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payagentfenrunlist:searchType querywhere:time];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)payagentfenrunlistNotify:(NSNotification *)notify
{
    NLProtocolResponse* response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self doPayagentfenrunlistNotify:response];
        });
        
    }
    else if (error == RSP_TIMEOUT)
    {
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    /*没数据不提示*/
    else
    {
        [_hud hide:YES];
        NSString *detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"服务器繁忙，请稍候再试";
        }
        if (![detail isEqualToString:@"没有数据!"]) {
            [self showErrorInfo:detail status:NLHUDState_Error];
        }
        
    }
}

-(void)doPayagentfenrunlistNotify:(NLProtocolResponse*)response
{
    NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        NLProtocolData* data = [response.data find:@"msgbody/message" index:0];
        NSString* value = data.value;
        [self showErrorInfo:value status:NLHUDState_Error];
    }
    else
    {
        _isFirst = NO;
        
        //总收益
        NLProtocolData* data = [response.data find:@"msgbody/totalfenrun" index:0];
        NSString* totalenrunStr = data.value;
        
        //功能id
        NSArray* appfunid = [response.data find:@"msgbody/msgchild/appfunid"];
        //功能名称
        NSArray* appfunname = [response.data find:@"msgbody/msgchild/appfunname"];
        //功能利润
        NSArray* allfenrun = [response.data find:@"msgbody/msgchild/allfenrun"];
        
        NSString *appfunidStr = nil;
        NSString *appfunnameStr = nil;
        NSString *allfenrunStr  = nil;
        
        NSMutableArray *appfunArr = [NSMutableArray array];
        
        for (int i =0 ; i<appfunid.count; i++)
        {
            NLProtocolData* data = [appfunid objectAtIndex:i];
            appfunidStr = data.value;
            data = [appfunname objectAtIndex:i];
            appfunnameStr = data.value;
            data = [allfenrun objectAtIndex:i];
            allfenrunStr = data.value;
            [appfunArr addObject:@{@"appfunName": appfunnameStr,@"appfunEarn":allfenrunStr}];
        }
        
        [appfunArr addObject:@{@"appfunName": @"总收益",@"appfunEarn":totalenrunStr}];
        
        dispatch_async(dispatch_get_main_queue(), ^void(){
            if (_isCurrent) {
                [self setContentUI:appfunArr];
            }
        });
    }
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
