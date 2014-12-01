//
//  ACPaymentIsSuccessfulViewController.m
//  TFB_demo_授权码
//
//  Created by 湘郎 on 14-11-25.
//  Copyright (c) 2014年 MacAir. All rights reserved.
//

#import "ACPaymentIsSuccessfulViewController.h"
#import "XIAOYU_TheControlPackage.h"

@interface ACPaymentIsSuccessfulViewController ()
{
    UIScrollView *scrollView;
}

#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

@end

@implementation ACPaymentIsSuccessfulViewController


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
    self.title = @"支付结果";
    
    self.authorizationCode = @"1610015423";
    
    [self leftBarButtonBack];//返回按钮
    
    [self scrollVC];
    [self initVC];
    
}

#pragma mark - UIScrollView
-(void)scrollVC{
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.backgroundColor = RGBACOLOR(242, 247, 248, 1.0);
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+20);
    [self.view addSubview:scrollView];
}


-(void)initVC{

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 30, 25, 25)];
    imageView.image = [UIImage imageNamed:@"SMS_success@2x"];
    [scrollView addSubview:imageView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(145, 23, 100, 40)];
    label1.text = @"支付成功";
    label1.textColor = RGBACOLOR(70, 74, 74, 1.0);
    label1.font = [UIFont systemFontOfSize:18];
//    label1.backgroundColor = [UIColor redColor];
    [scrollView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 73, 100, 20)];
    label2.text = @"您的授权码为: ";
    label2.textColor = RGBACOLOR(70, 74, 74, 1.0);
    label2.font = [UIFont systemFontOfSize:15];
//    label2.backgroundColor = [UIColor redColor];
    [scrollView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(160, 73, 100, 20)];
    label3.text = self.authorizationCode;
    label3.textColor = RGBACOLOR(70, 74, 74, 1.0);
    label3.font = [UIFont systemFontOfSize:15];
//    label3.backgroundColor = [UIColor redColor];
    [scrollView addSubview:label3];
    
    
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 98, 200, 20)];
    label4.text = @"已绑定当前登陆账号和本设备!";
    label4.textColor = RGBACOLOR(70, 74, 74, 1.0);
    label4.font = [UIFont systemFontOfSize:15];
//    label3.backgroundColor = [UIColor redColor];
    [scrollView addSubview:label4];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 140, 130, 40)];
    [btn1 setTitle:@"我知道了" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_nor"] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_pre"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(tap1) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(170, 140, 130, 40)];
    [btn2 setTitle:@"马上体验转账" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"SMS_ye_btn_nor"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"SMS_ye_btn_pre"] forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(tap2) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn2];
    
}

-(void)tap1{
    NSLog(@"我知道了");
}

-(void)tap2{
    NSLog(@"马上体验转账");
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
