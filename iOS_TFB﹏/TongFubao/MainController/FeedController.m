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

@interface FeedController ()
{
    NLProgressHUD  * _hud;
    int          IOS7HEIGHT;
    int         IOS7IPHONE4;
    int        numCount;
    NSString       *JumType;
    NSString       *strPhone;
    UIImageView    *btImg;
    UIImageView    *rightbg;
    UIButton       *singleBt;
    UIButton       *select;
    UIButton       *rightBtn3;
    UIButton       *rightBtn2;
    UIButton       *rightBtn1;
    
    UIView *firstView;
    UIView *thirdView;
    UIView *secondView;
   
    UIPageControl  *pageControl;
    NSMutableArray *btArray;
    NSMutableArray *btfirstArray;
    NSMutableArray *btsecondArray;
    NSMutableArray *rightarray;
}

@property (nonatomic,strong) NSMutableArray *dataid;

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic,strong) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *itemScrollView;
@property (nonatomic,strong) NSMutableArray    *myMenuModuleArray;
@property (nonatomic,strong) NSMutableArray    *myDefaultMenuArray;
@property (nonatomic,strong) NSMutableArray    *dataArray;

-(void)setupLeftMenuButton;
-(void)createScrollView:(int)count;
-(void)loadScrollViewWithPage:(int)page;
-(void)leftDrawerButtonPress:(id)sender;
-(void)onAgentClicked:(id)sender;

@end

@implementation FeedController
@synthesize phone,password,authorid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//新主页模板菜单
-(void)newAPPMenu{
    
    NSString *payCard= @"0";
    
    NSString *ppversion= @"1.0.0";
    
    NSString* name = [NLUtils getNameForRequest:Notify_ApireadMenuModule];
    
    REGISTER_NOTIFY_OBSERVER(self, getappMenuNotify, name);
    
    [[[NLProtocolRequest alloc]initWithRegister:YES]getApireadMenuModule:payCard appversion:ppversion];
    
}
     
-(void)getappMenuNotify:(NSNotification*)notify{
   
    NLProtocolResponse* response = (NLProtocolResponse*)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self dogetappMenuNotify:response];
    }
    else
    {
        [_hud hide:YES];
        NSString *detail = response.detail;
        
        if (!detail || detail.length <= 0)
        {
            detail = @"系统有误，请稍候再试";
        }
        [self showErrorInfo:detail status:NLHUDState_Error];
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
        NSArray *msgchildArr = [response.data find:@"msgbody/msgchild/msgchild"];
        NSArray *mnunameArr = [response.data find:@"msgbody/msgchild/mnuname"];
        NSArray *mnupicArr = [response.data find:@"msgbody/msgchild/mnupic"];
        NSArray *mnuorderArr = [response.data find:@"msgbody/msgchild/mnuorder"];
        NSArray *mnuurlArr = [response.data find:@"msgbody/msgchild/mnuurl"];
        NSArray *mnuversionArr = [response.data find:@"msgbody/msgchild/mnuversion"];
        NSArray *mnuidArr = [response.data find:@"msgbody/msgchild/mnuid"];
        NSArray *mnutypeidArr = [response.data find:@"msgbody/msgchild/mnutypeid"];
        NSArray *mnutypenameArr = [response.data find:@"msgbody/msgchild/mnutypename"];
        NSArray *pointnumArr = [response.data find:@"msgbody/msgchild/pointnum"];
        NSArray *mnuisconstArr = [response.data find:@"msgbody/msgchild/mnuisconst"];
        
        NSString *msgchildStr = nil;
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
        
        for (int i = 0 ; i<msgchildArr.count; i++) {
            
            NLProtocolData* data = [msgchildArr objectAtIndex:i];
            msgchildStr = data.value;
            
            data = [mnunameArr objectAtIndex:i];
            mnunameStr = data.value;
            
            data = [mnupicArr objectAtIndex:i];
            mnupicStr = data.value;
            
            data = [mnuorderArr objectAtIndex:i];
            mnuorderStr = data.value;
            
            data = [mnuurlArr objectAtIndex:i];
            mnuurlStr = data.value;
            
            data = [mnuversionArr objectAtIndex:i];
            mnuversionStr = data.value;
            
            data = [mnuidArr objectAtIndex:i];
            mnuidStr = data.value;
            
            data = [mnutypeidArr objectAtIndex:i];
            mnutypeidStr = data.value;
            
            data = [mnutypenameArr objectAtIndex:i];
            mnutypenameStr = data.value;
            
            data = [pointnumArr objectAtIndex:i];
            pointnumStr = data.value;
            
            data = [mnuisconstArr objectAtIndex:i];
            mnuisconstStr = data.value;

            [_dataArray addObject:@{@"msgchild":msgchildStr,@"mnuname":mnunameStr ,@"mnupic":mnupicStr ,@"mnuorder":mnuorderStr ,@"mnuurl":mnuurlStr , @"mnuversion":mnuversionStr ,@"mnuid":mnuidStr , @"mnutypeid":mnutypeidStr ,@"mnutypename":mnutypenameStr , @"pointnum":pointnumStr , @"mnuisconst":mnuisconstStr }];
        }
       
        //这里获取到数据
        
        BOOL failer= YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //如果数据没下载完成
                if (failer==YES) {
                   
                }else{
                    
                    
                }
            });
        });
    }
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self newAPPMenu];
    
    [super viewWillAppear:animated];
    
    [self checkAppVersion];
    
    //检测是否已经设置过密保问题的（更换手机或者下次再说的判断）
    [self SafeGuardUser];
}

#pragma 密保的检测
-(void)SafeGuardUser{
    
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

-(void)AlertGuard{
    
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"立马设置密保" message:@"为了您的账户找回密码及安全，是否前往设定密保问题" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立马设置", nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    if (1==buttonIndex) {
        
        SecretText *ser= [[SecretText alloc]initWithNibName:@"SecretText" bundle:nil];
        
        [NLUtils presentModalViewController:self newViewController:ser];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"PhoneNoFlag"];
    
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

//后台控制主页面的scroller
-(void)initScrollView
{

    int count = btArray.count;
    if (count <= 0)
    {
        [self createScrollView:3];
    }
    else
    {
        [self createScrollView:count];
    }
}

-(void)createScrollView:(int)count
{
    self.myScrollView.pagingEnabled = YES;
    for (int i=0; i<count; i++)
    {
        [self loadScrollViewWithPage:i];
    }
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.frame.size.width * count, self.myScrollView.frame.size.height);
   
}

- (void)loadScrollViewWithPage:(int)page
{
    CGRect frame = self.myScrollView.frame;
    frame.origin.x = frame.size.width * (page);
    frame.origin.y = 0;
    NSString* key = [NSString stringWithFormat:@"%@%d",TFBC_MainAdImageURL,page+1];
    NSString* url = [NLPlistOper readValue:key
                                      path:FETCH_ABS_FILE_NAME(TFBConfigurator)];
    NLAsynImageView* view = [[NLAsynImageView alloc] initWithFrame:frame];
    view.placeholderImage = [UIImage imageNamed:@"unloaded.png"];
    view.imageURL = url;
    [self.myScrollView addSubview:view];
}

#pragma 主界面
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    IOS7HEIGHT=IOS7_OR_LATER==YES?0:64;
    
    IOS7IPHONE4=IOS7_OR_SCREEN==YES?0:30;
    
    [self scrollViewInit];
    
    [self setupLeftMenuButton];
    
//    [self initScrollView];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    REMOVE_NOTIFY_OBSERVER(self);
}

#pragma moreMenuBtn
-(void)setupLeftMenuButton
{
    
//    [self vieMain];
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
-(void)rightBtn:(UIButton*)sender{
    
    numCount ++;
    
    [self starButtonClicked:sender];
    
    _itemScrollView.contentOffset = CGPointMake(320*(sender.tag-101), 0);
    
    /*
    self.view.frame= CGRectMake(0, 0, 320, 480);
    self.view.backgroundColor= [UIColor redColor];
    */
}

-(void)viewisOn:(UIButton*)sender{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            rightbg.frame= CGRectMake(120, 432, 201, 40.5);
        }else{
             rightbg.frame= CGRectMake(120, 470, 201, 40.5);
        }
        [self.view addSubview:rightbg];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)viewisUp:(UIButton*)sender{
    
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

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

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
  

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
    
}


#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender
{
    NLSlideBroadsideController* slider = [[NLSlideBroadsideController alloc] init];
    [slider onDrawerButtonPressed:NLSlideBroadsideCenterControllerMenuLeft viewController:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[UINavigationBar appearance] setBarTintColor:NAV_COLOR];
}

-(void)scrollViewInit
{
    //代理商的识别为No
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AgentFlag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIImageView *titleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logos.png"]];
    
    titleImgView.frame = CGRectMake(120, 3, 66, 38);
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [titleView addSubview:titleImgView];
    
    self.navigationItem.titleView = titleView;
    
       /*
     新版首页的桌面9个图标：
     信用卡还款  转账汇款  现金抵用券
     余额查询    快递查询  购买刷卡器
     话费充值    Q币充值   代理商
     
     第一类：
     信用卡还款  转账汇款   现金抵用券
     余额查询    购买刷卡器 代理商
     
     第二类：
     话费充值    Q币充值     游戏充值
     飞机票预定  火车票预定  酒店预定
     水电煤缴费  快递查询
     */
    
    
    //按钮添加 /主界面/
    self.itemScrollView.pagingEnabled= YES;
    
    self.itemScrollView.delegate= self;
 
    self.itemScrollView.contentSize = CGSizeMake(320*3,self.itemScrollView.frame.size.height);
    
    [self.view addSubview:self.itemScrollView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgmain.png"]];
    
    //第一个页面
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height)];
    
    [_itemScrollView addSubview:firstView];
    
    //第二个页面
    secondView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height)];
    
    [_itemScrollView addSubview:secondView];
    
    //第三个页面
    thirdView = [[UIView alloc]initWithFrame:CGRectMake(640, 0, self.itemScrollView.frame.size.width, self.itemScrollView.frame.size.height)];
    
    [_itemScrollView addSubview:thirdView];
    
     numCount= 0;//判断点击的次数
    
     btArray = [NSMutableArray array];
     btfirstArray= [NSMutableArray array];
     btsecondArray= [NSMutableArray array];
    
    [btArray addObject:@{@"img": @"xinyongka_normal.png",@"txt":@"信用卡还款",@"bgicon":@"mao1.png",@"img_select":@"xinyongka_selected.png"}];
    [btArray addObject:@{@"img": @"zhuanzhang_normal.png",@"txt":@"转账汇款",@"bgicon":@"mao2.png",@"img_select":@"zhuanzhang_selected.png"}];
    [btArray addObject:@{@"img": @"xianjin_normal.png",@"txt":@"现金抵用券" ,@"bgicon":@"mao3.png",@"img_select":@"xianjin_selected.png"}];
    [btArray addObject:@{@"img": @"yue_normal.png",@"txt":@"余额查询",@"bgicon":@"mao4.png",@"img_select":@"yue_selected.png"}];
    [btArray addObject:@{@"img": @"kuaidi_normal.png",@"txt":@"快递查询",@"bgicon":@"mao5.png",@"img_select":@"kuaidi_selected.png"}];
    [btArray addObject:@{@"img": @"paySKQ_normal.png",@"txt":@"购买刷卡器",@"bgicon":@"mao8.png",@"img_select":@"paySKQ_selected.png"}];
    [btArray addObject:@{@"img": @"phone_normal.png",@"txt":@"话费充值",@"bgicon":@"mao6.png",@"img_select":@"phone_selected.png"}];
    [btArray addObject:@{@"img": @"Qcon_noraml.png",@"txt":@"Q币充值",@"bgicon":@"mao7.png",@"img_select":@"Qcon_selected.png"}];
    [btArray addObject:@{@"img": @"dailishang_normal.png",@"txt":@"代理商",@"bgicon":@"mao2.png",@"img_select":@"dailishang_sel.png"}];
    
   //firstBtn
    [btfirstArray addObject:@{@"img": @"xinyongka_normal.png",@"txt":@"信用卡还款",@"bgicon":@"mao1.png",@"img_select":@"xinyongka_selected.png"}];
    [btfirstArray addObject:@{@"img": @"zhuanzhang_normal.png",@"txt":@"转账汇款",@"bgicon":@"mao2.png",@"img_select":@"zhuanzhang_selected.png"}];
    [btfirstArray addObject:@{@"img": @"xianjin_normal.png",@"txt":@"现金抵用券" ,@"bgicon":@"mao3.png",@"img_select":@"xianjin_selected.png"}];
    [btfirstArray addObject:@{@"img": @"yue_normal.png",@"txt":@"余额查询",@"bgicon":@"mao4.png",@"img_select":@"yue_selected.png"}];
    [btfirstArray addObject:@{@"img": @"paySKQ_normal.png",@"txt":@"购买刷卡器",@"bgicon":@"mao8.png",@"img_select":@"paySKQ_selected.png"}];
    [btfirstArray addObject:@{@"img": @"dailishang_normal.png",@"txt":@"代理商",@"bgicon":@"mao2.png",@"img_select":@"dailishang_sel.png"}];
    
    //btnsecond
    [btsecondArray addObject:@{@"img": @"phone_normal.png",@"txt":@"话费充值",@"bgicon":@"mao6.png",@"img_select":@"phone_selected.png"}];
    [btsecondArray addObject:@{@"img": @"Qcon_noraml.png",@"txt":@"Q币充值",@"bgicon":@"mao7.png",@"img_select":@"Qcon_selected.png"}];
//    [btsecondArray addObject:@{@"img": @"game_normal.png",@"txt":@"游戏充值",@"bgicon":@"mao5.png",@"img_select":@"game_sel.png"}];
    [btsecondArray addObject:@{@"img": @"plane_normalt.png",@"txt":@"飞机票",@"bgicon":@"mao1.png",@"img_select":@"plane_sel.png"}];
    [btsecondArray addObject:@{@"img": @"train_normal.png",@"txt":@"火车票",@"bgicon":@"mao3.png",@"img_select":@"train_selected.png"}];
    [btsecondArray addObject:@{@"img": @"hotel_normal.png",@"txt":@"酒店预订",@"bgicon":@"mao6.png",@"img_select":@"hotel_sel.png"}];
    [btsecondArray addObject:@{@"img": @"sdf_normal.png",@"txt":@"水电煤充值",@"bgicon":@"mao9.png",@"img_select":@"zhuanzhang_selected.png"}];
    [btsecondArray addObject:@{@"img": @"kuaidi_normal.png",@"txt":@"快递查询",@"bgicon":@"mao5.png",@"img_select":@"kuaidi_selected.png"}];
    
    //    [btArray addObject:@{@"img": @"myWallet.png",@"txt":@"我的钱包"}];
    //    [btArray addObject:@{@"img": @"returnLoan.png",@"txt":@"还贷款"}];
    //    [btArray addObject:@{@"img": @"orderPay.png",@"txt":@"订单号付款"}];
    //    [btArray addObject:@{@"img": @"orderQuery.png",@"txt":@"订单查询"}];
    //    [btArray addObject:@{@"img": @"Qcoincharge.png",@"txt":@"新版本"}];
    
    //以前的1.0.7版本的 我就懒得动了
    for (int i=0; i<btArray.count; i++) {
      
        if ([UIScreen mainScreen].bounds.size.height!=568) {
             btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 95+108*(i/3), 80, 80)];
        }else{
             btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 100+120*(i/3), 80, 80)];
        }
        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btArray[i][@"bgicon"]]]];
        
        btImg.userInteractionEnabled= YES;
        
        singleBt = [[UIButton alloc]initWithFrame:CGRectMake(6.5,6.8,67,67)];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btArray[i][@"img"]]] forState:UIControlStateNormal];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btArray[i][@"img_select"]]] forState:UIControlStateHighlighted];

        singleBt.tag = i+1;
        
        [singleBt addTarget:self action:@selector(clickBtAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [btImg addSubview:singleBt];
        
        UILabel *btTxt = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 92, 21)];
        btTxt.backgroundColor = [UIColor clearColor];
        btTxt.textAlignment = LabelAlignmentCenter;
        btTxt.textColor = [UIColor whiteColor];
        btTxt.font = [UIFont boldSystemFontOfSize:13];
        btTxt.text = [NSString stringWithFormat:@"%@",btArray[i][@"txt"]];
        [btImg addSubview:btTxt];
    
        [firstView addSubview:btImg];
    }
    
    //firstbtn
    for (int i=0; i<btfirstArray.count; i++) {
       
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 95+108*(i/3), 80, 80)];
        }else{
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 100+120*(i/3), 80, 80)];
        }

        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btfirstArray[i][@"bgicon"]]]];
        
        btImg.userInteractionEnabled= YES;
        
        singleBt = [[UIButton alloc]initWithFrame:CGRectMake(6.5,6.8,67,67)];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btfirstArray[i][@"img"]]] forState:UIControlStateNormal];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btfirstArray[i][@"img_select"]]] forState:UIControlStateHighlighted];
        
        singleBt.tag = i+1;
        
        [singleBt addTarget:self action:@selector(firstAction:) forControlEvents:UIControlEventTouchUpInside];
       
        [btImg addSubview:singleBt];
        
        UILabel *btTxt = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 92, 21)];
        btTxt.backgroundColor = [UIColor clearColor];
        btTxt.textAlignment = LabelAlignmentCenter;
        btTxt.textColor = [UIColor whiteColor];
        btTxt.font = [UIFont boldSystemFontOfSize:13];
        btTxt.text = [NSString stringWithFormat:@"%@",btfirstArray[i][@"txt"]];
        
        [btImg addSubview:btTxt];
        
        [secondView addSubview:btImg];
    }

    //secondbtn
    for (int i=0; i<btsecondArray.count; i++) {
        
        if ([UIScreen mainScreen].bounds.size.height!=568) {
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 95+108*(i/3), 80, 80)];
        }else{
            btImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+104*(i%3), 100+120*(i/3), 80, 80)];
        }

        [btImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btsecondArray[i][@"bgicon"]]]];
        
        btImg.userInteractionEnabled= YES;
        
        singleBt = [[UIButton alloc]initWithFrame:CGRectMake(6.5,6.8,67,67)];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btsecondArray[i][@"img"]]] forState:UIControlStateNormal];
        [singleBt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btsecondArray[i][@"img_select"]]] forState:UIControlStateHighlighted];
        
        singleBt.tag = i+1;
        [singleBt addTarget:self action:@selector(secondAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [btImg addSubview:singleBt];
        
        UILabel *btTxt = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 92, 21)];
        btTxt.backgroundColor = [UIColor clearColor];
        btTxt.textAlignment = LabelAlignmentCenter;
        btTxt.textColor = [UIColor whiteColor];
        btTxt.font = [UIFont boldSystemFontOfSize:13];
        btTxt.text = [NSString stringWithFormat:@"%@",btsecondArray[i][@"txt"]];
       
        [btImg addSubview:btTxt];
        
        [thirdView addSubview:btImg];
    }
   
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(125, 63, 60, 30)];
    pageControl.numberOfPages = 3;
    pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pageControl];
}

/*
 新版首页的桌面9个图标：
 信用卡还款  转账汇款  现金抵用券
 余额查询    快递查询  购买刷卡器
 话费充值    Q币充值   代理商
 
 第一类：
 信用卡还款  转账汇款   现金抵用券
 余额查询    购买刷卡器 代理商
 
 第二类：
 话费充值    Q币充值     游戏充值
 飞机票预定  火车票预定  酒店预定
 水电煤缴费  快递查询
 */

/*游戏数据太卡 先撤了*/
#pragma btnInMainAction
-(void)secondAction:(UIButton *)sender
{
    NSInteger tagNum = sender.tag;
    
    switch (tagNum) {
        case 1:
        {
            [self onPhoneBtnClicked:sender];
        }
            break;
        case 2:
        {
            [self onQcoinBtnClicked:sender];
        }
            break;
//        case 3:
//        {
//            [self onGameChargeClicked:sender];
//        }
//            break;
        case 3:
        {
            [self planeView:sender];
        }
            break;
        case 4:
        {
            [self trainView:sender];
        }
            break;
        case 5:
        {
            [self hotelview:sender];
        }
            break;
        case 6:
        {
            [self onWaterElecClicked:sender];
        }
            break;
        case 7:
        {
            [self onExpressQueryBtnClicked:sender];
        }
            break;
        case 9:
        {
           
        }
            break;
        default:
            break;
    }
}

-(void)firstAction:(UIButton *)sender
{
    NSInteger tagNum = sender.tag;
    
    switch (tagNum) {
        case 1:
        {
             [self onCreditCardPaymentsBtnClicked:sender];
        }
            break;
        case 2:
        {
            [self onTransferRemittanceBtnClicked:sender];
        }
            break;
        case 3:
        {
            [self onMyCouponBtnClicked:sender];
        }
            break;
        case 4:
        {
            [self onBalanceQueryBtnClicked:sender];
        }
            break;
        case 5:
        {
            [self onOrderPayBtnClicked:sender];
        }
            break;
        case 6:
        {
            [self onAgentClicked:sender];
        }
            break;
        case 7:
        {
           
        }
            break;
        case 8:
        {
           
        }
            break;
        case 9:
        {
           
        }
            break;
            default:
            break;
    }
}



-(void)clickBtAction:(UIButton *)sender
{
    NSInteger tagNum = sender.tag;
    
    switch (tagNum) {
        case 1:
        {
            [self onCreditCardPaymentsBtnClicked:sender];
        }
            break;
        case 2:
        {
            [self onTransferRemittanceBtnClicked:sender];
        }
            break;
        case 3:
        {
            [self onMyCouponBtnClicked:sender];
        }
            break;
        case 4:
        {
            [self onBalanceQueryBtnClicked:sender];
        }
            break;
        case 5:
        {
            [self onExpressQueryBtnClicked:sender];
        }
            break;
        case 6:
        {
           [self IsPayTFBSKtotheMoneyPeople:sender];
        }
            break;
        case 7:
        {
            [self onPhoneBtnClicked:sender];
          
        }
            break;
        case 8:
        {
             [self onQcoinBtnClicked:sender];
        }
            break;
        case 9:
        {
            [self onAgentClicked:sender];
        }
            break;
    
        default:
            break;
    }
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
    if ([NLUtils getAgentid].length<=0||[[NLUtils getAgentid] isEqualToString:@"0"]) {
        [NLUtils showTosatViewWithMessage:@"您还没有成为代理商" inView:self.view hideAfterDelay:1.0 beIndeter:NO];
        return;
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
  /*
    if ([self isUserRegister:NLPushViewType_plane]) {
        UIViewController* vc = [[NLPushViewIntoNav sharePushViewIntoNav] getPushViewIntoNavByType:NLPushViewType_plane];
        [self.navigationController pushViewController:vc animated:YES];
    }
     */
    
     NSURL *URL = [NSURL URLWithString:@"http://u.ctrip.com/union/CtripRedirect.aspx?TypeID=615&sid=451200&allianceid=20230&ouid="];
     SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
     [self.navigationController pushViewController:webViewController animated:YES];
   
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

- (void) doPush
{
    [_hud hide:YES];
    [NLUtils popToLogonVCByHTTPError:self feedOrLeft:1];
}

//后期写个按钮的
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

@end
