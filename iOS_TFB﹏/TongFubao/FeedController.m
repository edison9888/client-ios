//
//  FeedController.m
//  TongFubao
//
//  Created by MD313 on 13-8-1.
//  Copyright (c) 2013年 MD313. All rights reserved.
//

#import "FeedController.h"
#import "LeftController.h"
#import "NLSlideBroadsideController.h"
#import "NLContants.h"
#import "NLLogOnViewController.h"
#import "NLProtocolRequest.h"
#import "NLPlistOper.h"
#import "NLAsynImageView.h"
#import "NLUtils.h"
#import "NLPushViewIntoNav.h"
#import "NLToast.h"
#import "NLMoreMenuViewController.h"
#import "NLFormQueryViewController.h"
#import "NLProgressHUD.h"
#import "WalletMainView.h"
#import "PaySKQ.h"
#import "TFAgentMainCtr.h"
#import "TFMainViewCtr.h"
#import "SvUDIDTools.h"
#import "SecretText.h"
#import "NewloginRestive.h"
#import "SVWebViewController.h"
#import "DDExpandableButton.h"
#import "ApplyOrTestViewController.h"
#import "ApplyAgentViewController.h"
#import "Person.h"
#import "planeMain.h"

@interface FeedController ()
{
    NLProgressHUD  * _hud;
    Person         *personTest;
    BOOL         flag;
    int          IOS7HEIGHT;
    int          IOS7IPHONE4;
    int          numCount;
    
    NSString       *appmnuid;
    NSString       *appmnuidBtn[12];
    NSString       *appmnuidfirst[12];
    NSString       *appmnuidsecond[12];
    NSString       *appmnuidthird[9];
    
    NSString       *JumType;
    NSString       *strPhone;
   
    UIImageView    *btImg;
    UIImageView    *rightbg;
   
    UIButton       *singleBt;
    UIButton       *singBtn;
    UIButton       *select;
    UIButton       *rightBtn3;
    UIButton       *rightBtn2;
    UIButton       *rightBtn1;
    
    UIView *firstView;
    UIView *thirdView;
    UIView *secondView;
    UIView *secondMorew;
    UIView *thirdMore;
    
    UIPageControl  *pageControl;
   
    NSArray *resultArray;
    NSArray *resultArrayBianming;
    NSMutableArray *sortedArray;
    
    NSMutableArray *noticeMain;
    NSMutableArray *noticeElment;
    NSMutableArray *noticePoint;
    NSMutableArray *btArray;
    NSMutableArray *btAllArray;
    NSMutableArray *mnuisconstArray;
    NSMutableArray *mnutypeidArray1;
    NSMutableArray *mnutypeidArray2;
    NSMutableArray *typeLiCaiArray;
    NSMutableArray *typeBianMingArray;
    NSMutableArray *rightarray;
}

@property (nonatomic,strong) NSMutableArray *dataid;

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic,strong) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *itemScrollView;
@property (nonatomic,strong) NSMutableArray    *myMenuModuleArray;
@property (nonatomic,strong) NSMutableArray    *myDefaultMenuArray;
@property (nonatomic,strong) NSMutableArray    *MainArray;
@property (nonatomic,strong) NSMutableArray    *PersonArray;
@property (nonatomic,strong) NSMutableArray    *arrMainPoint;
@property (nonatomic,strong) NSMutableArray    *constArray;
@property (nonatomic,strong) NSMutableArray    *mnuisconstArray;

@property (nonatomic,copy)NSArray *mnutypeidArr;/*功能分类id*/
@property (nonatomic,copy)NSArray *mnutypenameArr;/*功能分类名*/
@property (nonatomic,copy)NSArray *mnuisconstArr;/*固定功能图标*/
@property (nonatomic,copy)NSArray *mnuidArr;/*固定id*/
@property (nonatomic,copy)NSArray *pointnumArr;/*使用次数*/
@property (nonatomic,copy)NSArray *mnunoArr;/*编号*/


-(void)setupLeftMenuButton;
-(void)createScrollView:(int)count withType:(NSInteger)type
;
-(void)loadScrollViewWithPage:(int)page;
-(void)leftDrawerButtonPress:(id)sender;
-(void)onAgentClicked:(id)sender;

@end
/*[_MainArray addObject:@{@"mnuname":mnunameStr,@"mnupic":mnupicStr,@"mnuorder":mnuorderStr, @"mnuurl":mnuurlStr,@"mnuversion":mnuversionStr,@"mnuid":mnuidStr,@"mnutypeid":mnutypeidStr, @"mnutypename":mnutypenameStr, @"pointnum":pointnumStr,@"mnuisconst":mnuisconstStr}];
 */


@implementation FeedController
@synthesize phone,password,authorid,mnutypeidArr,mnutypenameArr,mnuisconstArr,mnuidArr,pointnumArr,constArray,mnunoArr,arrMainPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma 点击次数
-(void)touchtap
{
    /*功能id*/
    NSString *agentnoID= [NLUtils getAgentid];//代理商代号
    NSString* name = [NLUtils getNameForRequest:Notify_ApiauthorMenuCount];
    REGISTER_NOTIFY_OBSERVER(self, getApireadMenutapCountNotify, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]getApireadMenutapCount:appmnuid agentno:agentnoID];
}

-(void)getApireadMenutapCountNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dogetApireadMenutapCountNotify:response];
        });
    }
}

-(void)dogetApireadMenutapCountNotify:(NLProtocolResponse*)response
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
}

#pragma 新主页模板菜单
-(void)newAPPMenu
{
    NSString* name = [NLUtils getNameForRequest:Notify_ApireadMenuModule];
    REGISTER_NOTIFY_OBSERVER(self, getappMenuNotify, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]getApireadMenuModule:@"0" appversion:@"1.0.0"];
}
     
-(void)getappMenuNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
    [self dogetappMenuNotify:response];
    }
    NSString *detail = response.detail;
    if (!detail || detail.length <= 0)
    {
        detail = @"读取数据失败，请稍候再试";
    }

}

-(void)dogetappMenuNotify:(NLProtocolResponse*)response
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
        [_PersonArray removeAllObjects];
        [_MainArray removeAllObjects];
        [arrMainPoint removeAllObjects];
        
        _PersonArray = [NSMutableArray arrayWithCapacity:20];
        constArray= [NSMutableArray array];
        mnutypeidArray1= [NSMutableArray array];
        mnutypeidArray2= [NSMutableArray array];
       
        NSArray *mnunameArr = [response.data find:@"msgbody/msgchild/mnuname"];
        NSArray *mnupicArr = [response.data find:@"msgbody/msgchild/mnupic"];
        NSArray *mnuorderArr = [response.data find:@"msgbody/msgchild/mnuorder"];
        NSArray *mnuurlArr = [response.data find:@"msgbody/msgchild/mnuurl"];
        NSArray *mnuversionArr = [response.data find:@"msgbody/msgchild/mnuversion"];
        
        //编号
        mnunoArr = [response.data find:@"msgbody/msgchild/mnuno"];
        //固定功能的ID不能变
        mnuidArr = [response.data find:@"msgbody/msgchild/mnuid"];
        //功能分类id
        mnutypeidArr = [response.data find:@"msgbody/msgchild/mnutypeid"];
        //功能分类名
        mnutypenameArr = [response.data find:@"msgbody/msgchild/mnutypename"];
        //使用次数
        pointnumArr = [response.data find:@"msgbody/msgchild/pointnum"];
        //1：标识首页默认的9个功能图标 0：非首页固定
        mnuisconstArr = [response.data find:@"msgbody/msgchild/mnuisconst"];
        
        NSString *mnunameStr = nil;
        NSString *mnupicStr = nil;
        NSString *mnuorderStr = nil;
        NSString *mnuurlStr = nil;
        NSString *mnuversionStr = nil;
        NSString *mnuidStr = nil;
        NSString *mnutypeidStr = nil;
        NSString *mnutypenameStr = nil;
        NSString *pointnumStr = nil;
        NSString *mnuisconstStr = nil;
        NSString *mnunoStr = nil;
        
        for (int i = 0 ; i<mnuidArr.count; i++)
        {
            
            NLProtocolData* Menudata = [mnunameArr objectAtIndex:i];
            mnunameStr = [self checkInfoMain:Menudata.value];
          
            Menudata = [mnupicArr objectAtIndex:i];
            mnupicStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [mnuorderArr objectAtIndex:i];
            mnuorderStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [mnuurlArr objectAtIndex:i];
            mnuurlStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [mnuversionArr objectAtIndex:i];
            mnuversionStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [mnuidArr objectAtIndex:i];
            mnuidStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [mnutypeidArr objectAtIndex:i];
            mnutypeidStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [mnutypenameArr objectAtIndex:i];
            mnutypenameStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [pointnumArr objectAtIndex:i];
            pointnumStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [mnuisconstArr objectAtIndex:i];
            mnuisconstStr = [self checkInfoMain:Menudata.value];
            
            Menudata = [mnunoArr objectAtIndex:i];
            mnunoStr = [self checkInfoMain:Menudata.value];
            
            if (![mnuorderStr isEqualToString:@"未知"])
            {
                NSLog(@"mnuorderStr %@",mnuorderStr);
                
                /*存储person实例进行筛选*/
                Person *person= [[Person alloc]init];
                [person setMnuno:mnunoStr];
                [person setMnuid:mnuidStr];
                [person setMnuname:mnunameStr];
                [person setPointnum:pointnumStr];
                [person setMnuorder:mnuorderStr];
                [person setMnutypeid:mnutypeidStr];
                [person setMnutypename:mnutypenameStr];
                [person setMnuisconst:mnuisconstStr];
                [_PersonArray addObject:person];
                
                /*用于获取本地数据的存储*/
                [_MainArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:mnunoStr,MAIN_MNUNO,mnuidStr,MAIN_MNUID,mnunameStr,MAIN_MNUANME,pointnumStr,MAIN_POINTNUM,mnuorderStr,MAIN_MNUORDER,mnutypeidStr,MAIN_MNUTYPEID,mnutypenameStr,MAIN_MNUTYPENAME,mnuisconstStr,MAIN_MNUISCONST, nil]];
            }
        }
        
        [self intoTheshabox];
        /*数据处理*/
        [self mainView];
        
    }
}

-(void)mainviewSort{
   
    /*默认主界面没有任何点击次数时候 多于9次时候开始替换*/
    mnuisconstArray= [NSMutableArray arrayWithCapacity:10];
    
    NSPredicate *pre= [NSPredicate predicateWithFormat:@"mnuisconst= '1'"];
    
    for ( int i=0; i<_MainArray.count; i++)
    {
        Person *person= [_MainArray objectAtIndex:i];
        if ([pre evaluateWithObject: person])
        {
            [mnuisconstArray addObject:person];
        }
    }
    
    for (int i=0; i<_MainArray.count; i++)
    {
        NSString *str= [[_MainArray valueForKey:@"pointnum"] objectAtIndex:i];
        
        if ([str intValue]>9)
        {
            [arrMainPoint addObject:_MainArray[i]];
        }
    }
    
    /*对点击数组的进行排序*/
    [sortedArray removeAllObjects];
    sortedArray = [NSMutableArray arrayWithCapacity:9];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pointnum" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *arraPoint = [arrMainPoint sortedArrayUsingDescriptors:sortDescriptors];
    [sortedArray setArray:arraPoint] ;
    
    NSLog(@"sortedArray排列%@ --%d",[sortedArray valueForKey:@"pointnum"],sortedArray.count);
    
    /*存储*/
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *noticemainPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:MAIN_COUNVWTDATA];
    
    if (sortedArray.count>0) {
        
        [sortedArray writeToFile:noticemainPath atomically:YES];
    }
    
    /*求主界面的所不拥有的图标从最后面开始替换*/
    NSMutableSet *set1=[NSMutableSet setWithArray:mnuisconstArray];
    NSMutableSet *set2=[NSMutableSet setWithArray:sortedArray];
    [set2 minusSet:set1];
    
    NSString *element;
    NSMutableArray *pointElement= [NSMutableArray arrayWithCapacity:9];
    for (element in set2) {
        [pointElement addObject:element];
        }
    NSLog(@"pointElement minusSet%@",pointElement);
    
    /*主界面图标*/
    for (int i=0; i<mnuisconstArray.count-pointElement.count; i++)
    {
        /*默认主界面图标*/
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 95+108*(i/3), 80, 80)];
        }else{
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 100+120*(i/3), 80, 80)];
        }
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btAllArray[i][@"bgicon"]]]];
        
        btImg.userInteractionEnabled= YES;
        
        singleBt = [[UIButton alloc]initWithFrame:CGRectMake(6.5,6.8,67,67)];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[mnuisconstArray valueForKey:@"mnuno"][i]]] forState:UIControlStateNormal];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[mnuisconstArray valueForKey:@"mnuno"][i]]] forState:UIControlStateHighlighted];
        [singleBt setTitle:[[mnuisconstArray valueForKey:@"mnuname"]objectAtIndex:i] forState:UIControlStateNormal];
        [singleBt setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -107, 0)];
        singleBt.titleLabel.font= [UIFont systemFontOfSize:13];
        singleBt.titleLabel.textAlignment= LabelAlignmentCenter;
        appmnuidBtn[i] = [mnuisconstArray valueForKey:@"mnuid"][i];
        singleBt.tag= 1+i;
        [singleBt addTarget:self action:@selector(mainTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btImg addSubview:singleBt];
        [firstView addSubview:btImg];
       
    if (flag!=YES)/*避免重复加载界面*/
      {
        for (int i=0; i<pointElement.count; i++)
        {
            /*默认主界面图标*/
            flag= YES;
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*((i+mnuisconstArray.count-pointElement.count)%3), 100+120*((i+mnuisconstArray.count-pointElement.count)/3), 80, 80)];
            [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btAllArray[i][@"bgicon"]]]];
            btImg.userInteractionEnabled= YES;
            singleBt = [[UIButton alloc]initWithFrame:CGRectMake(6.5,6.8,67,67)];
            [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[pointElement valueForKey:@"mnuno"][i]]] forState:UIControlStateNormal];
            [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[pointElement valueForKey:@"mnuno"][i]]] forState:UIControlStateHighlighted];
            [singleBt setTitle:[[pointElement valueForKey:@"mnuname"]objectAtIndex:i] forState:UIControlStateNormal];
            [singleBt setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -107, 0)];
            singleBt.titleLabel.font= [UIFont systemFontOfSize:13];
            singleBt.tag= 301 +i;
            appmnuidthird[i] = [pointElement valueForKey:@"mnuid"][i];
            singleBt.titleLabel.textAlignment= LabelAlignmentCenter;
            [singleBt addTarget:self action:@selector(mainTouchAction:) forControlEvents:UIControlEventTouchUpInside];
            [btImg addSubview:singleBt];
            [firstView addSubview:btImg];
        }
      }
    }
}

/*数据保存*/
-(void)intoTheshabox
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *noticemainPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:MAIN_DATA];
    /*保证不会存到空值进去*/
    if (_MainArray.count>0) {
        
        [_MainArray writeToFile:noticemainPath atomically:YES];
    }
}

-(void)maininList
{
    /*本地的数据获取*/
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *noticemainPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:MAIN_DATA];
    
    noticeMain = [[NSMutableArray alloc] initWithContentsOfFile:noticemainPath];
    
    NSString *noticeElmentPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:MAIN_COUNVWTDATA];
    
    noticeElment = [[NSMutableArray alloc] initWithContentsOfFile:noticeElmentPath];
    
    if (!noticeMain)
    {
        [self newAPPMenu];
        
    }else{
        
        /*所有请求图标*/
        _MainArray= noticeMain;
        /*点击超过9次的图标*/
        sortedArray = noticeElment;
        /*本地读取上次的数据*/
        [self mainView];
        /*存储这次数据下一次加载*/
        [self newAPPMenu];
    }
}


#pragma 筛选主界面
-(void)mainView
{
    /*主界面的点击次数排序筛选*/
    [self mainviewSort];
    /*功能分类页*/
    [self scrollViewInit];
    
}
-(void)viewmain{
    
    //代理商的识别为No
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AgentFlag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIImageView *titleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logos.png"]];
    titleImgView.frame = CGRectMake(120, 3, 66, 38);
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [titleView addSubview:titleImgView];
    self.navigationItem.titleView = titleView;
    
    //按钮添加 /主界面/
    self.itemScrollView.pagingEnabled= YES;
    self.itemScrollView.delegate= self;
    self.itemScrollView.contentSize = CGSizeMake(self.itemScrollView.frame.size.width * 3, self.itemScrollView.frame.size.height);
    [self.view addSubview:self.itemScrollView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgmain.png"]];
    
    //主界面
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height)];
    [_itemScrollView addSubview:firstView];
    
    /*第一个分类功能页面*/
    secondView = [[UIView alloc]init];
    secondView.frame= CGRectMake(320, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height);
    [_itemScrollView addSubview:secondView];
    
    /*第二个分类功能页面*/
    thirdView = [[UIView alloc]init];
    thirdView.frame= CGRectMake(640, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height);
    [_itemScrollView addSubview:thirdView];
    
    numCount= 0;//rightBtn判断点击的次数
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(125, 64, 60, 30)];
    pageControl.numberOfPages = 3;
    pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pageControl];
    
    /*请求主界面模板的数据*/
    [self maininList];
    
}

/*分类数据的功能*/
-(void)viewInOrCount
{
    /*便民类 2 ？ 测试环境 1 是娱乐*/
    /*支付理财 1 ？ 测试环境 3 是理财*/
    
    typeLiCaiArray= [NSMutableArray array];
    typeBianMingArray= [NSMutableArray array];
    
    NSPredicate *preLiCai= [NSPredicate predicateWithFormat:@"mnutypeid='1'"];
    NSPredicate *preBianMing= [NSPredicate predicateWithFormat:@"mnutypeid='2'"];
    
    for ( int i=0; i<_PersonArray.count; i++)
    {
        Person *person= [_PersonArray objectAtIndex:i];
        
        if ([preLiCai evaluateWithObject: person])
        {
            /*测试超过9个的值*/
            [typeLiCaiArray addObject:person];
        }
        else if ([preBianMing evaluateWithObject: person])
        {
            [typeBianMingArray addObject:person];
        }
    }
    
    /*筛选更多功能页条件的*/
    NSComparator finderSort = ^(Person *person1,Person *person2)
    {
        NSString *str1= person1.mnuorder;
        NSString *str2= person2.mnuorder;
        if ([str1 integerValue] > [str2 integerValue])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([str1 integerValue] < [str2 integerValue])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    resultArray = [typeLiCaiArray sortedArrayUsingComparator:finderSort];
    
    NSComparator finderSortBinming = ^(Person *person1,Person *person2)
    {
        NSString *str1= person1.mnuorder;
        NSString *str2= person2.mnuorder;
        if ([str1 integerValue] > [str2 integerValue])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([str1 integerValue] < [str2 integerValue])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    resultArrayBianming = [typeBianMingArray sortedArrayUsingComparator:finderSortBinming];
    
    /*
     18更多功能点控制
     [self morescrollerViewIntypeOn];
     */
}

#pragma 功能分类页面
-(void)scrollViewInit
{
    [self viewInOrCount];
    
    //firstbtn分类功能1
    for (int i=0; i<typeLiCaiArray.count; i++)
    {
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 95+108*(i/3), 80, 80)];
        }else{
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 100+120*(i/3), 80, 80)];
        }
       
        /*功能列表大于9的显示
        else{
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(330+104*(i%3), 100+120*((i-9)/3), 80, 80)];
        }*/
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btAllArray[i][@"bgicon"]]]];
        btImg.userInteractionEnabled= YES;
        singleBt = [[UIButton alloc]initWithFrame:CGRectMake(6.5,6.8,67,67)];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[resultArray valueForKey:@"mnuno"][i]]] forState:UIControlStateNormal];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[resultArray valueForKey:@"mnuno"][i]]] forState:UIControlStateHighlighted];
        singleBt.tag= 101+i;
        appmnuidfirst[i] = [resultArray valueForKey:@"mnuid"][i];
        [singleBt setTitle:[[resultArray valueForKey:@"mnuname"]objectAtIndex:i] forState:UIControlStateNormal];
        [singleBt setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -107, 0)];
        singleBt.titleLabel.font= [UIFont systemFontOfSize:13];
        singleBt.titleLabel.textAlignment= LabelAlignmentCenter;
        [singleBt addTarget:self action:@selector(mainTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btImg addSubview:singleBt];
        [secondView addSubview:btImg];
    }
    
    //secondbtn分类功能2
    for (int i=0; i<typeBianMingArray.count; i++)
    {
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 95+108*(i/3), 80, 80)];
        }else{
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 100+120*(i/3), 80, 80)];
        }
        /*
        else{
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(330+104*(i%3), 100+120*((i-9)/3), 80, 80)];
        }*/
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btAllArray[i][@"bgicon"]]]];
        btImg.userInteractionEnabled= YES;
        singleBt = [[UIButton alloc]initWithFrame:CGRectMake(6.5,6.8,67,67)];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[resultArrayBianming valueForKey:@"mnuno"][i]]] forState:UIControlStateNormal];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[resultArrayBianming valueForKey:@"mnuno"][i]]] forState:UIControlStateHighlighted];
        singleBt.tag= 201+i;
        appmnuidsecond[i] = [resultArrayBianming valueForKey:@"mnuid"][i];
        [singleBt setTitle:[[resultArrayBianming valueForKey:@"mnuname"]objectAtIndex:i] forState:UIControlStateNormal];
        [singleBt setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -107, 0)];
        singleBt.titleLabel.font= [UIFont systemFontOfSize:13];
        singleBt.titleLabel.textAlignment= LabelAlignmentCenter;
        [singleBt addTarget:self action:@selector(mainTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btImg addSubview:singleBt];
        [thirdView addSubview:btImg];
    }
}



#pragma btnInMainAction

/*主界面的事件*/
-(void)mainTouchAction:(UIButton*)sender
{
      /*对应图标的叠加*/
    if (sender.tag>200&&sender.tag<300) {
         appmnuid= appmnuidsecond[sender.tag - 201];
    }else if (sender.tag>100&&sender.tag<200){
         appmnuid= appmnuidfirst[sender.tag - 101];
    }else if (sender.tag>0&&sender.tag<100){
         appmnuid= appmnuidBtn[sender.tag - 1];
    }else if (sender.tag>300){
         appmnuid= appmnuidthird[sender.tag - 301];
    }
    [self touchtap];
  
    if ([sender.titleLabel.text isEqualToString:@"信用卡还款"]) {
        [self onCreditCardPaymentsBtnClicked:sender];
    }
    else if
        ([sender.titleLabel.text isEqualToString:@"Q币充值"]){
            [self onQcoinBtnClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"话费充值"]){
            [self onPhoneBtnClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"内购刷卡器"]){
            [self onOrderPayBtnClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"代理商"]){
            [self onAgentClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"游戏充值"]){
            [self onGameChargeClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"机票预订"]){
            [self planeView:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"火车票预订"]){
//            [self trainView:sender];
            [self onGameChargeClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"酒店预订"]){
            [self hotelview:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"水电煤缴费"]){
            [self onWaterElecClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"转账汇款"]){
            [self onTransferRemittanceBtnClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"商户收款"]){
            [self onMyCouponBtnClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"快递查询"]){
            [self onExpressQueryBtnClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"余额查询"]){
            [self onBalanceQueryBtnClicked:sender];
        }
}

#pragma 密保的检测
-(void)SafeGuardUser
{
    [NLUtils get_req_token];
    NSString *mobile= [NLUtils getRegisterMobile];
    NSString* name = [NLUtils getNameForRequest:Notify_ApiSafeGuardUser];
    REGISTER_NOTIFY_OBSERVER(self, getGuardUser, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiSafeGuardUser:mobile];
}

-(void)getGuardUser:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
    }
    else
    {
        NLProtocolData* data = [response.data find:@"msgbody/result" index:0];
        NSString *result = data.value;
        NSRange range = [result rangeOfString:@"succ"];
        if (range.length <= 0) {
        [_hud hide:YES];
        }
        NSString *detail = response.detail;
        if (!detail || detail.length <= 0)
        {
            detail = @"请求失败，请检查网络";
        }
        //清空数据时
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"PhoneNoFlag"]==nil) {
         [self AlertGuard];
        }else{
            BOOL check= [[NSUserDefaults standardUserDefaults]boolForKey:@"PhoneNoFlag"];
            NSLog(@"phoneNoflag%d",check);
            if (check==YES) {
                [self AlertGuard];
            }
        }
    }
}

#pragma 主界面
-(void)viewDidLoad
{
    [super viewDidLoad];
   
    IOS7HEIGHT=IOS7_OR_LATER==YES?0:64;
    IOS7IPHONE4=IOS7_OR_IPHONE4==YES?0:30;
    /*版本的检测*/
    [self checkAppVersion];
    
    [self modelList];
    [self viewmain];
    /*检测密保问题*/
    [self SafeGuardUser];
    [self setupLeftMenuButton];
   
    //    [self initScrollView];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    REMOVE_NOTIFY_OBSERVER(self);
    
    _MainArray= nil;
    arrMainPoint= nil;
    _PersonArray= nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma moreMenuBtn
-(void)setupLeftMenuButton
{
    UIButton* sidebtn= [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.height!=568) {
        sidebtn.frame= CGRectMake(0, 432, 43.5, 40.5);
    }else{
        sidebtn.frame= CGRectMake(0, 470, 43.5, 40.5);
    }
    [sidebtn setImage:[UIImage imageNamed:@"mainSelf_selected.png"] forState:UIControlStateNormal];
    [sidebtn setImage:[UIImage imageNamed:@"mainSelf.png"] forState:UIControlStateSelected];
    [sidebtn addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sidebtn];
    
    if ([UIScreen mainScreen].bounds.size.height!=568) {
        rightbg = [[UIImageView alloc]initWithFrame:CGRectMake(120, 432, 201, 40.5)];
    }else{
        rightbg = [[UIImageView alloc]initWithFrame:CGRectMake(120, 470, 201, 40.5)];
    }
    [rightbg setImage:[UIImage imageNamed:@"right.png"]];
    rightbg.userInteractionEnabled= YES;
    [self.view addSubview:rightbg];

    rightarray = [NSMutableArray array];
    
    [rightarray addObject:@{@"img": @"licai_normal.png",@"imgSelect": @"licai_selected.png"}];
    
    [rightarray addObject:@{@"img": @"bianmin_normal.png",@"imgSelect": @"bianmin_selected.png"}];
    
     [rightarray addObject:@{@"img": @"favourite_normal.png",@"imgSelect": @"favourite_selected.png"}];
    
    //favourite按钮
    rightBtn1= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rightarray[2][@"img"]]] forState:UIControlStateNormal];
    [rightBtn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rightarray[2][@"imgSelect"]]] forState:UIControlStateSelected];
    rightBtn1.frame= CGRectMake(rightHeight, 8, 26.5, 26.5);
    rightBtn1.selected= YES;
    rightBtn1.tag=101;
    [rightBtn1 addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightbg addSubview:rightBtn1];

    
    rightBtn2= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rightarray[0][@"img"]]] forState:UIControlStateNormal];
    [rightBtn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rightarray[0][@"imgSelect"]]] forState:UIControlStateSelected];
    rightBtn2.frame= CGRectMake(88, 8, 26.5, 26.5);
    rightBtn2.tag=102;
    [rightBtn2 addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightbg addSubview:rightBtn2];
        
    
    rightBtn3= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn3 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rightarray[1][@"img"]]] forState:UIControlStateNormal];
    [rightBtn3 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",rightarray[1][@"imgSelect"]]] forState:UIControlStateSelected];
    rightBtn3.frame= CGRectMake(88+50, 8, 26.5, 26.5);
    rightBtn3.tag=103;
    [rightBtn3 addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightbg addSubview:rightBtn3];

}

#pragma btnisonRightSide
-(void)rightBtn:(UIButton*)sender
{
    numCount ++;
    [self starButtonClicked:sender];
    _itemScrollView.contentOffset = CGPointMake(320*(sender.tag-101), 0);
    
    /* iphone4
    self.view.frame= CGRectMake(0, 0, 320, 480);
    self.view.backgroundColor= [UIColor redColor];
    */
}

-(void)viewisOn:(UIButton*)sender
{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            rightbg.frame= CGRectMake(120, 432, 201, 40.5);
        }else{
            rightbg.frame= CGRectMake(120, 470, 201, 40.5);
        }
        [self.view addSubview:rightbg];
    } completion:^(BOOL finished)
    {
        
    }];
}

-(void)viewisUp:(UIButton*)sender
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            rightbg.frame= CGRectMake(266.5, 432, 201, 40.5);
            
        }else{
            rightbg.frame= CGRectMake(266.5, 470, 201, 40.5);
        }
        [self.view addSubview:rightbg];
    } completion:^(BOOL finished) {
    }];

}

- (void)starButtonClicked:(id)sender
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:)object:sender];
    [self performSelector:@selector(todoSomething:)withObject:sender afterDelay:0.1f];
}


static  CGFloat rightHeight= 14;
static  CGFloat rightwidth= 7;
static  CGFloat righttooHeight= 78;
static  CGFloat widthBtn= 26.5;

-(void)todoSomething:(UIButton*)sender
{
    //粗来
    if (numCount%2==0) {
        
        [self viewisOn:sender];
        
        switch (sender.tag) {
            case 101:
                rightBtn2.selected= NO;
                rightBtn3.selected= NO;
                break;
            case 102:
                rightBtn1.selected= NO;
                rightBtn3.selected= NO;
                break;
            case 103:
                rightBtn1.selected= NO;
                rightBtn2.selected= NO;
                break;
                default:
                break;
        }
        
    }//进去
    else{
        
        [self viewisUp:sender];
        switch (sender.tag) {
                case 101:
                    [self rightSelect1];
                break;
                case 102:
                    [self rightSelect2];
                    break;
                case 103:
                    [self rightSelect3];
               break;
                default:
                    break;
            
        }
    }
}

#pragma 图标改变方法
-(void)rightSelect1{
    
    rightBtn1.selected= YES;
    
    rightBtn1.frame=CGRectMake( rightHeight, rightwidth, widthBtn, widthBtn);
    rightBtn3.frame=CGRectMake( righttooHeight*2-rightHeight, rightwidth, widthBtn, widthBtn);
    rightBtn2.frame=CGRectMake( righttooHeight, rightwidth, widthBtn, widthBtn);

}

-(void)rightSelect2{
    
    rightBtn2.selected= YES;
    rightBtn2.frame=CGRectMake( rightHeight, rightwidth, widthBtn, widthBtn);
    rightBtn3.frame=CGRectMake( righttooHeight*2-rightHeight, rightwidth, widthBtn, widthBtn);
    rightBtn1.frame=CGRectMake( righttooHeight, rightwidth, widthBtn, widthBtn);
}

-(void)rightSelect3{
    
    rightBtn3.selected= YES;
    rightBtn3.frame=CGRectMake( rightHeight, rightwidth, widthBtn, widthBtn);
    rightBtn2.frame=CGRectMake( righttooHeight, rightwidth, widthBtn, widthBtn);
    rightBtn1.frame=CGRectMake( righttooHeight*2-rightHeight, rightwidth, widthBtn, widthBtn);

}


#pragma scroller delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat pageWidth = self.itemScrollView.frame.size.width;
 
    int currentPage = floor((self.itemScrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    
    pageControl.currentPage= currentPage;
    
    if (0 == currentPage)
    {
        rightBtn2.selected= NO;
        rightBtn3.selected= NO;
        [self rightSelect1];
    
    }
    else if (currentPage == 1)
    {
       
        rightBtn1.selected= NO;
        rightBtn3.selected= NO;
        [self rightSelect2];
        
    }
    else if (currentPage == 2)
    {
       
        rightBtn1.selected= NO;
        rightBtn2.selected= NO;
        [self rightSelect3];

    }

}

/*优化有待测试*/
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
    
}


#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender
{
    NLSlideBroadsideController* slider = [[NLSlideBroadsideController alloc] init];
    [slider onDrawerButtonPressed:NLSlideBroadsideCenterControllerMenuLeft viewController:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (IOS_7)
    {
        [[UINavigationBar appearance] setBarTintColor:NAV_COLOR];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundColor:NAV_COLOR];
    }
}

#pragma 数量控制页面
-(void)createScrollView:(int)count withType:(NSInteger)type
{
    
    /*暂时每个功能页面少于18个*/
    int num = 0;
    switch (type) {
        case 1:
            self.itemScrollView.contentSize = CGSizeMake(self.itemScrollView.frame.size.width * 3, self.itemScrollView.frame.size.height);
            num= 3;
            break;
        case 2:
            self.itemScrollView.contentSize = CGSizeMake(self.itemScrollView.frame.size.width * 4, self.itemScrollView.frame.size.height);
            num= 4;
            break;
        case 3:
            self.itemScrollView.contentSize = CGSizeMake(self.itemScrollView.frame.size.width * 5, self.itemScrollView.frame.size.height);
            num= 5;
            break;
        default:
            break;
    }
    pageControl.numberOfPages = num;
    [_itemScrollView addSubview:secondView];
    [_itemScrollView addSubview:thirdView];
    
}


//通付宝刷卡器购买
- (void)IsPayTFBSKtotheMoneyPeople:(id)sender{

     if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_FormPay])

    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_FormPay];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

//我的钱包 新的
- (void)MyWalletMainViewController:(id)sender{

    WalletMainView *wa= [[WalletMainView alloc]initWithNibName:@"WalletMainView" bundle:nil];
    [self.navigationController pushViewController:wa animated:YES];
}

-(BOOL)isForceUpdate
{
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:@"qiangzhi"];
    
    if(result){
    
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"需要更新才可以使用"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles: nil];
    [av show];
            
    }
        
    return result;
    
}

-(BOOL)isUserRegister:(NLPushViewType)type
{
    if ([self isForceUpdate])
    {
        return NO;
    }
    
    BOOL reg = [NLUtils isUserRegister];
    if (!reg)
    {
        Gesture *ges= [[Gesture alloc]init];
        ges.timeOutType = @"timeOut";
        [self presentModalViewController:ges animated:YES];

    }
    return reg;
}

-(BOOL)isEnableTheMenu:(id)sender
{
    return YES;
}

//信用卡还款
- (void)onCreditCardPaymentsBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_CreditCardPayments])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_CreditCardPayments];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//转账汇款
- (void)onTransferRemittanceBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_TransferRemittance])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_TransferRemittance];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//余额查询
- (void)onBalanceQueryBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_BalanceQuery])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_BalanceQuery];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//我的钱包
- (void)onMyWalletBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_MyWallet])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_MyWallet];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//还贷款
- (void)onReturnLoanBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_ReturnLoan])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_ReturnLoan];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//现金抵用券
- (void)onMyCouponBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_CashArriveMain])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_CashArriveMain];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//购买刷卡器
- (void)onOrderPayBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_FormPay])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_FormPay];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//订单号付款
- (void)onOrderQueryBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_FormQuery])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_FormQuery];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//快递查询
- (void)onExpressQueryBtnClicked:(id)sender
{
    if ([self isEnableTheMenu:sender] && [self isUserRegister:NLPushViewType_OrderQuery])
    {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_OrderQuery];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onOtherBtnClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    if ((3+10) == btn.tag)
    {
        NLMoreMenuViewController* vc = [[NLMoreMenuViewController alloc] initWithNibName:@"NLMoreMenuViewController" bundle:nil];
        vc.myArray = [NSArray arrayWithArray:self.myMenuModuleArray];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [[[NLToast alloc] init] show:@"正在开发中,敬请期待..."
                             gravity:NLToastGravityBottom
                            duration:NLToastDurationNormal];
    }
}

//话费充值
- (void)onPhoneBtnClicked:(id)sender {
    
    if ([self isUserRegister:NLPushViewType_PhoneMoney]) {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_PhoneMoney];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//Q币充值
- (void)onQcoinBtnClicked:(id)sender {
    if ([self isUserRegister:NLPushViewType_QCoinCharge]) {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_QCoinCharge];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 代理商点击
-(void)onAgentClicked:(id)sender
{
    if ([NLUtils getAgentid].length <= 0 || [[NLUtils getAgentid] isEqualToString:@"0"])
    {
        ApplyOrTestViewController *applyView = [[ApplyOrTestViewController alloc] init];
        [self.navigationController pushViewController:applyView animated:YES];
        
        return ;
    }
    
    if ([self isUserRegister:NLPushViewType_Agent]) {

        //给默认第一次的NLSlideBroadsideController赋值、、、
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SlideBroadFlag"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_Agent];
        
        UIViewController *newLeftController = [[LeftController alloc] init];
        UIViewController * newrightSideDrawerViewController = nil;
        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        
        NLSlideBroadsideController* root = [[NLSlideBroadsideController alloc] initWithCenterViewController:navigationController
                                                                                   leftDrawerViewController:newLeftController
                                                                                  rightDrawerViewController:newrightSideDrawerViewController
                                                                                                  leftWidth:240
                                                                                                 rightWidth:0];
        NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.feedController = vc;
        
        [UIView
         transitionWithView:delegate.window
         duration:0.5
         options:UIViewAnimationOptionTransitionCrossDissolve
         animations:^(void) {
             BOOL oldState = [UIView areAnimationsEnabled];
             [UIView setAnimationsEnabled:NO];
             delegate.window.rootViewController = (UIViewController*)root;
             [UIView setAnimationsEnabled:oldState];
         }
         completion:nil];
        
    }
}

//水电费
-(void)onWaterElecClicked:(id)sender
{
    if ([self isUserRegister:NLPushViewType_WaterElec]) {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_WaterElec];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

//游戏充值
-(void)onGameChargeClicked:(id)sender
{
    if ([self isUserRegister:NLPushViewType_GameCharge]) {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_GameCharge];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//飞机
-(void)planeView:(id)sender{
 
    if ([self isUserRegister:NLPushViewType_plane]) {
      planeMain *plan= [[planeMain alloc]initWithNibName:@"planeMain" bundle:nil];
     [NLUtils presentModalViewController:self newViewController:plan];
    }
    
    /*
     NSURL *URL = [NSURL URLWithString:@"http://u.ctrip.com/union/CtripRedirect.aspx?TypeID=615&sid=451200&allianceid=20230&ouid="];
     SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
     [self.navigationController pushViewController:webViewController animated:YES];
   */
}

//火车
-(void)trainView:(id)sender{
    
    NSURL *URL = [NSURL URLWithString:@"http://u.ctrip.com/union/CtripRedirect.aspx?TypeID=2&sid=451200&allianceid=20230&OUID=&jumpUrl=http://m.ctrip.com/webapp/train/"];
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

//酒店
-(void)hotelview:(id)sender{
    
    NSURL *URL = [NSURL URLWithString:@"http://u.ctrip.com/union/CtripRedirect.aspx?TypeID=636&sid=451200&allianceid=20230&ouid="];
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

//新版本点击
-(void)onNewVersoinClicked:(id)sender
{
    TFMainViewCtr *mainCtr = [[TFMainViewCtr alloc]init];
    UINavigationController *navMainCtrl = [[UINavigationController alloc] initWithRootViewController:mainCtr];
    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    navMainCtrl.navigationController.navigationBar.translucent = NO;
    [delegate.window setRootViewController:navMainCtrl];
     [self customNavigationBar];
}

//bar定制
-(void)customNavigationBar
{
    if (IOS_7)
    {
        [[UINavigationBar appearance] setBarTintColor:NAV_COLOR];
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        NSShadow *shadow = [[NSShadow alloc] init];
        
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        shadow.shadowOffset = CGSizeMake(0, -0.5);
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                                               shadow, NSShadowAttributeName,
                                                               [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    else
    {
        [UINavigationBar appearance].tintColor = NAV_COLOR;
    }
}

-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            //_hud.labelText = error;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = error;
            [_hud show:YES];
        }
            break;
            
        default:
            break;
    }
    
    return;
}

-(NSString*)getNoNilStr:(NSString*)str
{
    if (str == nil)
    {
        return @"";
    }
    return str;
}

-(NSArray*)sort:(NSArray*)array
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"mnuid" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

//检查版本号
-(void)checkAppVersion
{
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
}

/*密保*/
-(void)AlertGuard
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"立马设置密保" message:@"为了您的账户找回密码及安全，是否前往设定密保问题" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立马设置", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex) {
        SecretText *ser= [[SecretText alloc]initWithNibName:@"SecretText" bundle:nil];
        [NLUtils presentModalViewController:self newViewController:ser];
    }else{
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"PhoneNoFlag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

-(void)modelList
{
    btAllArray   = [NSMutableArray arrayWithCapacity:20];
    _MainArray   = [NSMutableArray arrayWithCapacity:20];
    arrMainPoint = [NSMutableArray arrayWithCapacity:9];
    
    /*Model*/
    [btAllArray addObject:@{@"img": @"tfmg_normal1.png",@"txt":@"转账汇款",@"bgicon":@"mao2.png",@"img_select":@"tfmg_selected.png",@"mnuno":@"tfmg"}];
    [btAllArray addObject:@{@"img": @"mobilerecharge_normal.png",@"txt":@"话费充值",@"bgicon":@"mao6.png",@"img_select":@"mobilerecharge_selected.png",@"mnuno":@"mobilerecharge"}];
    [btAllArray addObject:@{@"img": @"family_normal.png",@"txt":@"水电煤缴费",@"bgicon":@"mao9.png",@"img_select":@"family_selected.png",@"mnuno":@"family"}];
    [btAllArray addObject:@{@"img": @"delivery_normal.png",@"txt":@"快递查询",@"bgicon":@"mao5.png",@"img_select":@"delivery_selected.png",@"mnuno":@"delivery"}];
    [btAllArray addObject:@{@"img": @"airplane_normal.png",@"txt":@"机票预订",@"bgicon":@"mao1.png",@"img_select":@"airplane_selected.png",@"mnuno":@"airplane"}];
    [btAllArray addObject:@{@"img": @"train_normal.png",@"txt":@"火车票预订",@"bgicon":@"mao3.png",@"img_select":@"train_selected.png",@"mnuno":@"train"}];
    [btAllArray addObject:@{@"img": @"hotel_normal.png",@"txt":@"酒店预订",@"bgicon":@"mao6.png",@"img_select":@"hotel_selected.png",@"mnuno":@"hotel"}];
    [btAllArray addObject:@{@"img": @"game_normal.png",@"txt":@"游戏充值",@"bgicon":@"mao5.png",@"img_select":@"game_selected.png",@"mnuno":@"game"}];
    [btAllArray addObject:@{@"img": @"qqrecharge_normal.png",@"txt":@"Q币充值",@"bgicon":@"mao7.png",@"img_select":@"qqrecharge_selected.png",@"mnuno":@"qqrecharge"}];
    [btAllArray addObject:@{@"img": @"creditcard_normal.png",@"txt":@"信用卡还款",@"bgicon":@"mao1.png",@"img_select":@"creditcard_selected.png",@"mnuno":@"creditcard"}];
    [btAllArray addObject:@{@"img": @"balance_normal.png",@"txt":@"余额查询",@"bgicon":@"mao4.png",@"img_select":@"balance_selected.png",@"mnuno":@"balance"}];
    [btAllArray addObject:@{@"img": @"coupon_normal.png",@"txt":@"商户收款" ,@"bgicon":@"mao3.png",@"img_select":@"coupon_selected.png",@"mnuno":@"coupon"}];
    [btAllArray addObject:@{@"img": @"orderbuy_normal.png",@"txt":@"内购刷卡器",@"bgicon":@"mao8.png",@"img_select":@"orderbuy_selected.png",@"mnuno":@"orderbuy"}];
    [btAllArray addObject:@{@"img": @"agentbuy_normal.png",@"txt":@"代理商",@"bgicon":@"mao2.png",@"img_select":@"agentbuy_selected.png",@"mnuno":@"agentbuy"}];
}

-(NSString *)checkInfoMain:(NSString *)str
{
    if (str == nil)
    {
        return @"未知";
    }
    else
    {
        return str;
    }
}

#pragma 代码优化 下面的与上面没关联的
/*后期写个按钮的*/
-(void)vieMain{
    
    DDExpandableButton *colorButton = [[DDExpandableButton alloc] initWithPoint:CGPointMake(20.0f, 65.0f)
                                                                      leftTitle:@"测试一号"
                                                                        buttons:[NSArray arrayWithObjects:@"黑色", @"红色", @"绿色", @"蓝色", nil]];
	[[self view] addSubview:colorButton];
	[colorButton addTarget:self action:@selector(toggleColor:) forControlEvents:UIControlEventValueChanged];
    
	[[colorButton.labels objectAtIndex:0] setHighlightedTextColor:[UIColor blackColor]];
	[[colorButton.labels objectAtIndex:1] setHighlightedTextColor:[UIColor redColor]];
	[[colorButton.labels objectAtIndex:2] setHighlightedTextColor:[UIColor greenColor]];
	[[colorButton.labels objectAtIndex:3] setHighlightedTextColor:[UIColor blueColor]];
    
}

- (void)toggleColor:(DDExpandableButton *)sender
{
	switch ([sender selectedItem])
	{
		default:
			[[[self.view viewWithTag:10] layer] setBorderColor:[UIColor blackColor].CGColor];
			break;
		case 1:
			[[[self.view viewWithTag:10] layer] setBorderColor:[UIColor redColor].CGColor];
			break;
		case 2:
			[[[self.view viewWithTag:10] layer] setBorderColor:[UIColor greenColor].CGColor];
			break;
		case 3:
			[[[self.view viewWithTag:10] layer] setBorderColor:[UIColor blueColor].CGColor];
			break;
	}
}

/*person实例存储*/
-(void)mainmodeltolist
{
    
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSData *data = [[NSMutableData alloc]initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        personTest = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        NSString *str;
        str= personTest.mnuname;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAppDataWhenApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    
}

-(void) saveAppDataWhenApplicationWillResignActive:(NSNotification*) notification
{
    NSString *str;
    personTest.mnuname= str;
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:personTest forKey:kDataKey];
    [archiver finishEncoding];
    NSLog(@"mainvewperson %@",str);
    [data writeToFile:[self dataFilePath] atomically:YES];
}

-(void)morescrollerViewIntypeOn
{
    /* 后台改变或新增接口功能 可以控制18个分类图标功能及scrollerview显示*/
    if (typeLiCaiArray.count > 9)
    {
        secondMorew = [[UIView alloc]initWithFrame:CGRectMake(640, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height)];
        [_itemScrollView addSubview:secondMorew];
        
        thirdView.frame= CGRectMake(960, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height);
        [self createScrollView:0 withType:2];
    }
    
    int count = typeBianMingArray.count;
    
    if (count > 9 && typeLiCaiArray.count < 9 )
    {
        [self createScrollView:count withType:2];
    }
    else if (typeLiCaiArray.count > 9 && count < 9)
    {
        [self createScrollView:count withType:2];
    }
    else if (typeLiCaiArray.count > 9 && count > 9)
    {
        thirdMore = [[UIView alloc]initWithFrame:CGRectMake(320*4, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height)];
        [_itemScrollView addSubview:thirdMore];
        [self createScrollView:count withType:3];
    }
    else if (typeLiCaiArray.count < 9 && count < 9)
    {
        [self createScrollView:count withType:1];
    }
    
}

+ (void) changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo
{
   
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
  	[dicArray sortUsingDescriptors:descriptors];
    NSLog(@"2222%@",descriptors);
}

@end
