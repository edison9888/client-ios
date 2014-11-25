//
//  SMSAddBankCardViewController.m
//  TongFubao
//
//  Created by 湘郎 on 14-11-11.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSAddBankCardViewController.h"
#import "SMSreceiptViewController.h"
#import "SMSBankCardViewController.h"
#import "NLBankListViewController.h"
#import "XIAOYU_TheControlPackage.h"


@interface SMSAddBankCardViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,NLBankLisDelegate>
{
    NLProgressHUD *_hud;
    
    UITextField *creditTextField[6];//信用卡输入框
    UITextField *theSavingsCardTextField[4];//储蓄卡输入框
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(strong,nonatomic)UIButton *creditButton;//信用卡
@property(strong,nonatomic)UIButton *theSavingsCardButton;//储蓄卡
@property(strong,nonatomic)UIImageView *indicatorIconImageView;//指示图标
@property(assign,nonatomic)int state2;//代理取值的状态值  1:信用卡  2:储蓄卡


//信用卡属性
@property(strong,nonatomic)UIView *creditView;//加载视图
@property(strong,nonatomic)UILabel *creditLabel;//输入框前面的标签
@property(strong,nonatomic)UIButton *creditJumpButton;//跳转信用卡开户银行按钮
@property(strong,nonatomic)UIButton *creditSaveButton;//信用卡保存按钮
@property(strong,nonatomic)UILabel *month;//月
@property(strong,nonatomic)UILabel *years;//年
@property(assign,nonatomic)int state;//选取日期状态值
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dateArray;//有效期日期数组

@property(strong,nonatomic)NSString *xy_bankCode;//信用卡银行Code值
@property(strong,nonatomic)NSString *xy_theOpeningBankString;//开户银行
@property(strong,nonatomic)NSString *xy_creditCardString;//信用卡号
@property(strong,nonatomic)NSString *xy_ccvString;//CCV验证码
@property(strong,nonatomic)NSString *xy_phoneString;//预留手机号
@property(strong,nonatomic)NSString *xy_nameString;//持卡人姓名
@property(strong,nonatomic)NSString *xy_identityCardNumberString;//身份证号码




//储蓄卡属性
@property(strong,nonatomic)UIView *theSavingsCardView;//加载视图
@property(strong,nonatomic)UILabel *theSavingsCardLabel;//输入框前面的标签
@property(strong,nonatomic)UIButton *theSavingsCardSaveButton;//信用卡保存按钮
@property(strong,nonatomic)UIButton *theSavingsCardJumpButton;//跳储蓄卡开户银行按钮

@property(strong,nonatomic)NSString *cx_bankCode;//储蓄卡银行Code值
@property(strong,nonatomic)NSString *cx_theOpeningBankString;//开户银行
@property(strong,nonatomic)NSString *cx_creditCardString;//银行卡号
@property(strong,nonatomic)NSString *cx_nameString;//开户人姓名
@property(strong,nonatomic)NSString *cx_phoneString;//开户人手机号




@end

//报警告是因为获取银行卡那个类写了两个代理方法 真心吐槽
@implementation SMSAddBankCardViewController




//开户银行的代理方法
- (void)dataSearch:(NLBankListViewController *)controller didSelectWithObject:(id)aObject
         withState:(NSString *)state{
    
    if (self.state2 == 1) {
        self.xy_bankCode = (NSString *)state;
        self.xy_theOpeningBankString = (NSString *)aObject;
         NSLog(@"信用卡开户银行为:%@  Code:%@",self.xy_theOpeningBankString,self.xy_bankCode);
        //刷新信用卡数据
        creditTextField[0].text = [NSString stringWithFormat:@"%@",self.xy_theOpeningBankString ];
        NSLog(@"开户银行 :%@",creditTextField[0].text);
    }else if (self.state2 == 2){
        self.cx_bankCode = (NSString *)state;
        self.cx_theOpeningBankString = (NSString *)aObject;
        NSLog(@"信用卡开户银行为:%@  Code:%@",self.cx_theOpeningBankString,self.cx_bankCode);
        //刷新信用卡数据
        theSavingsCardTextField[0].text = [NSString stringWithFormat:@"%@",self.cx_theOpeningBankString ];
        NSLog(@"开户银行 :%@",theSavingsCardTextField[0].text);
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"视图即将加载时");
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"即将离开界面 键盘已收起");
//    for (int i=0; i<4; i++) {
//        [textFields[i] resignFirstResponder];
//    }
//    creditTextField[6];//信用卡输入框
//    theSavingsCardTextField[4];//储蓄卡输入框
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
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

-(void)tapleftBarButtonItemBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    
    [self scrollViewVC];//UIScrollView
    
    
    
    
    
}


#pragma mark - 加载滑动视图
-(void)scrollViewVC
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50);
    [self.view addSubview:self.scrollView];
    
    [self creditAndTheSavingsCard];//调用 信用卡/储蓄卡
}


#pragma mark - 加载 信用卡/储蓄卡 按钮
-(void)creditAndTheSavingsCard
{
    self.creditButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 150, 41)];
    self.creditButton.tag = 7050;
    [self.creditButton setTitle:@"信用卡" forState:UIControlStateNormal];
    [self.creditButton setBackgroundImage:[UIImage imageNamed:@"SMS_left_light"] forState:UIControlStateNormal];
    [self.creditButton addTarget:self action:@selector(tapAddCredit) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.creditButton];
    
    
    self.theSavingsCardButton = [[UIButton alloc]initWithFrame:CGRectMake(160, 10, 150, 41)];
    self.theSavingsCardButton.tag = 7051;
    [self.theSavingsCardButton setTitle:@"储蓄卡" forState:UIControlStateNormal];
    [self.theSavingsCardButton setBackgroundImage:[UIImage imageNamed:@"SMS_right_dark"] forState:UIControlStateNormal];
    [self.theSavingsCardButton addTarget:self action:@selector(tapAddTheSavingsCard) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.theSavingsCardButton];
    
    
    self.indicatorIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SMS_triangle"]];
    self.indicatorIconImageView.frame = CGRectMake(80, 50, 15, 10);
    [self.scrollView addSubview:self.indicatorIconImageView];
    
    
    self.creditView = [[UIView alloc]initWithFrame:CGRectMake(10, 65, 300, 420)];
    self.creditView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.creditView];
    
    
    self.theSavingsCardView = [[UIView alloc]initWithFrame:CGRectMake(10, 65, 300, 320)];
    self.theSavingsCardView.backgroundColor = [UIColor clearColor];
    self.theSavingsCardView.alpha = 0;
    [self.scrollView addSubview:self.theSavingsCardView];
    
    
    [self creditVC];//信用卡输入框
    [self thePeriodOfValidity];//有效期
    [self theSavingsCardVC];//储蓄卡输入框
    [self saveCredit];//信用卡保存按钮
    [self saveTheSavingsCardButton];//储蓄卡保存按钮
}



#pragma mark - 信用卡点击方法
-(void)tapAddCredit{
    NSLog(@"信用卡");
    
    [self.creditButton setBackgroundImage:[UIImage imageNamed:@"SMS_left_light"] forState:UIControlStateNormal];
    [self.theSavingsCardButton setBackgroundImage:[UIImage imageNamed:@"SMS_right_dark"] forState:UIControlStateNormal];
    self.indicatorIconImageView.frame = CGRectMake(80, 50, 15, 10);
    
    self.theSavingsCardView.alpha = 0;
    self.creditView.alpha = 1;
    
}


#pragma mark - 储蓄卡点击方法
-(void)tapAddTheSavingsCard{
    NSLog(@"储蓄卡");
    
    [self.theSavingsCardButton setBackgroundImage:[UIImage imageNamed:@"SMS_right_light"] forState:UIControlStateNormal];
    [self.creditButton setBackgroundImage:[UIImage imageNamed:@"SMS_left_dark"] forState:UIControlStateNormal];
    self.indicatorIconImageView.frame = CGRectMake(230, 50, 15, 10);
    
    self.creditView.alpha = 0;
    self.theSavingsCardView.alpha = 1;
}



#pragma mark - 加载信用卡输入框
-(void)creditVC{
    
    for (int i=0; i<6; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (41+10)*i, 300, 41)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        [self.creditView addSubview:imageView];
        
        
        creditTextField[i] = [[UITextField alloc]initWithFrame:CGRectMake(110, (41+10)*i, 190, 41)];
        creditTextField[i].delegate = self;
        creditTextField[i].backgroundColor = [UIColor clearColor];
        creditTextField[i].tag = 8010+i;
        [self.creditView addSubview:creditTextField[i]];
        
        
        self.creditLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, (41+10)*i, 90, 41)];
        self.creditLabel.tag = 8000+i;
        [self.creditLabel setTextAlignment:NSTextAlignmentLeft];
        self.creditLabel.backgroundColor = [UIColor clearColor];
        self.creditLabel.textColor= RGBACOLOR(99, 99, 99, 1);
        [self.creditView addSubview:self.creditLabel];
        
        switch (self.creditLabel.tag) {
            case 8000:
                self.creditLabel.text = @"开户银行";
                break;
            case 8001:
                self.creditLabel.text = @"信用卡号";
                break;
            case 8002:
                self.creditLabel.text = @"CCV验证码";
                break;
            case 8003:
                self.creditLabel.text = @"预留手机号";
                break;
            case 8004:
                self.creditLabel.text = @"持卡人姓名";
                break;
            case 8005:
                self.creditLabel.text = @"身份证号码";
                break;
                
            default:
                break;
        }
        
        switch (creditTextField[i].tag) {
            case 8010:
                creditTextField[0].placeholder = @"请选择银行";
                
                [self jumpCreditButton];//选择开户银行
                ;
                break;
            case 8011:
                creditTextField[1].placeholder = @"请输入银行卡号";
                creditTextField[1].keyboardType = UIKeyboardTypeNumberPad;
                [creditTextField[1] addTarget:self action:@selector(addCreditCardNumber:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8012:
                creditTextField[2].placeholder = @"请输入卡背后末三位数字";
                creditTextField[2].keyboardType = UIKeyboardTypeNumberPad;
                [creditTextField[2] addTarget:self action:@selector(addCreditCCV:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8013:
                creditTextField[3].placeholder = @"请输入银行预留的手机号";
                creditTextField[3].keyboardType = UIKeyboardTypeNumberPad;
                [creditTextField[3] addTarget:self action:@selector(addCreditPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8014:
                creditTextField[4].placeholder = @"请输入开户人名字";
                creditTextField[4].keyboardType = UIKeyboardTypeDefault;
                [creditTextField[4] addTarget:self action:@selector(addCreditAccountName:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8015:
                creditTextField[5].placeholder = @"请输入开户人身份证号码";
                creditTextField[5].keyboardType = UIKeyboardTypeNumberPad;
                [creditTextField[5] addTarget:self action:@selector(addCreditIdentityCardNumber:) forControlEvents:UIControlEventEditingChanged];
                break;
                
            default:
                break;
        }
    }
    
    
    
}



#pragma mark - 跳转信用卡 开户银行
-(void)jumpCreditButton{
    
    if (!self.creditJumpButton) {
        self.creditJumpButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, creditTextField[0].frame.size.width, creditTextField[0].frame.size.height)];
        [self.creditJumpButton setBackgroundColor:[UIColor clearColor]];
        [creditTextField[0] addSubview:self.creditJumpButton];
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(175, 10, 10, 22)];
        [btn setBackgroundImage:[UIImage imageNamed:@"SMS_jump@2x"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapJumpCreditButn) forControlEvents:UIControlEventTouchUpInside];
        [creditTextField[0] addSubview:btn];
    }
    [self.creditJumpButton addTarget:self action:@selector(tapJumpCreditButn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tapJumpCreditButn{
    NSLog(@"选择开户银行");
    
//    SMSChooseABankTableViewController *vc = [[SMSChooseABankTableViewController alloc]init];
    
    NLBankListViewController *vc = [[NLBankListViewController alloc]initWithNibName:@"NLBankListViewController" bundle:nil];
    vc.delegate = self;
    self.state2 = 1;
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}

#pragma mark - 添加 信用卡 银行卡号
-(void)addCreditCardNumber:(UITextField *)textField{

    self.xy_creditCardString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"信用卡号 :%@",self.xy_creditCardString);
    
}


#pragma mark - 添加 信用卡 背后CCV三位数
-(void)addCreditCCV:(UITextField *)textField{
    
    if ([textField.text length]>3) {
        textField.text=[textField.text substringToIndex:3];
        self.xy_ccvString = [ self.xy_ccvString substringWithRange:NSMakeRange(0,3)];
        NSLog(@"截取到的CCV验证码 :%@",self.xy_ccvString);
    }else{
        self.xy_ccvString = [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"CCV验证码 :%@", self.xy_ccvString);
    }
    
}


#pragma mark - 添加 信用卡 预留手机号码
-(void)addCreditPhoneNumber:(UITextField *)textField{
    
    if ([textField.text length]>11) {
        textField.text=[textField.text substringToIndex:11];
        self.xy_phoneString = [self.xy_phoneString substringWithRange:NSMakeRange(0,11)];
        NSLog(@"截取到的预留手机号码 :%@",self.xy_phoneString);
    }else{
        self.xy_phoneString= [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"预留手机号码 :%@", self.xy_phoneString);
    }
    
}


#pragma mark - 添加 信用卡 开户名字
-(void)addCreditAccountName:(UITextField *)textField{
    
    self.xy_nameString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"持卡人姓名 :%@",self.xy_nameString);
    
}


#pragma mark - 添加 信用卡 持有人身份证号码
-(void)addCreditIdentityCardNumber:(UITextField *)textField{
 
    if ([textField.text length]>18) {
        textField.text=[textField.text substringToIndex:18];
        self.xy_identityCardNumberString = [self.xy_identityCardNumberString substringWithRange:NSMakeRange(0,18)];
        NSLog(@"截取到的身份证号码 :%@",self.xy_identityCardNumberString);
    }else{
        self.xy_identityCardNumberString = [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"身份证号码 :%@", self.xy_identityCardNumberString);
    }
    
}


#pragma mark - 添加 信用卡 有限期
-(void)thePeriodOfValidity{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 314, 55, 21)];
    label.text = @"有限期";
    label.textColor= RGBACOLOR(99, 99, 99, 1);
    //    label.backgroundColor = [UIColor whiteColor];
    [self.creditView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(73, 309, 75, 30)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [self.creditView addSubview:imageView];
    
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
    
    
    
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(158, 314, 30, 21)];
    label2.text = @"月/";
    label2.textColor= RGBACOLOR(99, 99, 99, 1);
    //    label2.backgroundColor = [UIColor whiteColor];
    [self.creditView addSubview:label2];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(193, 309, 75, 30)];
    imageView2.backgroundColor = [UIColor whiteColor];
    imageView2.layer.cornerRadius = 5;
    imageView2.layer.masksToBounds = YES;
    imageView2.userInteractionEnabled = YES;
    [self.creditView addSubview:imageView2];
    
    
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
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(280, 314, 20, 21)];
    label3.text = @"年";
    label3.textColor= RGBACOLOR(99, 99, 99, 1);
    //    label3.backgroundColor = [UIColor whiteColor];
    [self.creditView addSubview:label3];
    
}



//选择年月
-(void)tapMonth:(UIButton *)button{
    NSLog(@"选择年月");
    self.state = (int)button.tag;
    
    switch (button.tag) {
        case 8020:
            [self.dateArray removeAllObjects];
            self.dateArray = [NSMutableArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
            [self.tableView reloadData];
            break;
        case 8021:
            [self.dateArray removeAllObjects];
            self.dateArray = [NSMutableArray arrayWithObjects:@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030", nil];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
    
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStylePlain];
        self.tableView.tag = 8023;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.layer.cornerRadius = 8;
        self.tableView.layer.masksToBounds = YES;
        [self.creditView addSubview:self.tableView];
    }
    
    
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







#pragma mark - 信用卡保存按钮
-(void)saveCredit{
    
    self.creditSaveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 360, 300, 41)];
    [self.creditSaveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.creditSaveButton setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_nor@2x"] forState:UIControlStateNormal];
    [self.creditSaveButton setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_pre@2x"] forState:UIControlStateNormal];
    [self.creditSaveButton addTarget:self action:@selector(tapPreservationCredit) forControlEvents:UIControlEventTouchUpInside];
    [self.creditView addSubview:self.creditSaveButton];
    
}

-(void)tapPreservationCredit{
    NSLog(@"保存信用卡");
    
//    xy_theOpeningBankString;//开户银行
//    xy_creditCardString;//信用卡号
//    xy_ccvString;//CCV验证码
//    xy_phoneString;//预留手机号
//    xy_nameString;//持卡人姓名
//    xy_identityCardNumberString;//身份证号码
    
    if (self.xy_theOpeningBankString.length >0 && self.xy_creditCardString.length >0 && self.xy_ccvString.length >0 && self.xy_phoneString.length >0 && self.xy_nameString.length >0 && self.xy_identityCardNumberString.length >0 && self.month.text.length>0 && self.years.text.length>0){
        
        //信用卡号
        if ([NLUtils checkBankCard:self.xy_creditCardString] == YES){
            
            //CCV验证码
            if (self.xy_ccvString.length == 3){
                
                //预留手机号
                if ([NLUtils checkMobilePhone:self.xy_phoneString] == YES){
                    
                    //持卡人姓名
                    if ([NLUtils checkName:self.xy_nameString] == YES) {
                        
                        //身份证号码
                        if ([NLUtils checkIdentity:self.xy_identityCardNumberString] == YES) {
                            
                            NSLog(@"信用卡保存成功 !!!");
                            [self creditCardToSaveNetworkRequest];
                            
                        }else{
                            UIAlertView *alertView6 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号码有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                            [alertView6 show];
                        }
                        
                    }else{
                        UIAlertView *alertView5 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"姓名不合法 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                        [alertView5 show];
                    }
                    
                }else{
                    UIAlertView *alertView4 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                    [alertView4 show];
                }
                
            }else{
                UIAlertView *alertView3 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"CCV验证码有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alertView3 show];

            }
            
        }else{
            UIAlertView *alertView2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信用卡号有误 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alertView2 show];
        }
    }else{
        UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善资料填写 !" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alertView1 show];
    }
    
}


#pragma mark - 信用卡保存网络请求
-(void)creditCardToSaveNetworkRequest{
    
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoAdd];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForNewCard, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoAdd:self.xy_bankCode
                                                                         bkcardbank:creditTextField[0].text
                                                                           bkcardno:creditTextField[1].text
                                                                      bkcardbankman:creditTextField[4].text
                                                                    bkcardbankphone:creditTextField[3].text
                                                                      bkcardyxmonth:self.month.text
                                                                       bkcardyxyear:self.years.text
                                                                          bkcardcvv:creditTextField[2].text
                                                                       bkcardidcard:creditTextField[5].text
                                                                     bkcardcardtype:@"creditcard"
                                                                    bkcardisdefault:@"0"
                                                             bkcardisdefaultPayment:@"1"];

}









#pragma mark - 加载储蓄卡卡输入框
-(void)theSavingsCardVC{
    
    for (int i=0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (41+10)*i, 300, 41)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        [self.theSavingsCardView addSubview:imageView];
        
        
        theSavingsCardTextField[i] = [[UITextField alloc]initWithFrame:CGRectMake(100, (41+10)*i, 195, 41)];
        theSavingsCardTextField[i].delegate = self;
        theSavingsCardTextField[i].backgroundColor = [UIColor clearColor];
        theSavingsCardTextField[i].tag = 8030+i;
        [self.theSavingsCardView addSubview:theSavingsCardTextField[i]];
        
        
        self.theSavingsCardLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, (41+10)*i, 87, 41)];
        self.theSavingsCardLabel.tag = 8020+i;
        [self.theSavingsCardLabel setTextAlignment:NSTextAlignmentLeft];
        self.theSavingsCardLabel.backgroundColor = [UIColor clearColor];
        self.theSavingsCardLabel.textColor= RGBACOLOR(99, 99, 99, 1);
        [self.theSavingsCardView addSubview:self.theSavingsCardLabel];
        
        switch (self.theSavingsCardLabel.tag) {
            case 8020:
                self.theSavingsCardLabel.text = @"开户银行";
                break;
            case 8021:
                self.theSavingsCardLabel.text = @"银行卡号";
                break;
            case 8022:
                self.theSavingsCardLabel.text = @"开户人";
                break;
            case 8023:
                self.theSavingsCardLabel.text = @"手机号码";
                break;
                
            default:
                break;
        }
        
        switch (theSavingsCardTextField[i].tag) {
            case 8030:
                theSavingsCardTextField[0].placeholder = @"请选择银行";
                
                [self jumpTheSavingsCardButton];//选择开户银行
                ;
                break;
            case 8031:
                theSavingsCardTextField[1].placeholder = @"请输入银行卡号";
                theSavingsCardTextField[1].keyboardType = UIKeyboardTypeNumberPad;
                [theSavingsCardTextField[1] addTarget:self action:@selector(addTheSavingsCardCardNumber:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8032:
                theSavingsCardTextField[2].placeholder = @"请输入开户人名字";
                theSavingsCardTextField[2].keyboardType = UIKeyboardTypeDefault;
                [theSavingsCardTextField[2] addTarget:self action:@selector(addTheSavingsCardAccountName:) forControlEvents:UIControlEventEditingChanged];
                break;
            case 8033:
                theSavingsCardTextField[3].placeholder = @"请输入开户人手机号码";
                theSavingsCardTextField[3].keyboardType = UIKeyboardTypeNumberPad;
                [theSavingsCardTextField[3] addTarget:self action:@selector(addTheSavingsCardPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - 添加 储蓄卡 银行卡号
-(void)addTheSavingsCardCardNumber:(UITextField *)textField{
    
    self.cx_creditCardString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"储蓄卡卡号 :%@",self.cx_creditCardString);
    
}


#pragma mark - 添加 储蓄卡 开户人
-(void)addTheSavingsCardAccountName:(UITextField *)textField{
    
    self.cx_nameString = [NSString stringWithFormat:@"%@",textField.text];
    NSLog(@"储蓄卡持卡人姓名 :%@",self.cx_nameString);
    
}


#pragma mark - 添加 储蓄卡 手机号码
-(void)addTheSavingsCardPhoneNumber:(UITextField *)textField{
    
    if ([textField.text length]>11) {
        textField.text=[textField.text substringToIndex:11];
        self.cx_phoneString = [self.cx_phoneString substringWithRange:NSMakeRange(0,11)];
        NSLog(@"截取到的储蓄卡开户人手机号码 :%@",self.cx_phoneString);
    }else{
        self.cx_phoneString= [NSString stringWithFormat:@"%@",textField.text];
        NSLog(@"储蓄户卡开户人手机号码 :%@", self.cx_phoneString);
    }
    
}





#pragma mark - 跳转 储蓄卡 开户银行
-(void)jumpTheSavingsCardButton{
    
    if (!self.theSavingsCardJumpButton) {
        self.theSavingsCardJumpButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, theSavingsCardTextField[0].frame.size.width, theSavingsCardTextField[0].frame.size.height)];
        [self.theSavingsCardJumpButton setBackgroundColor:[UIColor clearColor]];
        [theSavingsCardTextField[0] addSubview:self.theSavingsCardJumpButton];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(180, 10, 10, 22)];
        [btn setBackgroundImage:[UIImage imageNamed:@"SMS_jump@2x"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapJumpTheSavingsCardBtn) forControlEvents:UIControlEventTouchUpInside];
        [theSavingsCardTextField[0] addSubview:btn];
        
    }
    [self.theSavingsCardJumpButton addTarget:self action:@selector(tapJumpTheSavingsCardBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tapJumpTheSavingsCardBtn{
    NSLog(@"选择开户银行");
    
//    SMSChooseABankTableViewController *vc = [[SMSChooseABankTableViewController alloc]init];
    NLBankListViewController *vc = [[NLBankListViewController alloc]initWithNibName:@"NLBankListViewController" bundle:nil];
    vc.delegate = self;
    self.state2 = 2;
    [self jumpViewController:self newViewController:vc PushAndPresent:YES];
    
}





#pragma mark - 储蓄卡保存按钮
-(void)saveTheSavingsCardButton{
    
    self.theSavingsCardSaveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 215, 300, 41)];
    [self.theSavingsCardSaveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.theSavingsCardSaveButton setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_nor@2x"] forState:UIControlStateNormal];
    [self.theSavingsCardSaveButton setBackgroundImage:[UIImage imageNamed:@"SMS_bl_btn_pre@2x"] forState:UIControlStateNormal];
    [self.theSavingsCardSaveButton addTarget:self action:@selector(tapSaveTheSavingsCard) forControlEvents:UIControlEventTouchUpInside];
    [self.theSavingsCardView addSubview:self.theSavingsCardSaveButton];
    
}

-(void)tapSaveTheSavingsCard{
    NSLog(@"保存储蓄卡");
    
//    cx_theOpeningBankString;//开户银行
//    cx_creditCardString;//银行卡号
//    cx_nameString;//开户人姓名
//    cx_phoneString;//开户人手机号
    
    if (self.cx_theOpeningBankString.length >0 && self.cx_creditCardString.length >0 && self.cx_nameString.length >0 && self.cx_phoneString.length >0) {
        
        if ([NLUtils checkBankCard:self.cx_creditCardString] == YES && self.cx_creditCardString.length >15) {
            
            if ([NLUtils checkName:self.cx_nameString] == YES) {
                
                if ([NLUtils checkMobilePhone:self.cx_phoneString] == YES) {
                    
                    NSLog(@"储蓄卡保存成功 !!!");
                    [self savingsCardsStoreNetworkRequest];
                    
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


#pragma mark - 储蓄卡保存网络请求
-(void)savingsCardsStoreNetworkRequest{
    
    NSString *name = [NLUtils getNameForRequest:Notify_ApiAuthorKuaibkcardInfoAdd];
    REGISTER_NOTIFY_OBSERVER(self, checkDataForNewCard, name);
    [[[NLProtocolRequest alloc] initWithRegister:YES] getApiAuthorKuaibkcardInfoAdd:self.cx_bankCode
                                                                         bkcardbank:theSavingsCardTextField[0].text
                                                                           bkcardno:theSavingsCardTextField[1].text
                                                                      bkcardbankman:theSavingsCardTextField[2].text
                                                                    bkcardbankphone:theSavingsCardTextField[3].text
                                                                      bkcardyxmonth:@""
                                                                       bkcardyxyear:@""
                                                                          bkcardcvv:@""
                                                                       bkcardidcard:@""
                                                                     bkcardcardtype:@"bankcard"
                                                                    bkcardisdefault:@"0"
                                                             bkcardisdefaultPayment:@"1"];
    
    
}


#pragma mark - 判断网络请求结果
- (void)checkDataForNewCard:(NSNotification *)notify
{
    NLProtocolResponse *response = (NLProtocolResponse *)notify.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        //成功或失败
        [self getDataWithNewCard:response];
    }
    else
    {
        NSString *string = response.detail;
        //服务器繁忙
        [self showError:string];
    }
}


- (void)showError:(NSString *)detail
{
    if (detail)
    {
        [self showErrorInfo:detail status:NLHUDState_Error];
    }
    else
    {
        [self showErrorInfo:@"服务器繁忙，请稍候再试" status:NLHUDState_Error];
    }
}

- (void)getDataWithNewCard:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
    
    NSRange range = [result rangeOfString:@"succ"];
    
    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        
        NSLog(@"errorData = %@",errorData);
    }
    else
    {
        [self showError:@"操作成功"];
        //如果是短信收款界面跳转过来的
        if (self.stateIndex == 1) {
            
            //传信用卡
            if (self.state2 == 1) {
                [self.delegate agent:self Refresh:YES theOpeningBankString:creditTextField[0].text creditCard:creditTextField[1].text name:creditTextField[4].text phone:creditTextField[3].text identity:creditTextField[5].text ccv:creditTextField[2].text month:self.month.text years:self.years.text];
                
            //传储蓄卡
            }else if(self.state2 == 2){
                [self.delegate agent:self Refresh:YES theOpeningBankString:theSavingsCardTextField[0].text creditCard:theSavingsCardTextField[1].text name:theSavingsCardTextField[2].text phone:theSavingsCardTextField[3].text identity:nil ccv:nil month:nil years:nil];
            }
        
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SMSreceiptViewController class]]) {
                    SMSreceiptViewController *subscribe=(SMSreceiptViewController*)vc;
                    [self.navigationController popToViewController:subscribe animated:YES];
                }
            }
        //如果是银行卡列表跳转过来的
        }else if(self.stateIndex == 2){
        
            [self.delegate agent:self Refresh:YES theOpeningBankString:nil creditCard:nil name:nil phone:nil identity:nil ccv:nil month:nil years:nil];//通知银行卡刷新列表
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


-(void)showErrorInfo:(NSString*)error status:(NLHUDState)status
{
    [_hud hide:YES];
    _hud = [[NLProgressHUD alloc] initWithParentView: self.view];
    
    switch (status)
    {
        case NLHUDState_Error:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCheckmark.png"]] ;
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.detailsLabelText = error;
            [_hud show:YES];
            [_hud hide:YES afterDelay:2];
        }
            break;
            
        case NLHUDState_NoError:
        {
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]] ;
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
