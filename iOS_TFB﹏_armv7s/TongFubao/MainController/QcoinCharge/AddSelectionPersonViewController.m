//
//  AddSelectionPersonViewController.m
//  TongFubao
//
//  Created by kin on 14-8-21.
//  Copyright (c) 2014年 MD313. All rights reserved.
//

#import "AddSelectionPersonViewController.h"
#import "PlayCustomActivityView.h"
@interface AddSelectionPersonViewController ()

@end

@implementation AddSelectionPersonViewController
{
    NSMutableArray *_textFiedArray;
    PlayCustomActivityView *_activityView;
    
}
@synthesize PassengerName,PassengerIphone;

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
    _textFiedArray = [[NSMutableArray alloc]init];
    // 导航
    [self navigationView];
    [self allControllerView];
    
}
-(void)navigationView
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackButtonItemWithImage:[UIImage imageNamed:@"navigationLeftBtnBack2"]];
    self.title= @"选择联系人";
    [self addRightButtonItemWithTitle:@"确定"];
}

// 右边导航
-(void)rightItemClick:(id)sender
{
    
    
    UITextField *textFieldName = [_textFiedArray objectAtIndex:0];
    UITextField *textFieldIphone = [_textFiedArray objectAtIndex:1];
    [textFieldName resignFirstResponder];
    [textFieldIphone resignFirstResponder];
    
    
    self.PassengerName = textFieldName.text;
    self.PassengerIphone = textFieldIphone.text;
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    UITextField *iphoneField =[_textFiedArray objectAtIndex:1];
    
    
    if (([regextestmobile evaluateWithObject:iphoneField.text]||[regextestcm evaluateWithObject:iphoneField.text]||[regextestcu evaluateWithObject:iphoneField.text]||[regextestct evaluateWithObject:iphoneField.text]) && ([self.PassengerName length] >0 && [self.PassengerIphone length] > 0))
    {
        _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
        _activityView.center = self.view.center;
        [_activityView setTipsText:@"正在加载数据..."];
        [_activityView starActivity];
        [self.view addSubview:_activityView];
        
        
        NSString* name = [NLUtils getNameForRequest:Notify_SavePassenger];
        REGISTER_NOTIFY_OBSERVER(self, GetSavePassengerNotify, name);
        [[[NLProtocolRequest alloc]initWithRegister:YES]savePassengerName:self.PassengerName savePassengerCardType:@"" savePassengerCardId:@"" savePassengerPhoneNumber:self.PassengerIphone savePassengerPassengerType:@"2"];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请正确填写手机号和名字" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)GetSavePassengerNotify:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    
    if (error == RSP_NO_ERROR)
    {
        [self getApiAirticket:response];
        
    }
    else if (error == RSP_TIMEOUT)
    {
        return ;
    }
    else
    {
        NSString *string = response.detail;
        NSLog(@"===string====%@",string);
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        if ([string isEqualToString:@"请勿重复添加信息"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！请勿重复添加信息" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！加载数据失败！" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }
}

- (void)getApiAirticket:(NLProtocolResponse *)response
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
        // 机票实际价格
        //        self.priceArray = [response.data find:@"msgbody/msgchild/price"];
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲！加载数据成功！" delegate:self cancelButtonTitle:@"退出添加联系人" otherButtonTitles:nil, nil];
        [alert show];
        UITextField *textFieldName = [_textFiedArray objectAtIndex:0];
        textFieldName.text = nil;
        textFieldName.placeholder = @"请输入姓名";
        UITextField *textFieldIphone = [_textFiedArray objectAtIndex:1];
        textFieldIphone.text = nil;
        textFieldIphone.placeholder = @"请输入手机号码";
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(message:) name:@"添加联系人" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"添加联系人" object:nil];
    }
    
}
-(void)message:(NSNotificationCenter *)sender
{
    NSLog(@"=====添加了联系人添加了联系人添加了联系人===");
}
-(void)allControllerView
{
    for (int i = 0; i < 2; i++)
    {
        UIImageView *lineAccorIamge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 125+i*60, 320, 1)];
        lineAccorIamge.image = [UIImage imageNamed:@"line@2x.png"];
        [self.view addSubview:lineAccorIamge];
        
    }
    
    NSArray *infoArray = @[@"请输入姓名",@"请输入手机号码"];
    for (int j = 0; j < 2; j++)
    {
        UITextField *infoField = [[UITextField alloc]initWithFrame:CGRectMake(10, 64+j*60, 300, 60)];
        infoField.placeholder = [infoArray objectAtIndex:j];
        infoField.tag = j;
        if (infoField.tag ==1 )
        {
            infoField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [_textFiedArray addObject:infoField];
        [self.view addSubview:infoField];
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[_textFiedArray objectAtIndex:0] resignFirstResponder];
    [[_textFiedArray objectAtIndex:1] resignFirstResponder];
    
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




















































































