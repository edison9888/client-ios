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
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50)];
    
    self.lconImageView.image = [UIImage imageNamed:@"SMS_success"];
    
    [self promptLabel];
    
    self.sms_theOpeningBank.text = [NSString stringWithFormat:@"%@",self.theOpeningBank];
    
    NSString *phone1 = [self.bankAccount substringToIndex:4];
    
    
    
    NSString *phone2 = [self.bankAccount substringFromIndex:12];
    NSString *phone3 = [NSString stringWithFormat:@"%@%@%@",phone1,@"****",phone2];
    
    self.sms_bankAccount.text = [NSString stringWithFormat:@"%@",phone3];
    
    

    
}



-(void)promptLabel{

    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(35, 84, 145, 21)];
    label1.text = @"您已成功向手机号码";
    label1.textColor = RGBACOLOR(93, 94, 95, 1);
    [label1 setFont:[UIFont fontWithName:nil size:16]];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(35+label1.frame.size.width, 84, 110, 21)];
    label2.text = self.telephone;
    label2.textColor = RGBACOLOR(93, 94, 95, 1);
    [label2 setFont:[UIFont fontWithName:nil size:16]];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(35, 105, 80, 21)];
    label3.text = @"发起金额为";
    label3.textColor = RGBACOLOR(93, 94, 95, 1);
    [label3 setFont:[UIFont fontWithName:nil size:16]];
    
    
    
    NSString *string = @"￥";
    
    if ([self.amountOfMoney rangeOfString:@"."].location != NSNotFound) {
        string  = [string stringByAppendingFormat:@"%@",self.amountOfMoney];
        NSLog(@"这个字符串中有小数点");
    
    }else{
      string  = [string stringByAppendingFormat:@"%@%@",self.amountOfMoney,@".00"];
    }
    
    CGSize size=[string sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(290, 10000)];
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(35+label3.frame.size.width,105 ,size.width ,size.height )];
    label4.font = [UIFont systemFontOfSize:16];
//    label4.textColor = [UIColor brownColor];
    label4.textColor = RGBACOLOR(229, 158, 53, 1);
    label4.text = string;
    label4.textAlignment = NSTextAlignmentLeft;
    //自动换行
    label4.lineBreakMode = NSLineBreakByWordWrapping;
    label4.numberOfLines = 0;
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(37+label3.frame.size.width+label4.frame.size.width, 105, 100, 21)];
    label5.text = @"的短信收款，";
    label5.textColor = RGBACOLOR(93, 94, 95, 1);
    [label5 setFont:[UIFont fontWithName:nil size:16]];
    
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(35, 126, 260, 21)];
    label6.text = @"对方成功付款后1个工作日内，该笔";
    label6.textColor = RGBACOLOR(93, 94, 95, 1);
    [label6 setFont:[UIFont fontWithName:nil size:16]];
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(35, 148, 260, 21)];
    label7.text = @"款项将转入您以下指定的银行账户：";
    label7.textColor = RGBACOLOR(93, 94, 95, 1);
    [label7 setFont:[UIFont fontWithName:nil size:16]];
    
    [self.scrollView addSubview:label1];
    [self.scrollView addSubview:label2];
    [self.scrollView addSubview:label3];
    [self.scrollView addSubview:label4];
    [self.scrollView addSubview:label5];
    [self.scrollView addSubview:label6];
    [self.scrollView addSubview:label7];
    
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
