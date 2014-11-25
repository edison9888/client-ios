//
//  planeChage.m
//  TongFubao
//
//  Created by  俊   on 14-7-3.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "planeChage.h"
#import "UIViewController+NavigationItem.h"
#import "EnterViewController.h"
#import "MobileRechangeHistoryCtr.h"
#import "planeCity.h"

@interface planeChage ()

@property (nonatomic,strong) UIButton *gameBt;
@property (nonatomic,strong) UIButton *comBt;
@property (nonatomic,strong) NSDictionary *information;

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) planeCity *planeCity;

@end

@implementation planeChage

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

    //生成导航栏右按扭
    [self createRightBarButton];
}

- (void)createRightBarButton
{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)rightBarButtonAction:(UIBarButtonItem *)sender
{
    EnterViewController *enterView = [[EnterViewController alloc] init];
    [self.navigationController pushViewController:enterView animated:YES];
}

-(id)initWithInfor:(NSDictionary*)infor
{
    if (self = [super init]) {
        if (infor) {
            _information = [NSDictionary dictionaryWithDictionary:infor];
        }else{
            _information = [NSDictionary dictionary];
        }
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NLUtils enableSliderViewController:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([TFData getTempData][RECORD_COM_FLAG]) {
        [_mainScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
        [[TFData getTempData]removeObjectForKey:RECORD_COM_FLAG];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NLUtils enableSliderViewController:YES];
}

-(void)UIInit
{
    self.title = @"城市选择";
    self.view.backgroundColor = SACOLOR(245, 1.0);
    CGFloat IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
   
    [self addRightButtonItemWithTitle:@"确认"];
    
    //分类
    _gameBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _gameBt.frame = CGRectMake(0, IOS7HEIGHT, 160, 44);
    [_gameBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_gameBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_gameBt setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0) rect:CGRectMake(0, 0, 160, 44)] forState:UIControlStateNormal];
    [_gameBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0) rect:CGRectMake(0, 0, 160, 44)] forState:UIControlStateSelected];
    [_gameBt addTarget:self action:@selector(clickCategory:) forControlEvents:UIControlEventTouchUpInside];
    [_gameBt setTitle:@"出发" forState:UIControlStateNormal];
    _gameBt.selected = YES;
    
    _comBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _comBt.frame = CGRectMake(160, IOS7HEIGHT, 160, 44);
    [_comBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_comBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_comBt setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0) rect:CGRectMake(0, 0, 160, 44)] forState:UIControlStateNormal];
    [_comBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0) rect:CGRectMake(0, 0, 160, 44)] forState:UIControlStateSelected];
    [_comBt addTarget:self action:@selector(clickCategory:) forControlEvents:UIControlEventTouchUpInside];
    [_comBt setTitle:@"到达" forState:UIControlStateNormal];
    [_comBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:_gameBt];
    [self.view addSubview:_comBt];
    
    //滚动视图
    CGFloat scrollViewH = [NLUtils getDeviceHeight] - 108;
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT + 44, 320, scrollViewH)];
    _planeCity = [[planeCity alloc]init];
    _planeCity.view.frame = CGRectMake(0, 0, 320, scrollViewH);
    [_mainScrollView addSubview:_planeCity.view];
    
    _mainScrollView.scrollEnabled = NO;
    [self.view addSubview:_mainScrollView];
}

-(void)clickCategory:(UIButton *)sender
{
    if (sender==_gameBt) {
        _gameBt.selected = YES;
        _comBt.selected =  NO;
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        _gameBt.selected = NO;
        _comBt.selected =  YES;
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
