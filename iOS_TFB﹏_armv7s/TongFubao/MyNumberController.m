//
//  MyNumberController.m
//  TongFubao
//
//  Created by Delpan on 14/10/27.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "MyNumberController.h"
#import "SvUDIDTools.h"

@interface MyNumberController ()
{
    NLProgressHUD  *_hud;
    //当前高度
    NSInteger currentHeight;
    //当前Y值
    NSInteger currentY;
    //当前类型
    MyImpowerType currentType;
    //登录密码输入框
    UITextField *passwordText;
    //解除绑定/绑定/确定按扭
    UIButton *enterBtn;
    //授权码/设备输入框
    UITextField *infoText[2];
}

@end

@implementation MyNumberController

- (instancetype)initWithType:(MyImpowerType)type
{
    if (self = [super init])
    {
        currentType = type;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    ViewControllerProperty;
    
#endif
    
    //获取当前屏幕size
    currentHeight = iphoneSize;
    
    self.title = @"我的授权码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化视图
    [self initView];
}

#pragma mark - 初始化视图
- (void)initView
{
    currentY = 20;
    
    //查看/登出授权码
    if (currentType == ImpowerInfoType)
    {
        //授权信息底图
        UIView *infoBasicView = [UIView viewWithFrame:CGRectMake(10, currentY, SelfWidth - 20, 80)];
        infoBasicView.layer.borderColor = [UIColor grayColor].CGColor;
        infoBasicView.layer.borderWidth = 0.5;
        infoBasicView.layer.cornerRadius = 10.0;
        [self.view addSubview:infoBasicView];
        
        currentY += 120;
        
        for (int i = 0; i < 2; i++)
        {
            //授权码/设备文本
            UILabel *infoLabel = [UILabel labelWithFrame:CGRectMake(10, 10 + 40 * i, 150, 20)
                                         backgroundColor:[UIColor clearColor]
                                               textColor:[UIColor blackColor]
                                                    text:(i == 0? @"您的授权码为：" : @"绑定设备为：")
                                                    font:[UIFont systemFontOfSize:16.0]];
            [infoBasicView addSubview:infoLabel];
            
            //授权码/设备输入框
            infoText[i] = [UITextField textWithFrame:CGRectMake(150, 10 + 40 * i, 150, 20) placeholder:nil];
            infoText[i].borderStyle = UITextBorderStyleNone;
            infoText[i].text = (i == 0? (self.impowerNumber? self.impowerNumber : @"") : (self.paycardIMEI? self.paycardIMEI : @"未绑定"));
            infoText[i].textColor = (i == 0? RGBACOLOR(231, 149, 28, 1.0) : [UIColor blackColor]);
            [infoBasicView addSubview:infoText[i]];
        }
    }
    else
    {
        //请输入您的登录密码
        UILabel *passwordLabel = [UILabel labelWithFrame:CGRectMake(10, currentY, SelfWidth - 20, 20)
                                         backgroundColor:[UIColor clearColor]
                                               textColor:[UIColor blackColor]
                                                    text:(currentType == ImpowerType? @"请输入您的刷卡器编号以获取授权码" : @"请输入您的登录密码已更改授权码绑定")
                                                    font:[UIFont systemFontOfSize:16.0]];
        [self.view addSubview:passwordLabel];
        
        currentY += 40;
        
        //登录密码输入框
        passwordText = [UITextField textWithFrame:CGRectMake(10, currentY, SelfWidth - 20, 40) placeholder:(currentType == ImpowerType? @"刷卡器编号" : @"请输入登录密码")];
        passwordText.borderStyle = UITextBorderStyleNone;
        passwordText.layer.borderColor = [UIColor grayColor].CGColor;
        passwordText.layer.borderWidth = 0.5;
        passwordText.layer.cornerRadius = 5.0;
        [self.view addSubview:passwordText];
        
        currentY += 80;
    }
    
    NSString *enterBtnName = (currentType == ImpowerInfoType? (self.paycardIMEI? @"解除设备绑定" : @"绑定设备") : (currentType == ImpowerType? @"获取授权码" : @"确定"));
    
    //解除绑定/绑定/确定按扭
    enterBtn = [UIButton buttonWithFrame:CGRectMake(10, currentY, SelfWidth - 20, 40)
                           unSelectImage:[UIImage imageNamed:@"change_btn_normal@2x"]
                             selectImage:nil
                                     tag:10000
                              titleColor:[UIColor whiteColor]
                                   title:enterBtnName];
    [enterBtn addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
}

#pragma mark - 解除绑定/绑定/确定
- (void)enterAction:(UIButton *)sender
{
    //解除设备绑定/绑定设备/获取授权码/确定
    if ([[sender currentTitle] isEqualToString:@"解除设备绑定"])
    {
        MyNumberController *thisClass = [[MyNumberController alloc] initWithType:ImpowerSignOutType];
        [self.navigationController pushViewController:thisClass animated:YES];
    }
    else if ([[sender currentTitle] isEqualToString:@"绑定设备"])
    {
        
    }
    else if ([[sender currentTitle] isEqualToString:@"获取授权码"])
    {
        
    }
    else if ([[sender currentTitle] isEqualToString:@"确定"])
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

























