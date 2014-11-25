//
//  SMSCreditCardViewController.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-8.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSCreditCardViewController.h"

@interface SMSCreditCardViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UITextField *textFields;//输入框
@property(strong,nonatomic)UILabel *labels;//输入框前面的标签

@property(strong,nonatomic)UILabel *month;//月
@property(strong,nonatomic)UILabel *years;//年
@property(assign,nonatomic)int state;//状态值

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dateArray;


@property(strong,nonatomic)NSString *creditCardString;//信用卡号
@property(strong,nonatomic)NSString *ccvString;//CCV验证码
@property(strong,nonatomic)NSString *phoneString;//预留手机号
@property(strong,nonatomic)NSString *nameString;//持卡人姓名
@property(strong,nonatomic)NSString *identityCardNumberString;//身份证号码


@end

@implementation SMSCreditCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self ScrollViewVC];//UIScrollView
        [self TheInputBox];//信用卡输入框
        [self ThePeriodOfValidity];//有效期
        [self SaveButton];//保存按钮
        
    }
    return self;
}

- (void)viewDidCurrentView
{
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
    
    for (int i=0; i<6; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10+(41+10)*i, 300, 41)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        [self.scrollView addSubview:imageView];
        
        
        self.textFields = [[UITextField alloc]initWithFrame:CGRectMake(115, 10+(self.textFields.frame.size.height+10)*i, 190, 41)];
        self.textFields.delegate = self;
        //        self.textFields.backgroundColor = [UIColor yellowColor];
        self.textFields.tag = 8010+i;
        [self.scrollView addSubview:self.textFields];
        
        self.labels= [[UILabel alloc]initWithFrame:CGRectMake(18, 10+(self.labels.frame.size.height+10)*i, 90, 41)];
        self.labels.tag = 8000+i;
        [self.labels setTextAlignment:NSTextAlignmentLeft];
        //        self.labels.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:self.labels];
        
        switch (self.labels.tag) {
            case 8000:
                self.labels.text = @"开户银行";
                break;
            case 8001:
                self.labels.text = @"信用卡号";
                break;
            case 8002:
                self.labels.text = @"CCV验证码";
                break;
            case 8003:
                self.labels.text = @"预留手机号";
                break;
            case 8004:
                self.labels.text = @"持卡人姓名";
                break;
            case 8005:
                self.labels.text = @"身份证号码";
                break;
                
            default:
                break;
        }
        
        switch (self.textFields.tag) {
            case 8010:
                self.textFields.placeholder = @"请选择银行";
                if (self.bankString != nil) {
                    self.textFields.text = [NSString stringWithFormat:@"%@",self.bankString ];
                }
                [self bankbJumpButton];
                ;
                break;
            case 8011:
                self.textFields.placeholder = @"请输入银行卡号";
                self.textFields.keyboardType = UIKeyboardTypeNumberPad;
                [self.textFields addTarget:self action:@selector(bankCardNumberTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8012:
                self.textFields.placeholder = @"请输入卡背后末三位数字";
                self.textFields.keyboardType = UIKeyboardTypeNumberPad;
                [self.textFields addTarget:self action:@selector(cardThreeTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8013:
                self.textFields.placeholder = @"请输入银行预留的手机号";
                self.textFields.keyboardType = UIKeyboardTypeNumberPad;
                [self.textFields addTarget:self action:@selector(phoneTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8014:
                self.textFields.placeholder = @"请输入开户人名字";
                self.textFields.keyboardType = UIKeyboardTypeDefault;
                [self.textFields addTarget:self action:@selector(accountNameTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8015:
                self.textFields.placeholder = @"请输入开户人身份证号码";
                self.textFields.keyboardType = UIKeyboardTypeNumberPad;
                [self.textFields addTarget:self action:@selector(identityCardNumberTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
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


#pragma mark - 信用卡号
-(void)bankCardNumberTextEditingChanged:(UITextField *)textField{
    self.creditCardString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"信用卡号 :%@",self.creditCardString);
}


#pragma mark - CCV验证码  卡背后三位数
-(void)cardThreeTextEditingChanged:(UITextField *)textField{
    
    if ([textField.text length]>3) {
        textField.text=[textField.text substringToIndex:3];
        self.ccvString = [ self.ccvString substringWithRange:NSMakeRange(0,3)];
        NSLog(@"截取到的CCV验证码 :%@",self.ccvString);
    }else{
        self.ccvString = [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"CCV验证码 :%@", self.ccvString);
    }
    
}


#pragma mark - 预留手机号码
-(void)phoneTextEditingChanged:(UITextField *)textField{
    
    if ([textField.text length]>11) {
        textField.text=[textField.text substringToIndex:11];
        self.phoneString = [self.phoneString substringWithRange:NSMakeRange(0,11)];
        NSLog(@"截取到的预留手机号码 :%@",self.phoneString);
    }else{
        self.phoneString= [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"预留手机号码 :%@", self.phoneString);
    }
    
}


#pragma mark - 持卡人姓名
-(void)accountNameTextEditingChanged:(UITextField *)textField{
    
    self.nameString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"持卡人姓名 :%@",self.nameString);
    
}


#pragma mark - 身份证号码
-(void)identityCardNumberTextEditingChanged:(UITextField *)textField{
    
    if ([textField.text length]>18) {
        textField.text=[textField.text substringToIndex:18];
        self.identityCardNumberString = [self.identityCardNumberString substringWithRange:NSMakeRange(0,18)];
        NSLog(@"截取到的身份证号码 :%@",self.identityCardNumberString);
    }else{
        self.identityCardNumberString = [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"身份证号码 :%@", self.identityCardNumberString);
    }
    
}


#pragma mark - 有效期
-(void)ThePeriodOfValidity{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 324, 55, 21)];
    label.text = @"有限期";
//    label.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 319, 75, 30)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imageView];
    
    //月
    self.month = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.month.backgroundColor = [UIColor whiteColor];
    //    self.month.text = @"12";
    [self.month setTextAlignment:NSTextAlignmentCenter];
    [imageView addSubview:self.month];
    
    UIButton *monthButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 25, 30)];
//    [monthButton setBackgroundColor:[UIColor yellowColor]];
    [monthButton setBackgroundImage:[UIImage imageNamed:@"SMS_chosen@2x"] forState:UIControlStateNormal];
    monthButton.tag = 8020;
    [monthButton addTarget:self action:@selector(tapMonth:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:monthButton];
    
    
    
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(160, 324, 30, 21)];
    label2.text = @"月/";
//    label2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:label2];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(200, 319, 75, 30)];
    imageView2.backgroundColor = [UIColor whiteColor];
    imageView2.layer.cornerRadius = 5;
    imageView2.layer.masksToBounds = YES;
    imageView2.userInteractionEnabled = YES;
    [self.scrollView addSubview:imageView2];
    
    
    //年
    self.years = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//    self.years.backgroundColor = [UIColor redColor];
    //    self.years.text = @"2014";
    [self.years setTextAlignment:NSTextAlignmentCenter];
    [imageView2 addSubview:self.years];
    
    UIButton *yearsButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 25, 30)];
//    [yearsButton setBackgroundColor:[UIColor yellowColor]];
    [yearsButton setBackgroundImage:[UIImage imageNamed:@"SMS_chosen@2x"] forState:UIControlStateNormal];
    yearsButton.tag = 8021;
    [yearsButton addTarget:self action:@selector(tapMonth:) forControlEvents:UIControlEventTouchUpInside];
    [imageView2 addSubview:yearsButton];
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(285, 324, 20, 21)];
    label3.text = @"年";
//    label3.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:label3];
    
}



#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

//UITextField是否进入编辑模式
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //NO进入不了编辑模式
    if (textField.tag == 8010) {
        return NO;
    }else{
        return YES;
    }
}

//选择年月
-(void)tapMonth:(UIButton *)button{
    NSLog(@"选择年月");
    self.state = (int)button.tag;
    
    switch (button.tag) {
        case 8020:
            [self.dateArray removeAllObjects];
            self.dateArray = [NSMutableArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
            break;
        case 8021:
            [self.dateArray removeAllObjects];
            self.dateArray = [NSMutableArray arrayWithObjects:@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030", nil];
            break;
        default:
            break;
    }
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, 300, 350) style:UITableViewStylePlain];
    self.tableView.tag = 8023;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 8;
    self.tableView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = self.dateArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.state == 8020) {
        self.month.text = self.dateArray[indexPath.row];
    }else if(self.state == 8021){
        self.years.text = self.dateArray[indexPath.row];
    }
    
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    
}



#pragma mark - 保存按钮
-(void)SaveButton{
    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 365, 300, 41)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_nor"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_pre"] forState:UIControlStateHighlighted];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(tapSave) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:saveBtn];
    
}


-(void)tapSave{
    
    //    bankString;//开户银行
    //    creditCardString;//信用卡号
    //    ccvString;//CCV验证码
    //    phoneString;//预留手机号
    //    nameString;//持卡人姓名
    //    identityCardNumberString;//身份证号码
    if (self.bankString.length >0 && self.creditCardString.length >0 && self.ccvString.length >0 && self.phoneString.length >0 && self.nameString.length >0 && self.identityCardNumberString.length >0 && self.month.text.length>0 && self.years.text.length>0) {
        
        if ([NLUtils checkBankCard:self.creditCardString] == YES) {
            if ([NLUtils checkMobilePhone:self.phoneString] == YES) {
                if ([NLUtils checkName:self.nameString] == YES) {
                    if ([NLUtils checkIdentity:self.identityCardNumberString] == YES) {
                        if (self.ccvString.length == 3) {
                            
                            NSLog(@"信用卡保存成功 !!!");
                            
                        }else{
                            UIAlertView *alertView6 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"CCV验证码有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                            [alertView6 show];
                        }
                
                    }else{
                        UIAlertView *alertView5 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号码有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                        [alertView5 show];
                    }
                
                }else{
                    UIAlertView *alertView4 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"姓名不合法 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                    [alertView4 show];
                }
            }else{
                UIAlertView *alertView3 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alertView3 show];
            }
            
        }else{
            UIAlertView *alertView2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"银行卡号有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alertView2 show];
        }
     
    }else{
        UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善资料填写 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alertView1 show];
        
        
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
