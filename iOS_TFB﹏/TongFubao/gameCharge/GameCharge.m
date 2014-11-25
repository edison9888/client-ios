//
//  GameCharge.m
//  TongFubao
//
//  Created by ec on 14-6-9.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "GameCharge.h"
#import "UIViewController+NavigationItem.h"
#import "MobileRechangeHistoryCtr.h"
#import "AllGameCharge.h"
#import "ComGameCharge.h"

@interface GameCharge ()

@property (nonatomic,strong)UIButton *gameBt;
@property (nonatomic,strong)UIButton *comBt;

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) AllGameCharge *allGameView;
@property (nonatomic,strong) ComGameCharge *comGameView;

@end

@implementation GameCharge

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
    self.title = @"游戏充值";
    self.view.backgroundColor = SACOLOR(245, 1.0);
    CGFloat IOS7HEIGHT=IOS7_OR_LATER==YES?64:0;
    [self addRightButtonItemWithImage:[UIImage imageNamed:@"history"]];
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    
    //分类
    _gameBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _gameBt.frame = CGRectMake(0, IOS7HEIGHT, 160, 44);
    [_gameBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_gameBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_gameBt setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0) rect:CGRectMake(0, 0, 160, 44)] forState:UIControlStateNormal];
    [_gameBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0) rect:CGRectMake(0, 0, 160, 44)] forState:UIControlStateSelected];
    [_gameBt addTarget:self action:@selector(clickCategory:) forControlEvents:UIControlEventTouchUpInside];
    [_gameBt setTitle:@"按游戏" forState:UIControlStateNormal];
    _gameBt.selected = YES;
    
    _comBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _comBt.frame = CGRectMake(160, IOS7HEIGHT, 160, 44);
    [_comBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_comBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_comBt setBackgroundImage:[NLUtils createImageWithColor:SACOLOR(219, 1.0) rect:CGRectMake(0, 0, 160, 44)] forState:UIControlStateNormal];
    [_comBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 179, 241, 1.0) rect:CGRectMake(0, 0, 160, 44)] forState:UIControlStateSelected];
    [_comBt addTarget:self action:@selector(clickCategory:) forControlEvents:UIControlEventTouchUpInside];
    [_comBt setTitle:@"按公司" forState:UIControlStateNormal];
    [_comBt setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [self.view addSubview:_gameBt];
    [self.view addSubview:_comBt];
    
    //滚动视图
    CGFloat scrollViewH = [NLUtils getDeviceHeight]-108;
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT+44, 320, scrollViewH)];
    _allGameView = [[AllGameCharge alloc]init];
    _allGameView.view.frame = CGRectMake(0, 0, 320, scrollViewH);
    [_mainScrollView addSubview:_allGameView.view];
    
    _comGameView = [[ComGameCharge alloc]init];
    _comGameView.view.frame = CGRectMake(320, 0, 320, scrollViewH);
    [_mainScrollView addSubview:_comGameView.view];
    
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
        [_mainScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
        [_comGameView getComGameList];
    }
}

-(void)rightItemClick:(id)sender{
    
    MobileRechangeHistoryCtr *mobileRechangeHistoryCtr = [[MobileRechangeHistoryCtr alloc]initWithNibName:@"MobileRechangeHistoryCtr" bundle:nil];
    mobileRechangeHistoryCtr.myChargeHistoryType = GameType;
    [self.navigationController pushViewController:mobileRechangeHistoryCtr animated:YES];
    
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
