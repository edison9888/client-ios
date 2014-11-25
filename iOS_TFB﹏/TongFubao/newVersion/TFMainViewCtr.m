//
//  TFMainViewCtr.m
//  TongFubao
//
//  Created by ec on 14-5-23.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "TFMainViewCtr.h"
#import "NLUtils.h"
#import "NLContants.h"

@interface TFMainViewCtr ()

{
    CGFloat IOS7HEIGHT;
}

@property (nonatomic,strong) NSMutableArray *btArr;  //存储按钮数组

@property (nonatomic,strong) UIImageView *deltaImgView; //倒三角图标

@property (nonatomic,strong)  UIScrollView *mainScroll; //滚动视图


@end

@implementation TFMainViewCtr

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

-(void)UIInit
{
    self.navigationController.delegate = self;
    self.view.backgroundColor = SACOLOR(208, 1.0);

    IOS7HEIGHT=IOS7_OR_LATER==YES?20:0;
     CGFloat ctrH = [NLUtils getCtrHeight];
    
    //电池栏
    if (IOS7_OR_LATER) {
        UIView *headStatusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        headStatusBar.backgroundColor = RGBACOLOR(18, 142, 227, 1.0);
        [self.view addSubview:headStatusBar];
    }
    
    //头部 指示bar
    UIView *headBarView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT, 320, 44)];
    headBarView.backgroundColor = RGBACOLOR(18, 142, 227, 1.0);
    [self.view addSubview:headBarView];
    
    //头按钮
    _btArr = [NSMutableArray array];
    
    UIButton *getBt = [UIButton buttonWithType:UIButtonTypeCustom];
    getBt.tag = 0;
    getBt.frame = CGRectMake(13, 8, 50, 25);
    [getBt setTitle:@"收款" forState:UIControlStateNormal];
    getBt.titleLabel.font = [UIFont systemFontOfSize:17];
    [getBt setTitleColor:SACOLOR(255, 0.4) forState:UIControlStateNormal];
    [getBt addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [headBarView addSubview:getBt];
    [_btArr addObject:getBt];
    
    UIButton *payBt = [UIButton buttonWithType:UIButtonTypeCustom];
    payBt.tag = 1;
    payBt.frame = CGRectMake(138, 8, 50, 25);
    [payBt setTitle:@"支付" forState:UIControlStateNormal];
    payBt.titleLabel.font = [UIFont systemFontOfSize:19];
    [payBt addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [headBarView addSubview:payBt];
    payBt.selected = YES;
    [_btArr addObject:payBt];

    UIButton *searchBt = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBt.tag =2;
    searchBt.frame = CGRectMake(260, 8, 50, 25);
    [searchBt setTitle:@"查询" forState:UIControlStateNormal];
    searchBt.titleLabel.font = [UIFont systemFontOfSize:17];
    [searchBt setTitleColor:SACOLOR(255, 0.4) forState:UIControlStateNormal];
    [searchBt addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [headBarView addSubview:searchBt];
    [_btArr addObject:searchBt];
    
    
    //倒三角
    _deltaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(154, IOS7HEIGHT+36, 14, 8)];
    [_deltaImgView setImage:[UIImage imageNamed:@"delta"]];
    [self.view addSubview:_deltaImgView];
    
    //滚动视图
    CGFloat scrollViewH = [NLUtils getDeviceHeight]-BATTERY_HEIGHT - NAVBAR_HEIGHT;
    CGFloat scrollViewContentH = 504;
    _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS7HEIGHT+44, 320, scrollViewH)];
    _mainScroll.delegate = self;
    _mainScroll.pagingEnabled = YES;
    _mainScroll.bounces = NO;
    _mainScroll.directionalLockEnabled = YES;
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.contentSize = CGSizeMake(320*3, scrollViewContentH);
    _mainScroll.contentOffset = CGPointMake(320, 0);
    [self.view addSubview:_mainScroll];
    
    //收款
    UIView *getView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, scrollViewContentH)];
    
    [_mainScroll addSubview:getView];
    
    //支付
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, scrollViewContentH)];
    payView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:payView];
    
    //转账汇款
    UIButton *transferBt = [UIButton buttonWithType:UIButtonTypeCustom];
    transferBt.frame = CGRectMake(9, 19, 200, 108);
    [transferBt setBackgroundImage:[NLUtils createImageWithColor:[UIColor clearColor] rect:CGRectMake(0, 0, 200, 108)] forState:UIControlStateNormal];
    [transferBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(28, 161, 226, 1.0) rect:CGRectMake(0, 0, 200, 108)] forState:UIControlStateNormal];
    [transferBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(96, 189, 235, 1.0) rect:CGRectMake(0, 0, 200, 108)] forState:UIControlStateHighlighted];
    UILabel *transferTXT = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 70, 20)];
    transferTXT.backgroundColor = [UIColor clearColor];
    transferTXT.text = @"转账汇款";
    transferTXT.font = [UIFont boldSystemFontOfSize:16];
    transferTXT.textColor = [UIColor whiteColor];
    UIImageView *tranImg = [[UIImageView alloc]initWithFrame:CGRectMake(125, 45, 50, 50)];
    [tranImg setImage:[UIImage imageNamed:@"transfer"]];
    [transferBt addSubview:transferTXT];
    [transferBt addSubview:tranImg];
    [payView addSubview:transferBt];

    //当面付
    UIButton *facePayBt = [UIButton buttonWithType:UIButtonTypeCustom];
    facePayBt.frame = CGRectMake(218, 19, 93, 108);
    [facePayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(64, 177, 62, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateNormal];
    [facePayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(68, 195, 66, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateHighlighted];
    UILabel *facePayTXT = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 93, 20)];
    facePayTXT.backgroundColor = [UIColor clearColor];
    facePayTXT.text = @"当面付";
    facePayTXT.textAlignment = UITextAlignmentCenter;
    facePayTXT.font = [UIFont boldSystemFontOfSize:16];
    facePayTXT.textColor = [UIColor whiteColor];
    UIImageView *facePayImg = [[UIImageView alloc]initWithFrame:CGRectMake(21, 45, 50, 50)];
    [facePayImg setImage:[UIImage imageNamed:@"facePay"]];
    [facePayBt addSubview:facePayTXT];
    [facePayBt addSubview:facePayImg];
    [payView addSubview:facePayBt];
    
    //信用卡还款
    UIButton *creditCardPayBt = [UIButton buttonWithType:UIButtonTypeCustom];
    creditCardPayBt.frame = CGRectMake(9, 135, 96, 108);
    [creditCardPayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(254, 175, 0, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateNormal];
    [creditCardPayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(251, 189, 51, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateHighlighted];
    UILabel *creditCardPayTXT = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 96, 20)];
    creditCardPayTXT.backgroundColor = [UIColor clearColor];
    creditCardPayTXT.text = @"信用卡还款";
    creditCardPayTXT.textAlignment = UITextAlignmentCenter;
    creditCardPayTXT.font = [UIFont boldSystemFontOfSize:16];
    creditCardPayTXT.textColor = [UIColor whiteColor];
    UIImageView *creditCardPayImg = [[UIImageView alloc]initWithFrame:CGRectMake(23, 40, 50, 50)];
    [creditCardPayImg setImage:[UIImage imageNamed:@"creditCardPay"]];
    [creditCardPayBt addSubview:creditCardPayTXT];
    [creditCardPayBt addSubview:creditCardPayImg];
    [payView addSubview:creditCardPayBt];
    
    //游戏充值
    UIButton *gameChargeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    gameChargeBt.frame = CGRectMake(113, 135, 96, 108);
    [gameChargeBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(21, 191, 190, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateNormal];
    [gameChargeBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(29, 201, 200, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateHighlighted];
    UILabel *gameChargeTXT = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 96, 20)];
    gameChargeTXT.backgroundColor = [UIColor clearColor];
    gameChargeTXT.text = @"游戏充值";
    gameChargeTXT.textAlignment = UITextAlignmentCenter;
    gameChargeTXT.font = [UIFont boldSystemFontOfSize:16];
    gameChargeTXT.textColor = [UIColor whiteColor];
    UIImageView *gameChargeImg = [[UIImageView alloc]initWithFrame:CGRectMake(23, 40, 50, 50)];
    [gameChargeImg setImage:[UIImage imageNamed:@"gameCharge"]];
    [gameChargeBt addSubview:gameChargeTXT];
    [gameChargeBt addSubview:gameChargeImg];
    [payView addSubview:gameChargeBt];
    

    //向好友付款
    UIButton *friendPayBt = [UIButton buttonWithType:UIButtonTypeCustom];
    friendPayBt.frame = CGRectMake(218, 135, 93, 225);
    [friendPayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(232, 99, 183, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateNormal];
    [friendPayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(242, 117, 196, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateHighlighted];
    UILabel *friendPayTXT = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 93, 20)];
    friendPayTXT.backgroundColor = [UIColor clearColor];
    friendPayTXT.text = @"向好友付款";
    friendPayTXT.textAlignment = UITextAlignmentCenter;
    friendPayTXT.font = [UIFont boldSystemFontOfSize:16];
    friendPayTXT.textColor = [UIColor whiteColor];
    UIImageView *friendPayImg = [[UIImageView alloc]initWithFrame:CGRectMake(21, 42, 50, 50)];
    [friendPayImg setImage:[UIImage imageNamed:@"friendPay"]];
    
    UILabel *friendPayMORETXT = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 93, 70)];
    friendPayMORETXT.backgroundColor = [UIColor clearColor];
    friendPayMORETXT.numberOfLines = 3;
    friendPayMORETXT.text = @"通讯录\n微信\nQQ";
    friendPayMORETXT.textAlignment = UITextAlignmentCenter;
    friendPayMORETXT.font = [UIFont boldSystemFontOfSize:16];
    friendPayMORETXT.textColor = [UIColor whiteColor];

    [friendPayBt addSubview:friendPayTXT];
    [friendPayBt addSubview:friendPayImg];
    [friendPayBt addSubview:friendPayMORETXT];
    [payView addSubview:friendPayBt];
    
    //信用变现
    UIButton *creditCardCashBt = [UIButton buttonWithType:UIButtonTypeCustom];
    creditCardCashBt.frame = CGRectMake(9, 252, 96, 108);
    [creditCardCashBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(235, 70, 168, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateNormal];
    [creditCardCashBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(243, 87, 179, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateHighlighted];
    UILabel *creditCardCashTXT = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 96, 20)];
    creditCardPayTXT.backgroundColor = [UIColor clearColor];
    creditCardCashTXT.text = @"信用变现";
    creditCardCashTXT.textAlignment = UITextAlignmentCenter;
    creditCardCashTXT.font = [UIFont boldSystemFontOfSize:16];
    creditCardCashTXT.textColor = [UIColor whiteColor];
    UIImageView *creditCardCashImg = [[UIImageView alloc]initWithFrame:CGRectMake(23, 40, 50, 50)];
    [creditCardCashImg setImage:[UIImage imageNamed:@"creditCardCash"]];
    [creditCardCashBt addSubview:creditCardCashTXT];
    [creditCardCashBt addSubview:creditCardCashImg];
    [payView addSubview:creditCardCashBt];
    
    //订单付款
    UIButton *orderPayBt = [UIButton buttonWithType:UIButtonTypeCustom];
    orderPayBt.frame = CGRectMake(113, 252, 96, 108);
    [orderPayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(185, 171, 168, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateNormal];
    [orderPayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(197, 184, 182, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateHighlighted];
    UILabel *orderPayTXT = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 96, 20)];
    orderPayTXT.backgroundColor = [UIColor clearColor];
    orderPayTXT.text = @"订单付款";
    orderPayTXT.textAlignment = UITextAlignmentCenter;
    orderPayTXT.font = [UIFont boldSystemFontOfSize:16];
    orderPayTXT.textColor = [UIColor whiteColor];
    UIImageView *orderPayImg = [[UIImageView alloc]initWithFrame:CGRectMake(23, 40, 50, 50)];
    [orderPayImg setImage:[UIImage imageNamed:@"orderPayImg"]];
    [orderPayBt addSubview:orderPayTXT];
    [orderPayBt addSubview:orderPayImg];
    [payView addSubview:orderPayBt];
    
    //水电缴费
    UIButton *hydroelectricityPayBt = [UIButton buttonWithType:UIButtonTypeCustom];
    hydroelectricityPayBt.frame = CGRectMake(9, 369, 200, 108);
    [hydroelectricityPayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(155, 209, 48, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateNormal];
    [hydroelectricityPayBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(168, 218, 59, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateHighlighted];
    UILabel *hydroelectricityPayTXT = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 70, 20)];
    hydroelectricityPayTXT.backgroundColor = [UIColor clearColor];
    hydroelectricityPayTXT.text = @"水电缴费";
    hydroelectricityPayTXT.font = [UIFont boldSystemFontOfSize:16];
    hydroelectricityPayTXT.textColor = [UIColor whiteColor];
    UIImageView *hydroelectricityPayImg = [[UIImageView alloc]initWithFrame:CGRectMake(125, 45, 50, 50)];
    [hydroelectricityPayImg setImage:[UIImage imageNamed:@"hydroelectricityPay"]];
    [hydroelectricityPayBt addSubview:hydroelectricityPayTXT];
    [hydroelectricityPayBt addSubview:hydroelectricityPayImg];
    [payView addSubview:hydroelectricityPayBt];
    
    //手机充值
    UIButton *mobileChargeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    mobileChargeBt.frame = CGRectMake(218, 369, 93, 108);
    [mobileChargeBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(241, 108, 50, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateNormal];
    [mobileChargeBt setBackgroundImage:[NLUtils createImageWithColor:RGBACOLOR(247, 117, 60, 1.0) rect:CGRectMake(0, 0, 93, 108)] forState:UIControlStateHighlighted];
    UILabel *mobileChargeTXT = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 93, 20)];
    mobileChargeTXT.backgroundColor = [UIColor clearColor];
    mobileChargeTXT.text = @"手机充值";
    mobileChargeTXT.textAlignment = UITextAlignmentCenter;
    mobileChargeTXT.font = [UIFont boldSystemFontOfSize:16];
    mobileChargeTXT.textColor = [UIColor whiteColor];
    UIImageView *mobileChargeImg = [[UIImageView alloc]initWithFrame:CGRectMake(21, 45, 50, 50)];
    [mobileChargeImg setImage:[UIImage imageNamed:@"mobileCharge"]];
    [mobileChargeBt addSubview:mobileChargeTXT];
    [mobileChargeBt addSubview:mobileChargeImg];
    [payView addSubview:mobileChargeBt];
    
    //查询
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(640, 0, 320, scrollViewContentH)];
    searchView.backgroundColor = [UIColor greenColor];
    [_mainScroll addSubview:searchView];
    
    //更多按钮
    UIButton *moreBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBt setImage:[UIImage imageNamed:@"main_more_normal"] forState:UIControlStateNormal];
    [moreBt setImage:[UIImage imageNamed:@"main_more_press"] forState:UIControlStateHighlighted];
    moreBt.frame = CGRectMake(0, ctrH-39, 57, 30);
    [self.view addSubview:moreBt];
}

-(void)clickSelect:(UIButton *)sender
{
    
    sender.selected = YES;
    NSInteger tag = sender.tag;
    
    //字体
    for (int i=0; i<_btArr.count; i++) {
        UIButton *bt = _btArr[i];
        if (tag == bt.tag) {
            bt.titleLabel.font = [UIFont systemFontOfSize:19];
            [bt setTitleColor:SACOLOR(255, 1.0) forState:UIControlStateNormal];
        }else{
            bt.titleLabel.font = [UIFont systemFontOfSize:17];
            [bt setTitleColor:SACOLOR(255, 0.4) forState:UIControlStateNormal];

        }
    }
    
    //三角形动态效果
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^void{
        _deltaImgView.frame = CGRectMake(24+tag*130, IOS7HEIGHT+36, 14, 8);
    }completion:nil];
    
    //scrollview 滚动
    _mainScroll.contentOffset = CGPointMake(320*tag, 0);
}

#pragma mark scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offX = scrollView.contentOffset.x;
    _deltaImgView.frame = CGRectMake(24+offX*130/320, IOS7HEIGHT+36, 14, 8);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    CGFloat offX = scrollView.contentOffset.x;
    NSInteger tag = offX/320;
    for (int i=0; i<_btArr.count; i++) {
        UIButton *bt = _btArr[i];
        if (tag == bt.tag) {
            bt.selected = YES;
            bt.titleLabel.font = [UIFont systemFontOfSize:19];
            [bt setTitleColor:SACOLOR(255, 1.0) forState:UIControlStateNormal];
        }else{
            bt.titleLabel.font = [UIFont systemFontOfSize:17];
            [bt setTitleColor:SACOLOR(255, 0.4) forState:UIControlStateNormal];
            
        }
    }

}


#pragma mark
-(void)push
{
    UIViewController *viewCtr = [[UIViewController alloc]init];
    viewCtr.view.backgroundColor = [UIColor greenColor];
    viewCtr.title = @"二级";
    
    [self.navigationController pushViewController:viewCtr animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isMemberOfClass:[self class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
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
