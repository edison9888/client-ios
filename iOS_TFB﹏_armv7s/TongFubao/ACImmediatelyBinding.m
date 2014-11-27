//
//  ACImmediatelyBinding.m
//  TongFubao
//
//  Created by 湘郎 on 14-11-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "ACImmediatelyBinding.h"
#import "XIAOYU_TheControlPackage.h"


@interface ACImmediatelyBinding ()<UITextFieldDelegate>
{
    NLProgressHUD *_hud;
    
    UIScrollView *scrollView;
    UITextField *bindingEquipment;
    UIImageView *cardReader;
    UIButton *bindingBtton;
    
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *str4;
    NSString *str5;
    NSString *str6;
    NSString *str7;
    NSString *str8;
    NSString *str9;
}


@end

@implementation ACImmediatelyBinding

-(void)tapleftBarButtonItemBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        str1 = @"请输入您的刷卡器编号以获取授权码:";
        str2 = @"请输入您的登陆密码以更改授权码绑定:";
        str3 = @"请刷卡获取刷卡器编号";
        str4 = @"请输入登陆密码";
        str5 = @"确认";
        str6 = @"绑定本机";
        str7 = @"解除绑定";
        str8 = @"绑定验证";
        str9 = @"获取授权码";
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    
    NSLog(@"当前状态值  state :%d",self.state);
    self.title = self.state == 1 || self.state == 2 ? str8 : str9;
    
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



#pragma mark - 输入框与确定按钮
-(void)initView{

    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 300, 21)];
    label1.text = self.state == 1 || self.state == 2 ? str2:str1;
    label1.textColor = RGBACOLOR(115, 117, 115, 1);
    label1.font = [UIFont fontWithName:nil size:16];
//    label1.backgroundColor = [UIColor yellowColor];
    [scrollView addSubview:label1];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 300, 44)];
    imageView.image = [UIImage imageNamed:@"AC_InputBox@2x"];
    imageView.userInteractionEnabled = YES;
    [scrollView addSubview:imageView];
    
/*
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 120, 20)];
    label2.text = self.bindingEquipments ? str4:str3;
    label2.backgroundColor = [UIColor yellowColor];
    label2.textColor = RGBACOLOR(147, 147, 147, 1);
    label2.font = [UIFont fontWithName:nil size:16];
    [imageView addSubview:label2];
*/
    
    bindingEquipment = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, 280, 40)];
//    bindingEquipment.backgroundColor = [UIColor redColor];
    bindingEquipment.placeholder = self.state == 1 || self.state == 2 ? str4:str3;
    bindingEquipment.userInteractionEnabled = self.state == 1 || self.state == 2 ? YES:NO;
    bindingEquipment.keyboardType = UIKeyboardTypeAlphabet;
    bindingEquipment.delegate = self;
    [imageView addSubview:bindingEquipment];
    
    cardReader = [[UIImageView alloc]initWithFrame:CGRectMake(230, 5, 50, 30)];
    cardReader.image = [UIImage imageNamed:@"swipingCard"];//swipingCard2
    cardReader.alpha = self.state == 1 || self.state == 2 ? 0:1;
    [bindingEquipment addSubview:cardReader];
    
    

    
    bindingBtton = [[UIButton alloc]initWithFrame:CGRectMake(10, 125, 300, 40)];
    [bindingBtton setTitle:self.state == 1  ? str6 : self.state == 2 ? str7 : str5 forState:UIControlStateNormal];
    [bindingBtton setBackgroundImage:[UIImage imageNamed:@"SMS_yellowbtn@2x"] forState:UIControlStateNormal];
    [bindingBtton addTarget:self action:@selector(tapBinding) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:bindingBtton];
}


#pragma mark - 绑定/解绑 按钮
-(void)tapBinding{
    
    //绑定本机
    if (self.state == 1) {
        if (bindingEquipment.text.length >0) {
            if ([NLUtils checkPassword:bindingEquipment.text] == YES) {
                NSLog(@"绑定");
                
                [self bindingRequest];
    
            }else{
                [self showErrorInfo:@"登陆密码有误" status:NLHUDState_Error];
            }
        }else{
            [self showErrorInfo:@"请输入登陆密码" status:NLHUDState_Error];
        }
        
    //解除绑定
    }else if(self.state == 2){
        if (bindingEquipment.text.length >0) {
            if ([NLUtils checkPassword:bindingEquipment.text] == YES) {
                NSLog(@"解绑");
                
                [self unbundlingRequest];
                
            }else{
                [self showErrorInfo:@"登陆密码有误" status:NLHUDState_Error];
            }
        }else{
            [self showErrorInfo:@"请输入登陆密码" status:NLHUDState_Error];
        }
        
    //绑定刷卡器
    }else if(self.state == 3){
        if (bindingEquipment.text.length >0) {
            if ([NLUtils checkPassword:bindingEquipment.text] == YES) {
                NSLog(@"绑定刷卡器");
                
                [self bindCardReaderRequest];
                
            }else{
                [self showErrorInfo:@"刷卡器编号有误!" status:NLHUDState_Error];
            }
        }else{
            [self showErrorInfo:@"请先进行一次刷卡!" status:NLHUDState_Error];
        }
    }

//    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 绑定本机
-(void)bindingRequest{
    
    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSDictionary *dic = @{@"paycardid" : @"paycardid",@"IMEI" : @"IMEI",@"paycardmachinno" : self.paycardmachinnos,@"aupwd" : bindingEquipment.text};
    
    [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiAuthorInfo" apiNameFunc:@"paycardbdterminal" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        
        [_hud hide:YES];
        
        if (![data[@"result"] isEqualToString:@"success"]) {
            NSLog(@"解析失败");
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
        }else{
            NSLog(@"解析成功");
            [self showErrorInfo:data[@"message"] status:NLHUDState_NoError];
        }
        
   }];
}


#pragma mark - 解除绑定本机
-(void)unbundlingRequest{

    [self showErrorInfo:@"请稍候" status:NLHUDState_None];
    NSDictionary *dic = @{@"paycardid" : @"paycardid",@"IMEI" : @"IMEI",@"aupwd" : bindingEquipment.text};
    
    [LoadDataWithASI loadDataWithMsgbody:dic apiName:@"ApiAuthorInfo" apiNameFunc:@"paycardbdterminal" rolePath:@"//operation_response/msgbody" type:PublicCommon completionBlock:^(id data, NSError *error) {
        
        [_hud hide:YES];
        
        if (![data[@"result"] isEqualToString:@"success"]) {
            NSLog(@"解析失败");
            [self showErrorInfo:data[@"message"] status:NLHUDState_Error];
        }else{
            NSLog(@"解析成功");
            [self showErrorInfo:data[@"message"] status:NLHUDState_NoError];
        }
        
    }];
    
}


#pragma mark - 绑定刷卡器
-(void)bindCardReaderRequest{

//    [self showErrorInfo:@"授权码绑定成功!" status:NLHUDState_Error];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的" delegate:self cancelButtonTitle:@"马上补充" otherButtonTitles:nil, nil];
    alert.tag = 7230;
    [alert show];
}


#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 7230) {
        switch (buttonIndex) {
            case 0:
                //用户填充资料的类 找阿豪要
                NSLog(@"补充添加用户资料");
                break;

            default:
                break;
        }
    }
    
    NSLog(@"%d",buttonIndex);
}


-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;//失败
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;//成功
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
            
            
        }
            break;
            
        case NLHUDState_None:
        {
            _hud.labelText = error;
            [_hud show:YES];
            
        }
            break;
            
        default:
            break;
    }
    return;
}



-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"即将离开界面 键盘已收起");
    [bindingEquipment resignFirstResponder];
    //    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
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
