//
//  SMSNewBankCardViewController.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSNewBankCardViewController.h"


@interface SMSNewBankCardViewController ()

@property(assign,nonatomic)int state;//状态

@end

@implementation SMSNewBankCardViewController


-(void)tapleftBarButtonItemBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"添加银行卡";
   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    
    
    self.slideSwitchView =[[SUNSlideSwitchView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    [self.slideSwitchView setSlideSwitchViewDelegate:self];
    [self.view addSubview:self.slideSwitchView];
    
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [UIImage imageNamed:@"red_line_and_shadow.png"];
    
    
    __weak typeof(self) weakSelf = self;
    
    self.creditCardVC = [[SMSCreditCardViewController alloc] init];
    self.creditCardVC.title = @"信用卡";
    self.creditCardVC.setPopBlock=^(){
        [weakSelf pushProductFavorite];
    };
    
    self.theSavingsCardVC = [[SMSTheSavingsCardViewController alloc] init];
    self.theSavingsCardVC.title = @"储蓄卡";
    self.theSavingsCardVC.setPopBlock=^(){
        [weakSelf pushStoreFavorite];
    };
    
    [self.slideSwitchView buildUI];
    
    
}


-(void)upload:(SMSChooseABankTableViewController *)vc bank:(NSString *)bank{
    
    NSLog(@"选择的银行卡是 %@",bank);
    
    if (self.state == 103) {
        self.creditCardVC.bankString = bank;
        //刷新数据
        [self.creditCardVC dataRefresh];
    }else if(self.state == 104){
        self.theSavingsCardVC.bankString = bank;
        [self.theSavingsCardVC dataRefresh];
    }
}


-(void)pushProductFavorite{
    
    self.state = 103;
    
    SMSChooseABankTableViewController *vc = [[SMSChooseABankTableViewController alloc]init];
    vc.delegate = self;
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)pushStoreFavorite{
 
    self.state = 104;
    
    SMSChooseABankTableViewController *vc = [[SMSChooseABankTableViewController alloc]init];
    vc.delegate = self;
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 2;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.creditCardVC;
    } else if (number == 1) {
        return self.theSavingsCardVC;
    } else {
        return nil;
    }
}


- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (number == 0) {
        SMSCreditCardViewController *creditCardVC = nil;
        creditCardVC = self.creditCardVC;
        [creditCardVC viewDidCurrentView];
    } else if (number == 1) {
        SMSTheSavingsCardViewController *theSavingsCardVC = nil;
        theSavingsCardVC = self.theSavingsCardVC;
        [theSavingsCardVC viewDidCurrentView];
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
