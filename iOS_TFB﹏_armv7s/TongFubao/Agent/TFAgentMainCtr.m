//
//  TFAgentMainCtr.m
//  TongFubao
//
//  Created by ec on 14-5-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFAgentMainCtr.h"
#import "NLContants.h"
#import "FeedController.h"
#import "LeftController.h"
#import "NLSlideBroadsideController.h"
#import "TFAgentSearchCtr.h"
#import "TFAgentAddgoodsCtr.h"
#import "ApplyAgentViewControllerNew.h"
//hhz
#import "TFAgentBookCardCtr.h"
#import "MainViewController.h"

#define AGENTNUM 1

@interface TFAgentMainCtr ()

{
    NLProgressHUD *_hud;
    
    //代理商类型
    NSInteger agentTypeId;
    
    UIView *barView;
}


@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (nonatomic,strong) UILabel *todayEarn;
@property (nonatomic,strong) UILabel *totalEarn;
@property (nonatomic,strong) UILabel *monthSellNum;
//@property (nonatomic,strong) UILabel *predictNum;
@property (nonatomic,strong) UILabel *totalDeviceNum;
@property (nonatomic,strong) UILabel *totalUserNum;
@property (nonatomic,strong) UILabel *estimatedIncomeLabel; /*雨*/
@property (nonatomic,strong) UILabel *todayLabel; /*雨*/

@property (nonatomic,strong) NSString *todayEarnStr;
@property (nonatomic,strong) NSString *totalEarnStr;
@property (nonatomic,strong) NSString *monthSellNumStr;
@property (nonatomic,strong) NSString *predictNumStr;
@property (nonatomic,strong) NSString *totalDeviceNumStr;
@property (nonatomic,strong) NSString *totalUserNumStr;


@property (nonatomic,strong) NSString *agentsNo;//代理商号  /*雨*/
@property (nonatomic,strong) NSString *estimatedIncome;//预计收入  /*雨*/

@end

@implementation TFAgentMainCtr

@synthesize agentNumber = _agentNumber;

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
    // Do any additional setup after loading the view from its nib.
    
    agentTypeId = [[NLUtils getAgenttypeid] integerValue];
    
    [self dataInit];
    
    [self UIInit];
    
    [self performSelector:@selector(readagentBaseInfo) withObject:nil afterDelay:0.1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    barView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (barView)
    {
        barView.hidden = NO;
    }
}

-(void)dataInit
{
    _todayEarnStr = @"0"; //本日收益
    _totalEarnStr = @"0"; //历史总收益
    _monthSellNumStr = @"0";  //本月出售设备
    _totalDeviceNumStr = @"0"; //总设备
    _totalUserNumStr = @"0";
    self.agentsNo = @""; /*雨*/
    self.estimatedIncome = @"0"; /*雨*/
}

- (void)UIInit
{
    //标志代理商的
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AgentFlag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    [self setupLeftMenuButton];

    CGRect svFrame = IOS7_OR_LATER? CGRectMake(0, -20, 320, 64) : CGRectMake(0, 0, 320, 44);
    
    barView = [[UIView alloc] initWithFrame:svFrame];
    barView.opaque = YES;
    barView.backgroundColor = RGBACOLOR(0, 102, 156, 1.0);
    [self.navigationController.navigationBar addSubview:barView];
    
    //标题图片
    UIImageView *titleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo@@x"]];
    titleImgView.frame = CGRectMake(100, 0, 106, 44);
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [titleView addSubview:titleImgView];
    
    
    UIButton *titleBtn = [[UIButton alloc]init];
    titleBtn.frame = CGRectMake(250, 0, 50, 44);
    [titleBtn setTitle:@"订卡" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:titleBtn];
    
    self.navigationItem.titleView = titleView;
    self.navigationController.view.backgroundColor = RGBACOLOR(0, 102, 152, 1.0);
    
    //主视图
    _mainScroll.contentSize = CGSizeMake(320, 504);
    _mainScroll.backgroundColor = [UIColor whiteColor];

    UIImageView *topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 304, 160)];
    [topImgView setImage:[[UIImage imageNamed:@"btnbg@2x"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 2, 10, 2) resizingMode:UIImageResizingModeStretch]];
    
    UIImageView *earnFlag = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 15, 13)];
    [earnFlag setImage:[UIImage imageNamed:@"board"]];
    [topImgView addSubview:earnFlag];
    
    self.todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 13, 270, 20)];
    self.todayLabel.textColor = [UIColor whiteColor];
    self.todayLabel.backgroundColor = [UIColor clearColor];
    self.todayLabel.font = [UIFont fontWithName:TFB_FONT size:14];
//    self.todayLabel.text = [NSString stringWithFormat:@"代理商%@, 您今天的收益（元）",self.agentsNo];
    self.todayLabel.text = [NSString stringWithFormat:@"%@",@"您今天的收益（元）"];
    [topImgView addSubview:self.todayLabel];
    
    _todayEarn = [[UILabel alloc]initWithFrame:CGRectMake(4, 35, 300, 80)];
    _todayEarn.font = [UIFont fontWithName:TFB_FONT size:62.0f];
    _todayEarn.textColor = [UIColor whiteColor];
    _todayEarn.backgroundColor = [UIColor clearColor];
    _todayEarn.text = _todayEarnStr;
    [topImgView addSubview:_todayEarn];
    
    self.estimatedIncomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 110, 280, 21)];
    self.estimatedIncomeLabel.backgroundColor = [UIColor clearColor];
    self.estimatedIncomeLabel.textColor = [UIColor redColor];
    self.estimatedIncomeLabel.font = [UIFont fontWithName:TFB_FONT size:14];
    self.estimatedIncomeLabel.text = [NSString stringWithFormat:@"(+%@)",self.estimatedIncome ];
//    [topImgView addSubview:self.estimatedIncomeLabel];
    
    _totalEarn = [[UILabel alloc]initWithFrame:CGRectMake(8, 131, 290, 25)];
    _totalEarn.font = [UIFont fontWithName:TFB_FONT size:16];
    _totalEarn.textColor = RGBACOLOR(153, 33, 29, 1.0);
    _totalEarn.backgroundColor = [UIColor clearColor];
    _totalEarn.text = [NSString stringWithFormat:@"本区历史总收益%@元",_totalEarnStr];
    [topImgView addSubview:_totalEarn];
    
    [_mainScroll addSubview:topImgView];
    
    UIView *yellowView = [UIButton buttonWithType:UIButtonTypeCustom];
    yellowView.frame = CGRectMake(8, 178, 148, 100);
    yellowView.backgroundColor = RGBACOLOR(191, 113, 95, 1.0);
    [_mainScroll addSubview:yellowView];
    
    UILabel *sellLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 120, 20)];
    sellLabel.textColor = [UIColor whiteColor];
    sellLabel.backgroundColor = [UIColor clearColor];
    sellLabel.font = [UIFont fontWithName:TFB_FONT size:14];
    [yellowView addSubview:sellLabel];
    
    _monthSellNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 148, 40)];
    _monthSellNum.textAlignment = NSTextAlignmentCenter;
    _monthSellNum.textColor = RGBACOLOR(64, 145, 30, 1.0);
    _monthSellNum.backgroundColor = [UIColor clearColor];
    _monthSellNum.font = [UIFont fontWithName:TFB_FONT size:28];
    [yellowView addSubview:_monthSellNum];
    
    //本区用户数 /销售数量 (正式 虚拟)
    if (agentTypeId == AGENTNUM)
    {
        sellLabel.text = @"本月销量（台）";
        _monthSellNum.text = _monthSellNumStr;
    }
    else
    {
        sellLabel.text = @"本区用户数";
        _monthSellNum.text = _totalUserNumStr;
    }
    
    UIView *greenView = [UIButton buttonWithType:UIButtonTypeCustom];
    greenView.frame = CGRectMake(164, 178, 148, 100);
    greenView.backgroundColor = RGBACOLOR(149, 182, 69, 1.0);
    [_mainScroll addSubview:greenView];
    
    UILabel *totalDeviceNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 130, 20)];
    totalDeviceNumLabel.textColor = [UIColor whiteColor];
    totalDeviceNumLabel.backgroundColor = [UIColor clearColor];
    totalDeviceNumLabel.font = [UIFont fontWithName:TFB_FONT size:14];
    totalDeviceNumLabel.text = @"本区刷卡器（台）";
    [greenView addSubview:totalDeviceNumLabel];
    
    _totalDeviceNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 148, 35)];
    _totalDeviceNum.textColor = RGBACOLOR(225, 46, 42, 1.0);
    _totalDeviceNum.backgroundColor = [UIColor clearColor];
    _totalDeviceNum.font = [UIFont fontWithName:TFB_FONT size:28];
    _totalDeviceNum.text = _totalDeviceNumStr;
    _totalDeviceNum.textAlignment = UITextAlignmentCenter;
    [greenView addSubview:_totalDeviceNum];
    
    UIButton *pinkView = [UIButton buttonWithType:UIButtonTypeCustom];
    pinkView.frame = CGRectMake(8, 288, 148, 100);
    pinkView.backgroundColor = RGBACOLOR(180, 121, 167, 1.0);
    
    if ([[NLUtils getAgenttypeid] isEqualToString: @"1"]) {
        pinkView.userInteractionEnabled= NO;
    }else
    {
        pinkView.userInteractionEnabled= YES;
    }
    [pinkView addTarget:self action:@selector(applyAgentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:pinkView];
    
    if (agentTypeId == AGENTNUM)
    {
        UILabel *totalUserNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 100, 20)];
        totalUserNumLabel.textColor = [UIColor whiteColor];
        totalUserNumLabel.backgroundColor = [UIColor clearColor];
        totalUserNumLabel.font = [UIFont fontWithName:TFB_FONT size:14];
        totalUserNumLabel.text = @"本区用户数";
        [pinkView addSubview:totalUserNumLabel];
        
        
        
        
        _totalUserNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 148, 35)];
        _totalUserNum.textColor = [UIColor whiteColor];
        _totalUserNum.backgroundColor = [UIColor clearColor];
        _totalUserNum.font = [UIFont fontWithName:TFB_FONT size:28];
        _totalUserNum.text = _totalUserNumStr;
        _totalUserNum.textAlignment = UITextAlignmentCenter;
        [pinkView addSubview:_totalUserNum];
    }
    else
    {
        UIImageView *applyImage = [[UIImageView alloc] initWithFrame:CGRectMake(51, 20, 46, 30)];
        applyImage.image = imageName(@"申请正式@2x", @"png");
        [pinkView addSubview:applyImage];
        
        UILabel *applyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 148, 20)];
        applyLabel.opaque = YES;
        applyLabel.backgroundColor = [UIColor clearColor];
        applyLabel.textAlignment = UITextAlignmentCenter;
        applyLabel.textColor = [UIColor whiteColor];
        applyLabel.font = [UIFont fontWithName:TFB_FONT size:14];
        applyLabel.text = @"正式申请";
        [pinkView addSubview:applyLabel];
    }
    
    //补货
    UIButton *addGoodsBt = [UIButton buttonWithType:UIButtonTypeCustom];
    addGoodsBt.frame = CGRectMake(164, 288, 148, 100);
    [addGoodsBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(43, 179, 187, 1.0) rect:CGRectMake(0, 0, 148, 100)] forState:UIControlStateNormal];
    [addGoodsBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(252, 211, 161, 1.0) rect:CGRectMake(0, 0, 148, 100)] forState:UIControlStateHighlighted];
    
    UIImageView *addgoodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(51, 20, 46, 30)];
    [addgoodsImg setImage:[UIImage imageNamed:@"addgoods"]];
    [addGoodsBt addSubview:addgoodsImg];
    
    UILabel *addgoodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 148, 20)];
    addgoodsLabel.textColor = [UIColor whiteColor];
    addgoodsLabel.backgroundColor = [UIColor clearColor];
    addgoodsLabel.font = [UIFont fontWithName:TFB_FONT size:14];
    addgoodsLabel.text = @"我要补货";
    addgoodsLabel.textAlignment = UITextAlignmentCenter;
    [addGoodsBt addSubview:addgoodsLabel];
    [addGoodsBt addTarget:self action:@selector(clickAddGood) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScroll addSubview:addGoodsBt];
    
    //查询
    UIButton *searchBt = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBt.frame = CGRectMake(8, 398, 148, 100);
    [searchBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(140, 152, 204, 1.0) rect:CGRectMake(0, 0, 148, 100)] forState:UIControlStateNormal];
    [searchBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(161, 175, 233, 1.0) rect:CGRectMake(0, 0, 148, 100)] forState:UIControlStateHighlighted];
    [_mainScroll addSubview:searchBt];
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(51, 20, 46, 30)];
    [searchImg setImage:[UIImage imageNamed:@"search"]];
    [searchBt addSubview:searchImg];
    
    UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 148, 20)];
    searchLabel.textColor = [UIColor whiteColor];
    searchLabel.backgroundColor = [UIColor clearColor];
    searchLabel.font = [UIFont fontWithName:TFB_FONT size:14];
    searchLabel.text = @"查询历史收益";
    searchLabel.textAlignment = UITextAlignmentCenter;
    [searchBt addSubview:searchLabel];
    [searchBt addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    
    //我的通付宝
    UIButton *myTFBBt = [UIButton buttonWithType:UIButtonTypeCustom];
    myTFBBt.frame = CGRectMake(164, 398, 148, 100);
    [myTFBBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(94, 161, 191, 1.0) rect:CGRectMake(0, 0, 148, 100)] forState:UIControlStateNormal];
    [myTFBBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(171, 224, 248, 1.0) rect:CGRectMake(0, 0, 148, 100)] forState:UIControlStateHighlighted];
    [myTFBBt addTarget:self action:@selector(clickTFB) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:myTFBBt];
    
    UIImageView *TFBImg = [[UIImageView alloc]initWithFrame:CGRectMake(51, 20, 46, 30)];
    [TFBImg setImage:[UIImage imageNamed:@"home"]];
    [myTFBBt addSubview:TFBImg];
    
    UILabel *TFBLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 148, 20)];
    TFBLabel.textColor = [UIColor whiteColor];
    TFBLabel.backgroundColor = [UIColor clearColor];
    TFBLabel.font = [UIFont fontWithName:TFB_FONT size:14];
    TFBLabel.text = @"我的通付宝";
    TFBLabel.textAlignment = UITextAlignmentCenter;
    [myTFBBt addSubview:TFBLabel];
}

#pragma mark - 正式申请代理商
- (void)applyAgentBtnAction:(UIButton *)sender
{
    ApplyAgentViewControllerNew *applyView = [[ApplyAgentViewControllerNew alloc] init];
    [self.navigationController pushViewController:applyView animated:YES];
}

//我要补货
- (void)clickAddGood
{
    TFAgentAddgoodsCtr *agentAddgoodsCtr = [[TFAgentAddgoodsCtr alloc]init];
    agentAddgoodsCtr.title = @"刷卡器补货";
    [agentAddgoodsCtr addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self.navigationController pushViewController:agentAddgoodsCtr animated:YES];
}

#pragma mark - 点击查询
- (void)clickSearch
{
    TFAgentSearchCtr *agentSearchCtr = [[TFAgentSearchCtr alloc]init];
    agentSearchCtr.title = @"查询历史收益";
    [agentSearchCtr addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
//    MainViewController *agentSearchCtr = [[MainViewController alloc]init];
    [self.navigationController pushViewController:agentSearchCtr animated:YES];
}

#pragma mark - 点击我的通付宝
- (void)clickTFB
{
    NLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate backToMain];
}

#pragma mark - 读取代理商信息
- (void)readagentBaseInfo
{
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    [NLUtils get_au_token];
    NSString* name = [NLUtils getNameForRequest:Notify_readagentinfo];
    REGISTER_NOTIFY_OBSERVER(self, readagentinfoNotify, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] readagentinfo];
}

- (void)readagentinfoNotify:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (RSP_NO_ERROR == error)
    {
        [_hud hide:YES];
        
        [self doReadagentinfoNotify:response];
     
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
            detail = @"服务器繁忙，请稍候再试";
        }
        
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
}

#pragma mark - 哈哈哈
-(void)doReadagentinfoNotify:(NLProtocolResponse *)response
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
        data = [response.data find:@"msgbody/todayfenrun" index:0];
        _todayEarnStr = data.value;
        data = [response.data find:@"msgbody/areafenrun" index:0];
        _totalEarnStr = data.value;
        data = [response.data find:@"msgbody/salepaycardnum" index:0];
        _monthSellNumStr = [data.value componentsSeparatedByString:@"|"][0];
        _predictNumStr = [[data.value componentsSeparatedByString:@"|"] lastObject];
        data = [response.data find:@"msgbody/areapaycardnum" index:0];
        _totalDeviceNumStr = data.value;
        data = [response.data find:@"msgbody/areaauthornum" index:0];
        _totalUserNumStr = data.value;
        

        data = [response.data find:@"msgbody/agentno" index:0];//代理商号 /*雨*/
        self.agentsNo = data.value;
        
        data = [response.data find:@"msgbody/todayyufenrun" index:0];//预计收入 /*雨*/
        self.estimatedIncome = data.value;
        if (self.estimatedIncome.length <=0) {
            self.estimatedIncome = @"0";
        }
        
        
//        self.todayLabel.text = [NSString stringWithFormat:@"代理商%@, 您今天的收益（元）",self.agentsNo];//代理商号 /*雨*/
//        self.estimatedIncomeLabel.text = [NSString stringWithFormat:@"(+%@)",self.estimatedIncome ];//预计收入 /*雨*/
        
        
        //本区用户数 /销售数量 (正式 虚拟)
        _monthSellNum.text = agentTypeId == AGENTNUM ? _monthSellNumStr : _totalUserNumStr;
        
        _todayEarn.text = _todayEarnStr;
        _totalEarn.text = [NSString stringWithFormat:@"本区历史总收益%@元",_totalEarnStr];
        _totalDeviceNum.text = _totalDeviceNumStr;
    }
}

//左击
-(void)setupLeftMenuButton
{
    NLSlideBroadsideController* slider = [[NLSlideBroadsideController alloc] init];
    UIBarButtonItem* item = [slider setupNavigationItemMenuButton:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender
{
    NLSlideBroadsideController* slider = [[NLSlideBroadsideController alloc] init];
    [slider onDrawerButtonPressed:NLSlideBroadsideCenterControllerMenuLeft viewController:self];
}

//超时
- (void)doPush
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
            
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]];
            
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

// hhz-右边导航
-(void)rightItemClick:(id)sender
{
    NSLog(@"右边导航");
    TFAgentBookCardCtr *bookcardView = [[TFAgentBookCardCtr alloc]init];
    [bookcardView setTitle:@"汇通卡订购"];
    [bookcardView addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    [self.navigationController pushViewController:bookcardView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











