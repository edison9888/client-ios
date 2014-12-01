//
//  BillViewController.m
//  TongFubao
//
//  Created by Delpan on 14-7-15.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "BillViewController.h"

@interface BillViewController ()

@end

@implementation BillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    self.title = @"机票帐单";
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //初始化视图
    [self initView];
}

- (void)initView
{
    //帐单信息
    UILabel *billLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 60, 15)];
    billLabel.opaque = YES;
    billLabel.backgroundColor = [UIColor clearColor];
    billLabel.textColor = [UIColor grayColor];
    billLabel.font = [UIFont systemFontOfSize:15.0];
    billLabel.text = @"帐单信息";
    billLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:billLabel];
    
    //帐单名称
    for (int i = 0; i < 4; i++)
    {
        NSString *unitName = nil;
        
        if (i == 0)
        {
            unitName = @"票价(元)";
        }
        else if (i == 1)
        {
            unitName = @"基建(元)";
        }
        else if (i == 2)
        {
            unitName = @"燃油费(元)";
        }
        else
        {
            unitName = @"保险(元)";
        }
        
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60 + 25 * i, 100, 20)];
        unitLabel.opaque = YES;
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.textColor = [UIColor grayColor];
        unitLabel.textAlignment = NSTextAlignmentLeft;
        unitLabel.text = unitName;
        unitLabel.font = [UIFont systemFontOfSize:20.0];
        [self.view addSubview:unitLabel];
    }
    
    //价格
    for (int i = 0; i < 4; i++)
    {
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 60 + 25 * i, 100, 20)];
        priceLabel.opaque = YES;
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor grayColor];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text = @"价格";
        priceLabel.font = [UIFont systemFontOfSize:20.0];
        [self.view addSubview:priceLabel];
    }
    
    //总价
    UILabel *sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(SelfWidth / 2, 200, 110, 30)];
    sumLabel.backgroundColor = [UIColor clearColor];
    sumLabel.opaque = YES;
    sumLabel.textColor = RGBACOLOR(229, 185, 75, 1.0);
    sumLabel.textAlignment = NSTextAlignmentRight;
    sumLabel.text = @"总价";
    sumLabel.font = [UIFont systemFontOfSize:30.0];
    [self.view addSubview:sumLabel];
    
    //支付帐号信息
    UILabel *particularLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 200, 20)];
    particularLabel.opaque = YES;
    particularLabel.backgroundColor = [UIColor clearColor];
    particularLabel.textColor = [UIColor grayColor];
    particularLabel.textAlignment = NSTextAlignmentLeft;
    particularLabel.text = @"支付帐号信息";
    particularLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:particularLabel];
    
    NSString *btnName = @"前往银联支付";
    
    //支付按扭
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.opaque = YES;
    enterBtn.frame = CGRectMake(20, 290, 280, 50);
    enterBtn.backgroundColor = RGBACOLOR(229, 185, 75, 1.0);
    [enterBtn setTitle:btnName forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
}

#pragma mark - 前往银联支付触发
- (void)enterBtnAction:(UIButton *)sender
{
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end















