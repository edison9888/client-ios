//
//  ACMyAuthorizationCode.m
//  TongFubao
//
//  Created by 湘郎 on 14-11-20.
//  Copyright (c) 2014年 MD313. All rights reserved.
//


#import "ACMyAuthorizationCode.h"
#import "ACImmediatelyBinding.h"

#import "XIAOYU_TheControlPackage.h"



@interface ACMyAuthorizationCode ()
{
    UIScrollView *scrollView;
    UIButton *bindingBtton;//绑定按钮
//    UITextField *authorizationCode;//授权码
//    UITextField *bindingEquipment;//绑定设备
    NSString *str1;
    NSString *str2;
}


@end

@implementation ACMyAuthorizationCode



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        str1 = @"绑定本机";
        str2 = @"解除设备绑定";
        
        self.title = @"我的授权码";
        
    }
    return self;
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self leftBarButtonBack];//返回按钮
    
    [self scrollVC];
    [self initView];
    
}


#pragma mark - UIScrollView
-(void)scrollVC{
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.backgroundColor = RGBACOLOR(246, 250, 252, 1);
    scrollView.contentSize = CGSizeMake(SelfWidth, iphoneSize+50);
    [self.view addSubview:scrollView];
}

#pragma mark - 显示框与确定按钮
-(void)initView{
 //AC_InputBox
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 300, 75)];
    imageView.image = [UIImage imageNamed:@"AC_InputBox"];
//    imageView.backgroundColor = [UIColor lightGrayColor];
//    imageView.layer.cornerRadius = 5;
//    imageView.layer.masksToBounds = YES;
    [scrollView addSubview:imageView];
    
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 96, 300, 45)];
    imageView2.image = [UIImage imageNamed:@"AC_InputBox"];
    [scrollView addSubview:imageView2];
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 110, 21)];
//    label1.backgroundColor = [UIColor yellowColor];
    label1.text = @"你的授权码为:";
    label1.font = [UIFont fontWithName:nil size:16];
    label1.textColor = RGBACOLOR(86, 86, 86, 1);
    [imageView addSubview:label1];
    
    UILabel *authorizationCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 5, 160, 70)];
//    authorizationCodeLabel.backgroundColor = [UIColor yellowColor];
    authorizationCodeLabel.text = self.authorizationCode;
    authorizationCodeLabel.textColor = RGBACOLOR(229, 145, 51, 1);
    //    authorizationCodeLabel.
    authorizationCodeLabel.font = [UIFont fontWithName:nil size:27];
    authorizationCodeLabel.numberOfLines = 2;
    [imageView addSubview:authorizationCodeLabel];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 100, 21)];
    label2.text = @"绑定设备为:";
    label2.font = [UIFont fontWithName:nil size:16];
    label2.textColor = RGBACOLOR(86, 86, 86, 1);
//    label2.backgroundColor = [UIColor yellowColor];
    [imageView2 addSubview:label2];
    
    UILabel *bindingEquipmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 12, 175, 21)];
    NSLog(@"当前状态值  state %d",self.state);
    bindingEquipmentLabel.text = self.state == 1 ? @"未绑定" : self.bindingEquipment;
    bindingEquipmentLabel.textColor = RGBACOLOR(86, 86, 86, 1);
    bindingEquipmentLabel.font = [UIFont fontWithName:nil size:16];
//    bindingEquipmentLabel.backgroundColor = [UIColor yellowColor];
    [imageView2 addSubview:bindingEquipmentLabel];
    
    
    bindingBtton = [[UIButton alloc]initWithFrame:CGRectMake(10, 160, 300, 40)];
    [bindingBtton setTitle:self.state == 1 ? str1:str2 forState:UIControlStateNormal];
    [bindingBtton setBackgroundImage:[UIImage imageNamed:@"SMS_yellowbtn@2x"] forState:UIControlStateNormal];
    [bindingBtton addTarget:self action:@selector(tapBinding) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:bindingBtton];
    
}

#pragma mark - 绑定/解除绑定
-(void)tapBinding{
    NSLog(@"点击按钮");
    
    ACImmediatelyBinding *vc = [[ACImmediatelyBinding alloc]init];

    vc.authorizationCodes = self.authorizationCode;
    vc.bindingEquipments = self.bindingEquipment;
    vc.paycardmachinnos = self.paycardmachinno;
    //复用界面状态表达值  1:绑定本机  2:解除绑定
    vc.state = self.state;
    
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
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
