//
//  SingPayMoney.m
//  TongFubao
//
//  Created by  俊   on 14-9-18.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SingPayMoney.h"

@interface SingPayMoney ()

@end

@implementation SingPayMoney

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)btnOnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
//            payoffView *vc= [[payoffView alloc]init];
//            [NLUtils presentModalViewController:self newViewController:vc];

            BossPayMoneyMain *pay= [[BossPayMoneyMain alloc]init];
            [self.navigationController pushViewController:pay animated:YES];
            
        }
            break;
        case 2:
        {
            SignOnMain *vc= [[SignOnMain alloc]init];
            [NLUtils presentModalViewController:self newViewController:vc];
        }
            break;
        default:
            break;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewInMain];
}

-(void)viewInMain
{
    self.title= @"工资管理";
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
//    [self addRightButtonItemWithImage:[UIImage imageNamed:@"history"]];
}

/*发放历史*/
-(void)rightItemClick:(id)sender
{
    payMoneyHistory *pay= [[payMoneyHistory alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
