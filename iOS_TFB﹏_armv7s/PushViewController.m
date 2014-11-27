//
//  PushViewController.m
//  TongFubao
//
//  Created by  俊   on 14-7-25.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "PushViewController.h"
#import "ApplyOrTestViewController.h"
#import "AgentInfoViewController.h"
#import "NewLoginCow.h"
#import "AirTicketViewController.h"
#import "ReserveHotelController.h"
#import "payoffView.h"
#import "ExpressageMain.h"
#import "SingPayMoney.h"
#import "TransferAccountsController.h"
#import "MyBankCardViewController.h"
#import "SavingsCardViewController.h"
#import "ImpowerController.h"

#import "SMSreceiptViewController.h"
#import "TFNewVersionAgentMainCtr.h"//待删

/*區分點擊通道的mnuno*/
static  NSString       *MNUNOISONE[9];

@class FirstViewController,SecondViewController,ThirdViewController,MoreViewController;

@interface PushViewController () <UIAlertViewDelegate,UITextFieldDelegate>
{
    TabAllView     *Tabview;
    NLProgressHUD  * _hud;
    
    BOOL           flagReturn;
    BOOL           Tend;
    BOOL           flagLint;
    BOOL           flagArr;
    UIButton       *singleBt;
    
    UIImage        * _downImage;
    
    UIImageView    *btImg;
    UIImageView    *imagVc;
    UIScrollView   *sv;
    UIPageControl  *page;
    
    /*对应的mnum判断点击事件*/
    NSString       *appmnuid;
    NSString       *appmnuidBtn[12];
    NSString       *appmnuidfirst[12];
    NSString       *appmnuidsecond[12];
    NSString       *appmnuidthird[9];
    
    /*appnmun*/
    NSString       *appmnuno;
    NSString       *appmnunoBtn[12];
    NSString       *appmnunofirst[12];
    NSString       *appmnunosecond[12];
    NSString       *appmnunothird[9];
    
    int TimeNum;
    int navheight;
    double IOS7IPHONE4;

    ImageData *imageData;
    
    NSArray *Arr;
    NSArray *resultArray;
    NSArray *resultArrayBianming;
    
    NSMutableArray *indexArr;
    NSMutableArray *btMoreArr;
    NSMutableArray *btAllArray;
    NSMutableArray *noticeMain;
    NSMutableArray *noticeElment;
    NSMutableArray *sortedArray;
    NSMutableArray *mnuisconstArray;
    NSMutableArray *typeLiCaiArray;
    NSMutableArray *typeBianMingArray;
    
    //TextFieldOfAlertView
    UITextField *alertText;
    NSString *alertTextString;
    NSTimer *myTimer;
    
    UIView *viewphone;
}

@property (weak, nonatomic) IBOutlet UILabel *nalogobg;
@property (weak, nonatomic) IBOutlet UILabel *naline;
@property (weak, nonatomic) IBOutlet UIImageView *naname;
@property (weak, nonatomic) IBOutlet UIButton *nabtn;
@property (weak, nonatomic) IBOutlet UILabel *lable;

@property (nonatomic,strong) NSMutableArray    *PersonArray;
@property (nonatomic,strong) NSMutableArray    *MainArray;
@property (nonatomic,strong) NSMutableArray    *arrMainPoint;

@property (nonatomic,copy)NSArray *mnutypeidArr;/*功能分类id*/
@property (nonatomic,copy)NSArray *mnutypenameArr;/*功能分类名*/
@property (nonatomic,copy)NSArray *mnuisconstArr;/*固定功能图标*/
@property (nonatomic,copy)NSArray *mnuidArr;/*固定id*/
@property (nonatomic,copy)NSArray *pointnumArr;/*使用次数*/
@property (nonatomic,copy)NSArray *mnunoArr;/*编号*/

@end

@implementation PushViewController

@synthesize mnutypeidArr,mnutypenameArr,mnuisconstArr,mnuidArr,pointnumArr,mnunoArr,arrMainPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 下载图片 暂时不用这个方法了
void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    NSLog(@"URL = %@",URL);
    
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           
                           if(image != nil)
                           {
                               imageBlock(image);
                           }
                           else
                           {
                               errorBlock();
                           }
                       });
                   });
}

/*数据请求*/
#pragma 新主页模板菜单
-(void)newAPPMenu
{
    [NLUtils get_au_token];
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSString* name = [NLUtils getNameForRequest:Notify_ApireadMenuModule];
    REGISTER_NOTIFY_OBSERVER(self, getappMenuNotify, name);
    [[[NLProtocolRequest alloc]initWithRegister:YES]getApireadMenuModule:@"0" appversion:@""];
}

-(void)getappMenuNotify:(NSNotification*)notify
{

    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self dogetappMenuNotify:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [_hud hide:YES];
        [self showErrorInfo:@"请求超时,需要重新登录" status:NLHUDState_Error];
        [self performSelector:@selector(doPush) withObject:nil afterDelay:2.0f];
        return;
    }
    [_hud hide:YES];
    NSString *detail = response.detail;
    if (!detail || detail.length <= 0)
    {
        
        detail = @"读取数据失败，请稍候再试";
    }
}

-(void)dogetappMenuNotify:(NLProtocolResponse *)response
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
        
        for (int i = 0; i < mnuidArr.count; i++)
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
        /*主界面的点击次数排序筛选*/
        if (flagReturn!=YES) {
            [self ViewMain];
        }
        /*数据筛选*/
        [self viewInOrCount];
        /*新的通知信息*/
        [self readNewMessage];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [IQKeyboardManager disableKeyboardManager];
   
    /*版本检测*/
    [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:0.1f];
    /*代理商编号*/
    [self initAgentView];
     /*请求主界面模板的数据*/
    AnimateTabbarView *tab= [[AnimateTabbarView singleton]initWithFrame:self.view.frame];
    tab.delegate=self;
    [self.view addSubview:tab];
    [self navsethiden:YES];
    [self mainviewisOn];
}

#pragma mark - 绑定代理商
- (void)initAgentView
{
    int i = [[NLUtils getRelateAgent] intValue];
 
    if(i != 1)
    {
        [self loadDataWithAgentNo:@"020001"];
        
//        NSString *message = @"请您输入6位数的服务代号";
//        NSString *cancelName = @"确  认";
//        
//        UIAlertView *agentAlertView = [[UIAlertView alloc] initWithTitle:@"提   示" message:message delegate:self cancelButtonTitle:cancelName otherButtonTitles:@"使用默认", nil];
//        agentAlertView.tag = 3702;
//        agentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [agentAlertView show];
//        
//        alertTextString = @"020001";
//        
//        alertText = [agentAlertView textFieldAtIndex:0];
//        alertText.keyboardType = UIKeyboardTypeNumberPad;
//        alertText.text = alertTextString;
//        alertText.delegate = self;
//        [alertText resignFirstResponder];
    }
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3701)
    {
        //绑定代理商
        [self initAgentView];
    }
    else if (alertView.tag == 3702)
    {
        [self loadDataWithAgentNo:alertText.text];
    }
    else if (alertView.tag == 3838 )
    {
        if (1==buttonIndex) {
            
            id thisClass = [[NSClassFromString(@"SecretText") alloc] initWithNibName:@"SecretText" bundle:nil];
            [NLUtils presentModalViewController:self newViewController:thisClass];
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"PhoneNoFlag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    alertText.text = @"";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue = YES;
    
    if([[textField text] length] - range.length + string.length > 6)
    {
        retValue = NO;
    }
    
    return retValue;
}

#pragma mark - 绑定代理商请求
- (void)loadDataWithAgentNo:(NSString *)agentNo
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAgentInfoBind];
    REGISTER_NOTIFY_OBSERVER(self, checkDataWithNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAgentInfoBind:agentNo];
}

- (void)checkDataWithNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    if (error == RSP_NO_ERROR)
    {
        [self getAuthorBindAgentWithResponse:response];
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"string = %@",string);
    }
}

- (void)getAuthorBindAgentWithResponse:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@", errorData);
    }
/*
    else
    {
        [self showErrorInfo:@"激活成功" status:NLHUDState_NoError];
        
        [NLUtils setRelateAgent:@"1"];
    }
 */
}

#pragma mark - 读取新的信息
- (void)readNewMessage
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"newMessage"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"newMessage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self loadDataForNewMessage];
    }
}

#pragma mark - 读取新的信息请求
- (void)loadDataForNewMessage
{
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAppInfo];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForNewMessage, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAppInfo];
}

- (void)checkDataForNewMessage:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getApiAppInfoWithResponse:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"string = %@",string);
    }
}

- (void)getApiAppInfoWithResponse:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@", errorData);
    }
    else
    {
        NLProtocolData *noticecontent = [response.data find:@"msgbody/msgchild/noticecontent" index:0];
        NLProtocolData *noticetitle = [response.data find:@"msgbody/msgchild/noticetitle" index:0];
        
        if (noticetitle.value)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:noticetitle.value message:noticecontent.value delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 3701;
            [alertView show];
        }
    }
}

-(void)mainviewisOn
{
    /*广告*/
    flagLint = NO;
    arrMainPoint = [NSMutableArray arrayWithCapacity:9];
    _PersonArray = [NSMutableArray arrayWithCapacity:20];
    _MainArray   = [NSMutableArray arrayWithCapacity:20];
    
    navheight= _naline.frame.origin.y+_naline.frame.size.height;
    /*当前为5尺寸 4偏大故缩小*/
    IOS7IPHONE4=IOS7_OR_SCREEN==YES?0.8:1;
    
    btMoreArr = [NSMutableArray arrayWithCapacity:8];
    [btMoreArr addObject:@{@"txt":@"账户管理",@"bgicon":@"btnmore_1.png"}];
    [btMoreArr addObject:@{@"txt":@"服务信息",@"bgicon":@"btnmore_2.png"}];
    [btMoreArr addObject:@{@"txt":@"代理商",@"bgicon":@"btnmore_3.png"}];
    [btMoreArr addObject:@{@"txt":@"帮助中心",@"bgicon":@"btnmore_4.png"}];
    [btMoreArr addObject:@{@"txt":@"意见反馈",@"bgicon":@"btnmore_5.png"}];
    [btMoreArr addObject:@{@"txt":@"关于我们",@"bgicon":@"btnmore_6.png"}];
    [btMoreArr addObject:@{@"txt":@"检查更新",@"bgicon":@"btnmore_7.png"}];
//    [btMoreArr addObject:@{@"txt":@"新接口demo",@"bgicon":@"btnmore_8.png"}];
//    [btMoreArr addObject:@{@"txt":@"推荐应用",@"bgicon":@"sugust.png"}];

    [self newAPPMenu];
 
}

/*实现对应的界面*/
-(void)TabBarBtnClick:(UIButton*)sender
{
    [myTimer invalidate];
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1001:
        {
            [Tabview removeFromSuperview];
            [self navsethiden:YES];
            [self ViewMain];
        }
            break;
        case 1002:
        {
            [Tabview removeFromSuperview];
            [self navsethiden:NO];
            [self ViewBank];
        }
            break;
        case 1003:
        {
            [Tabview removeFromSuperview];
            [self navsethiden:NO];
            [self Viewbianmin];
        }
            break;
        case 1004:
        {
            [Tabview removeFromSuperview];
            [self navsethiden:NO];
            [self viewMore];
            
        }
            break;
    }
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
}


#pragma mark - 主页
/*主页的页面*/
-(void)ViewMain
{
//    [self performSelector:@selector(SafeGuardUser) withObject:nil afterDelay:5.1f];
    Tabview = [TabAllView instanceTextView:0];
    Tabview.frame = CGRectMake(0, 0, 320, SelfHeight-72);
    [self.view addSubview:Tabview];
    
    /*广告的scroller*/
    CGRect svFrame;
    
    if (IOS7_OR_LATER)
    {
        svFrame = CGRectMake(0, 20, 320, 118*IOS7IPHONE4);
    }
    else
    {
        svFrame = CGRectMake(0, 0, 320, 138*IOS7IPHONE4);
    }
    
    imagVc= [[UIImageView alloc]initWithFrame:svFrame];
    imagVc.image= [UIImage imageNamed:@"tfbpayIndex.jpg"];
    [Tabview addSubview:imagVc];
  
    sv = [[UIScrollView alloc]initWithFrame:svFrame];
    sv.pagingEnabled = YES;
    sv.contentOffset = CGPointMake(320, 0);
    sv.bounces= YES;
    sv.delegate= self;
    [Tabview addSubview:sv];
    
    /*广告*/
    [self readIndexAdList];

    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    [[NSRunLoop currentRunLoop]addTimer:myTimer forMode:NSDefaultRunLoopMode];
    
    page = [[UIPageControl alloc]initWithFrame:CGRectMake(125, 120 * IOS7IPHONE4, 60, 20)];
    page.numberOfPages = [[indexArr valueForKey:@"adallcount"][1] intValue];
    page.backgroundColor = [UIColor clearColor];
    [Tabview addSubview:page];
    
    [self setCurrentPage:page.currentPage];
    
    /*橙色*/
    NSString *btnName;
    NSString *btnImage;
    
    UIImageView *imag= [[UIImageView alloc]initWithFrame:CGRectMake(0, 138*IOS7IPHONE4, 320, 118*IOS7IPHONE4)];
    imag.image= [UIImage imageNamed:@"123.jpg"];
    [Tabview addSubview:imag];
    
    UIImageView *imagline= [[UIImageView alloc]initWithFrame:CGRectMake(159, 0, 2, 118*IOS7IPHONE4)];
    imagline.image= [UIImage imageNamed:@"lineTab"];
    [imag addSubview:imagline];
    
     /*按钮*/
    for (int i=0; i<2; i++)
    {
        btnName = (i == 0? @"购买刷卡器" : @"我的银行卡");
        btnImage= (i == 0? @"tfbbtn" : @"qbbtn");
        btImg = [[UIImageView alloc]initWithFrame:CGRectMake(50/IOS7IPHONE4, 12, 68*IOS7IPHONE4, 67*IOS7IPHONE4)];
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btnImage]]];
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(160*i, 138*IOS7IPHONE4, 160, 118*IOS7IPHONE4);
        [btn setTitle:btnName forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -90*IOS7IPHONE4, 0)];
        btn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
        [btn setTag:21+i];
        [btn setBackgroundImage:[UIImage imageNamed:@"333.jpg"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(MainViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:btImg];
        [Tabview addSubview:btn];
    }
    
    mnuisconstArray= [NSMutableArray arrayWithCapacity:10];
    NSPredicate *pre= [NSPredicate predicateWithFormat:@"mnuisconst = '1'"];
    
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
   
    /*存储*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *noticemainPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:MAIN_COUNVWTDATA];
    
    if (sortedArray.count > 0)
    {
        [sortedArray writeToFile:noticemainPath atomically:YES];
    }
    
    /*求主界面的所不拥有的图标从最后面开始替换*/
    NSMutableSet *set1 = [NSMutableSet setWithArray:mnuisconstArray];
    NSMutableSet *set2 = [NSMutableSet setWithArray:sortedArray];
    [set2 minusSet:set1];

    NSString *element;
    NSMutableArray *pointElement= [NSMutableArray arrayWithCapacity:9];
    for (element in set2)
    {
        [pointElement addObject:element];
    }
    /*主页固定菜单数值*/
    int mainCount;
    /*点击替换数的次数*/
    if (mnuisconstArray.count<6)
    {
        if (mnuisconstArray.count+pointElement.count<6)
        {
            mainCount= mnuisconstArray.count+pointElement.count;
        }
        else
        {
            mainCount= 6;
        }
    }
    else
    {
       mainCount= 6;
    }
    
    /*主界面图标*/
    if (pointElement.count>6)
    {
        /*如果点击次数大于主界面次数*/
        [pointElement removeLastObject];
    }
    flagReturn = YES;
    for (int i=0; i<mainCount-pointElement.count; i++)
    {
        MNUNOISONE[i] = [mnuisconstArray valueForKey:@"mnuno"][i];
        btImg = [[UIImageView alloc]initWithFrame:CGRectMake(26, 12, 52, 52)];
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[mnuisconstArray valueForKey:@"mnuno"][i]]]];
//        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",MNUNOISONE[i]]]];
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(106*(i%3), 258*IOS7IPHONE4+120*(i/3)*IOS7IPHONE4, 106, 106);
        btn.tag= 1+i;
        [btn setTitle:[[mnuisconstArray valueForKey:@"mnuname"]objectAtIndex:i] forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
        btn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
        appmnuidBtn[i] = [mnuisconstArray valueForKey:@"mnuid"][i];
        appmnunoBtn[i] = [mnuisconstArray valueForKey:@"mnuno"][i];
        [btn setBackgroundImage:[UIImage imageNamed:@"123.jpg"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(NewTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:btImg];
        [Tabview addSubview:btn];
    }
    
       /*新账户没点击次数*/
    if (pointElement.count!=0)
    {
        for (int i=0; i<pointElement.count; i++)
        {
             MNUNOISONE[i]= [mnuisconstArray valueForKey:@"mnuno"][i];
            /*点击次数替换主界面图标*/
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(26, 12, 52, 52)];
            [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[pointElement valueForKey:@"mnuno"][i]]]];
//           [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",MNUNOISONE[i]]]];
            UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(106*((i+6-pointElement.count)%3), 258*IOS7IPHONE4+120*((i+6-pointElement.count)/3)*IOS7IPHONE4, 106, 106);
            [btn setTitle:[[pointElement valueForKey:@"mnuname"]objectAtIndex:i] forState:UIControlStateNormal];
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
            btn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
            singleBt.tag= 301 +i;
            appmnuidthird[i] = [pointElement valueForKey:@"mnuid"][i];
            appmnunothird[i] = [pointElement valueForKey:@"mnuno"][i];
            [btn setBackgroundImage:[UIImage imageNamed:@"123.jpg"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(NewTouchAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:btImg];
            [Tabview addSubview:btn];
        }
    }
}

/*支付理财*/
-(void)ViewBank
{
    Tabview = [TabAllView instanceTextView:1];
    Tabview.frame = CGRectMake(0, navheight, 320, (SelfHeight-73-navheight)*IOS7IPHONE4);
    [self.view addSubview:Tabview];
    
    //firstbtn分类功能1
    for (int i=0; i<typeLiCaiArray.count; i++)
    {
        btImg = [[UIImageView alloc]initWithFrame:CGRectMake(26, 12, 52, 52)];
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[resultArray valueForKey:@"mnuno"][i]]]];
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(106*(i%3), 10+120*(i/3)*IOS7IPHONE4, 106, 106);
        btn.tag= 101+i;
        [btn setTitle:[[resultArray valueForKey:@"mnuname"]objectAtIndex:i] forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
        btn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
        appmnuidfirst[i] = [resultArray valueForKey:@"mnuid"][i];
        appmnunofirst[i] = [resultArray valueForKey:@"mnuno"][i];
        [btn setBackgroundImage:[UIImage imageNamed:@"123.jpg"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(NewTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:btImg];
        [Tabview addSubview:btn];
    }
    
}

/*便民服务*/
-(void)Viewbianmin
{
    Tabview = [TabAllView instanceTextView:2];
    Tabview.frame = CGRectMake(0, navheight, 320, (SelfHeight - 73 - navheight) * IOS7IPHONE4);
    [self.view addSubview:Tabview];
    
    //secondbtn分类功能2
    for (int i=0; i<typeBianMingArray.count; i++)
    {
  
        btImg = [[UIImageView alloc]initWithFrame:CGRectMake(26, 12, 52, 52)];
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",[resultArrayBianming valueForKey:@"mnuno"][i]]]];
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(106*(i%3), 10+120*(i/3)*IOS7IPHONE4, 106, 106);
        btn.tag= 201+i;
        [btn setTitle:[[resultArrayBianming valueForKey:@"mnuname"]objectAtIndex:i] forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
        btn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
        appmnuidsecond[i] = [resultArrayBianming valueForKey:@"mnuid"][i];
        appmnunosecond[i] = [resultArrayBianming valueForKey:@"mnuno"][i];
        [btn setBackgroundImage:[UIImage imageNamed:@"123.jpg"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(NewTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:btImg];
        [Tabview addSubview:btn];
    }
}

/*更多的功能*/
-(void)viewMore
{
    Tabview = [TabAllView instanceTextView:3];
    Tabview.frame = CGRectMake(0, navheight, 320, (SelfHeight-73-navheight)*IOS7IPHONE4);
    [self.view addSubview:Tabview];
    
    for (int i=0; i< btMoreArr.count; i++) {
        btImg = [[UIImageView alloc]initWithFrame:CGRectMake(26, 12, 52, 52)];
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btMoreArr[i][@"bgicon"]]]];
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(106*(i%3), 10+120*(i/3)*IOS7IPHONE4, 106, 106);
        btn.tag= 401+i;
        [btn setTitle:[[btMoreArr valueForKey:@"txt"]objectAtIndex:i] forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
        btn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0];
        [btn setBackgroundImage:[UIImage imageNamed:@"123.jpg"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(tagMoreViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:btImg];
        [Tabview addSubview:btn];
    }
}

// 代理商点击
-(void)onAgentClicked:(id)sender
{
    if ([NLUtils getAgentid].length <= 0 || [[NLUtils getAgentid] isEqualToString:@"0"])
    {
        ApplyOrTestViewController *applyView = [[ApplyOrTestViewController alloc] init];
        [NLUtils presentModalViewController:(UIViewController*)self newViewController:applyView];
        
        return ;
    }
    //给默认第一次的NLSlideBroadsideController赋值、、、
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SlideBroadFlag"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_Agent];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [UIView
     transitionWithView:delegate.window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         delegate.window.rootViewController = (UIViewController*)navigationController;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}


#pragma mark - 刷卡器  银行卡
/*刷卡器按钮*/
-(void)MainViewAction:(UIButton*)sender{
    switch (sender.tag) {
        case 21:
        {
            /*
            PaySKQ *vc= [[PaySKQ alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
            */
             
            /*刷卡器授权码*/
            ImpowerController *impowerView = [[ImpowerController alloc] init];
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:impowerView];
            [self presentViewController:navigation animated:YES completion:nil];
        }
            break;
        case 22:
        {
            /*我的银行卡*/
            MyBankCardViewController *vc= [[MyBankCardViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
            
            /*
            [self showErrorInfo:@"我的钱包正在开发当中!" status:NLHUDState_None];
            [self performSelector:@selector(hideAction)withObject:sender afterDelay:1.5f];
             */
        }
            break;
        default:
            break;
    }
}

-(void)hideAction{
    [_hud hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*更多个人设置的*/
-(void)tagMoreViewAction:(UIButton*)sender{
    
    int value= sender.tag;
    switch (value) {
        case 401:
        {
            /*现在我的信息里面包括代理商数据*/
            NLMoreViewController *vl = [[NLMoreViewController alloc] initWithNibName:@"NLMoreViewController" bundle:nil];
            /*agenttypeid字段 0普通/1正式/2虚拟 */
            NSString *agentID= [NLUtils getAgenttypeid];
            if (![agentID isEqualToString:@"0"]) {
                vl.agentFlag= YES;
            }
            [NLUtils presentModalViewController:self newViewController:vl];
        }
            break;
        case 402:
        {
            AgentInfoViewController *agentInfoView = [[AgentInfoViewController alloc] init];
            [NLUtils presentModalViewController:(UIViewController *)self newViewController:agentInfoView];
        }
            break;
        case 403:
        {
            [self onAgentClicked:sender];
        }
            break;
        case 404:
        {
            NLHelpCenterViewController* vl=  [[NLHelpCenterViewController alloc] initWithNibName:@"NLHelpCenterViewController" bundle:nil] ;
            vl.RefreshingFlag= YES;
            [NLUtils presentModalViewController:(UIViewController*)self newViewController:vl];
        }
            break;
        case 405:
        {
            //意见反馈
            NLFeedbackViewController *vl = [[NLFeedbackViewController alloc] initWithNibName:@"NLFeedbackViewController" bundle:nil] ;
            [NLUtils presentModalViewController:(UIViewController*)self newViewController:vl];
        }
            break;
        case 406:
        {
            NLAboutUsViewController* vl=  [[NLAboutUsViewController alloc] initWithNibName:@"NLAboutUsViewController" bundle:nil] ;
            [NLUtils presentModalViewController:(UIViewController*)self newViewController:vl];
        }
            break;
        case 407:
        {
            /*获取进入页面的 appnewversion */
            [self checkAppnewversion];
        }
            break;
        case 408:
        {
            ShareAppView *shapp= [[ShareAppView alloc]init];
            [NLUtils presentModalViewController:self newViewController:shapp];
        }
            break;
        case 409:
        {
            /*
            EWMview *ewmView = [[EWMview alloc] init];
            ewmView.ewmToAPP= YES;
            [NLUtils presentModalViewController:self newViewController:ewmView];
             */
            
            //级别
            NLPeopleLevel *pay= [[NLPeopleLevel alloc]init];
           [NLUtils presentModalViewController:self newViewController:pay];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 主页功能跳转二级界面的对应方法
/*对应的方法*/
-(void)NewTouchAction:(UIButton*)sender{
    
    /*对应图标的叠加*/
    if (sender.tag>200&&sender.tag<300) {
        appmnuid= appmnuidsecond[sender.tag - 201];
        appmnuno= appmnunosecond[sender.tag - 201];
    }else if (sender.tag>100&&sender.tag<200){
        appmnuid= appmnuidfirst[sender.tag - 101];
        appmnuno= appmnunofirst[sender.tag - 101];
    }else if (sender.tag>0&&sender.tag<100){
        appmnuid= appmnuidBtn[sender.tag - 1];
        appmnuno= appmnunoBtn[sender.tag - 1];
    }else if (sender.tag>300){
        appmnuid= appmnuidthird[sender.tag - 301];
        appmnuno= appmnunothird[sender.tag - 301];
    }
    [self touchtap];
    
    /*mnuno交易类型的获取 先發工資的*/
    if (appmnuno==nil) {
        appmnuno= @"salarypay";
    }

    NSArray *arr= [NSArray arrayWithObject:appmnuno];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:BANK_PAYTYPE_CHECK];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([sender.titleLabel.text isEqualToString:@"还信用卡"] && [self isUserRegister:NLPushViewType_CreditCardPayments]) {
        
        NLCreditCardPaymentsViewController *vc= [[NLCreditCardPaymentsViewController alloc]init];
        [NLUtils presentModalViewController:self newViewController:vc];
        //发工资 text
//        SingPayMoney *vc= [[SingPayMoney alloc]init];
//        [NLUtils presentModalViewController:self newViewController:vc];
        
//        NLhhzTestViewController *vc= [[NLhhzTestViewController alloc]init];
//        [NLUtils presentModalViewController:self newViewController:vc];
        
    }
    else if
        ([sender.titleLabel.text isEqualToString:@"信用卡还款"] && [self isUserRegister:NLPushViewType_CreditCardPayments]){
            
            NLCreditCardPaymentsViewController *vc= [[NLCreditCardPaymentsViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
            
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"Q币充值"] && [self isUserRegister:NLPushViewType_QCoinCharge]){
  
//            QCoinView *vc= [[QCoinView alloc]init];
//            [NLUtils presentModalViewController:self newViewController:vc];
            TFNewVersionAgentMainCtr *vc = [[TFNewVersionAgentMainCtr alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
            
       
        }
    else if
        (([sender.titleLabel.text isEqualToString:@"话费充值"]||[sender.titleLabel.text isEqualToString:@"手机充值"]) && [self isUserRegister:NLPushViewType_PhoneMoney]){
            
            PhoneMoneyView *vc= [[PhoneMoneyView alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
    
    else if
        ([sender.titleLabel.text isEqualToString:@"购买刷卡器"] && [self isUserRegister:NLPushViewType_FormPay]){
            
            PaySKQ *vc= [[PaySKQ alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"代理商"]){
            [self onAgentClicked:sender];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"游戏充值"] && [self isUserRegister:NLPushViewType_GameCharge]){
            
            GameCharge *vc= [[GameCharge alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"机票预订"]){
            
            AirTicketViewController *airTicketView = [[AirTicketViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:airTicketView];
        
//            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://u.ctrip.com/union/CtripRedirect.aspx?TypeID=615&sid=451200&allianceid=20230&ouid=%@",[NLUtils getRegisterMobile]]];
//            planeMain *pla= [[planeMain alloc]init];
//            [NLUtils presentModalViewController:self newViewController:pla];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"火车票预订"]){
        
//            planeMain *pla= [[planeMain alloc]init];
//            [NLUtils presentModalViewController:self newViewController:pla];
            
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://u.ctrip.com/union/CtripRedirect.aspx?TypeID=2&sid=451200&allianceid=20230&OUID=%@&jumpUrl=http://m.ctrip.com/webapp/train/" ,[NLUtils getRegisterMobile]]];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
            [NLUtils presentModalViewController:self newViewController:webViewController];
           
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"酒店预订"]){
            
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://u.ctrip.com/union/CtripRedirect.aspx?TypeID=636&sid=451200&allianceid=20230&ouid=%@",[NLUtils getRegisterMobile]]];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
            [NLUtils presentModalViewController:self newViewController:webViewController];
          
            
//            ReserveHotelController *hotelView = [[ReserveHotelController alloc] init];
//            [NLUtils presentModalViewController:self newViewController:hotelView]; 
            
             
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"水电煤缴费"] && [self isUserRegister:NLPushViewType_WaterElec]){
            
            WaterElec *vc= [[WaterElec alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"转账汇款"] && [self isUserRegister:NLPushViewType_TransferRemittance]){
            
//            NLTransferRemittanceViewController *vc= [[NLTransferRemittanceViewController alloc]init];
//            [NLUtils presentModalViewController:self newViewController:vc];
            
            TransferAccountsController *accountsView = [[TransferAccountsController alloc] init];
            [NLUtils presentModalViewController:self newViewController:accountsView];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"商户收款"] && [self isUserRegister:NLPushViewType_CashArriveMain]){
            
            NLCashArriveMainViewController *vc= [[NLCashArriveMainViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"快递查询"] && [self isUserRegister:NLPushViewType_OrderQuery]){
            /*
            GameCharge *vc= [[GameCharge alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
            */
            ExpressageMain *vc= [[ExpressageMain alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
            
            /*
            NLOrderQueryViewController *vc= [[NLOrderQueryViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
             */
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"苏宁商城"]){
            id thisClass = [[NSClassFromString(@"MobileShop") alloc] init];
            [NLUtils presentModalViewController:self newViewController:thisClass];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"手机购物"]){
            id thisClass = [[NSClassFromString(@"MobileShop") alloc] init];
            [NLUtils presentModalViewController:self newViewController:thisClass];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"余额查询"] && [self isUserRegister:NLPushViewType_BalanceQuery]){
            
            NLBalanceQueryViewController *vc= [[NLBalanceQueryViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"现金抵用券"] && [self isUserRegister:NLPushViewType_CashArriveMain]){
            
            NLCashArriveMainViewController *vc= [[NLCashArriveMainViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
    else if
        (([sender.titleLabel.text isEqualToString:@"优惠卡"]||[sender.titleLabel.text isEqualToString:@"通付卡卡"]) && [self isUserRegister:NLPushViewType_CashArriveMain]){
            
            NLCashHTCard *pay= [[NLCashHTCard alloc]init];
            [NLUtils presentModalViewController:self newViewController:pay];
        }
    
    else if
        ([sender.titleLabel.text isEqualToString:@"发放工资"] && [self isUserRegister:NLPushViewType_WaterElec]){
            
            SingPayMoney *vc= [[SingPayMoney alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
           /*
            payoffView *vc= [[payoffView alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
             */
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"信用卡发工资"] && [self isUserRegister:NLPushViewType_WaterElec]){
            
            SingPayMoney *vc= [[SingPayMoney alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"签收工资"] && [self isUserRegister:NLPushViewType_WaterElec]){
      
            SignOnMain *vc= [[SignOnMain alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
    }
    else if
        ([sender.titleLabel.text isEqualToString:@"付临门"] && [self isUserRegister:NLPushViewType_SavingsCard]){
            
            SavingsCardViewController *SavingsCardView= [[SavingsCardViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:SavingsCardView];
        }
    else if
        ([sender.titleLabel.text isEqualToString:@"短信收款"] && [self isUserRegister:NLPushViewType_SMSreceipt]){
            
            SMSreceiptViewController *vc= [[SMSreceiptViewController alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
}

/*隐藏nav*/
-(void)navsethiden:(BOOL)flag
{
    if (flag==YES)
    {
        [_nabtn setHidden:YES];
        [_naline setHidden:YES];
        [_nalogobg setHidden:YES];
        [_naname setHidden:YES];
        [_lable setHidden:YES];
    }
    else
    {
        [_nabtn setHidden:NO];
        [_naline setHidden:NO];
        [_nalogobg setHidden:NO];
        [_naname setHidden:NO];
        [_lable setHidden:NO];
    }
}

#pragma mark - 二维码扫描
/*二维码扫描*/
- (IBAction)NaEWM:(id)sender {
  
    CGRect svFrame;
    if (IOS7_OR_LATER)
    {
        svFrame = CGRectMake(0, 0, 320, SelfHeight);
    }
    else
    {
        svFrame = CGRectMake(0, -20, 320, SelfHeight);
    }
    
    EWMview *ewm= [EWMview singleton];
    CGRect frame=svFrame;
    frame.origin.y-=self.view.frame.size.height;
    ewm.view.frame=frame;
    [self.view addSubview:ewm.view];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect animateFrame=ewm.view.frame;
        animateFrame.origin.y+=self.view.frame.size.height-self.view.frame.origin.y;
        ewm.view.frame=animateFrame;
    } completion:^(BOOL finished) {
    
    }];
    
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

#pragma mark - 广告请求
/*广告请求*/
-(void)readIndexAdList
{
    flagLint= YES;
    NSString* name = [NLUtils getNameForRequest:Notify_readIndexAdList];
    REGISTER_NOTIFY_OBSERVER(self, readIndexAdListNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readIndexAdList:@"1"];
}

-(void)readIndexAdListNotify:(NSNotification*)notify
{
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        [self doreadIndexAdListNotify:response];
    }
}

-(void)doreadIndexAdListNotify:(NLProtocolResponse*)response
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
        indexArr= [NSMutableArray arrayWithCapacity:9];
        
        NSArray *adpicurlArr= [response.data find:@"msgbody/msgchild/adpicurl"];
        NSArray *adnoArr= [response.data find:@"msgbody/msgchild/adno"];
        NSArray *adtitleArr= [response.data find:@"msgbody/msgchild/adtitle"];
        NSArray *adlinkurlArr= [response.data find:@"msgbody/msgchild/adlinkurl"];
        
        NSString *adpicurlStr = nil;
        NSString *adnoStr = nil;
        NSString *adtitleStr = nil;
        NSString *adlinkurlStr = nil;
        
        NLProtocolData* data = [response.data find:@"msgbody/adallcount" index:0];
        NSString *adallcountStr = data.value;
        
        for (int i =0 ; i<adpicurlArr.count; i++)
        {
            NLProtocolData* data = [adpicurlArr objectAtIndex:i];
            adpicurlStr = [self checkInfoMain:data.value];
            
            data = [adnoArr objectAtIndex:i];
            adnoStr = [self checkInfoMain:data.value];
            
            data = [adtitleArr objectAtIndex:i];
            adtitleStr = [self checkInfoMain:data.value];
            
            data = [adlinkurlArr objectAtIndex:i];
            adlinkurlStr = [self checkInfoMain:data.value];
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:adpicurlStr, @"adpicurl", adnoStr, @"adno", adtitleStr, @"adtitle", adlinkurlStr,@"adlinkurl",adallcountStr,@"adallcount",nil];
            [indexArr addObject:dic];
            
            [self adImage];
        }
        
    }
}

- (void) setCurrentPage:(NSInteger)secondPage
{
    for (NSUInteger subviewIndex = 0; subviewIndex < [page.subviews count]; subviewIndex++)
    {
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 24/2;
        size.width = 24/2;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
    }
}

/*广告*/
- (void)adImage
{
    //获取当前广告url
    Arr = [indexArr valueForKey:@"adpicurl"];
    
    imageData = [ImageData singleton];
    
    [sv setContentSize:CGSizeMake(320 * [Arr count], 118 * IOS7IPHONE4)];
    page.numberOfPages = [Arr count];
    
    NSArray *arrPicurl= [[NSUserDefaults standardUserDefaults] objectForKey:@"adpicurl"];
    
    if (!arrPicurl)
    {
        arrPicurl = Arr;
        
        [[NSUserDefaults standardUserDefaults] setObject:Arr forKey:@"adpicurl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (int i = 0; i < Arr.count; i++)
        {
            NSString *urlString = arrPicurl[i];
            
            CGRect btnFrame = IOS7_OR_LATER? CGRectMake(320 * i, 0, 320, 118 * IOS7IPHONE4) : CGRectMake(320 * i, 0, 320, 138 * IOS7IPHONE4);
            
            UIButton *advertBtn = [[UIButton alloc] initWithFrame:btnFrame];
            [sv addSubview:advertBtn];
            
            UIImageFromURL([NSURL URLWithString:urlString], ^(UIImage *image) {
                
                [advertBtn setBackgroundImage:image forState:UIControlStateNormal];
                
                [imageData imageCacheWith:urlString image:image];
            }, ^{
                
            });
        }
    }
    else
    {
        if ([arrPicurl isEqualToArray:Arr])
        {
            for (int i = 0; i < arrPicurl.count; i++)
            {
                NSArray *images = [imageData queryImageWith:arrPicurl[i]];
                
                ImageCache *imageCache = (ImageCache *)images[0];
                
                CGRect btnFrame = IOS7_OR_LATER? CGRectMake(320 * i, 0, 320, 118 * IOS7IPHONE4) : CGRectMake(320 * i, 0, 320, 138 * IOS7IPHONE4);
                
                UIButton *advertBtn = [[UIButton alloc] initWithFrame:btnFrame];
                [advertBtn setBackgroundImage:imageCache.image forState:UIControlStateNormal];
                [sv addSubview:advertBtn];
            }
            
            imagVc.hidden = YES;
        }
        else
        {
            for (int i = 0; i < Arr.count; i++)
            {
                NSArray *images = [imageData queryImageWith:Arr[i]];
                
                CGRect btnFrame = IOS7_OR_LATER? CGRectMake(320 * i, 0, 320, 118 * IOS7IPHONE4) : CGRectMake(320 * i, 0, 320, 138 * IOS7IPHONE4);
                
                UIButton *advertBtn = [[UIButton alloc] initWithFrame:btnFrame];
                [sv addSubview:advertBtn];
                
                if (!images)
                {
                    NSString *urlString = Arr[i];
                    
                    UIImageFromURL([NSURL URLWithString:urlString], ^(UIImage *image) {
                        
                        [advertBtn setBackgroundImage:image forState:UIControlStateNormal];
                        
                        [imageData imageCacheWith:urlString image:image];
                    }, ^{
                        
                    });
                }
                else
                {
                    ImageCache *imageCache = (ImageCache *)images[0];
                    
                    [advertBtn setBackgroundImage:imageCache.image forState:UIControlStateNormal];
                }
            }
        }
    }
    
    [self performSelector:@selector(imagVChide) withObject:nil afterDelay:4.0f];
}



-(void)AdImg:(NSArray*)arr
{
    NSArray *arrPicurl= [[NSUserDefaults standardUserDefaults] objectForKey:@"adpicurl"];
    Arr = [indexArr valueForKey:@"adpicurl"];
    
    [sv setContentSize:CGSizeMake(320 * [arr count], 118 * IOS7IPHONE4)];
    page.numberOfPages=[Arr count];
    
    if (!arrPicurl)
    {
        arrPicurl = Arr;
        
        for (int i = 0; i < arrPicurl.count; i++)
        {
            NSString *urlStr = arrPicurl[i];
            
            UIButton *btnVC = [[UIButton alloc]initWithFrame:CGRectMake(320 * i, 0, 320, 118 * IOS7IPHONE4)];
            
            if (!IOS7_OR_LATER)
            {
                btnVC.frame = CGRectMake(320 * i, 0, 320, 138 * IOS7IPHONE4);
            }
            
            /*事件链接 暂不需要件*/
            [btnVC addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
            [sv addSubview:btnVC];
        }
    }
    else
    {
        
    }
    
    for (int i = 0; i < Arr.count; i++)
    {
        NSString *urlStr = [arr objectAtIndex:i];
        UIButton *btnVC = [[UIButton alloc]initWithFrame:CGRectMake(320 * i, 0, 320, 118 * IOS7IPHONE4)];
        
        if (!IOS7_OR_LATER)
        {
            btnVC.frame = CGRectMake(320 * i, 0, 320, 138 * IOS7IPHONE4);
        }
        
        /*事件链接 暂不需要件*/
        [btnVC addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:btnVC];
        
        /*函数的请求图片*/
        UIImageFromURL([NSURL URLWithString:urlStr], ^(UIImage *image)
                       {
                           [btnVC setBackgroundImage:image forState:UIControlStateNormal];
                       }, ^(void){
                           
                       });
    }
    
    [self performSelector:@selector(imagVChide) withObject:nil afterDelay:4.0f];
}

/*广告对应的事件 暂时不用*/
-(void)Action:(UIButton*)sneder
{
    
    
}

- (void)handleTimer:(NSTimer *)timer
{
    if (TimeNum % 5 == 0 )
    {
        if (!Tend)
        {
            page.currentPage++;
            if (page.currentPage==page.numberOfPages-1)
            {
                Tend=YES;
            }
        }
        else
        {
            page.currentPage--;
            if (page.currentPage==0)
            {
                Tend=NO;
            }
        }
        [UIView animateWithDuration:1.1 //速度0.7秒
                         animations:^{//修改坐标
                            
                             sv.contentOffset = CGPointMake(page.currentPage*320,0);
                         }];
    }
    TimeNum ++;
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

//检查版本号
-(void)checkAppVersion
{
    [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
}

-(void)checkAppnewversion
{
        [[[NLProtocolRequest alloc] initWithRegister:YES] checkAppVersion:@"2" version:TFBVersion];
        [[[NLToast alloc] init] show:@"正在检测最新版本，请稍后..."
                             gravity:NLToastGravityBottom
                            duration:NLToastDurationShort];
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
            detail = @"服务器繁忙，请稍候再试";
        }
        //清空数据时
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"PhoneNoFlag"]==nil) {
            [self AlertGuard];
        }else{
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"PhoneNoFlag"] !=NO) {
                [self AlertGuard];
            }
        }
    }
}

/*密保*/
-(void)AlertGuard
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"立马设置密保" message:@"为了您的账户找回密码及安全，是否前往设定密保问题" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立马设置", nil];
    alert.tag= 3838;
    [alert show];
}

#pragma mark - scrollView && page
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    page.currentPage=scrollView.contentOffset.x/320;
    [self setCurrentPage:page.currentPage];
    
}

/*强制更新*/
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

-(void)imagVChide
{
    imagVc.hidden= YES;
}

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/*数据保存 暂时不用*/
-(void)intoTheshabox
{

    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *noticemainPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:MAIN_DATA];
    if (_MainArray.count>0) {
        [_MainArray writeToFile:noticemainPath atomically:YES];
    }
}


-(void)nav
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", @"Back button title") style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
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
        /*暂时用不了*/
//        [self mainviewisOn];
        
    }else{
        /*所有请求图标*/
        _MainArray= noticeMain;
        /*点击超过9次的图标*/
        sortedArray = noticeElment;
        /*本地读取上次的数据 并刷新数据存储这次的*/
        
    }
}

/*
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [IQKeyboardManager enableKeyboardManger];
    首次进来的引导话费界面图
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"firstInto"] ==YES) {
        viewphone= [[UIView alloc]initWithFrame:self.view.frame];
        viewphone.backgroundColor= [UIColor lightGrayColor];
        [self.view addSubview:viewphone];
        
        UIButton *leadButton[2];
        for (int i = 0; i < 2; i++)
        {
            NSString *btnName = ( i == 0? @"立即充值" : @"再逛一圈");
            leadButton[i] = [UIButton buttonWithType:UIButtonTypeCustom];
            leadButton[i].opaque = YES;
            leadButton[i].tag = 1818 + i;
            leadButton[i].frame = CGRectMake(25 + 130 * i, 205, 90, 35);
            [leadButton[i] setBackgroundImage:imageName(@"next_press@2x", @"png") forState:UIControlStateNormal];
            [leadButton[i] setTitle:btnName forState:UIControlStateNormal];
            [leadButton[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [leadButton[i] setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
            [leadButton[i] addTarget:self action:@selector(leadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [viewphone addSubview:leadButton[i]];
        }
    }
    
}

#pragma 引导话费功能页面
-(void)leadButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1818:
        {
            id thisClass = [[NSClassFromString(@"PhoneMoneyView") alloc] initWithNibName:@"PhoneMoneyView" bundle:nil];
            [NLUtils presentModalViewController:self newViewController:thisClass];
        }
            break;
        default:
        {
            viewphone.hidden= YES;
        }
            break;
    }
}
*/
@end
