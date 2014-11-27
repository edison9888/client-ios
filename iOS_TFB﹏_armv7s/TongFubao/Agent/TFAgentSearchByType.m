//
//  TFAgentSearchByDay.m
//  TongFubao
//
//  Created by 〝Cow﹏. on 14-6-16.
//  Copyright (c) 2014年 〝Cow﹏. All rights reserved.
//

#import "TFAgentSearchByType.h"
#import "MainViewController.h"

/*新的展示形式*/
#import "RADataObject.h"
#import "RATreeView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TFAgentSearchByType ()<RATreeViewDelegate, RATreeViewDataSource>

{
    NLProgressHUD  * _hud;
    NSMutableArray *appfunArr;
    NSString       *querTypeStr;
    NSString       *querwhereStr;
    UIView         *viewList;
    UIButton       *searchBt;
}

@property (nonatomic,assign) TFAgentSearchType searchType;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,strong) UIScrollView *contentScroll;
@property (nonatomic,strong) MainViewController*mainView;

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) RATreeView *treeView;
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
    
    searchBt = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    int currentCorrley= 50;
    
    _contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, currentCorrley, 320, scrollH -50 )];
    _contentScroll.backgroundColor= SACOLOR(245,1.0);
    [self.view addSubview:_contentScroll];
   
    appfunArr = [NSMutableArray array];
    /*没写查询收益功能 我擦 还要我重做*/
    
    /*界面收益功能显示*/
    _mainView= [[MainViewController alloc]init];
    _mainView.view.frame=  CGRectMake(0, currentCorrley + 50 , 320, _contentScroll.frame.size.height-currentCorrley );
    _mainView.view.backgroundColor= SACOLOR(245, 1.0);
//    [self.view addSubview:_mainView.view];
}

/*url 功能重新写*/
/*查询类型 Data/month/year 查询值 2014/2014-06/2014-06-18*/
/*收益类 详细或者大类*/
-(void)AgentfenrunListURL:(NSString *)time searchType:(NSString *)searchType
{
    
    NSDictionary *dataDictionary = @{ @"querytype" : searchType,   @"querywhere" : time , };
    
    [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiAgentInfo" apiNameFunc:@"payagentfenrunlist" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(NSMutableDictionary *data, NSError *error) {
        NSLog(@"data %@",data);
   
        if (![data[@"result"] isEqualToString:@"success"])
        {
            [self setContentUI:nil];

     
        }else
        {

            [TFData setdic:data];

            [LoadDataWithASI loadDataWithMsgbody:dataDictionary apiName:@"ApiAgentInfo" apiNameFunc:@"payagentfenrunlist" rolePath:@"//operation_response/msgbody/msgchild" type:PublicList completionBlock:^(id data, NSError *error) {
                NSLog(@"msgchilddata %@",data);
            
                [self setContentUI:[TFData setarr:data]];
             }];
     
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
    if (_searchType == SearchTypeYear)
    {
        NSInteger year  = [[NLUtils componentsOfDate:[NSDate date]] year];
        NSString *yearStr = [NSString stringWithFormat:@"%d",year];
        _recordTime = [NSString stringWithFormat:@"%d年",year];
        /*就接口*/
        [self getAgentfenrunList:yearStr searchType:@"year"];
//            [self AgentfenrunListURL:yearStr searchType:@"year"];
        
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
//       [self AgentfenrunListURL:monthStr searchType:@"month"];
    }
    else if (_searchType == SearchTypeDay)
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
//          [self AgentfenrunListURL:dayStr searchType:@"date"];

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

#pragma 日历日期选择
-(void)searchByTime:(NSString *)time andTime:(NSString*)aTime
{
    if (_searchType == SearchTypeDay)
    {
        [self getAgentfenrunList:time searchType:@"date"];
//       [self AgentfenrunListURL:time searchType:@"date"];
        _recordTime = [NSString stringWithFormat:@"%@",aTime];
    }
    else if (_searchType == SearchTypeMonth)
    {
        [self getAgentfenrunList:time searchType:@"month"];
//      [self AgentfenrunListURL:time searchType:@"month"];
        _recordTime = [NSString stringWithFormat:@"%@",aTime];
    }
    else if (_searchType == SearchTypeDay)
    {
        [self getAgentfenrunList:time searchType:@"year"];
//        [self AgentfenrunListURL:time searchType:@"year"];
        _recordTime = [NSString stringWithFormat:@"%@",aTime];
    }

    /*日历选择后的布局*/
    [self setContentUI:nil];
  
}


/*界面布局*/
-(void)setContentUI:(NSMutableArray *)array
{

    for (UIView *subView in _contentScroll.subviews)
    {
        [subView removeFromSuperview];
    }
     /*table头实现*/
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
    
    UILabel *timeFlag = [[UILabel alloc]initWithFrame:CGRectMake( 100, 14, 120, 20)];
    timeFlag.font = [UIFont systemFontOfSize:15];
    timeFlag.text = _recordTime;
    timeFlag.textAlignment = UITextAlignmentCenter;
    timeFlag.textColor = RGBACOLOR(144, 145, 147, 1.0);
    timeFlag.backgroundColor = [UIColor clearColor];
    [_contentScroll addSubview:timeFlag];
 
    /*分割线*/
    UIImageView *lineA = [[UIImageView alloc]initWithFrame:CGRectMake(17, 45, 286,2)];
    [lineA setImage:[UIImage imageNamed:@"dashed_line"]];
    [_contentScroll addSubview:lineA];
    
    /*收益cell布局 替换*/
    [self fenrunListCell:array];
    
    /*没选择点击详细收益的显示*/
//    [_mainView reloadtable];
}

-(void)fenrunListCell:(NSMutableArray *)array
{
    /*新展示界面*/
//    [self REATressView:array];
    
    viewList= [[UIView alloc]initWithFrame:(CGRect){0,55,320,120}];
    
    viewList.backgroundColor= [UIColor clearColor];
    [_contentScroll addSubview:viewList];
 
    viewList.hidden= YES;
    for (int i = 0; i < array.count; i++)
    {
        UIImageView *dotImg = [[UIImageView alloc]initWithFrame:CGRectMake(18, 7 + 35 * i, 7, 7)];
        
        NSDictionary *singleDict = array[i];
        UILabel *earnName = [[UILabel alloc]initWithFrame:CGRectMake(30, 0 + 35 * i, 120, 20)];
        earnName.text = singleDict[@"appfunName"];
        earnName.textColor = [UIColor grayColor];
        earnName.backgroundColor = [UIColor clearColor];
      
        UILabel *earn = [[UILabel alloc]initWithFrame:CGRectMake(200, 0 + 35 * i, 120, 20)];
        earn.text = [NSString stringWithFormat:@"¥ %@",singleDict[@"appfunEarn"]];
        earn.textColor = [UIColor grayColor];
        earn.backgroundColor = [UIColor clearColor];
       
        
        if (i == array.count - 1)
        {
            [dotImg setImage:[UIImage imageNamed:@"yellowdot"]];
            earn.textColor = RGBACOLOR(253, 154, 14, 1.0);
          
        }
        else
        {
            [dotImg setImage:[UIImage imageNamed:@"bluedot"]];
        }
    
        [viewList addSubview:earnName];
        [viewList addSubview:dotImg];
        [viewList addSubview:earn];
    
    }
    viewList.hidden= NO;
    if ( array==nil) {

        viewList.hidden= YES;
        UIImageView *dotImg = [[UIImageView alloc]initWithFrame:CGRectMake(18, 7 , 7, 7)];
        [dotImg setImage:[UIImage imageNamed:@"yellowdot"]];
        [viewList addSubview:dotImg];
        
        UILabel *earnName = [[UILabel alloc]initWithFrame:CGRectMake(30, 0 , 120, 20)];
        earnName.text = @"总收益";
        earnName.textColor = [UIColor grayColor];
        earnName.backgroundColor = [UIColor clearColor];
        [viewList addSubview:earnName];
        
        UILabel *earn = [[UILabel alloc]initWithFrame:CGRectMake(200, 0 , 120, 20)];
        earn.text = @"￥0.00";
        earn.textColor = [UIColor grayColor];
        earn.backgroundColor = [UIColor clearColor];
        earn.textColor = RGBACOLOR(253, 154, 14, 1.0);
    
        [viewList addSubview:earn];
        viewList.hidden= NO;
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

#pragma 呔 旧接口写法 历史收益
-(void)getAgentfenrunList:(NSString *)time searchType:(NSString *)searchType
{
    querTypeStr = searchType;
    querwhereStr = time;
    NSString* name = [NLUtils getNameForRequest:Notify_payagentfenrunlist];
    REGISTER_NOTIFY_OBSERVER(self, payagentfenrunlistNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] payagentfenrunlist:searchType querywhere:time];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
}

-(void)payagentfenrunlistNotify:(NSNotification *)notify
{
    NLProtocolResponse* response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    [appfunArr removeAllObjects];
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doPayagentfenrunlistNotify:response];
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
        
        [appfunArr addObject:@{@"appfunName": @"总收益",@"appfunEarn":@"0.00",@"allfunEarn":@"0.00",@"Cell": @"agentEarningsCell",@"isAttached":@(NO)}];
        [TFData setarr:appfunArr];
        
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
  
        for (int i =0 ; i<appfunid.count; i++)
        {
            NLProtocolData* data = [appfunid objectAtIndex:i];
            appfunidStr = data.value;
            data = [appfunname objectAtIndex:i];
            appfunnameStr = data.value;
            data = [allfenrun objectAtIndex:i];
            allfenrunStr = data.value;
            
            [appfunArr addObject:@{@"querwhere":querwhereStr , @"querType":querTypeStr , @"appfunid" : appfunidStr,@"appfunName": appfunnameStr,@"appfunEarn":allfenrunStr,@"Cell": @"agentEarningsCell",@"isAttached":@(NO)}];
        }
         [appfunArr addObject:@{@"appfunName": @"总收益",@"appfunEarn":totalenrunStr,@"Cell": @"agentEarningsCell",@"isAttached":@(NO)}];
        
        [TFData setarr:appfunArr];
        [self setContentUI:appfunArr];
   
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*另外一种展现形式*/
-(void)REATressView:(NSMutableArray *)array
{
    
    RADataObject *phone1 = [RADataObject dataObjectWithName:@"刷卡器收益" children:nil];
    RADataObject *phone2 = [RADataObject dataObjectWithName:@"转账收益" children:nil];
    RADataObject *phone3 = [RADataObject dataObjectWithName:@"QQ收益" children:nil];
    RADataObject *phone4 = [RADataObject dataObjectWithName:@"话费收益" children:nil];
    
    RADataObject *phone = [RADataObject dataObjectWithName:@"硬件收益"
                                                  children:[NSArray arrayWithObjects:phone1, phone2, phone3, phone4, nil]];
    
    
    /*三级节点*/
    RADataObject *notebook1 = [RADataObject dataObjectWithName:@"英雄联盟" children:nil];
    RADataObject *notebook2 = [RADataObject dataObjectWithName:@"CF" children:nil];
    self.expanded = notebook1;
    
    RADataObject *computer1 = [RADataObject dataObjectWithName:@"游戏"
                                                      children:[NSArray arrayWithObjects:notebook1, notebook2, nil]];
    RADataObject *computer2 = [RADataObject dataObjectWithName:@"话费" children:nil];
    RADataObject *computer3 = [RADataObject dataObjectWithName:@"QQ" children:nil];
    
    RADataObject *computer = [RADataObject dataObjectWithName:@"充值"
                                                     children:[NSArray arrayWithObjects:computer1, computer2, computer3, nil]];
    RADataObject *car = [RADataObject dataObjectWithName:@"总收益" children:nil];
    
    self.data = [NSArray arrayWithObjects:phone, computer, car, nil];

    RATreeView *treeView = [RATreeView singleton:CGRectMake(0, 75, 320, self.view.frame.size.height-40)];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [treeView reloadData];
    [treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    self.treeView = treeView;
    [self.view addSubview:treeView];
    
    /*头信息*/
    for (UIView *subView in treeView.subviews)
    {
        [subView removeFromSuperview];
    }
    /*table头实现*/
    UIImageView *lineOne = [[UIImageView alloc]initWithFrame:CGRectMake(16, 48, 64, 2)];
    [lineOne setImage:[UIImage imageNamed:@"decorationLine"]];
    [treeView addSubview:lineOne];
    
    UIImageView *lineTwo = [[UIImageView alloc]initWithFrame:CGRectMake(235, 48, 64, 2)];
    [lineTwo setImage:[UIImage imageNamed:@"decorationLine"]];
    [treeView addSubview:lineTwo];
    
    UIImageView *squareOne = [[UIImageView alloc]initWithFrame:CGRectMake(85, 43, 12, 12)];
    [squareOne setImage:[UIImage imageNamed:@"decorationSquare"]];
    [treeView addSubview:squareOne];
    
    UIImageView *squareTwo = [[UIImageView alloc]initWithFrame:CGRectMake(218, 43, 12, 12)];
    [squareTwo setImage:[UIImage imageNamed:@"decorationSquare"]];
    [treeView addSubview:squareTwo];
    
    UILabel *timeFlag = [[UILabel alloc]initWithFrame:CGRectMake( 100, 39, 120, 20)];
    timeFlag.font = [UIFont systemFontOfSize:15];
    timeFlag.text = _recordTime;
    timeFlag.textAlignment = UITextAlignmentCenter;
    timeFlag.textColor = RGBACOLOR(144, 145, 147, 1.0);
    timeFlag.backgroundColor = [UIColor clearColor];
    [treeView addSubview:timeFlag];
    
    /*分割线*/
    UIImageView *lineA = [[UIImageView alloc]initWithFrame:CGRectMake(17, 70, 286,2)];
    [lineA setImage:[UIImage imageNamed:@"dashed_line"]];
    [treeView addSubview:lineA];
    
    /*searchbar*/
    [treeView addSubview:_searchField];
    [treeView addSubview:searchBt];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
    }
    self.treeView.frame = self.view.bounds;
}


#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expanded]) {
        return YES;
    }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSInteger numberOfChildren = [treeNodeInfo.children count];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %d", numberOfChildren];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
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
