//
//  SMSTheSavingsCardViewController.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSTheSavingsCardViewController.h"

@interface SMSTheSavingsCardViewController ()<UITextFieldDelegate>

@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UITextField *textFields;//输入框
@property(strong,nonatomic)UILabel *labels;//输入框前面的标签


@property(strong,nonatomic)NSString *creditCardString;//银行卡号
@property(strong,nonatomic)NSString *nameString;//开户人姓名
@property(strong,nonatomic)NSString *phoneString;//开户人手机号


@end

@implementation SMSTheSavingsCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self ScrollViewVC];//UIScrollView
        [self TheInputBox];//信用卡输入框
        [self SaveButton];//保存按钮
    }
    return self;
}

- (void)viewDidCurrentView{
    NSLog(@"加载为当前视图 = %@",self.title);
}

- (void)dataRefresh{
    NSLog(@"已获取到得值 %@",self.bankString);
    //刷新
    [self TheInputBox];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}


#pragma mark - 滑动视图
-(void)ScrollViewVC{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50);
    [self.view addSubview:self.scrollView];
}


#pragma mark - 信用卡输入框
-(void)TheInputBox{
    
    for (int i=0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10+(41+10)*i, 300, 41)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        [self.scrollView addSubview:imageView];
        
        
        self.textFields = [[UITextField alloc]initWithFrame:CGRectMake(100, 10+(self.textFields.frame.size.height+10)*i, 205, 41)];
        self.textFields.delegate = self;
        //        self.textFields.backgroundColor = [UIColor yellowColor];
        self.textFields.tag = 8030+i;
        [self.scrollView addSubview:self.textFields];
        
        self.labels= [[UILabel alloc]initWithFrame:CGRectMake(18, 10+(self.labels.frame.size.height+10)*i, 90, 41)];
        self.labels.tag = 8035+i;
        [self.labels setTextAlignment:NSTextAlignmentLeft];
        //        self.labels.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:self.labels];
        
        switch (self.labels.tag) {
            case 8035:
                self.labels.text = @"开户银行";
                break;
            case 8036:
                self.labels.text = @"银行卡号";
                break;
            case 8037:
                self.labels.text = @"开户人";
                break;
            case 8038:
                self.labels.text = @"手机号码";
                break;
                
            default:
                break;
        }
        
        switch (self.textFields.tag) {
            case 8030:
                self.textFields.placeholder = @"请选择银行";
                if (self.bankString != nil) {
                    self.textFields.text = [NSString stringWithFormat:@"%@",self.bankString ];
                }
                [self bankbJumpButton];
                ;
                break;
            case 8031:
                self.textFields.placeholder = @"请输入银行卡号";
                self.textFields.keyboardType = UIKeyboardTypeNumberPad;
                [self.textFields addTarget:self action:@selector(bankCardNumberTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8032:
                self.textFields.placeholder = @"请输入开户人名字";
                self.textFields.keyboardType = UIKeyboardTypeDefault;
                [self.textFields addTarget:self action:@selector(accountNameTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8033:
                self.textFields.placeholder = @"请输入开户人手机号码";
                self.textFields.keyboardType = UIKeyboardTypeNumberPad;
                [self.textFields addTarget:self action:@selector(phoneTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
                
            default:
                break;
        }
    }
}



#pragma mark - 开户银行
-(void)bankbJumpButton{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.textFields.frame.size.width, self.textFields.frame.size.height)];
    [btn setBackgroundColor:[UIColor lightTextColor]];
    [btn addTarget:self action:@selector(tapBankbJumpButton) forControlEvents:UIControlEventTouchUpInside];
    [self.textFields addSubview:btn];
}

-(void)tapBankbJumpButton{
    NSLog(@"选择开户银行");
    self.setPopBlock();
}



#pragma mark - 银行卡号
-(void)bankCardNumberTextEditingChanged:(UITextField *)textField{
    self.creditCardString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"信用卡号 :%@",self.creditCardString);
}



#pragma mark - 开户人姓名
-(void)accountNameTextEditingChanged:(UITextField *)textField{
    
    self.nameString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"持卡人姓名 :%@",self.nameString);
    
}



#pragma mark - 预留手机号码
-(void)phoneTextEditingChanged:(UITextField *)textField{
    
    if ([textField.text length]>11) {
        textField.text=[textField.text substringToIndex:11];
        self.phoneString = [self.phoneString substringWithRange:NSMakeRange(0,11)];
        NSLog(@"截取到的开户人手机号码 :%@",self.phoneString);
    }else{
        self.phoneString= [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"开户人手机号码 :%@", self.phoneString);
    }
    
}



#pragma mark - 保存按钮
-(void)SaveButton{
    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 213, 300, 41)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_nor"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_pre"] forState:UIControlStateHighlighted];;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(tapSave) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:saveBtn];
    
}

-(void)tapSave{
    
    //    bankString;//银行卡号
    //    creditCardString;//银行卡号
    //    nameString;//开户人姓名
    //    phoneString;//开户人手机号

    if (self.bankString.length >0 && self.creditCardString.length >0 && self.nameString.length >0 && self.phoneString.length >0) {
        
        if ([NLUtils checkBankCard:self.creditCardString] == YES) {
            
            if ([NLUtils checkName:self.nameString] == YES) {
                
                if ([NLUtils checkMobilePhone:self.phoneString] == YES) {
                    
                    NSLog(@"储蓄卡保存成功 !!!");
                    
                }else{
                    UIAlertView *alertView4 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                    [alertView4 show];
                }
                
            }else{
                UIAlertView *alertView3 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"姓名不合法 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alertView3 show];
            }
            
        }else{
            UIAlertView *alertView2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"银行卡号有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alertView2 show];
        }
        
    }else{
        UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善资料填写" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alertView1 show];
    }
    
}



#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
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
