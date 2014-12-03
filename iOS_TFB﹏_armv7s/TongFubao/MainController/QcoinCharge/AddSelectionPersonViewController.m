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
    
    BOOL result = [NLUtils checkMobilePhone:self.PassengerIphone];

    if (result == YES && ([self.PassengerName length] >0 && [self.PassengerIphone length] > 0))
    {
        _activityView = [[PlayCustomActivityView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
        _activityView.center = self.view.center;
        [_activityView setTipsText:@"正在加载数据..."];
        [_activityView starActivity];
        [self.view addSubview:_activityView];
        
        
        NSString* name = [NLUtils getNameForRequest:Notify_SaveContact];
        REGISTER_NOTIFY_OBSERVER(self, GetSaveContactNotify, name);
        [[[NLProtocolRequest alloc]initWithRegister:YES] savecontactName:self.PassengerName savecontactCardType:@"" savecontactCardId:@"" savecontactPhoneNumber:self.PassengerIphone savecontactType:@"2" contactbirthday:@""];

    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请正确填写手机号或姓名" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)GetSaveContactNotify:(NSNotification *)senderFication
{
    NLProtocolResponse *response = (NLProtocolResponse *)senderFication.object;
    int error = response.errcode;
    NSString *string = response.detail;
//    NSLog(@"===string====%@",string);

    
    if (error == RSP_NO_ERROR)
    {
        [self getSaveContactApiAirticket:response];
    }
    else if (error == RSP_TIMEOUT)
    {
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
    }
    else
    {
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

- (void)getSaveContactApiAirticket:(NLProtocolResponse *)response
{
    //获取数据标记，判断是否请求成功
    NLProtocolData *data = [response.data find:@"msgbody/result" index:0];
    NSString *result = data.value;
//    NSLog(@"======result=======%@",result);
    NSRange range = [result rangeOfString:@"succ"];

    if (range.length <= 0)
    {
        //获取错误信息
        NLProtocolData *errorData = [response.data find:@"msgbody/message" index:0];
        NSLog(@"errorData = %@",errorData);
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
    }
    else
    {
        // 机票实际价格
        //        self.priceArray = [response.data find:@"msgbody/msgchild/price"];
        UITextField *textFieldName = [_textFiedArray objectAtIndex:0];
        textFieldName.text = nil;
        textFieldName.placeholder = @"请输入姓名";
        UITextField *textFieldIphone = [_textFiedArray objectAtIndex:1];
        textFieldIphone.text = nil;
        textFieldIphone.placeholder = @"请输入手机号码";
        [_activityView performSelector:@selector(endActivity) withObject:_activityView afterDelay:0.7];
        [_activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"成功添加联系人!" message:@"" delegate:self cancelButtonTitle:@"添加联系人" otherButtonTitles:@"退出", nil];
        alert.tag = 100;
        [alert show];
        
        [self.delegate UpdateAddSelectionPersonPassengers];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(message:) name:@"添加联系人" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"添加联系人" object:nil];

    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
//-(void)message:(NSNotificationCenter *)sender
//{
//    NSLog(@"=====添加了联系人添加了联系人添加了联系人===");
//}
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
        infoField.clearButtonMode=UITextFieldViewModeAlways;
        infoField.tag = j;
        if (infoField.tag ==1 )
        {
            infoField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [_textFiedArray addObject:infoField];
        [self.view addSubview:infoField];
    }
    
//    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    button.frame = CGRectMake(30, 200, 260, 40);
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 5;
//    button.backgroundColor = [UIColor orangeColor];
//    [button setTitle:@"添加联系人" forState:(UIControlStateNormal)];
//    [button addTarget:self action:@selector(sureButton) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:button];
    
}
//-(void)sureButton
//{
//    
//}
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


