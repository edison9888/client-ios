//
//  SMSTradingNoticeViewController.m
//  TongFubao
//
//  Created by 通付宝MAC on 14-11-6.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "SMSTradingNoticeViewController.h"

#import "XIAOYU_TheControlPackage.h"

@interface SMSTradingNoticeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIImageView *lconImageView;

//@property (strong, nonatomic) UILabel *label1;
//@property (strong, nonatomic) UILabel *label2;
//@property (strong, nonatomic) UILabel *label3;
//@property (strong, nonatomic) UILabel *label4;

@property (strong, nonatomic) UILabel *sms_telephone;//电话号码
@property (strong, nonatomic) UILabel *sms_amountOfMoney;//金额
@property (weak, nonatomic) IBOutlet UILabel *sms_theOpeningBank;//开户行
@property (weak, nonatomic) IBOutlet UILabel *sms_bankAccount;//银行卡号


@end

@implementation SMSTradingNoticeViewController


-(void)tapleftBarButtonItemBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"交易通知";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+10)];
    
    self.lconImageView.image = [UIImage imageNamed:@"SMS_success"];
    
    [self promptLabel];
    
    self.sms_theOpeningBank.text = [NSString stringWithFormat:@"%@",self.theOpeningBank];
    

    
    if(self.bankAccount.length == 14){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:9];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
        
    }else if (self.bankAccount.length == 15) {
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:10];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
        
    }else if(self.bankAccount.length == 16){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:11];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
        
    }else if(self.bankAccount.length == 17){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:12];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    }else if(self.bankAccount.length == 18){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:13];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    }else if(self.bankAccount.length == 19){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:14];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    }else if(self.bankAccount.length == 20){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:15];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    }else if(self.bankAccount.length == 21){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:16];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    }else if(self.bankAccount.length == 22){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:17];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    }else if(self.bankAccount.length == 23){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:18];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    }else if(self.bankAccount.length == 24){
        NSString *phone1 = [self.bankAccount substringToIndex:6];
        NSString *phone2 = [self.bankAccount substringFromIndex:19];
        NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    }else{
        self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",self.bankAccount];
    }
    

    
}



-(void)promptLabel{

    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(45, 84, 140, 21)];
    label1.text = @"您已成功向手机号码";
    [label1 setFont:[UIFont fontWithName:nil size:15]];
    label1.textColor = RGBACOLOR(93, 94, 95, 1);

    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(41+label1.frame.size.width, 84, 95, 21)];
    label2.text = self.telephone;
    [label2 setFont:[UIFont fontWithName:nil size:15]];
    label2.textColor = RGBACOLOR(93, 94, 95, 1);
    
    
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(40+label1.frame.size.width+label2.frame.size.width, 84, 35, 21)];
    label8.text = @"发起";
    [label8 setFont:[UIFont fontWithName:nil size:15]];
    label8.textColor = RGBACOLOR(93, 94, 95, 1);
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 105, 47, 21)];
    label3.text = @"金额为";
    [label3 setFont:[UIFont fontWithName:nil size:15]];
    label3.textColor = RGBACOLOR(93, 94, 95, 1);

    
    
    
    NSString *string = @"￥";
    
    if ([self.amountOfMoney rangeOfString:@"."].location != NSNotFound) {
        string  = [string stringByAppendingFormat:@"%@",self.amountOfMoney];
        NSLog(@"这个字符串中有小数点");
    
    }else{
      string  = [string stringByAppendingFormat:@"%@%@",self.amountOfMoney,@".00"];
    }
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(13+label3.frame.size.width,105 ,77 ,21)];
    label4.font = [UIFont systemFontOfSize:15];
    label4.text = string;
    label4.textAlignment = NSTextAlignmentCenter;
    label4.textColor = RGBACOLOR(229, 158, 53, 1);
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(24+label3.frame.size.width+70, 105, 90, 21)];
    label5.text = @"的短信收款，";
    [label5 setFont:[UIFont fontWithName:nil size:15]];
    label5.textColor = RGBACOLOR(93, 94, 95, 1);
    
    
    UILabel *label9 = [[UILabel alloc]initWithFrame:CGRectMake(23+label3.frame.size.width+70+label5.frame.size.width, 105, 79, 21)];
    label9.text = @"对方成功付";
    [label9 setFont:[UIFont fontWithName:nil size:15]];
    label9.textColor = RGBACOLOR(93, 94, 95, 1);
    
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(15, 126, 130, 21)];
    label6.text = @"款后1个工作日内，";
    [label6 setFont:[UIFont fontWithName:nil size:15]];
    label6.textColor = RGBACOLOR(93, 94, 95, 1);
    
    
    UILabel *label10 = [[UILabel alloc]initWithFrame:CGRectMake(10+label6.frame.size.width, 126, 170, 21)];
    label10.text = @"该笔款项将转入您以下指";
    [label10 setFont:[UIFont fontWithName:nil size:15]];
    label10.textColor = RGBACOLOR(93, 94, 95, 1);
    
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(15, 148, 105, 21)];
    label7.text = @"定的银行账户：";
    [label7 setFont:[UIFont fontWithName:nil size:15]];
    label7.textColor = RGBACOLOR(93, 94, 95, 1);
    
    
    [self.scrollView addSubview:label1];
    [self.scrollView addSubview:label2];
    [self.scrollView addSubview:label3];
    [self.scrollView addSubview:label4];
    [self.scrollView addSubview:label5];
    [self.scrollView addSubview:label6];
    [self.scrollView addSubview:label7];
    [self.scrollView addSubview:label8];
    [self.scrollView addSubview:label9];
    [self.scrollView addSubview:label10];
    
}




#pragma mark - 再来一次
- (IBAction)onceAgain:(UIButton *)sender {
    
    NSLog(@"再来一次");
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 确认
- (IBAction)confirmation:(UIButton *)sender {
    
    NSLog(@"确认");
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PushViewController class]]) {
            PushViewController *subscribe=(PushViewController*)vc;
            [self.navigationController popToViewController:subscribe animated:YES];
        }
    }
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
