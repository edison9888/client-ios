//
//  CreditCardPaymentTicketViewController.m
//  TongFubao
//
//  Created by kin on 14-8-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "CreditCardPaymentTicketViewController.h"

@interface CreditCardPaymentTicketViewController ()

@end

@implementation CreditCardPaymentTicketViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationView];
    [self allControllerView];
    // Do any additional setup after loading the view.
}
-(void)navigationView{
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"信用卡支付";
}
-(void)allControllerView
{
    
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
